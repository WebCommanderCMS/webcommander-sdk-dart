import 'dart:convert';

import '../errors.dart';
import '../redaction.dart';

/// URL assembly for WebCommander paths with `{name}` placeholders. A dot-only
/// value is refused: `..` would still resolve to another endpoint.
class UrlBuilder {
  UrlBuilder._();

  static final RegExp _placeholder = RegExp(r'\{([a-z_][a-z0-9_]*)\}');
  static final RegExp _queryOrFragment = RegExp('[?#]');

  static final RegExp _redactedParameter = RegExp(
      '[?#&]([^?#&=]*)=${RegExp.escape(Redaction.redacted)}(?=[&#]|\\s|\$)');

  /// The `{name}` placeholders in a template, first-seen order, query part excluded.
  static List<String> findPathParamNames(String pathTemplate) {
    final names = <String>[];
    final seen = <String>{};
    for (final match
        in _placeholder.allMatches(_splitTemplate(pathTemplate).template)) {
      final name = match[1]!;
      if (seen.add(name)) names.add(name);
    }
    return names;
  }

  /// Fill `{name}` placeholders; every problem reported in one exception.
  static String substitutePathParams(
      String pathTemplate, Map<String, Object?>? pathParams) {
    final split = _splitTemplate(pathTemplate);
    final expected = findPathParamNames(pathTemplate);
    final supplied = pathParams ?? const <String, Object?>{};

    final problems = <String>[];
    final missing =
        expected.where((name) => !supplied.containsKey(name)).toList()..sort();
    if (missing.isNotEmpty) {
      problems.add('missing path params: ${missing.join(', ')}');
    }
    final unknown = supplied.keys
        .where((name) => !expected.contains(name))
        .toList()
      ..sort();
    if (unknown.isNotEmpty) {
      problems.add('unknown path params: ${unknown.join(', ')}');
    }

    final blank = <String>[];
    final wrongTyped = <String>[];
    final dotOnly = <String>[];
    for (final name in expected) {
      if (!supplied.containsKey(name)) continue;
      final value = supplied[name];
      if (value == null || (value is String && value.trim().isEmpty)) {
        blank.add(name);
      } else if (!_usablePathParam(value)) {
        wrongTyped.add('$name (${value.runtimeType})');
      } else if (_isDotOnly(_substitutionText(value))) {
        dotOnly.add(name);
      }
    }
    if (blank.isNotEmpty) {
      problems.add('blank path params: ${(blank..sort()).join(', ')}');
    }
    if (wrongTyped.isNotEmpty) {
      problems
          .add('wrong-typed path params: ${(wrongTyped..sort()).join(', ')}');
    }
    if (dotOnly.isNotEmpty) {
      problems.add('dot-only path params: ${(dotOnly..sort()).join(', ')}');
    }
    if (problems.isNotEmpty) {
      throw SdkUsageError('$pathTemplate -> ${problems.join('; ')}');
    }

    final substituted = split.template.replaceAllMapped(_placeholder,
        (match) => percentEncode(_substitutionText(supplied[match[1]]!)));
    if (substituted.contains('{') || substituted.contains('}')) {
      throw SdkUsageError('$pathTemplate -> malformed placeholder');
    }
    return substituted + split.queryAndFragment;
  }

  /// Join a base URL and a path.
  static String buildUrl(String baseUrl, String path) {
    _rejectRedactedValue(path);
    final lowered = path.toLowerCase();
    if (lowered.startsWith('http://') || lowered.startsWith('https://')) {
      _requireSameOrigin(baseUrl, path);
      return path;
    }
    final trimmedBase = _stripTrailingSlashes(baseUrl);
    return trimmedBase + (path.startsWith('/') ? '' : '/') + path;
  }

