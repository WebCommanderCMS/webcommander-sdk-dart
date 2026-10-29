// RFC 9110 token symbols: ``!#$%&'*+-.^_`|~``.
const Set<int> _headerNameSymbols = <int>{
  0x21, 0x23, 0x24, 0x25, 0x26, 0x27, 0x2a, 0x2b, //
  0x2d, 0x2e, 0x5e, 0x5f, 0x60, 0x7c, 0x7e
};

bool sendableHeaderName(String name) {
  if (name.isEmpty) return false;
  for (final codeUnit in name.codeUnits) {
    final alphanumeric = (codeUnit >= 0x30 && codeUnit <= 0x39) ||
        (codeUnit >= 0x41 && codeUnit <= 0x5a) ||
        (codeUnit >= 0x61 && codeUnit <= 0x7a);
    if (!alphanumeric && !_headerNameSymbols.contains(codeUnit)) return false;
  }
  return true;
}

bool sendableHeaderValue(String value) {
  if (value.isEmpty) return true;
  final first = value.codeUnitAt(0);
  if (first < 0x21 || first > 0x7e) return false;
  final last = value.codeUnitAt(value.length - 1);
  if (last == 0x20 || last == 0x09) return false;
  for (final codeUnit in value.codeUnits) {
    // HTAB is a field character between the ends only; both were judged above.
    if (codeUnit == 0x09) continue;
    if (codeUnit < 0x20 || codeUnit > 0x7e) return false;
  }
  return true;
}
