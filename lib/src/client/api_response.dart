import 'dart:convert';

import '../config/sdk_config.dart';
import '../errors.dart';
import '../redaction.dart';
import 'dto.dart';

/// Classification of a failed call, from the HTTP status and, for a 2xx, a body
/// that denies its own success.
enum ErrorType implements ErrorCategory {
  /// 2xx — no error.
  none('none'),

  /// 3xx — an unfollowed redirect.
  redirect('redirect'),

  /// 400/422 — the request was malformed or failed validation.
  validation('validation'),

  /// 401 — credentials were missing, rejected or expired.
  authentication('authentication'),

  /// 403 — authenticated but not permitted.
  authorization('authorization'),

  /// 404 — no such record.
  notFound('not_found'),

  /// 405 — wrong method for the path.
  methodNotAllowed('method_not_allowed'),

  /// 409 — a conflict with existing data.
  conflict('conflict'),

  /// 429 — rate limited.
  rateLimit('rate_limit'),

  /// 5xx — the server failed.
  server('server'),

  /// A transport-level failure with no HTTP status.
  network('network'),

  /// The request timed out.
  timeout('timeout'),

  /// Any other non-2xx status, and a 2xx whose body denied its own success.
  unknown('unknown');

  const ErrorType(this.value);

  /// The stable string form, safe to log or persist.
  final String value;

  /// The wire spelling, as [value].
  @override
  String toString() => value;

  /// The wire spelling, as [value], read through [ErrorCategory].
  @override
  String get wireName => value;

  /// Map an HTTP status to a classification.
  static ErrorType classify(int statusCode, {bool bodyDeniesSuccess = false}) {
    if (statusCode >= 200 && statusCode < 300) {
      return bodyDeniesSuccess ? ErrorType.unknown : ErrorType.none;
    }
    if (statusCode >= 300 && statusCode < 400) return ErrorType.redirect;
    return switch (statusCode) {
      400 || 422 => ErrorType.validation,
      401 => ErrorType.authentication,
      403 => ErrorType.authorization,
      404 => ErrorType.notFound,
      405 => ErrorType.methodNotAllowed,
      409 => ErrorType.conflict,
      429 => ErrorType.rateLimit,
      _ => (statusCode >= 500 && statusCode < 600)
          ? ErrorType.server
          : ErrorType.unknown,
    };
  }
}

/// An immutable record of the request behind a response: secrets redacted and
/// containers detached at construction.
final class RequestInfo implements RequestDetail {
  /// Build a record, redacting and detaching what is supplied.
  RequestInfo({
    this.clientName,
    this.apiVersion,
    this.httpMethod,
    String? url,
    String? endpointTemplate,
    Map<String, Object?>? queryParams,
    Object? body,
    Map<String, String>? headers,
    this.attemptCount = 1,
    this.maxAttempts = 1,
    this.elapsedSeconds = 0,
  })  : url = url == null ? null : Redaction.redactText(url),
        endpointTemplate = endpointTemplate ??
            (url == null ? null : deriveEndpointTemplate(url)),
        queryParams = _redactQueryParams(queryParams),
        body = _redactedSnapshot(body),
        headers = headers == null
            ? const <String, String>{}
            : Map<String, String>.unmodifiable(
                Redaction.redactMapping(headers));

  /// The logical instance name.
  final String? clientName;

  /// The API version segment.
  final String? apiVersion;

  /// The HTTP method.
  @override
  final String? httpMethod;

  /// The request URL, resolved, with secret query parameters redacted.
  @override
  final String? url;

  /// The endpoint this call named, path parameters unsubstituted.
  @override
  final String? endpointTemplate;

  /// The query parameters, secret keys and values redacted; unmodifiable.
  @override
  final Map<String, Object?> queryParams;

  /// The request body, redacted and detached at construction.
  final Object? body;

  /// The request headers, redacted at construction and unmodifiable.
  final Map<String, String> headers;

  /// Which attempt produced the response (1-based).
  @override
  final int attemptCount;

  /// The attempt ceiling in force.
  @override
  final int maxAttempts;

  /// Wall-clock seconds the exchange took.
  @override
  final double elapsedSeconds;

  static Map<String, Object?> _redactQueryParams(Map<String, Object?>? param) {
    if (param == null) return const <String, Object?>{};
    final shown = <String, Object?>{};
    param.forEach((key, value) {
      shown[key] = Redaction.shouldRedact(key)
          ? Redaction.redacted
          : _redactedSnapshot(value);
    });
    return Map<String, Object?>.unmodifiable(shown);
  }

  static Object? _redactedSnapshot(Object? value) =>
      _detached(Redaction.redactValue(value), 0);

