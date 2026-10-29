/// Secret handling: the one place that decides what counts as a secret.
library;

import 'dart:convert';

/// Redacts secrets from values, headers and text; every member is static.
class Redaction {
  Redaction._();

  /// What a redacted value is replaced with.
  static const String redacted = '***';

  /// What replaces a structure nested deeper than [maxDepth].
  static const String tooDeep = '<...>';

  /// What replaces a container that contains itself.
  static const String circular = '<circular>';

  /// What replaces a JSON document the redactor could not finish; fails closed.
  static const String unredactable = '<unredactable>';

  /// A value that opens like a structured document and is not one, rendered as
  /// its type and size and none of its text: `<unparsed String(1234 chars)>`.
  static String withheldStructure(String text) =>
      '<unparsed String(${text.length} chars)>';

  /// How deep [redactValue] walks before writing [tooDeep].
  static const int maxDepth = 64;

  /// Key-name markers, matched case-insensitively and ignoring separators.
  static const List<String> sensitiveKeyMarkers = <String>[
    'secret',
    'password',
    'passphrase',
    'passwd',
    'pwd',
    'token',
    'bearer',
    'jwt',
    'authorization',
    'authstring',
    'apikey',
    'assertion',
    'credential',
    'verifier',
    'cookie',
    'session',
    'signature',
    'privatekey',
  ];

  static const Set<String> _nonSecretTail = <String>{
    'amount',
    'at',
    'consent',
    'count',
    'duration',
    // `customer_password_expired` is a boolean flag, never a password.
    'expired',
    'level',
    'path',
    'policy',
    'remaining',
    'status',
    'type',
  };

  static const Set<String> _nonSecretLead = <String>{'has', 'is', 'was'};

  // Split camelCase without a lookbehind, which is not portable.
  static final RegExp _camelBoundary = RegExp(r'([a-z0-9])([A-Z])');
  static final RegExp _nonAlnum = RegExp(r'[^A-Za-z0-9]+');

  // Judged run by run; the 32-char scheme bound keeps this linear.
  static final RegExp _urlRun =
      RegExp('[A-Za-z][A-Za-z0-9+.\\-]{0,31}://[^\\s<>"\']*');

  static final RegExp _pathQueryRun = RegExp('/[^\\s<>"\'?#]*[?#][^\\s<>"\']+');

  /// Whether a key's name means its value must not be shown.
  static bool shouldRedact(String key) {
    final words = _keyWords(key);
    if (words.isNotEmpty &&
        (_nonSecretLead.contains(words.first) ||
            _nonSecretTail.contains(words.last))) {
      return false;
    }
    final normalised = words.join();
    for (final marker in sensitiveKeyMarkers) {
      if (normalised.contains(marker)) return true;
    }
    return false;
  }

  static List<String> _keyWords(String key) {
    final spaced = key.replaceAllMapped(
        _camelBoundary, (match) => '${match[1]} ${match[2]}');
    final words = <String>[];
    for (final word in spaced.split(_nonAlnum)) {
      if (word.isNotEmpty) words.add(word.toLowerCase());
    }
    return words;
  }

  /// A redacted copy of a JSON-shaped value: secret-named entries become [redacted],
  /// and any other opaque object becomes a type label, never rendered.
  static Object? redactValue(Object? value) =>
      _redact(value, 0, Set<Object>.identity());

  static Object? _redact(Object? value, int depth, Set<Object> seen) {
    if (value is Map) {
      if (depth >= maxDepth) return tooDeep;
      if (!seen.add(value)) return circular;
      try {
        final copy = <String, Object?>{};
        value.forEach((rawKey, item) {
          final key = _keyText(rawKey);
          copy[key] =
              shouldRedact(key) ? redacted : _redact(item, depth + 1, seen);
        });
        return copy;
      } finally {
        seen.remove(value);
      }
    }
    if (value is List<int>) return value;
    if (value is Iterable) {
      if (depth >= maxDepth) return tooDeep;
      if (!seen.add(value)) return circular;
      try {
        final copy = <Object?>[];
        for (final entry in value) {
          copy.add(_secretPair(entry) ?? _redact(entry, depth + 1, seen));
        }
        return copy;
      } finally {
        seen.remove(value);
      }
    }
    if (value is String) return redactText(_redactJsonText(value, depth));
    if (value == null || value is num || value is bool) return value;
    return '<${value.runtimeType}>';
  }

