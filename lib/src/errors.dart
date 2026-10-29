/// The SDK's error hierarchy, plus the insecure-transport warning.
library;

import 'redaction.dart';

/// The slice of a request record that [SdkError.explain] reads.
abstract class RequestDetail {
  /// The HTTP method, so [SdkError.toString] can name the call.
  String? get httpMethod;

  /// The request URL, redacted but resolved, so renderings use [endpointTemplate].
  String? get url;

  /// The endpoint with its path parameters unsubstituted; identifier-free.
  String? get endpointTemplate;

  /// The query parameters, already redacted.
  Map<String, Object?> get queryParams;

  /// Which attempt produced this outcome (1-based); `0` when unrecorded.
  int get attemptCount;

  /// The attempt ceiling in force; `0` when unrecorded.
  int get maxAttempts;

  /// Wall-clock seconds the exchange took.
  double get elapsedSeconds;
}

/// A failure classification that declares its wire spelling through [wireName].
abstract interface class ErrorCategory {
  /// The category's wire spelling: lower-case letters and underscores.
  String get wireName;
}

/// Base class for every error the SDK raises, and thrown for a non-2xx response.
/// Its default rendering is structural; [explain] opts into the sensitive detail.
class SdkError implements Exception {
  /// Creates an error; [message] is rendered by default, so it must stay structural.
  SdkError(
    this.message, {
    this.statusCode,
    this.errorType,
    this.rawResponse,
    Map<String, String>? responseHeaders,
    this.requestInfo,
    this.cause,
  }) : responseHeaders = responseHeaders == null
            ? const <String, String>{}
            : Map<String, String>.unmodifiable(responseHeaders);

  /// The SDK's own structural summary of the failure, safe to render by default.
  final String message;

  /// The HTTP status, when the error came from a response.
  final int? statusCode;

  /// The failure classification, an `ErrorType`; `null` when there is none.
  final Object? errorType;

  /// The decoded response body, redacted.
  final Object? rawResponse;

  /// Response headers, already redacted; empty when there was no response.
  final Map<String, String> responseHeaders;

  /// Describes the call that failed, with secrets already redacted.
  final Object? requestInfo;

  /// The underlying error, when this wraps one.
  final Object? cause;

  final List<String> _errors = <String>[];

  /// Append one field-level message extracted from the response body; chainable.
  SdkError addError(String errorMessage) {
    _errors.add(errorMessage);
    return this;
  }

  /// The field-level messages the API supplied; empty when there was no detail.
  List<String> getErrorMessages() => List<String>.unmodifiable(_errors);

  /// A suggestion for what to do about this failure, or `null`.
  String? getHint() => statusCode == null ? null : _hintsByStatus[statusCode];

  /// The diagnostic as one printable block; [includeSensitive] adds query values,
  /// messages and the body, which carry customer data.
  String explain({bool includeSensitive = false}) {
    final lines = StringBuffer(toString());

    final info = requestInfo;
    if (info is RequestDetail) {
      if (info.queryParams.isNotEmpty) {
        final names = info.queryParams.keys.toList()..sort();
        lines.write(includeSensitive
            ? '\n  params  : ${_flatten(Redaction.redactValue(info.queryParams))}'
            : '\n  params  : ${_flatten(names.join(', '))}');
      }
      if (info.attemptCount > 0 && info.maxAttempts > 0) {
        lines.write('\n  attempt : ${info.attemptCount}/${info.maxAttempts}');
      }
      lines.write('\n  elapsed : ${info.elapsedSeconds}s');
      final url = info.url;
      if (includeSensitive && url != null && url.isNotEmpty) {
        lines.write('\n  url     : ${_flatten(Redaction.redactText(url))}');
      }
    }

    final location = _redirectTarget(responseHeaders);
    if (location != null && includeSensitive) {
      lines.write('\n  location: ${_flatten(Redaction.redactText(location))}');
    }

    final reported = getErrorMessages();
    if (reported.isNotEmpty) {
      if (includeSensitive) {
        lines.write('\n  reported:');
        for (final reportedMessage in reported) {
          lines.write(
              '\n    - ${_flatten(Redaction.redactText(reportedMessage))}');
        }
      } else {
        lines.write('\n  reported: ${reported.length} message(s) from the '
            'server, withheld');
      }
    }

    final hint = getHint();
    if (hint != null) lines.write('\n  hint    : $hint');

    if (rawResponse != null) {
      if (includeSensitive) {
        var body = _flatten(Redaction.redactValue(rawResponse));
        if (body.length > 500) {
          body = '${body.substring(0, 500)}... +${body.length - 500} chars';
        }
        lines.write('\n  body    : $body');
      } else {
        lines.write('\n  body    : ${describeSafeShape(rawResponse)}');
      }
    }
    if (!includeSensitive) {
      lines.write('\n  detail  : explain(includeSensitive: true) adds the '
          'values, the messages and the body');
    }
    return lines.toString();
  }

