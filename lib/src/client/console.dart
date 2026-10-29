import 'dart:convert';
import 'dart:typed_data';

import '../config/sdk_config.dart';
import '../redaction.dart';
import 'api_response.dart';
import 'terminal_web.dart' if (dart.library.io) 'terminal_io.dart';

/// Rendering one exchange for a human at a terminal — presentation only, and
/// everything shown passes through the redactor first.
class Console {
  Console._();

  static final JsonEncoder _prettyEncoder =
      JsonEncoder.withIndent('  ', _renderUnencodable);

  /// Shown where a status code would go for a request that never reached one —
  /// text, so it cannot be mistaken for a code the server sent.
  static const String noResponseStatus = 'no response';

  /// The text to print for one exchange, per the config's print flags.
  static String renderExchange(
          ApiResponse response, Object? reportedBody, SdkConfig config,
          {Map<String, Object?>? files, bool formEncoded = false}) =>
      _render(response.requestInfo!, response.statusCode.toString(),
          response.map, response.headers,
          reportedBody: reportedBody,
          config: config,
          files: files,
          formEncoded: formEncoded);

  /// The text to print for a send that never produced a response — a connection
  /// failure or a timeout.
  static String renderFailure(
          RequestInfo info, Object? reportedBody, SdkConfig config,
          {Map<String, Object?>? files, bool formEncoded = false}) =>
      _render(info, noResponseStatus, null, const <String, String>{},
          reportedBody: reportedBody,
          config: config,
          files: files,
          formEncoded: formEncoded);

  static String _render(RequestInfo info, String status, Object? data,
      Map<String, String> responseHeaders,
      {required Object? reportedBody,
      required SdkConfig config,
      Map<String, Object?>? files,
      bool formEncoded = false}) {
    final colour = _Colour(config.printColor && stdoutSupportsColour());
    final payload = summarisePayload(reportedBody, files);
    if (config.printFormat == SdkConfig.printFormatCompact) {
      final line = StringBuffer('wc | ')
        ..write(info.clientName)
        ..write(' | ')
        ..write(info.httpMethod)
        ..write(' | ')
        ..write(info.url)
        ..write(' | ')
        ..write(status)
        ..write(' | ')
        ..write('${info.attemptCount}/${info.maxAttempts}')
        ..write(' | ')
        ..write('${info.elapsedSeconds}s');
      if (config.printRequestPayload) {
        line.write(
            ' | payload=${_json(Redaction.redactValue(payload), false)}');
      }
      if (config.printResponseBody) {
        line.write(' | response=${_json(Redaction.redactValue(data), false)}');
      }
      return _truncate(_neutralise(line.toString()), config.printMaxChars);
    }

    final out = StringBuffer(colour.dim('WebCommander  '
        '${_neutralise(info.httpMethod ?? '')}  $status  '
        '${info.elapsedSeconds}s'));
    if (config.printApiInfo) {
      _row(out, 'client', info.clientName);
      _row(out, 'api version', info.apiVersion);
      _row(out, 'method', info.httpMethod);
      _row(out, 'endpoint', info.url);
      _row(out, 'params', _json(info.queryParams, false));
      _row(out, 'status', colour.status(status, _statusSucceeded(status)),
          neutralise: false);
      _row(out, 'attempt', '${info.attemptCount} / ${info.maxAttempts}');
      _row(out, 'elapsed', '${info.elapsedSeconds}s');
    }
    if (config.printHeaders) {
      _section(out, 'request headers', colour);
      _headerRows(out, info.headers);
      _section(out, 'response headers', colour);
      _headerRows(out, Redaction.redactMapping(responseHeaders));
    }
    if (config.printRequestPayload && payload != null) {
      _section(out, 'payload', colour);
      _block(out, _json(Redaction.redactValue(payload), true));
    }
    if (config.printResponseBody) {
      _section(out, 'response', colour);
      _block(out, _json(Redaction.redactValue(data), true));
    }
    if (config.printCurl) {
      _section(out, 'curl (POSIX shell)', colour);
      _block(
          out,
          buildCurlForRequest(info, payload, config,
              files: files, formEncoded: formEncoded));
    }
    return _truncate(out.toString(), config.printMaxChars);
  }

  /// A copy-pasteable curl reproducing the call, for a POSIX shell, with every
  /// fragment single-quoted and headers already redacted.
  static String buildCurl(
          ApiResponse response, Object? reportedBody, SdkConfig config,
          {Map<String, Object?>? files, bool formEncoded = false}) =>
      buildCurlForRequest(response.requestInfo!, reportedBody, config,
          files: files, formEncoded: formEncoded);