  /// A map key as text, without asking a caller's object to render itself.
  static String _keyText(Object? rawKey) {
    if (rawKey is String) return rawKey;
    if (rawKey is int || rawKey is double || rawKey is bool || rawKey == null) {
      return '$rawKey';
    }
    return '<${rawKey.runtimeType}>';
  }

  /// Redact a JSON document that arrived as text, rewriting it only if redaction
  /// changed it; text that opens like one but does not parse is withheld.
  static String _redactJsonText(String text, int depth) {
    final trimmed = text.trimLeft();
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return text;
    final Object? parsed;
    try {
      parsed = _OrderedJsonParser(text).parseDocument();
    } on FormatException {
      return withheldStructure(text);
    } on StackOverflowError {
      return withheldStructure(text);
    }
    try {
      final after = _encodeSpacedJson(_redactOrdered(parsed, depth + 1));
      return after == _encodeSpacedJson(parsed) ? text : after;
    } on Object {
      return unredactable;
    }
  }

  /// [_redact]'s rules applied to the ordered tree the local parser yields.
  static Object? _redactOrdered(Object? value, int depth) {
    if (value is _JsonObject) {
      if (depth >= maxDepth) return tooDeep;
      final copy = _JsonObject();
      for (var i = 0; i < value.keys.length; i++) {
        final key = value.keys[i];
        copy.put(
            key,
            shouldRedact(key)
                ? redacted
                : _redactOrdered(value.values[i], depth + 1));
      }
      return copy;
    }
    if (value is List<Object?>) {
      if (depth >= maxDepth) return tooDeep;
      final copy = <Object?>[];
      for (final entry in value) {
        copy.add(_secretPair(entry) ?? _redactOrdered(entry, depth + 1));
      }
      return copy;
    }
    if (value is String) return redactText(_redactJsonText(value, depth));
    return value;
  }

  /// A `[name, value]` pair, the form header lists and form bodies use, with
  /// its value redacted when the name is secret; `null` for anything else.
  static List<Object?>? _secretPair(Object? entry) {
    if (entry is List &&
        entry.length == 2 &&
        entry[0] is String &&
        shouldRedact(entry[0] as String)) {
      return <Object?>[entry[0], redacted];
    }
    return null;
  }

  /// Re-serialise with spaced separators, so a redacted body stays diffable.
  static String _encodeSpacedJson(Object? value) {
    final out = StringBuffer();
    _writeSpacedJson(out, value);
    return out.toString();
  }

  static void _writeSpacedJson(StringBuffer out, Object? value) {
    if (value is _JsonObject) {
      out.write('{');
      for (var i = 0; i < value.keys.length; i++) {
        if (i > 0) out.write(', ');
        _writeSpacedJson(out, value.keys[i]);
        out.write(': ');
        _writeSpacedJson(out, value.values[i]);
      }
      out.write('}');
      return;
    }
    if (value is List) {
      out.write('[');
      var first = true;
      for (final entry in value) {
        if (!first) out.write(', ');
        first = false;
        _writeSpacedJson(out, entry);
      }
      out.write(']');
      return;
    }
    if (value is _JsonNumber) {
      out.write(_renderNumberToken(value.raw));
      return;
    }
    out.write(jsonEncode(value));
  }

  /// Render a raw number token; it must never throw, as that would skip redaction.
  static String _renderNumberToken(String raw) {
    if (raw == 'NaN' || raw == 'Infinity' || raw == '-Infinity') return raw;
    if (!raw.contains('.') && !raw.contains('e') && !raw.contains('E')) {
      if (raw == '-0') return '0';
      return raw;
    }
    final floatValue = double.parse(raw);
    if (floatValue.isInfinite) return floatValue > 0 ? 'Infinity' : '-Infinity';
    return _renderShortestFloat(floatValue);
  }

