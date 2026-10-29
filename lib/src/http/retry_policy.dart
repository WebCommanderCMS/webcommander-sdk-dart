import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../config/sdk_config.dart';
import '../errors.dart';
import 'client_factory_web.dart' if (dart.library.io) 'client_factory_io.dart';
import 'header_grammar.dart';

/// Which side of delivery a transport failure falls on, and so whether
/// replaying the request could duplicate what it asked for.
enum TransportFailureKind {
  /// The connection was never established: no byte of the request left the process.
  connectionNotEstablished,

  /// The request may already have been delivered.
  requestAlreadySent,
}

/// Retry decisions and backoff timing.
class RetryPolicy {
  /// Construct and validate the backoff bounds.
  RetryPolicy(
    this.maxAttempts,
    this.backoffSeconds,
    this.backoffMaxSeconds, {
    Set<int>? retryableStatusCodes,
    Set<int>? unsafeRetryableStatusCodes,
  })  : retryableStatusCodes = _validatedStatusCodes(
            retryableStatusCodes ?? defaultRetryableHttpCodes,
            'retryableStatusCodes'),
        unsafeRetryableStatusCodes = _validatedStatusCodes(
            unsafeRetryableStatusCodes ?? defaultUnsafeRetryableHttpCodes,
            'unsafeRetryableStatusCodes') {
    if (maxAttempts < 1) {
      throw SdkConfigError(
          'maxAttempts: must be at least 1 (1 disables retry), got $maxAttempts');
    }
    _requireFinite('backoffSeconds', backoffSeconds);
    _requireFinite('backoffMaxSeconds', backoffMaxSeconds);
    if (backoffSeconds < 0) {
      throw SdkConfigError('backoffSeconds: must be >= 0, got $backoffSeconds');
    }
    if (backoffMaxSeconds < backoffSeconds) {
      throw SdkConfigError(
          'backoffMaxSeconds: must be >= backoffSeconds, got $backoffMaxSeconds < $backoffSeconds');
    }
  }

  /// A policy carrying the retry settings on [config].
  factory RetryPolicy.fromConfig(SdkConfig config) => RetryPolicy(
        config.maxRetries,
        config.retryBackoffSeconds,
        config.retryBackoffMaxSeconds,
        retryableStatusCodes: config.retryableHttpCodes,
        unsafeRetryableStatusCodes: config.unsafeRetryableHttpCodes,
      );

  /// Statuses worth another attempt at all (safe methods).
  static const Set<int> defaultRetryableHttpCodes = <int>{
    429,
    500,
    502,
    503,
    504
  };

  /// Statuses retried even on a state-changing method; empty by default.
  static const Set<int> defaultUnsafeRetryableHttpCodes = <int>{};

  /// The methods a status retry may treat as harmless: RFC 9110's safe methods.
  static const Set<String> safeMethods = <String>{
    'GET',
    'HEAD',
    'OPTIONS',
    'TRACE'
  };

  /// RFC 9110's idempotent methods: the only ones replayed after a transport
  /// failure that may have reached the server. Status retries do not consult it.
  static const Set<String> idempotentMethods = <String>{
    'GET',
    'HEAD',
    'OPTIONS',
    'TRACE',
    'PUT',
    'DELETE'
  };

  /// Total attempts including the first.
  final int maxAttempts;

  /// Base backoff before the first retry, in seconds.
  final double backoffSeconds;

  /// Ceiling on any single backoff, in seconds.
  final double backoffMaxSeconds;

  /// Statuses worth another attempt at all, as actually in force.
  final Set<int> retryableStatusCodes;

  /// Statuses a state-changing method may be replayed on — the second list
  /// [shouldRetryStatusCode] also requires outside [safeMethods].
  final Set<int> unsafeRetryableStatusCodes;

  /// Whether a response with this status warrants another attempt; a method that
  /// is not safe also needs the status in [unsafeRetryableStatusCodes].
  bool shouldRetryStatusCode(int statusCode, [String? method = 'GET']) {
    if (!retryableStatusCodes.contains(statusCode)) return false;
    if (!isUnsafeMethod(method)) return true;
    return unsafeRetryableStatusCodes.contains(statusCode);
  }

