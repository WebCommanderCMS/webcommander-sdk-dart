import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

import '../client/api_response.dart';
import '../client/dto.dart';
import '../config/sdk_config.dart';
import '../errors.dart';
import '../redaction.dart';
import 'client_factory_web.dart' if (dart.library.io) 'client_factory_io.dart';
import 'header_grammar.dart';
import 'retry_policy.dart';

/// Refuse a `files` entry that is not bytes, a contents `String`, or
/// `[filename, contents, contentType?]`.
void validateFilePart(String field, Object? value) {
  _refusePartLabelBytes(
      'a files part name of ${field.length} code unit(s)', field);
  if (value is List<int>) return;
  if (value is String) return;
  if (value is List &&
      value.length >= 2 &&
      value[0] is String &&
      (value[1] is List<int> || value[1] is String)) {
    _validatePartLabels(field, value);
    return;
  }
  throw SdkUsageError("files: '$field' must be bytes, a String of contents, or "
      '[filename, contents, contentType?]');
}

// Parsed here: MediaType.parse throws a FormatException no SdkError handler covers.
void _validatePartLabels(String field, List<Object?> entry) {
  _refusePartLabelBytes("the filename on part '$field'", entry[0]! as String);
  if (entry.length < 3) return;
  final declared = entry[2];
  if (declared is! String) return;
  _refusePartLabelBytes("the contentType on part '$field'", declared);
  try {
    MediaType.parse(declared);
  } on FormatException catch (error) {
    throw SdkUsageError(
        "files: '$field' contentType is not a media type, got "
        '${jsonEncode(declared)} - use a `type/subtype` value such as '
        "'text/csv', or drop the third element to send "
        "'application/octet-stream'",
        cause: error);
  }
}

void _refusePartLabelBytes(String what, String value) {
  for (var index = 0; index < value.length; index++) {
    final String? found = switch (value.codeUnitAt(index)) {
      0x0d => 'a carriage return',
      0x0a => 'a newline',
      0x00 => 'a NUL',
      _ => null,
    };
    if (found == null) continue;
    throw SdkUsageError('$what carries $found at code unit $index');
  }
}