  /// Shortest round-trip digits, in fixed or exponent form.
  static String _renderShortestFloat(double floatValue) {
    var formatted = floatValue.toStringAsExponential();
    var sign = '';
    if (formatted.startsWith('-')) {
      sign = '-';
      formatted = formatted.substring(1);
    }
    final exponentIndex = formatted.indexOf('e');
    final mantissa = formatted.substring(0, exponentIndex);
    final digits = mantissa.replaceFirst('.', '');
    final exponent = int.parse(formatted.substring(exponentIndex + 1));
    final decimalPoint = exponent + 1;
    if (-4 < decimalPoint && decimalPoint <= 16) {
      if (decimalPoint <= 0) return '${sign}0.${'0' * -decimalPoint}$digits';
      if (decimalPoint >= digits.length) {
        return '$sign$digits${'0' * (decimalPoint - digits.length)}.0';
      }
      return '$sign${digits.substring(0, decimalPoint)}.${digits.substring(decimalPoint)}';
    }
    var head = digits.substring(0, 1);
    if (digits.length > 1) head += '.${digits.substring(1)}';
    final exponentSign = exponent < 0 ? '-' : '+';
    final exponentDigits = exponent.abs().toString().padLeft(2, '0');
    return '$sign${head}e$exponentSign$exponentDigits';
  }

  /// Redact a flat mapping such as request or response headers.
  static Map<String, String> redactMapping(Map<String, String>? headers) {
    final shown = <String, String>{};
    if (headers == null) return shown;
    headers.forEach((key, value) {
      shown[key] = shouldRedact(key) ? redacted : redactText(value);
    });
    return shown;
  }

  /// Redact every URL and every schemeless path?query inside free text.
  static String redactText(String value) {
    var cleaned = value;
    if (value.contains('://')) {
      cleaned = cleaned.replaceAllMapped(
          _urlRun, (match) => _redactOneUrl(match[0]!));
    }
    if (cleaned.contains('/') &&
        (cleaned.contains('?') || cleaned.contains('#'))) {
      cleaned = cleaned.replaceAllMapped(
          _pathQueryRun, (match) => _redactOneUrl(match[0]!));
    }
    return cleaned;
  }

  static String _redactOneUrl(String url) {
    var rest = url;
    var scheme = '';
    var authority = '';
    var redactedAuthority = '';
    var hasAuthority = false;
    final schemeEnd = rest.indexOf('://');
    final schemeless = schemeEnd < 0 && rest.startsWith('//');
    final authorityStart =
        schemeEnd >= 0 ? schemeEnd + 3 : (schemeless ? 2 : -1);
    if (authorityStart >= 0) {
      final authorityEnd =
          _indexOfAny(rest, authorityStart, const <String>['/', '?', '#']);
      scheme = schemeEnd >= 0 ? rest.substring(0, schemeEnd) : '';
      authority = rest.substring(authorityStart, authorityEnd);
      redactedAuthority = _redactUserinfo(authority);
      hasAuthority = true;
      rest = rest.substring(authorityEnd);
    }
    final hash = rest.indexOf('#');
    final head = hash < 0 ? rest : rest.substring(0, hash);
    final fragment = hash < 0 ? null : rest.substring(hash + 1);
    final mark = head.indexOf('?');
    final path = mark < 0 ? head : head.substring(0, mark);
    final query = mark < 0 ? null : head.substring(mark + 1);
    final redactedQuery = query == null ? null : _redactQueryString(query);
    final redactedFragment =
        fragment == null ? null : _redactQueryString(fragment);
    if (redactedAuthority == authority &&
        redactedQuery == query &&
        redactedFragment == fragment) {
      return url;
    }
    final out = StringBuffer();
    if (hasAuthority) {
      out.write(schemeless
          ? '//$redactedAuthority'
          : '${scheme.toLowerCase()}://$redactedAuthority');
    }
    out.write(path);
    if (redactedQuery != null && redactedQuery.isNotEmpty) {
      out.write('?$redactedQuery');
    }
    if (redactedFragment != null && redactedFragment.isNotEmpty) {
      out.write('#$redactedFragment');
    }
    return out.toString();
  }