  /// The same curl line built from the request record alone, so a call that
  /// never produced a response is still reproducible.
  static String buildCurlForRequest(
      RequestInfo info, Object? payload, SdkConfig config,
      {Map<String, Object?>? files, bool formEncoded = false}) {
    final reportedBody = _formPart(payload);
    // Neutralised, not just quoted: a raw newline inside single quotes still forges a line.
    final curl = StringBuffer('curl -X '
        '${_shellQuote(_neutralise(info.httpMethod ?? ''))} '
        '${_shellQuote(_withQuery(info))}');
    if (!config.verifySsl) curl.write(' \\\n  -k');
    final headerNames = info.headers.keys.toList()..sort();
    for (final name in headerNames) {
      curl.write(
          ' \\\n  -H ${_shellQuote(_neutralise('$name: ${info.headers[name]}'))}');
    }
    final entries = _multipartEntries(files);
    for (final (field, filename) in entries) {
      curl.write(' \\\n  -F ${_shellQuote(_neutralise('$field=@$filename'))}');
    }
    if (entries.isNotEmpty) {
      for (final (key, value) in _formFields(reportedBody)) {
        curl.write(' \\\n  -F ${_shellQuote(_neutralise('$key=$value'))}');
      }
    } else if (reportedBody != null) {
      final fields =
          formEncoded ? _formFields(reportedBody) : const <(String, String)>[];
      if (fields.isNotEmpty) {
        for (final (key, value) in fields) {
          curl.write(
              ' \\\n  --data-urlencode ${_shellQuote(_neutralise('$key=$value'))}');
        }
      } else {
        if (!formEncoded && !_hasContentType(info.headers)) {
          // curl sends --data-raw as a form unless told otherwise; the last -H wins.
          curl.write(
              ' \\\n  -H ${_shellQuote('Content-Type: application/json')}');
        }
        curl.write(
            ' \\\n  --data-raw ${_shellQuote(_curlBody(Redaction.redactValue(reportedBody)))}');
      }
    }
    return curl.toString();
  }

  /// The `--data-raw` argument for one already-redacted body.
  static String _curlBody(Object? value) {
    if (value is String && _isJsonDocument(value)) {
      return _neutralise(_spaceJsonTokens(jsonEncode(jsonDecode(value))));
    }
    return _json(value, false);
  }

  /// One space after each structural `:` and `,` of already-encoded JSON, so a
  /// collapsed document still reads as a document.
  static String _spaceJsonTokens(String encoded) {
    final out = StringBuffer();
    var inString = false;
    var escaped = false;
    for (var index = 0; index < encoded.length; index++) {
      final char = encoded[index];
      out.write(char);
      if (inString) {
        if (escaped) {
          escaped = false;
        } else if (char == r'\') {
          escaped = true;
        } else if (char == '"') {
          inString = false;
        }
        continue;
      }
      if (char == '"') {
        inString = true;
      } else if (char == ':' || char == ',') {
        out.write(' ');
      }
    }
    return out.toString();
  }

  /// Describe what was sent without reading a byte of any upload; a form part
  /// stays a structure, so its secrets still meet the redactor.
  static Object? summarisePayload(Object? body, Map<String, Object?>? files) {
    final entries = _multipartEntries(files);
    if (entries.isEmpty) return body;
    final names = entries.map((entry) => '${entry.$1}=${entry.$2}').join(', ');
    final summary = '$_multipartPrefix$names>';
    if (body == null) return summary;
    return <String, Object?>{_payloadFilesKey: summary, _payloadFormKey: body};
  }

  static const String _multipartPrefix = '<multipart: ';
  static const String _payloadFilesKey = 'files';
  static const String _payloadFormKey = 'form';

  /// The form body inside a [summarisePayload] result, or the payload itself.
  static Object? _formPart(Object? payload) {
    if (payload is Map &&
        payload.length == 2 &&
        payload.containsKey(_payloadFilesKey) &&
        payload.containsKey(_payloadFormKey) &&
        '${payload[_payloadFilesKey]}'.startsWith(_multipartPrefix)) {
      return payload[_payloadFormKey];
    }
    return payload;
  }

  /// The multipart field/filename pairs to render; contents are never read.
  static List<(String, String)> _multipartEntries(Map<String, Object?>? files) {
    if (files == null || files.isEmpty) return const <(String, String)>[];
    final entries = <(String, String)>[];
    files.forEach((field, value) {
      var filename = field;
      if (value is List && value.isNotEmpty && value.first is String) {
        filename = value.first as String;
      }
      entries.add((field, filename));
    });
    return entries;
  }

  /// Redacted name/value pairs for a form body; anything not a map has none.
  static List<(String, String)> _formFields(Object? body) {
    if (body is! Map) return const <(String, String)>[];
    final fields = <(String, String)>[];
    (Redaction.redactValue(body)! as Map<String, Object?>)
        .forEach((key, value) => fields.add((key, value?.toString() ?? '')));
    return fields;
  }