  /// Which side of delivery a transport failure falls on.
  static TransportFailureKind classifyTransportFailure(Object exception,
          [bool requestMayHaveBeenSent = false]) =>
      !requestMayHaveBeenSent && isConnectionEstablishmentFailure(exception)
          ? TransportFailureKind.connectionNotEstablished
          : TransportFailureKind.requestAlreadySent;

  /// Whether a transport-level failure warrants another attempt; once the request
  /// may have been sent, only an [idempotentMethods] one is replayed.
  bool shouldRetryAfterException(Object exception,
          [String? method = 'GET', bool requestMayHaveBeenSent = false]) =>
      switch (classifyTransportFailure(exception, requestMayHaveBeenSent)) {
        TransportFailureKind.connectionNotEstablished => true,
        TransportFailureKind.requestAlreadySent =>
          _isTransportFailure(exception) && isIdempotentMethod(method),
      };

  // Clamped: an int power wraps at 2^63; 1023 is the largest finite double exponent.
  static const int _maxBackoffExponent = 1023;

  /// How long to wait before the next attempt: exponential with full jitter, a
  /// numeric `Retry-After` winning but clamped by the same ceiling.
  double computeBackoffSeconds(int attempt, [String? retryAfter]) {
    final serverDelay = _parseRetryAfter(retryAfter);
    if (serverDelay != null) return min(serverDelay, backoffMaxSeconds);
    final growth =
        pow(2.0, min(max(0, attempt - 1), _maxBackoffExponent)).toDouble();
    final window = min(backoffSeconds * growth, backoffMaxSeconds);
    return window <= 0 ? 0.0 : Random().nextDouble() * window;
  }

  /// Whether this method may have changed something, and so whether its replay
  /// could duplicate an effect.
  static bool isUnsafeMethod(String? method) {
    if (method == null) return true;
    final normalised = method.trim().toUpperCase();
    return !isMethodToken(normalised) || !safeMethods.contains(normalised);
  }

  /// Whether a string is an HTTP method at all.
  static bool isMethodToken(String method) => sendableHeaderName(method);

  // Copied, not viewed: the constructor is public, so validate and detach here.
  static Set<int> _validatedStatusCodes(Set<int> codes, String field) {
    if (codes.length > _maxStatusCodes) {
      throw SdkConfigError('$field: at most $_maxStatusCodes status codes '
          '($minStatusCode-$maxStatusCode is every code there is), '
          'got more than that');
    }
    for (final code in codes) {
      if (code < minStatusCode || code > maxStatusCode) {
        throw SdkConfigError('$field: $code is not an HTTP status code — '
            'RFC 9110 allows $minStatusCode through $maxStatusCode');
      }
    }
    return Set<int>.unmodifiable(codes);
  }

  /// The lowest value RFC 9110 allows a status code to take.
  static const int minStatusCode = 100;

  /// The highest value RFC 9110 allows a status code to take.
  static const int maxStatusCode = 599;

  static const int _maxStatusCodes = maxStatusCode - minStatusCode + 1;

  /// Whether sending this method twice means the same end state as sending it
  /// once — one of [idempotentMethods].
  static bool isIdempotentMethod(String? method) {
    if (method == null) return false;
    final normalised = method.trim().toUpperCase();
    return isMethodToken(normalised) && idempotentMethods.contains(normalised);
  }

  static bool _isTransportFailure(Object exception) =>
      exception is TimeoutException || exception is http.ClientException;

  static double? _parseRetryAfter(String? retryAfter) {
    if (retryAfter == null || retryAfter.trim().isEmpty) return null;
    final seconds = double.tryParse(retryAfter.trim());
    // Non-finite parses are rejected: a NaN delay crashes Duration construction.
    if (seconds != null && seconds.isFinite) return max(0.0, seconds);
    final when = _parseHttpDate(retryAfter.trim());
    if (when == null) return null;
    return max(
        0.0,
        when.difference(DateTime.now().toUtc()).inMilliseconds /
            Duration.millisecondsPerSecond);
  }