  /// One structural line naming the exception, status, category, call and reason.
  @override
  String toString() {
    final head = StringBuffer('$runtimeType');
    if (statusCode != null) head.write(' $statusCode');
    final classification = errorType;
    if (classification != null) {
      // Never calls an arbitrary toString(): a category spells itself via ErrorCategory.
      final spelling =
          classification is ErrorCategory ? classification.wireName : null;
      head.write(spelling != null && _categorySpelling.hasMatch(spelling)
          ? ' $spelling'
          : ' <${_flatten(classification.runtimeType)}>');
    }
    final info = requestInfo;
    if (info is RequestDetail) {
      final method = info.httpMethod;
      final template = info.endpointTemplate;
      if (method != null &&
          method.isNotEmpty &&
          template != null &&
          template.isNotEmpty) {
        head.write(' ${_flatten(method)} ${_flatten(template)}');
      }
      if (info.attemptCount > 0 && info.maxAttempts > 0) {
        head.write(' attempt ${info.attemptCount}/${info.maxAttempts}');
      }
    }
    return '$head - ${_flatten(Redaction.redactText(message))}';
  }

  /// The spelling a classification needs to be rendered as one.
  static final RegExp _categorySpelling = RegExp(r'^[a-z][a-z_]{0,30}$');

  /// How many of a value's key names a shape names before it counts the rest.
  static const int _shownKeyNames = 12;

  /// What a value is, without what it holds: key names, sizes and types only.
  static String describeSafeShape(Object? value) {
    if (value == null) return 'null';
    if (value is Map) {
      final names = value.keys.map((key) => _flatten('$key')).toList()..sort();
      final shown = names.length > _shownKeyNames
          ? names.sublist(0, _shownKeyNames)
          : names;
      final rest = names.length - shown.length;
      return 'Map(${names.length} keys: ${shown.join(', ')}'
          '${rest > 0 ? ', +$rest more' : ''})';
    }
    if (value is List<int>) return 'bytes(${value.length})';
    if (value is Iterable) return 'List(${value.length} entries)';
    if (value is String) return 'String(${value.length} chars)';
    if (value is num || value is bool) return '${value.runtimeType}';
    return '<${value.runtimeType}>';
  }

  /// Render one server-controlled value as a single escaped line.
  static String _flatten(Object? value) {
    final text = value?.toString() ?? 'null';
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune <= 0x1f ||
          (rune >= 0x7f && rune <= 0x9f) ||
          rune == 0x2028 ||
          rune == 0x2029) {
        switch (rune) {
          case 0x0a:
            buffer.write(r'\n');
          case 0x0d:
            buffer.write(r'\r');
          case 0x09:
            buffer.write(r'\t');
          default:
            buffer.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
        }
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  static String? _redirectTarget(Map<String, String> headers) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == 'location') return entry.value;
    }
    return null;
  }

  static const String _redirectHint =
      'redirect not followed - read the Location header off the response';

  static const Map<int, String> _hintsByStatus = <int, String>{
    301: _redirectHint,
    302: _redirectHint,
    303: _redirectHint,
    307: _redirectHint,
    308: _redirectHint,
    400:
        'the API rejected the request itself - check the payload shape and the '
            'query parameter names against the endpoint documentation',
    401:
        'credentials were rejected, or the token expired and could not be renewed '
            '- check clientId, clientSecret and authString',
    403: 'authenticated, but this client is not allowed to do that',
    404: 'no such record - check the id you passed actually exists',
    405: 'wrong HTTP method for this path',
    409: 'conflicts with existing data, e.g. an email already in use',
    429: 'rate limited - slow down, or raise maxRetries so the SDK waits and '
        'retries for you',
    500: 'the server failed. Retrying may help on a read; the SDK will not retry a '
        'write on a 500, because it cannot tell whether the server committed',
  };
}

/// Configuration is missing or invalid; raised at construction, lists every problem.
class SdkConfigError extends SdkError {
  /// Creates a configuration error.
  SdkConfigError(super.message, {super.cause});
}

/// A caller mistake the SDK caught before any network I/O.
class SdkUsageError extends SdkError {
  /// Creates a usage error.
  SdkUsageError(super.message, {super.cause});
}

/// A name that does not exist on a client or on a bound resource.
class SdkAttributeError extends SdkUsageError {
  /// Creates an unknown-name error.
  SdkAttributeError(super.message, {super.cause});
}

/// Authentication failed: the token endpoint rejected the credentials, or a 401/403.
class SdkAuthError extends SdkError {
  /// Creates an auth error, optionally carrying the full response context.
  SdkAuthError(
    super.message, {
    super.statusCode,
    super.errorType,
    super.rawResponse,
    super.responseHeaders,
    super.requestInfo,
  });
}

/// Transport that cannot be trusted: TLS verification off, or plain `http://` to a
/// remote host. A warning, not an [SdkError]: construction still succeeds.
class InsecureTransportWarning {
  /// Creates the warning.
  InsecureTransportWarning(this.message);

  /// Why the transport cannot be trusted.
  final String message;

  @override
  String toString() => 'InsecureTransportWarning: $message';
}