  /// The recorded url with the recorded parameters appended, ready for the curl
  /// line.
  static String _withQuery(RequestInfo info) {
    final url = _neutralise(info.url ?? '');
    if (info.queryParams.isEmpty) return url;
    final query = StringBuffer(url);
    var separator = url.contains('?') ? '&' : '?';
    info.queryParams.forEach((key, value) {
      final values =
          value is Iterable && value is! String ? value : <Object?>[value];
      for (final single in values) {
        query.write('$separator${_encodeQuery(key)}='
            '${_encodeQuery(single?.toString() ?? '')}');
        separator = '&';
      }
    });
    return query.toString();
  }

  /// Percent-encode one query token, keeping `*` readable so a redacted
  /// parameter prints as `apiKey=***` rather than `apiKey=%2A%2A%2A`.
  static String _encodeQuery(String token) =>
      Uri.encodeQueryComponent(token).replaceAll('%2A', '*');

  static bool _hasContentType(Map<String, String> headers) =>
      headers.keys.any((name) => name.toLowerCase() == 'content-type');

  /// One header section's rows, name-sorted.
  static void _headerRows(StringBuffer out, Map<String, String> headers) {
    for (final name in headers.keys.toList()..sort()) {
      _row(out, name, headers[name], width: 14);
    }
  }

  /// One `label:value` row.
  static void _row(StringBuffer out, String label, Object? value,
          {int width = 12, bool neutralise = true}) =>
      out.write('\n${_neutralise(label).padRight(width)}: '
          '${neutralise ? _neutralise(value?.toString() ?? 'null') : value}');

  /// The box-drawing glyphs this console can actually print, resolved once per
  /// process by probing the console encoding.
  static final Map<String, String> _glyphs = resolveBoxGlyphs();

  static final String _rule = _glyphs['h']!;

  /// The truncation notice, chosen by the same probe as [_rule].
  static final String _ellipsis = _glyphs['ellipsis']!;