  static final RegExp _imfFixdate =
      RegExp(r'^[A-Za-z]{3,9},?\s+(\d{1,2})[ -]([A-Za-z]{3})[ -](\d{2,4})\s+'
          r'(\d{2}):(\d{2}):(\d{2})\s*([A-Za-z]+|[+-]\d{4})?$');

  static final RegExp _asctime =
      RegExp(r'^[A-Za-z]{3,9}\s+([A-Za-z]{3})\s+(\d{1,2})\s+'
          r'(\d{2}):(\d{2}):(\d{2})\s+(\d{4})$');

  static const List<String> _months = <String>[
    'jan', 'feb', 'mar', 'apr', 'may', 'jun', //
    'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
  ];

  static DateTime? _parseHttpDate(String value) {
    final fixed = _imfFixdate.firstMatch(value);
    if (fixed != null) {
      final month = _months.indexOf(fixed.group(2)!.toLowerCase());
      if (month < 0) return null;
      var year = int.parse(fixed.group(3)!);
      if (year < 100) year += year < 69 ? 2000 : 1900;
      final utc = _utcOrNull(
          year,
          month + 1,
          int.parse(fixed.group(1)!),
          int.parse(fixed.group(4)!),
          int.parse(fixed.group(5)!),
          int.parse(fixed.group(6)!));
      if (utc == null) return null;
      return _applyOffset(utc, fixed.group(7));
    }
    final ascii = _asctime.firstMatch(value);
    if (ascii == null) return null;
    final month = _months.indexOf(ascii.group(1)!.toLowerCase());
    if (month < 0) return null;
    return _utcOrNull(
        int.parse(ascii.group(6)!),
        month + 1,
        int.parse(ascii.group(2)!),
        int.parse(ascii.group(3)!),
        int.parse(ascii.group(4)!),
        int.parse(ascii.group(5)!));
  }

  static DateTime? _utcOrNull(
      int year, int month, int day, int hour, int minute, int second) {
    if (day < 1 || day > 31 || hour > 23 || minute > 59 || second > 59) {
      return null;
    }
    final utc = DateTime.utc(year, month, day, hour, minute, second);
    if (utc.year != year || utc.month != month || utc.day != day) return null;
    return utc;
  }

  // RFC 822 zone names as ±HHMM; an unknown name reads as UTC.
  static const Map<String, int> _namedZones = <String, int>{
    'UT': 0,
    'UTC': 0,
    'GMT': 0,
    'Z': 0,
    'AST': -400,
    'ADT': -300,
    'EST': -500,
    'EDT': -400,
    'CST': -600,
    'CDT': -500,
    'MST': -700,
    'MDT': -600,
    'PST': -800,
    'PDT': -700,
  };

  static DateTime? _applyOffset(DateTime utc, String? zone) {
    if (zone == null) return utc;
    final int minutes;
    if (zone.startsWith('+') || zone.startsWith('-')) {
      if (zone.length != 5) return utc;
      final magnitude = int.parse(zone.substring(1, 3)) * 60 +
          int.parse(zone.substring(3, 5));
      if (magnitude >= Duration.minutesPerDay) return null;
      minutes = zone[0] == '-' ? -magnitude : magnitude;
    } else {
      final hoursMinutes = _namedZones[zone.toUpperCase()] ?? 0;
      final magnitude = hoursMinutes.abs();
      minutes = (hoursMinutes < 0 ? -1 : 1) *
          ((magnitude ~/ 100) * 60 + magnitude % 100);
    }
    return utc.subtract(Duration(minutes: minutes));
  }

  static void _requireFinite(String name, double value) {
    if (value.isNaN || value.isInfinite) {
      throw SdkConfigError(
          '$name: expected a finite number of seconds, got $value');
    }
  }
}

/// The statuses the SDK retries by default on a safe method —
/// `{429, 500, 502, 503, 504}`.
const Set<int> defaultRetryableHttpCodes =
    RetryPolicy.defaultRetryableHttpCodes;

/// The statuses the SDK retries by default even on a state-changing method —
/// empty: no status alone replays a write.
const Set<int> defaultUnsafeRetryableHttpCodes =
    RetryPolicy.defaultUnsafeRetryableHttpCodes;