  static int _indexOfAny(String text, int from, List<String> targets) {
    for (var i = from; i < text.length; i++) {
      if (targets.contains(text[i])) return i;
    }
    return text.length;
  }

  static String _redactUserinfo(String authority) {
    final markerIndex = authority.lastIndexOf('@');
    if (markerIndex < 0) return authority;
    final userinfo = authority.substring(0, markerIndex);
    final colon = userinfo.indexOf(':');
    if (colon < 0) return authority;
    return '${userinfo.substring(0, colon)}:$redacted${authority.substring(markerIndex)}';
  }

  /// Replace the value of every secret-named parameter, leaving the rest byte-exact.
  static String _redactQueryString(String query) {
    if (query.isEmpty) return query;
    final chunks = query.split('&');
    var matched = false;
    for (var i = 0; i < chunks.length; i++) {
      final equals = chunks[i].indexOf('=');
      if (equals < 0) continue;
      final name = _safeDecode(chunks[i].substring(0, equals));
      if (shouldRedact(name)) {
        chunks[i] = '${chunks[i].substring(0, equals)}=$redacted';
        matched = true;
      }
    }
    return matched ? chunks.join('&') : query;
  }

  /// Render a name=value pair for a representation, redacting secret-named fields.
  static Object? redactForDisplay(String name, Object? value) =>
      value != null && shouldRedact(name) ? redacted : redactValue(value);

  static String _safeDecode(String text) {
    try {
      return Uri.decodeQueryComponent(text);
    } on ArgumentError {
      return text;
    } on FormatException {
      return text;
    }
  }
}

/// A JSON number kept as its source text, so an over-64-bit integer stays exact.
class _JsonNumber {
  const _JsonNumber(this.raw);

  /// The number token exactly as it appeared in the source document.
  final String raw;
}

/// A decoded JSON object as an ordered member list that can hold [_JsonNumber]s.
class _JsonObject {
  /// Member keys, in first-appearance order.
  final List<String> keys = <String>[];

  /// Member values, parallel to [keys].
  final List<Object?> values = <Object?>[];

  final Map<String, int> _index = <String, int>{};

  /// Add or overwrite one member.
  void put(String key, Object? value) {
    final existing = _index[key];
    if (existing != null) {
      values[existing] = value;
    } else {
      _index[key] = keys.length;
      keys.add(key);
      values.add(value);
    }
  }
}

/// An order-preserving JSON parser for the redact-json-text path, also accepting
/// `NaN`, `Infinity` and `-Infinity` so it never refuses a body it must redact.
class _OrderedJsonParser {
  _OrderedJsonParser(this._text);

  final String _text;
  int _position = 0;

  static const int _tab = 0x09;
  static const int _lineFeed = 0x0a;
  static const int _carriageReturn = 0x0d;
  static const int _space = 0x20;
  static const int _quote = 0x22;
  static const int _plus = 0x2b;
  static const int _comma = 0x2c;
  static const int _minus = 0x2d;
  static const int _dot = 0x2e;
  static const int _slash = 0x2f;
  static const int _zero = 0x30;
  static const int _one = 0x31;
  static const int _nine = 0x39;
  static const int _colon = 0x3a;
  static const int _upperA = 0x41;
  static const int _upperE = 0x45;
  static const int _upperF = 0x46;
  static const int _upperI = 0x49;
  static const int _upperN = 0x4e;
  static const int _openBracket = 0x5b;
  static const int _backslash = 0x5c;
  static const int _closeBracket = 0x5d;
  static const int _lowerA = 0x61;
  static const int _lowerB = 0x62;
  static const int _lowerE = 0x65;
  static const int _lowerF = 0x66;
  static const int _lowerN = 0x6e;
  static const int _lowerR = 0x72;
  static const int _lowerT = 0x74;
  static const int _lowerU = 0x75;
  static const int _openBrace = 0x7b;
  static const int _closeBrace = 0x7d;