  static Object? _detached(Object? value, int depth) {
    if (depth >= Redaction.maxDepth) return Redaction.tooDeep;
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }
    if (value is List<int>) return List<int>.unmodifiable(value);
    if (value is Map) {
      return Map<String, Object?>.unmodifiable(<String, Object?>{
        for (final entry in value.entries)
          '${entry.key}': _detached(entry.value, depth + 1)
      });
    }
    if (value is Iterable) {
      return List<Object?>.unmodifiable(
          value.map((item) => _detached(item, depth + 1)));
    }
    return '<${value.runtimeType}>';
  }
}

final RegExp _identifyingSegment =
    RegExp(r'^([0-9]+|[0-9a-fA-F-]{16,})$', caseSensitive: false);

/// The path of a resolved URL with every identifying segment replaced by `{id}`
/// and the query dropped.
String deriveEndpointTemplate(String url) {
  var path = url;
  final scheme = path.indexOf('://');
  if (scheme >= 0) {
    final slash = path.indexOf('/', scheme + 3);
    path = slash < 0 ? '/' : path.substring(slash);
  }
  for (final delimiter in const <String>['?', '#']) {
    final mark = path.indexOf(delimiter);
    if (mark >= 0) path = path.substring(0, mark);
  }
  return path.split('/').map(_templateSegment).join('/');
}

String _templateSegment(String segment) {
  if (segment.isEmpty) return segment;
  final lower = segment.toLowerCase();
  if (lower.contains('@') || lower.contains('%40')) return '{id}';
  return _identifyingSegment.hasMatch(segment) ? '{id}' : segment;
}

/// One HTTP exchange, readable four ways: [data] follows `responseFormat`,
/// while [map], [json] and [dto] always answer their own form.
class ApiResponse {
  /// Build a response.
  ApiResponse({
    required this.statusCode,
    required Object? data,
    required Map<String, String>? headers,
    required this.contentType,
    required this.requestInfo,
    ErrorType errorType = ErrorType.none,
    List<int>? bodyBytes,
    DtoDecoder? dtoDecoder,
    this.responseFormat = SdkConfig.responseFormatMap,
  })  : map = data,
        _bodyBytes = bodyBytes,
        _dtoDecoder = dtoDecoder,
        headers = headers == null
            ? const <String, String>{}
            : Map<String, String>.unmodifiable(headers),
        errorType = _deriveErrorType(statusCode, data, errorType);

  static const int _maxReportedMessages = 50;
  static const int _maxMessageDepth = 4;

  /// The HTTP status.
  final int statusCode;

  /// The decoded body, live and always in this form whatever `responseFormat`
  /// says: `Map`/`List` for JSON, `String` for text, `List<int>` for bytes.
  final Object? map;

  /// The response headers.
  final Map<String, String> headers;

  /// Which form [data] takes on this response: one of [SdkConfig.responseFormats].
  final String responseFormat;

  final List<int>? _bodyBytes;
  final DtoDecoder? _dtoDecoder;
  bool _jsonResolved = false;
  String? _jsonText;
  bool _dtoResolved = false;
  Object? _dtoValue;

  /// The response content type, or `null`.
  final String? contentType;

  /// The failure classification.
  final ErrorType errorType;

  /// What produced this response, for logging and diagnostics.
  final RequestInfo? requestInfo;

  /// The body in the form [responseFormat] resolved to, [map] by default, and
  /// `null` where that form has nothing to answer with — never another form.
  Object? get data => switch (responseFormat) {
        SdkConfig.responseFormatJson => json,
        SdkConfig.responseFormatDto => dto,
        _ => map,
      };

  /// The server's own body text, never a re-serialisation of [map]; `null` for
  /// a binary or empty body.
  String? get json {
    if (_jsonResolved) return _jsonText;
    _jsonResolved = true;
    final decoded = map;
    // Already decoded through its declared charset; UTF-8 would corrupt latin-1.
    if (decoded is String) return _jsonText = decoded;
    if (decoded == null || decoded is List<int>) return _jsonText = null;
    final bytes = _bodyBytes;
    if (bytes == null) return _jsonText = null;
    return _jsonText = utf8.decode(bytes, allowMalformed: true);
  }

  /// The typed view of this body, its type the endpoint's own answer, or `null`
  /// where the body cannot be typed or the endpoint declared no type.
  Object? get dto {
    if (_dtoResolved) return _dtoValue;
    _dtoResolved = true;
    final decoder = _dtoDecoder;
    if (decoder == null) return _dtoValue = null;
    return _dtoValue = decoder(map);
  }

  /// Whether the call succeeded: a 2xx whose body does not carry a falsy `isSuccess`.
  bool get succeeded =>
      statusCode >= 200 && statusCode < 300 && !_bodyDeniesSuccess(map);

  static ErrorType _deriveErrorType(
      int statusCode, Object? data, ErrorType supplied) {
    if (supplied != ErrorType.none) return supplied;
    return ErrorType.classify(statusCode,
        bodyDeniesSuccess: _bodyDeniesSuccess(data));
  }