  /// RFC 3986 percent-encoding with an empty safe set: unreserved characters only.
  static String percentEncode(String text) {
    final bytes = utf8.encode(text);
    final buffer = StringBuffer();
    for (final byteValue in bytes) {
      final unreserved = (byteValue >= 0x41 && byteValue <= 0x5a) ||
          (byteValue >= 0x61 && byteValue <= 0x7a) ||
          (byteValue >= 0x30 && byteValue <= 0x39) ||
          byteValue == 0x2d ||
          byteValue == 0x2e ||
          byteValue == 0x5f ||
          byteValue == 0x7e;
      if (unreserved) {
        buffer.writeCharCode(byteValue);
      } else {
        buffer.write(
            '%${byteValue.toRadixString(16).toUpperCase().padLeft(2, '0')}');
      }
    }
    return buffer.toString();
  }

  static void _rejectRedactedValue(String path) {
    final found = _redactedParameter.firstMatch(path);
    if (found != null) {
      throw SdkUsageError(
          "path: parameter '${found[1]}' holds only the redaction marker "
          '${Redaction.redacted}, so this URL is a printed or logged copy and the '
          'real value is not in it - read the value off the response itself');
    }
  }

  static void _requireSameOrigin(String baseUrl, String url) {
    // Userinfo is tested on the raw string: a failed parse would quote the password.
    final authority = _rawAuthority(url);
    if (authority.contains('@')) {
      throw SdkUsageError('absolute URL carries credentials');
    }
    final target = _parse(url);
    final configured = _parse(baseUrl);
    if (_origin(target) != _origin(configured)) {
      throw SdkUsageError('absolute URL is not on the configured origin '
          '(${_originDifference(target, configured)})');
    }
  }

  static String _originDifference(Uri target, Uri configured) {
    final differing = <String>[
      if (target.scheme.toLowerCase() != configured.scheme.toLowerCase())
        'the scheme',
      if (target.host.toLowerCase() != configured.host.toLowerCase())
        'the host',
      if (_effectivePort(target) != _effectivePort(configured)) 'the port',
    ];
    return '${differing.join(' and ')} '
        '${differing.length > 1 ? 'differ' : 'differs'}';
  }

  static String _rawAuthority(String url) {
    const marker = '://';
    final start = url.indexOf(marker) + marker.length;
    final end = url.indexOf(RegExp(r'[/?#]'), start);
    return end < 0 ? url.substring(start) : url.substring(start, end);
  }

  static Uri _parse(String url) {
    // hasScheme, not isAbsolute, which is false for any URI with a fragment.
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      throw SdkUsageError('not a parseable absolute URL');
    }
    return uri;
  }

  static String _origin(Uri uri) =>
      '${uri.scheme.toLowerCase()}://${uri.host.toLowerCase()}:'
      '${_effectivePort(uri)}';

  static int _effectivePort(Uri uri) {
    if (uri.hasPort) return uri.port;
    return switch (uri.scheme.toLowerCase()) {
      'https' => 443,
      'http' => 80,
      _ => -1,
    };
  }

  static ({String template, String queryAndFragment}) _splitTemplate(
      String pathTemplate) {
    final boundary = _queryOrFragment.firstMatch(pathTemplate);
    if (boundary == null) return (template: pathTemplate, queryAndFragment: '');
    return (
      template: pathTemplate.substring(0, boundary.start),
      queryAndFragment: pathTemplate.substring(boundary.start),
    );
  }

  static String _stripTrailingSlashes(String text) {
    var end = text.length;
    while (end > 0 && text[end - 1] == '/') {
      end--;
    }
    return text.substring(0, end);
  }

  static bool _usablePathParam(Object value) => value is String || value is int;

  static String _substitutionText(Object value) =>
      value is String ? value.trim() : value.toString();

  static bool _isDotOnly(String text) =>
      text.isNotEmpty && text.codeUnits.every((codeUnit) => codeUnit == 0x2e);
}

/// Join a base URL and a path, refusing another origin.
String buildUrl(String baseUrl, String path) =>
    UrlBuilder.buildUrl(baseUrl, path);

/// Fill the `{name}` placeholders in a path template.
String substitutePathParams(
        String pathTemplate, Map<String, Object?>? pathParams) =>
    UrlBuilder.substitutePathParams(pathTemplate, pathParams);