// Percent form, not backslash: most servers do not honour a backslash escape.
String _escapePartParameter(String value) =>
    value.replaceAll(r'\', '%5C').replaceAll('"', '%22');

/// Refuse a header no HTTP layer can safely send; the value is never quoted.
void validateRequestHeaders(Map<String, String>? headers) {
  if (headers == null) return;
  for (final entry in headers.entries) {
    if (sendableHeaderName(entry.key) && sendableHeaderValue(entry.value)) {
      continue;
    }
    throw SdkUsageError(
        'header ${jsonEncode(entry.key)}: not something the transport can '
        'send - a name or value carrying a carriage return, a newline, a NUL, '
        'another control character, a colon in the name, a blank name, '
        'leading or trailing whitespace in the value, or a character outside '
        'printable ASCII. An internal tab is allowed. The value is not shown: '
        'it may be a credential');
  }
}

const int _perElementSourceBytes = 16;

class _ByteBudget {
  _ByteBudget(this.limit, this.what, this.field);

  /// The ceiling, in bytes.
  final int limit;

  /// What is being counted, as it reads in the refusal.
  final String what;

  /// The `SdkConfig` field a caller raises to accept it.
  final String field;

  int _spent = 0;

  int get spent => _spent;

  /// Charge [bytes], refusing once the running total passes [limit].
  void charge(int bytes) {
    _spent += bytes;
    if (_spent > limit) {
      throw SdkUsageError('$what passes the $limit-byte $field ceiling at '
          '$_spent byte(s); raise SdkConfig.$field to accept it, or send less. '
          'The value is not shown: it is the payload');
    }
  }
}

int _utf8LengthCapped(String text, int limit) {
  var total = 0;
  for (var index = 0; index < text.length; index++) {
    final unit = text.codeUnitAt(index);
    if (unit < 0x80) {
      total += 1;
    } else if (unit < 0x800) {
      total += 2;
    } else if (unit >= 0xd800 && unit < 0xdc00 && index + 1 < text.length) {
      final low = text.codeUnitAt(index + 1);
      if (low >= 0xdc00 && low < 0xe000) {
        total += 4;
        index++;
      } else {
        total += 3;
      }
    } else {
      total += 3;
    }
    if (total > limit) return limit + 1;
  }
  return total;
}

class _BodyWriter {
  _BodyWriter(this._wire, [this._framing]);

  final _ByteBudget _wire;

  final _ByteBudget? _framing;

  final BytesBuilder _collected = BytesBuilder(copy: false);

  void writeFraming(String text) {
    final bytes = utf8.encode(text);
    _framing?.charge(bytes.length);
    _append(bytes);
  }

  void writeContent(List<int> bytes) => _append(bytes);

  void writeContentText(String text) => _append(utf8.encode(text));

  void _append(List<int> bytes) {
    _wire.charge(bytes.length);
    _collected.add(bytes);
  }

  Uint8List takeBytes() => _collected.takeBytes().asUnmodifiableView();
}

class _CappedJsonSink implements Sink<List<int>> {
  _CappedJsonSink(this._writer);

  final _BodyWriter _writer;

  @override
  void add(List<int> chunk) => _writer.writeContent(chunk);

  @override
  void close() {}
}

class _ResponseOverCap implements Exception {
  _ResponseOverCap(this.limitBytes, [this.declaredBytes]);

  final int limitBytes;

  final int? declaredBytes;
}

class _PhaseAwareRequest extends http.Request with http.Abortable {
  _PhaseAwareRequest(super.method, super.url, this.abortTrigger);

  @override
  final Future<void>? abortTrigger;

  bool get writeBegun => _writeBegun;
  bool _writeBegun = false;

  @override
  http.ByteStream finalize() {
    final inner = super.finalize();
    late StreamSubscription<List<int>> subscription;
    // sync: the flag must be set in the microtask the client starts reading in.
    final controller = StreamController<List<int>>(sync: true);
    controller
      ..onListen = () {
        _writeBegun = true;
        subscription = inner.listen(controller.add,
            onError: controller.addError, onDone: controller.close);
      }
      ..onPause = () {
        subscription.pause();
      }
      ..onResume = () {
        subscription.resume();
      }
      ..onCancel = () => subscription.cancel();
    return http.ByteStream(controller.stream);
  }
}

/// HTTP execution over `package:http`: retries, per-attempt timeouts, decoding
/// and the stale-echo workaround. Redirects are not followed.
class Transport {
  /// Build a transport sending through [client], or through a default it owns.
  Transport(
    this._config, {
    RetryPolicy? retryPolicy,
    http.Client? client,
    void Function(String message)? onProgress,
  })  : _retryPolicy = retryPolicy ?? RetryPolicy.fromConfig(_config),
        _onProgress = onProgress ?? _noop,
        _ownsClient = client == null,
        _client = client ?? createDefaultClient(_config);

  static const String _unknownParameterError = 'unknown_parameter';
  static final RegExp _parameterName = RegExp(r'[A-Za-z0-9_-]+');

  final SdkConfig _config;
  final RetryPolicy _retryPolicy;
  final void Function(String message) _onProgress;

  final bool _ownsClient;

  http.Client _client;

  static void _noop(String _) {}

  Duration get _timeout =>
      Duration(milliseconds: (_config.timeoutSeconds * 1000).round());

  /// Send one request, retried per the policy, and return its decoded [ApiResponse].
  Future<ApiResponse> sendHttpRequest(TransportRequest request) async {
    final method = request.httpMethod;
    final url = request.wireUrl;
    validateRequestHeaders(request.headers);
    final started = Stopwatch()..start();
    var attempt = 0;
    var requestsSent = 0;
    var staleEchoResent = false;
    Object? lastError;

    while (attempt < _retryPolicy.maxAttempts) {
      attempt++;
      requestsSent++;
      _onProgress('$method ${_endpointOf(request, url)} sending '
          '(attempt $attempt/${_retryPolicy.maxAttempts})');

      // Outside the try, whose catch would misfile a caller error as a network one.
      final abortGate = Completer<void>();
      final prepared = _buildRequest(method, url, request, abortGate.future);

      final attemptClock = Stopwatch()..start();
      var responseHeadersArrived = false;

      final http.StreamedResponse raw;
      final List<int> bodyBytes;
      try {
        raw = await _sendUnderBudget(prepared, abortGate, attemptClock);
        responseHeadersArrived = true;
        bodyBytes = await _readBodyUnderBudget(raw, abortGate, attemptClock);
      } on _ResponseOverCap catch (error) {
        throw SdkError(
            'the response body is larger than the ${error.limitBytes}-byte cap '
            'this client buffers'
            '${error.declaredBytes == null ? '' : ' (Content-Length ${error.declaredBytes})'}'
            '; raise SdkConfig.maxResponseBytes to accept it',
            errorType: ErrorType.unknown,
            requestInfo: _requestInfo(request, requestsSent,
                _grantedAttempts(staleEchoResent), started));
      } on Object catch (error) {
        lastError = error;
        if (attempt >= _retryPolicy.maxAttempts ||
            !_retryPolicy.shouldRetryAfterException(
                error, method, responseHeadersArrived || prepared.writeBegun)) {
          break;
        }
        await _delaySeconds(_retryPolicy.computeBackoffSeconds(attempt));
        continue;
      }

      final status = raw.statusCode;
      final contentType = raw.headers['content-type'];

      if (attempt < _retryPolicy.maxAttempts &&
          _retryPolicy.shouldRetryStatusCode(status, method)) {
        await _delaySeconds(_retryPolicy.computeBackoffSeconds(
            attempt, raw.headers['retry-after']));
        continue;
      }

      final decoded = decodeResponseBody(status, bodyBytes, contentType);
      final response = _buildResponse(raw, decoded, bodyBytes, request,
          requestsSent, _grantedAttempts(staleEchoResent), started);

      if (!staleEchoResent &&
          RetryPolicy.safeMethods.contains(method) &&
          _detectStaleParameterEcho(response, request.queryParams)) {
        staleEchoResent = true;
        attempt--;
        _discardPooledConnections();
        continue;
      }
      return response;
    }

    final timedOut = _isTimeout(lastError);
    // Platform text is withheld, as it can echo a rejected value; it rides on cause.
    throw SdkError(
      'the request ${timedOut ? 'timed out' : 'failed'} after $requestsSent '
      'attempt(s) (${lastError.runtimeType})',
      errorType: timedOut ? ErrorType.timeout : ErrorType.network,
      requestInfo: _requestInfo(
          request, requestsSent, _grantedAttempts(staleEchoResent), started),
      cause: lastError,
    );
  }

  /// Close the underlying HTTP client, releasing its pooled connections.
  void close() => _client.close();

  /// Release pooled connections. An alias for [close].
  void closeTransport() => close();

  void _discardPooledConnections() {
    if (!_ownsClient || !canDiscardPooledConnections) return;
    final previous = _client;
    _client = createDefaultClient(_config);
    previous.close();
  }

  Duration _remainingBudget(Stopwatch attemptClock) {
    final left = _timeout - attemptClock.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  Future<http.StreamedResponse> _sendUnderBudget(http.BaseRequest prepared,
      Completer<void> abortGate, Stopwatch attemptClock) {
    final pending = _client.send(prepared);
    unawaited(pending.then<void>((_) {}).catchError((Object _) {}));
    return pending.timeout(_remainingBudget(attemptClock), onTimeout: () {
      _abort(abortGate);
      throw TimeoutException('no response headers', _timeout);
    });
  }

  Future<List<int>> _readBodyUnderBudget(http.StreamedResponse raw,
      Completer<void> abortGate, Stopwatch attemptClock) {
    final limit = _config.maxResponseBytes;
    final declared = raw.contentLength;
    if (declared != null && declared > limit) {
      _abort(abortGate);
      unawaited(raw.stream
          .listen(null, cancelOnError: true)
          .cancel()
          .catchError((Object _) {}));
      return Future<List<int>>.error(_ResponseOverCap(limit, declared));
    }
    final completer = Completer<List<int>>();
    final collected = BytesBuilder(copy: false);
    late final StreamSubscription<List<int>> subscription;
    void stopWith(Object error) {
      _abort(abortGate);
      unawaited(subscription.cancel().catchError((Object _) {}));
      completer.completeError(error);
    }

    final budget = Timer(_remainingBudget(attemptClock), () {
      if (completer.isCompleted) return;
      stopWith(TimeoutException('the response body did not finish', _timeout));
    });
    subscription = raw.stream.listen(
      (List<int> chunk) {
        if (completer.isCompleted) return;
        if (collected.length + chunk.length > limit) {
          budget.cancel();
          stopWith(_ResponseOverCap(limit));
          return;
        }
        collected.add(chunk);
      },
      onDone: () {
        budget.cancel();
        if (!completer.isCompleted) completer.complete(collected.takeBytes());
      },
      onError: (Object error, StackTrace stack) {
        budget.cancel();
        if (!completer.isCompleted) completer.completeError(error, stack);
      },
      cancelOnError: true,
    );
    return completer.future;
  }

  static String _endpointOf(TransportRequest request, String url) =>
      request.endpointTemplate ?? deriveEndpointTemplate(url);

  static void _abort(Completer<void> abortGate) {
    if (!abortGate.isCompleted) abortGate.complete();
  }

  _PhaseAwareRequest _buildRequest(String method, String url,
      TransportRequest request, Future<void> abortTrigger) {
    final uri = Uri.parse(url);
    final httpRequest = _PhaseAwareRequest(method, uri, abortTrigger)
      ..followRedirects = false;
    if (request.headers != null) httpRequest.headers.addAll(request.headers!);
    final encoded = request.encodedBody;
    if (encoded != null) {
      final contentType = request.encodedContentType;
      if (contentType != null) {
        if (request.ownsContentType) {
          httpRequest.headers['content-type'] = contentType;
        } else {
          httpRequest.headers.putIfAbsent('content-type', () => contentType);
        }
      }
      // bodyBytes, not body/bodyFields, which re-encode and append a charset.
      httpRequest.bodyBytes = encoded;
    }
    return httpRequest;
  }

  ApiResponse _buildResponse(
      http.StreamedResponse raw,
      Object? decoded,
      List<int> bodyBytes,
      TransportRequest request,
      int attempt,
      int maxAttempts,
      Stopwatch started) {
    return ApiResponse(
      statusCode: raw.statusCode,
      data: decoded,
      headers: raw.headers,
      contentType: raw.headers['content-type'],
      requestInfo: _requestInfo(request, attempt, maxAttempts, started),
      bodyBytes: bodyBytes,
      dtoDecoder: request.dtoDecoder,
      responseFormat: request.responseFormat,
    );
  }

  RequestInfo _requestInfo(TransportRequest request, int attempt,
          int maxAttempts, Stopwatch started) =>
      RequestInfo(
        clientName: _config.clientName,
        apiVersion: _config.apiVersion,
        httpMethod: request.httpMethod,
        url: request.url,
        endpointTemplate: request.endpointTemplate,
        queryParams: request.queryParams,
        body: request.requestInfoBody,
        headers: request.requestInfoHeaders ?? const <String, String>{},
        attemptCount: attempt,
        maxAttempts: maxAttempts,
        elapsedSeconds: (started.elapsedMicroseconds / 1e6 * 1e4).round() / 1e4,
      );

  int _grantedAttempts(bool staleEchoResent) =>
      _retryPolicy.maxAttempts + (staleEchoResent ? 1 : 0);

  // A store keep-alive defect shifts a 400 onto the next request on the connection.
  static bool _detectStaleParameterEcho(
      ApiResponse response, Map<String, Object?>? sentParams) {
    if (response.statusCode != 400 || response.map is! Map) return false;
    final body = response.map! as Map;
    var namedFields = _extractErrorFields(body);
    if (namedFields.isEmpty && body['error'] == _unknownParameterError) {
      namedFields = _parseUnknownParameterMessage(body);
    }
    if (namedFields.isEmpty) return false;
    final sent = <String>{};
    if (sentParams != null) {
      for (final name in sentParams.keys) {
        sent.add(name.toLowerCase());
      }
    }
    if (sent.isEmpty) return false;
    return namedFields.intersection(sent).isEmpty;
  }

  static Set<String> _extractErrorFields(Map<Object?, Object?> body) {
    final fields = <String>{};
    final entries = body['errors'];
    if (entries is Map) {
      for (final fieldName in entries.keys) {
        final name = fieldName.toString().trim().toLowerCase();
        if (name.isNotEmpty) fields.add(name);
      }
    } else if (entries is List) {
      for (final entry in entries) {
        if (entry is Map && entry['field'] != null) {
          fields.add(entry['field'].toString().trim().toLowerCase());
        }
      }
    }
    return fields;
  }

  static Set<String> _parseUnknownParameterMessage(Map<Object?, Object?> body) {
    final fields = <String>{};
    final message = (body['message'] ?? '').toString();
    const marker = 'unknown query parameter(s):';
    final markerIndex = message.indexOf(marker);
    if (markerIndex >= 0) {
      for (final listed
          in message.substring(markerIndex + marker.length).split(',')) {
        final named = _parameterName.firstMatch(listed);
        if (named != null) fields.add(named.group(0)!.toLowerCase());
      }
    }
    return fields;
  }

  static bool _isTimeout(Object? error) =>
      error is TimeoutException || (error != null && isConnectTimeout(error));

  static Future<void> _delaySeconds(double seconds) async {
    // `!(seconds > 0)` rather than `seconds <= 0`, so NaN cannot reach Duration.
    if (!(seconds > 0)) return;
    await Future<void>.delayed(
        Duration(milliseconds: (seconds * 1000).round()));
  }
}

/// One request, snapshotted at construction: method normalised, query merged into
/// [wireUrl] and body encoded, so every attempt and replay sends the same bytes.
final class TransportRequest {
  /// Name only the method and URL; set the rest with named arguments.
  factory TransportRequest(
    String httpMethod,
    String url, {
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    Map<String, String>? requestInfoHeaders,
    Object? requestInfoBody,
    String responseFormat = SdkConfig.responseFormatMap,
    DtoDecoder? dtoDecoder,
    String? endpointTemplate,
    int maxRequestBytes = SdkConfig.defaultMaxRequestBytes,
    int maxRequestSourceBytes = SdkConfig.defaultMaxRequestSourceBytes,
    int maxMultipartOverheadBytes = SdkConfig.defaultMaxMultipartOverheadBytes,
  }) {
    final sourceBudget = _ByteBudget(
        maxRequestSourceBytes, 'the request payload', 'maxRequestSourceBytes');
    final frozenJson = _frozenValue(jsonBody, sourceBudget);
    final frozenForm = _frozenMap(formData, sourceBudget);
    final frozenFiles = _frozenMap(files, sourceBudget);
    final frozenQuery = _frozenMap(
        queryParams,
        _ByteBudget(maxRequestSourceBytes, 'the query parameters',
            'maxRequestSourceBytes'));
    final frozenRequestInfoBody = _frozenValue(
        requestInfoBody,
        _ByteBudget(maxRequestSourceBytes, 'the recorded request body',
            'maxRequestSourceBytes'));
    final multipart = frozenFiles != null && frozenFiles.isNotEmpty;
    if (multipart && frozenForm != null) {
      for (final name in frozenForm.keys) {
        _refusePartLabelBytes(
            'a formData name of ${name.length} code unit(s)', name);
      }
    }
    final wireBudget =
        _ByteBudget(maxRequestBytes, 'the request body', 'maxRequestBytes');
    final Map<String, String>? fields =
        multipart ? _materialiseFields(frozenForm) : null;
    final List<_MultipartPart> parts = frozenFiles == null || !multipart
        ? const <_MultipartPart>[]
        : _materialiseParts(frozenFiles);
    final String? boundary = multipart ? _generateMultipartBoundary() : null;
    return TransportRequest._(
      httpMethod: normaliseHttpMethod(httpMethod),
      url: url,
      wireUrl: _materialiseWireUrl(url, frozenQuery),
      endpointTemplate: endpointTemplate,
      queryParams: frozenQuery,
      jsonBody: frozenJson,
      formData: frozenForm,
      files: frozenFiles,
      headers: _frozenHeaders(headers),
      requestInfoHeaders: _frozenHeaders(requestInfoHeaders),
      requestInfoBody: frozenRequestInfoBody,
      responseFormat: responseFormat,
      dtoDecoder: dtoDecoder,
      encodedBody: boundary == null
          ? _encodeBody(frozenJson, frozenForm, wireBudget)
          : _frameMultipartBody(
              boundary,
              fields,
              parts,
              wireBudget,
              _ByteBudget(maxMultipartOverheadBytes, 'the multipart framing',
                  'maxMultipartOverheadBytes')),
      encodedContentType: boundary == null
          ? _encodedContentType(frozenJson, frozenForm)
          : '$_multipartMediaType; boundary=$boundary',
      ownsContentType: boundary != null,
    );
  }

  const TransportRequest._({
    required this.httpMethod,
    required this.url,
    required this.wireUrl,
    required this.endpointTemplate,
    required this.queryParams,
    required this.jsonBody,
    required this.formData,
    required this.files,
    required this.headers,
    required this.requestInfoHeaders,
    required this.requestInfoBody,
    required this.responseFormat,
    required this.dtoDecoder,
    required this.encodedBody,
    required this.encodedContentType,
    required this.ownsContentType,
  });

  /// The HTTP method, trimmed and upper-cased once at construction.
  final String httpMethod;

  /// The absolute request URL, without [queryParams].
  final String url;

  /// [url] with [queryParams] appended and percent-encoded, resolved once.
  final String wireUrl;

  /// The endpoint with path parameters unsubstituted, or `null` if none was named.
  final String? endpointTemplate;

  /// Query parameters to append, already normalised by the caller — an unmodifiable copy.
  final Map<String, Object?>? queryParams;

  /// The JSON body to send, as an unmodifiable snapshot.
  final Object? jsonBody;

  /// Form-encoded data to send — an unmodifiable copy.
  final Map<String, Object?>? formData;

  /// Multipart files to send — an unmodifiable copy, each part's bytes copied.
  final Map<String, Object?>? files;

  /// Headers for this request — an unmodifiable copy.
  final Map<String, String>? headers;

  /// Already-redacted headers to record on the response's request info.
  final Map<String, String>? requestInfoHeaders;

  /// An already-redacted body to record on the response's request info.
  final Object? requestInfoBody;

  /// The body's bytes, encoded once so every attempt and replay sends these.
  final List<int>? encodedBody;

  /// The `Content-Type` [encodedBody] was encoded as, or `null` without a body.
  final String? encodedContentType;

  /// Whether [encodedContentType] replaces a caller's own; true only for multipart.
  final bool ownsContentType;

  /// Which form the response's `data` takes, already resolved by the client.
  final String responseFormat;

  /// The typed view this call produces, or `null` where it produces none.
  final DtoDecoder? dtoDecoder;

  /// The same request under different headers, reusing the frozen URL and body.
  TransportRequest withHeaders(Map<String, String>? headers,
          {Map<String, String>? requestInfoHeaders}) =>
      TransportRequest._(
        httpMethod: httpMethod,
        url: url,
        wireUrl: wireUrl,
        endpointTemplate: endpointTemplate,
        queryParams: queryParams,
        jsonBody: jsonBody,
        formData: formData,
        files: files,
        headers: _frozenHeaders(headers),
        requestInfoHeaders: _frozenHeaders(requestInfoHeaders),
        requestInfoBody: requestInfoBody,
        responseFormat: responseFormat,
        dtoDecoder: dtoDecoder,
        encodedBody: encodedBody,
        encodedContentType: encodedContentType,
        ownsContentType: ownsContentType,
      );
}

// Plain bytes, not a MultipartFile, whose single-subscription stream sends once.
class _MultipartPart {
  const _MultipartPart(this.name, this.filename, this.bytes, this.contentType);

  final String name;

  final String filename;

  final List<int> bytes;

  final MediaType? contentType;
}

/// The trimmed, upper-cased method, refusing one that is not an RFC 9110 `token`.
String normaliseHttpMethod(String httpMethod) {
  final method = httpMethod.trim().toUpperCase();
  if (method.isEmpty) {
    throw SdkUsageError('httpMethod must name a verb');
  }
  if (!sendableHeaderName(method)) {
    throw SdkUsageError(
        'httpMethod ${jsonEncode(httpMethod)} is not an HTTP method: RFC 9110 '
        'makes a method a token, which excludes whitespace, a line break, a '
        'control character, a separator and every non-ASCII byte');
  }
  return method;
}

String _materialiseWireUrl(String url, Map<String, Object?>? queryParams) {
  final parsed = Uri.tryParse(url);
  if (parsed == null ||
      (!parsed.isScheme('http') && !parsed.isScheme('https'))) {
    throw SdkUsageError('not a valid http(s) URL');
  }
  // Tested on the raw string: Uri.hasFragment misses a trailing '#'.
  if (url.contains('#')) {
    throw SdkUsageError(
        'request URL ${deriveEndpointTemplate(url)} carries a fragment, which '
        'no server receives and which any query parameters would be appended '
        'after rather than before; strip everything from the # onwards. The '
        'resolved URL is not shown: it names the store and carries the path\'s '
        'own identifiers');
  }
  if (queryParams == null || queryParams.isEmpty) return url;

  final buffer = StringBuffer(url);
  var first = !url.contains('?');
  queryParams.forEach((key, value) {
    for (final single in _expandValue(value)) {
      buffer
        ..write(first ? '?' : '&')
        ..write(Uri.encodeQueryComponent(key))
        ..write('=')
        ..write(Uri.encodeQueryComponent(single));
      first = false;
    }
  });
  return buffer.toString();
}

Iterable<String> _expandValue(Object? value) sync* {
  if (value is String) {
    yield value;
  } else if (value is Iterable) {
    for (final item in value) {
      yield _stringify(item);
    }
  } else {
    yield _stringify(value);
  }
}

String _stringify(Object? value) => value == null ? '' : value.toString();

List<_MultipartPart> _materialiseParts(Map<String, Object?> files) {
  final parts = <_MultipartPart>[];
  files.forEach((field, value) {
    validateFilePart(field, value);
    // Escaped here rather than left to `package:http`, which handles `"` not `\`.
    final name = _escapePartParameter(field);
    if (value is List<int> || value is String) {
      parts.add(_MultipartPart(name, name, _partBytes(value), null));
      return;
    }
    final entry = value as List;
    parts.add(_MultipartPart(
        name,
        _escapePartParameter(entry[0] as String),
        _partBytes(entry[1]),
        entry.length >= 3 && entry[2] is String
            ? MediaType.parse(entry[2] as String)
            : null));
  });
  return List<_MultipartPart>.unmodifiable(parts);
}

Map<String, String>? _materialiseFields(Map<String, Object?>? formData) {
  if (formData == null) return null;
  return Map<String, String>.unmodifiable(<String, String>{
    for (final entry in formData.entries)
      _escapePartParameter(entry.key): _stringify(entry.value)
  });
}

List<int> _partBytes(Object? contents) =>
    contents is String ? utf8.encode(contents) : contents as List<int>;

const String _multipartMediaType = 'multipart/form-data';

const String _defaultPartMediaType = 'application/octet-stream';

const String _boundaryAlphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

const int _boundaryRandomChars = 32;

// Random.secure(): a predictable boundary lets content plant a delimiter.
final Random _boundaryRandom = Random.secure();

String _generateMultipartBoundary() {
  final buffer = StringBuffer('wcsdk-boundary-');
  for (var index = 0; index < _boundaryRandomChars; index++) {
    buffer.write(
        _boundaryAlphabet[_boundaryRandom.nextInt(_boundaryAlphabet.length)]);
  }
  return buffer.toString();
}

// Framed here: package:http picks a new boundary in every finalize().
List<int> _frameMultipartBody(String boundary, Map<String, String>? fields,
    List<_MultipartPart> parts, _ByteBudget wire, _ByteBudget framing) {
  final body = _BodyWriter(wire, framing);
  fields?.forEach((name, value) {
    body.writeFraming('--$boundary\r\n'
        'content-disposition: form-data; name="$name"\r\n');
    if (!_isPlainAscii(value)) {
      body.writeFraming('content-type: text/plain; charset=utf-8\r\n'
          'content-transfer-encoding: binary\r\n');
    }
    body
      ..writeFraming('\r\n')
      ..writeContentText(value)
      ..writeFraming('\r\n');
  });
  for (final part in parts) {
    body.writeFraming('--$boundary\r\n'
        'content-type: ${part.contentType ?? _defaultPartMediaType}\r\n'
        'content-disposition: form-data; name="${part.name}"; '
        'filename="${part.filename}"\r\n\r\n');
    body
      ..writeContent(part.bytes)
      ..writeFraming('\r\n');
  }
  body.writeFraming('--$boundary--\r\n');
  return body.takeBytes();
}

bool _isPlainAscii(String value) =>
    value.codeUnits.every((codeUnit) => codeUnit <= 0x7f);

Map<String, Object?>? _frozenMap(
    Map<String, Object?>? source, _ByteBudget budget) {
  if (source == null) return null;
  final copied = <String, Object?>{};
  for (final entry in source.entries) {
    budget.charge(_perElementSourceBytes +
        _utf8LengthCapped(entry.key, budget.limit - budget.spent));
    copied[entry.key] = _frozenValue(entry.value, budget);
  }
  return Map<String, Object?>.unmodifiable(copied);
}

Map<String, String>? _frozenHeaders(Map<String, String>? source) =>
    source == null ? null : Map<String, String>.unmodifiable(source);

Object? _frozenValue(Object? value, _ByteBudget budget, [int depth = 0]) {
  if (depth >= Redaction.maxDepth) {
    throw SdkUsageError(
        'a request value nests more than ${Redaction.maxDepth} levels deep, so '
        'it cannot be detached from the caller; flatten it before sending');
  }
  if (value is List<int>) {
    budget.charge(value.length);
    return _frozenIntList(value);
  }
  if (value is String) {
    budget.charge(_utf8LengthCapped(value, budget.limit - budget.spent));
    return value;
  }
  if (value is Map) {
    final copied = <String, Object?>{};
    for (final entry in value.entries) {
      budget.charge(_perElementSourceBytes);
      copied['${entry.key}'] = _frozenValue(entry.value, budget, depth + 1);
    }
    return Map<String, Object?>.unmodifiable(copied);
  }
  if (value is Iterable) {
    // A loop, not .map(): each element is charged before a lazy producer is drained.
    final copied = <Object?>[];
    for (final item in value) {
      budget.charge(_perElementSourceBytes);
      copied.add(_frozenValue(item, budget, depth + 1));
    }
    return List<Object?>.unmodifiable(copied);
  }
  budget.charge(_perElementSourceBytes);
  return value;
}

List<int> _frozenIntList(List<int> value) {
  for (final element in value) {
    if (element < 0 || element > 0xff) return List<int>.unmodifiable(value);
  }
  return Uint8List.fromList(value).asUnmodifiableView();
}

List<int>? _encodeBody(
    Object? jsonBody, Map<String, Object?>? formData, _ByteBudget wire) {
  if (jsonBody is String) {
    wire.charge(_utf8LengthCapped(jsonBody, wire.limit));
    return utf8.encode(jsonBody).asUnmodifiableView();
  }
  if (jsonBody != null) {
    final writer = _BodyWriter(wire);
    JsonUtf8Encoder().startChunkedConversion(_CappedJsonSink(writer))
      ..add(jsonBody)
      ..close();
    return writer.takeBytes();
  }
  if (formData != null) {
    final writer = _BodyWriter(wire);
    var first = true;
    for (final entry in formData.entries) {
      // Fragment by fragment: a `join` would build the whole string uncharged.
      if (!first) writer.writeContentText('&');
      first = false;
      writer
        ..writeContentText(Uri.encodeQueryComponent(entry.key))
        ..writeContentText('=')
        ..writeContentText(Uri.encodeQueryComponent(_stringify(entry.value)));
    }
    return writer.takeBytes();
  }
  return null;
}

String? _encodedContentType(Object? jsonBody, Map<String, Object?>? formData) {
  if (jsonBody != null) return 'application/json; charset=utf-8';
  if (formData != null) {
    return 'application/x-www-form-urlencoded; charset=utf-8';
  }
  return null;
}

/// Decode a body by Content-Type: JSON to Maps and Lists, `text/*` to text, other
/// types as bytes, and a 204 or empty body as `null`.
Object? decodeResponseBody(int status, List<int> body, String? contentType) {
  if (status == 204 || body.isEmpty) return null;
  final lowered = (contentType ?? '').toLowerCase();
  if (_isJsonMediaType(lowered)) {
    try {
      return jsonDecode(utf8.decode(body));
    } on FormatException {
      return utf8.decode(body, allowMalformed: true);
    }
  }
  if (lowered.startsWith('text/')) {
    return _decodeTextBody(body, lowered);
  }
  return body;
}

const String _jsonMediaType = 'application/json';

bool _isJsonMediaType(String loweredContentType) {
  final mediaType = loweredContentType.split(';').first.trim();
  return mediaType == _jsonMediaType || mediaType.endsWith('+json');
}

const String _charsetParameter = 'charset=';

String _decodeTextBody(List<int> body, String loweredContentType) {
  final declared = _declaredCharsetDecoder(loweredContentType);
  if (declared != null) return declared(body);
  try {
    return utf8.decode(body);
  } on FormatException {
    return latin1.decode(body);
  }
}

String Function(List<int> body)? _declaredCharsetDecoder(
    String loweredContentType) {
  final index = loweredContentType.indexOf(_charsetParameter);
  if (index < 0) return null;
  var name = loweredContentType.substring(index + _charsetParameter.length);
  final end = name.indexOf(';');
  if (end >= 0) name = name.substring(0, end);
  name = name.trim();
  if (name.length >= 2 && name.startsWith('"') && name.endsWith('"')) {
    name = name.substring(1, name.length - 1).trim();
  }
  switch (name) {
    case 'utf-8':
    case 'utf8':
      return (body) => utf8.decode(body, allowMalformed: true);
    case 'iso-8859-1':
    case 'iso8859-1':
    case 'latin-1':
    case 'latin1':
      return latin1.decode;
    case 'us-ascii':
    case 'ascii':
      return (body) => ascii.decode(body, allowInvalid: true);
  }
  return null;
}