  /// A section heading: [label] on a horizontal rule.
  static void _section(StringBuffer out, String label, _Colour colour) {
    final prefix = '$_rule$_rule $label ';
    out.write('\n${colour.dim('$prefix'
        '${_rule * (62 - prefix.length < 4 ? 4 : 62 - prefix.length)}')}');
  }

  /// Whether a status line reads as a success, for the colour choice; judged on
  /// text, so [noResponseStatus] answers false.
  static bool _statusSucceeded(String status) {
    final code = int.tryParse(status);
    return code != null && code >= 200 && code < 300;
  }

  /// Append [text] line by line.
  static void _block(StringBuffer out, String text) {
    for (final line in text.split('\n')) {
      out.write('\n$line');
    }
  }

  /// Render one already-redacted value for display: `null` is `<empty>`, bytes are
  /// `<N bytes>`, text is itself, anything else is JSON.
  static String renderJsonValue(Object? value, {bool compact = false}) =>
      _json(value, !compact);

  static String _json(Object? value, bool pretty) {
    if (value == null) return '<empty>';
    // TypedData, not any List<int>: a JSON array of numbers still renders as JSON.
    if (value is TypedData) return '<${value.lengthInBytes} bytes>';
    if (value is String) {
      if (pretty) return _neutralise(value, keepNewlines: true);
      if (_isJsonDocument(value)) return _neutralise(value);
      final encoded = jsonEncode(value);
      return _neutralise(encoded.substring(1, encoded.length - 1));
    }
    final summarised = _summariseNestedBytes(value, 0);
    try {
      // Neutralised too: jsonEncode leaves DEL, C1 and U+2028/U+2029 unescaped.
      return _neutralise(
          pretty
              ? _prettyEncoder.convert(summarised)
              : jsonEncode(summarised, toEncodable: _renderUnencodable),
          keepNewlines: pretty);
    } on Object {
      return _neutralise(value.toString(), keepNewlines: pretty);
    }
  }

  /// Whether text is one JSON object or array — what a caller pastes as a body,
  /// and what the redactor hands back after rebuilding one to insert `***`.
  static bool _isJsonDocument(String text) {
    final trimmed = text.trimLeft();
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return false;
    try {
      final decoded = jsonDecode(text);
      return decoded is Map || decoded is List;
    } on FormatException {
      return false;
    }
  }

  /// Replace every [TypedData] nested anywhere inside [value] with its
  /// `<N bytes>` summary, at any depth.
  static Object? _summariseNestedBytes(Object? value, int depth) {
    if (value is TypedData) return '<${value.lengthInBytes} bytes>';
    if (depth >= Redaction.maxDepth) return value;
    if (value is Map) {
      final copy = <Object?, Object?>{};
      value.forEach(
          (key, item) => copy[key] = _summariseNestedBytes(item, depth + 1));
      return copy;
    }
    if (value is List) {
      return value
          .map((item) => _summariseNestedBytes(item, depth + 1))
          .toList();
    }
    return value;
  }

  /// What the encoder cannot serialise, rendered rather than thrown on: a throw
  /// here would lose the whole document.
  static Object? _renderUnencodable(Object? value) {
    try {
      return '$value';
    } on Object {
      return '<unrenderable ${value.runtimeType}>';
    }
  }

  /// The characters that are safe to leave bare in a POSIX shell word.
  static final RegExp _shellUnsafe = RegExp(r'[^A-Za-z0-9_@%+=:,./-]');

  /// POSIX shell quoting for one token of the printed `curl` line, applied only where it is needed.
  static String _shellQuote(String fragment) {
    if (fragment.isEmpty) return "''";
    if (!_shellUnsafe.hasMatch(fragment)) return fragment;
    return "'${fragment.replaceAll("'", "'\"'\"'")}'";
  }

  /// Escape every control character so none reaches a terminal as itself,
  /// newlines included by default — a raw `\n` in a header would forge a row.
  static String _neutralise(String text, {bool keepNewlines = false}) {
    final out = StringBuffer();
    for (final rune in text.runes) {
      if ((rune <= 0x1f && !(keepNewlines && rune == 0x0a)) ||
          (rune >= 0x7f && rune <= 0x9f) ||
          rune == 0x2028 ||
          rune == 0x2029) {
        out.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
      } else {
        out.writeCharCode(rune);
      }
    }
    return out.toString();
  }

  static String _truncate(String text, int maxChars) {
    if (maxChars <= 0 || text.length <= maxChars) return text;
    var reserved = '$_ellipsis +${text.length} chars'.length;
    if (text.contains(_Colour.escape)) reserved += _Colour.reset.length;
    var cutIndex = maxChars - reserved;
    if (cutIndex < 0) cutIndex = 0;
    final sliced = _closeColourRun(text.substring(0, cutIndex));
    return '$sliced$_ellipsis +${text.length - cutIndex} chars';
  }

  /// Repair an ANSI sequence a character-wise cut landed inside, which would
  /// otherwise leave the terminal dim or emit a bare `\x1b[`.
  static String _closeColourRun(String text) {
    if (!text.contains(_Colour.escape)) return text;
    var out = text;
    final marker = out.lastIndexOf(_Colour.escape);
    if (!out.substring(marker).contains('m')) out = out.substring(0, marker);
    final last = out.lastIndexOf(_Colour.escapeStart);
    if (last != -1 && !out.startsWith(_Colour.reset, last)) {
      return out + _Colour.reset;
    }
    return out;
  }
}

/// ANSI helpers that no-op when disabled.
class _Colour {
  const _Colour(this._enabled);

  static const String escape = '\x1B';
  static const String escapeStart = '\x1B[';
  static const String reset = '\x1B[0m';

  final bool _enabled;

  String dim(String text) => _enabled ? '\x1B[2m$text$reset' : text;

  String status(String text, bool succeeded) =>
      _enabled ? '\x1B[${succeeded ? '32' : '31'}m$text$reset' : text;
}

/// The Unicode box-drawing set, keyed by role.
const Map<String, String> _unicodeBoxGlyphs = <String, String>{
  'top': '┌',
  'bottom': '└',
  'tee': '├',
  'v': '│',
  'h': '─',
  'ellipsis': '…',
};

/// The ASCII fallback, key for key.
const Map<String, String> _asciiBoxGlyphs = <String, String>{
  'top': '+',
  'bottom': '+',
  'tee': '+',
  'v': '|',
  'h': '-',
  'ellipsis': '...',
};

/// Box-drawing characters the current console can actually print.
Map<String, String> resolveBoxGlyphs() =>
    stdoutCanEncode(_unicodeBoxGlyphs.values.join())
        ? Map<String, String>.of(_unicodeBoxGlyphs)
        : Map<String, String>.of(_asciiBoxGlyphs);

/// A copy-pasteable `curl` reproducing the call, for a POSIX shell.
String buildCurlCommand(
  ApiResponse response,
  Object? payload,
  Map<String, Object?>? files,
  SdkConfig config, {
  bool formEncoded = false,
}) =>
    Console.buildCurl(response, payload, config,
        files: files, formEncoded: formEncoded);

/// The text to print for one exchange, per the config's print flags.
String renderExchange(
  ApiResponse response,
  Object? body,
  Map<String, Object?>? files,
  SdkConfig config, {
  bool formEncoded = false,
}) =>
    Console.renderExchange(response, body, config,
        files: files, formEncoded: formEncoded);