  // Only a present-but-falsy isSuccess denies; the string 'false' is truthy.
  static bool _bodyDeniesSuccess(Object? data) {
    if (data is! Map) return false;
    if (!data.containsKey('isSuccess')) return false;
    return !_isTruthy(data['isSuccess']);
  }

  /// JSON truthiness: what an `isSuccess` flag counts as true.
  static bool _isTruthy(Object? value) => switch (value) {
        null => false,
        final bool flag => flag,
        final num number => number != 0,
        final String text => text.isNotEmpty,
        final Iterable<Object?> items => items.isNotEmpty,
        final Map<Object?, Object?> entries => entries.isNotEmpty,
        _ => true,
      };

  /// Extract human-readable problems from an error body, most specific first:
  /// `errors[]`, then `message`, then `error`/`errorCode`.
  List<String> getErrorMessages() {
    Object? body = map;
    if (body is! Map) body = _parseJsonBody(body);
    if (body is! Map) return const <String>[];

    var messages = _readErrorEntries(body['errors']);
    if (messages.isEmpty) messages = _readMessageValue(body['message'], 0);
    if (messages.isEmpty) {
      messages = _readMessageValue(body['error'], 0);
      if (messages.isEmpty) messages = _readMessageValue(body['errorCode'], 0);
    }
    if (messages.isEmpty) {
      // RFC 7807, for an intermediary answering instead of WebCommander.
      messages = _readMessageValue(body['detail'], 0);
      if (messages.isEmpty) messages = _readMessageValue(body['title'], 0);
    }
    return _capMessages(messages);
  }

  /// Throw when the call failed, otherwise return this response; 401 and 403 raise
  /// [SdkAuthError], and the message carries the status alone.
  ApiResponse raiseForStatus() {
    if (succeeded) return this;
    final messages = getErrorMessages();
    final summary = 'HTTP $statusCode';
    final build = statusCode == 401 || statusCode == 403
        ? SdkAuthError.new
        : SdkError.new;
    final error = build(summary,
        statusCode: statusCode,
        errorType: errorType,
        rawResponse: Redaction.redactValue(map),
        responseHeaders: Redaction.redactMapping(headers),
        requestInfo: requestInfo);
    for (final message in messages) {
      error.addError(message);
    }
    throw error;
  }

  static Object? _parseJsonBody(Object? body) {
    String text;
    if (body is List<int>) {
      text = utf8.decode(body, allowMalformed: true);
    } else if (body is String) {
      text = body;
    } else {
      return null;
    }
    text = text.trim();
    if (text.isNotEmpty && text.codeUnitAt(0) == 0xFEFF) {
      text = text.substring(1);
    }
    if (!text.startsWith('{') && !text.startsWith('[')) return null;
    try {
      final parsed = jsonDecode(text);
      return parsed is Map ? parsed : null;
    } on FormatException {
      return null;
    }
  }

  static List<String> _readErrorEntries(Object? entries) {
    final messages = <String>[];
    if (entries is Map) {
      entries.forEach((field, value) {
        _prefixField(field, _readMessageValue(value, 0), messages);
      });
      return messages;
    }
    if (entries is List) {
      for (final entry in entries) {
        if (entry is Map) {
          final text = entry['message'] ?? entry['code'];
          _prefixField(entry['field'], _readMessageValue(text, 0), messages);
        } else {
          messages.addAll(_readMessageValue(entry, 0));
        }
      }
      return messages;
    }
    if (entries is String) return _readMessageValue(entries, 0);
    return messages;
  }

  static List<String> _readMessageValue(Object? value, int depth) {
    if (value == null || depth > _maxMessageDepth) return const <String>[];
    if (value is String) {
      return value.trim().isEmpty ? const <String>[] : <String>[value];
    }
    if (value is Map) {
      final text = value['message'] ?? value['code'];
      return _readMessageValue(text, depth + 1);
    }
    if (value is List) {
      final messages = <String>[];
      for (final item in value) {
        messages.addAll(_readMessageValue(item, depth + 1));
      }
      return messages;
    }
    final text = value.toString();
    return text.trim().isEmpty ? const <String>[] : <String>[text];
  }

  static void _prefixField(
      Object? fieldName, List<String> fieldMessages, List<String> out) {
    final name = fieldName == null ? '' : fieldName.toString().trim();
    for (final message in fieldMessages) {
      out.add(name.isEmpty ? message : '$name: $message');
    }
  }

  static List<String> _capMessages(List<String> messages) {
    if (messages.length <= _maxReportedMessages) return messages;
    return messages.sublist(0, _maxReportedMessages)
      ..add('+${messages.length - _maxReportedMessages} more problems');
  }
}
