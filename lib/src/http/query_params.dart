import '../errors.dart';

/// Sort direction for query parameters; serialises to its wire value.
enum SortDirection {
  /// Ascending.
  asc('asc'),

  /// Descending.
  desc('desc');

  const SortDirection(this.value);

  /// The value sent on the wire.
  final String value;
}

/// Normalises each query parameter to its wire form; a nested object or a nested
/// sequence throws [SdkUsageError].
class QueryParams {
  QueryParams._();

  /// Each parameter in its wire form; `null` values are dropped.
  static Map<String, Object?> build(Map<String, Object?>? params) {
    final out = <String, Object?>{};
    if (params == null) return out;
    params.forEach((key, value) {
      if (value == null) return;
      out[key] = _normalise(key, value, 0);
    });
    return out;
  }

  static Object? _normalise(String key, Object? value, int depth) {
    if (value is Enum) return value.name;
    if (value is num) return value;
    if (value is DateTime) return _iso(value);
    if (value is String) return value;
    if (value is Map) {
      throw SdkUsageError(
          "query param '$key': a nested object is not a query value - flatten it, "
          'or pass a scalar');
    }
    if (value is Iterable) {
      if (depth >= 1) {
        throw SdkUsageError(
            "query param '$key': a sequence inside a sequence is not a query value");
      }
      final list = <Object?>[];
      for (final item in value) {
        if (item == null) continue;
        list.add(_normalise(key, item, depth + 1));
      }
      return list;
    }
    return value.toString();
  }

  static String _iso(DateTime dateTime) {
    String two(int component) => component.toString().padLeft(2, '0');
    final text = StringBuffer('${dateTime.year.toString().padLeft(4, '0')}-'
        '${two(dateTime.month)}-${two(dateTime.day)}'
        'T${two(dateTime.hour)}:${two(dateTime.minute)}:${two(dateTime.second)}');
    final microseconds = dateTime.millisecond * 1000 + dateTime.microsecond;
    if (microseconds > 0) {
      text.write('.${microseconds.toString().padLeft(6, '0')}');
    }
    if (dateTime.isUtc) return (text..write('Z')).toString();
    final offsetMinutes = dateTime.timeZoneOffset.inMinutes;
    final magnitude = offsetMinutes.abs();
    text.write('${offsetMinutes < 0 ? '-' : '+'}'
        '${two(magnitude ~/ 60)}:${two(magnitude % 60)}');
    return text.toString();
  }
}

/// Each parameter in its wire form; `null` values are dropped.
Map<String, Object?> buildQueryParams([Map<String, Object?>? params]) =>
    QueryParams.build(params);