  /// Parse the whole document.
  Object? parseDocument() {
    final value = _parseValue();
    _skipWhitespace();
    if (_position != _text.length) {
      throw const FormatException('trailing content after the JSON document');
    }
    return value;
  }

  void _skipWhitespace() {
    while (_position < _text.length) {
      final codeUnit = _text.codeUnitAt(_position);
      if (codeUnit != _space &&
          codeUnit != _tab &&
          codeUnit != _lineFeed &&
          codeUnit != _carriageReturn) {
        return;
      }
      _position++;
    }
  }

  Never _fail(String reason) => throw FormatException(reason, _text, _position);

  Object? _parseValue() {
    _skipWhitespace();
    if (_position >= _text.length) _fail('unexpected end of input');
    final codeUnit = _text.codeUnitAt(_position);
    switch (codeUnit) {
      case _openBrace:
        return _parseObject();
      case _openBracket:
        return _parseArray();
      case _quote:
        return _parseString();
      case _lowerT:
        _expectLiteral('true');
        return true;
      case _lowerF:
        _expectLiteral('false');
        return false;
      case _lowerN:
        _expectLiteral('null');
        return null;
      case _upperN:
        _expectLiteral('NaN');
        return const _JsonNumber('NaN');
      case _upperI:
        _expectLiteral('Infinity');
        return const _JsonNumber('Infinity');
      default:
        if (codeUnit == _minus || (codeUnit >= _zero && codeUnit <= _nine)) {
          return _parseNumber();
        }
        _fail('unexpected character');
    }
  }

  void _expectLiteral(String literal) {
    if (!_text.startsWith(literal, _position)) _fail('malformed literal');
    _position += literal.length;
  }

  _JsonObject _parseObject() {
    _position++;
    final object = _JsonObject();
    _skipWhitespace();
    if (_position < _text.length &&
        _text.codeUnitAt(_position) == _closeBrace) {
      _position++;
      return object;
    }
    while (true) {
      _skipWhitespace();
      if (_position >= _text.length || _text.codeUnitAt(_position) != _quote) {
        _fail('expected a string key');
      }
      final key = _parseString();
      _skipWhitespace();
      if (_position >= _text.length || _text.codeUnitAt(_position) != _colon) {
        _fail("expected ':'");
      }
      _position++;
      object.put(key, _parseValue());
      _skipWhitespace();
      if (_position >= _text.length) _fail('unterminated object');
      final codeUnit = _text.codeUnitAt(_position);
      if (codeUnit == _comma) {
        _position++;
        continue;
      }
      if (codeUnit == _closeBrace) {
        _position++;
        return object;
      }
      _fail("expected ',' or '}'");
    }
  }

  List<Object?> _parseArray() {
    _position++;
    final array = <Object?>[];
    _skipWhitespace();
    if (_position < _text.length &&
        _text.codeUnitAt(_position) == _closeBracket) {
      _position++;
      return array;
    }
    while (true) {
      array.add(_parseValue());
      _skipWhitespace();
      if (_position >= _text.length) _fail('unterminated array');
      final codeUnit = _text.codeUnitAt(_position);
      if (codeUnit == _comma) {
        _position++;
        continue;
      }
      if (codeUnit == _closeBracket) {
        _position++;
        return array;
      }
      _fail("expected ',' or ']'");
    }
  }

  String _parseString() {
    _position++;
    final out = StringBuffer();
    while (true) {
      if (_position >= _text.length) _fail('unterminated string');
      final codeUnit = _text.codeUnitAt(_position);
      if (codeUnit == _quote) {
        _position++;
        return out.toString();
      }
      if (codeUnit == _backslash) {
        _position++;
        if (_position >= _text.length) _fail('unterminated escape');
        final escape = _text.codeUnitAt(_position);
        _position++;
        switch (escape) {
          case _quote:
            out.write('"');
          case _backslash:
            out.write(r'\');
          case _slash:
            out.write('/');
          case _lowerB:
            out.write('\b');
          case _lowerF:
            out.write('\f');
          case _lowerN:
            out.write('\n');
          case _lowerR:
            out.write('\r');
          case _lowerT:
            out.write('\t');
          case _lowerU:
            if (_position + 4 > _text.length) _fail('truncated \\u escape');
            var code = 0;
            for (var i = 0; i < 4; i++) {
              final hexCodeUnit = _text.codeUnitAt(_position + i);
              final digit = switch (hexCodeUnit) {
                >= _zero && <= _nine => hexCodeUnit - _zero,
                >= _upperA && <= _upperF => hexCodeUnit - _upperA + 10,
                >= _lowerA && <= _lowerF => hexCodeUnit - _lowerA + 10,
                _ => _fail('malformed \\u escape'),
              };
              code = code * 16 + digit;
            }
            out.writeCharCode(code);
            _position += 4;
          default:
            _fail('invalid escape');
        }
        continue;
      }
      if (codeUnit < _space) _fail('raw control character in string');
      out.writeCharCode(codeUnit);
      _position++;
    }
  }

  _JsonNumber _parseNumber() {
    final start = _position;
    if (_text.codeUnitAt(_position) == _minus) {
      _position++;
      if (_position < _text.length && _text.codeUnitAt(_position) == _upperI) {
        _expectLiteral('Infinity');
        return _JsonNumber(_text.substring(start, _position));
      }
    }
    if (_position >= _text.length) _fail('malformed number');
    final first = _text.codeUnitAt(_position);
    if (first == _zero) {
      _position++;
    } else if (first >= _one && first <= _nine) {
      _position++;
      _skipDigits();
    } else {
      _fail('malformed number');
    }
    if (_position < _text.length && _text.codeUnitAt(_position) == _dot) {
      _position++;
      if (!_isDigit()) _fail('malformed number');
      _skipDigits();
    }
    if (_position < _text.length) {
      final marker = _text.codeUnitAt(_position);
      if (marker == _lowerE || marker == _upperE) {
        _position++;
        if (_position < _text.length) {
          final sign = _text.codeUnitAt(_position);
          if (sign == _plus || sign == _minus) _position++;
        }
        if (!_isDigit()) _fail('malformed number');
        _skipDigits();
      }
    }
    return _JsonNumber(_text.substring(start, _position));
  }

  bool _isDigit() {
    if (_position >= _text.length) return false;
    final codeUnit = _text.codeUnitAt(_position);
    return codeUnit >= _zero && codeUnit <= _nine;
  }

  void _skipDigits() {
    while (_isDigit()) {
      _position++;
    }
  }
}

/// How deep [Redaction.redactValue] walks before writing [Redaction.tooDeep].
const int maxRedactionDepth = Redaction.maxDepth;

/// What a redacted value is replaced with.
const String redacted = Redaction.redacted;

/// What replaces a structure nested deeper than [maxRedactionDepth].
const String tooDeep = Redaction.tooDeep;

/// What replaces a container that contains itself.
const String circular = Redaction.circular;

/// The key-name markers that make a field a secret.
const List<String> sensitiveKeyMarkers = Redaction.sensitiveKeyMarkers;

/// Whether a key names a secret.
bool shouldRedact(String key) => Redaction.shouldRedact(key);

/// A JSON-shaped copy of [value] with every secret replaced.
Object? redactValue(Object? value) => Redaction.redactValue(value);

/// A copy of [headers] with every secret value replaced.
Map<String, String> redactMapping(Map<String, String>? headers) =>
    Redaction.redactMapping(headers);

/// [value] with secret URL parts replaced.
String redactText(String value) => Redaction.redactText(value);
