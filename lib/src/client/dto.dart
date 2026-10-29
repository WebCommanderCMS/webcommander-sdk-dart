/// The [Dto] base and the readers its subclasses decode fields with.
library;

import '../redaction.dart';

/// The reader an endpoint threads through a call to name the typed view its
/// `ApiResponse.dto` produces.
typedef DtoDecoder = Object? Function(Object? body);

/// Base for every typed view in this SDK: a read-only view over a decoded body,
/// or a payload handed to an endpoint.
abstract class Dto {
  const Dto();

  /// The key the API wraps this record in — `'customer'` for `{"customer": {...}}`.
  /// [readRecord] unwraps it on the way in, [toMap] puts it back on the way out.
  String? get envelopeKey => null;

  /// Fields that sit beside the envelope rather than inside it —
  /// `transaction_no` in `{"customer": {...}, "transaction_no": "..."}`.
  Set<String> get topLevelFields => const <String>{};

  /// Every field this type declares, keyed by wire name, in the order it sends them.
  Map<String, Object?> get fields;

  /// The body this DTO stands for, envelope included.
  Map<String, Object?> toMap() {
    final record = <String, Object?>{};
    final beside = <String, Object?>{};
    fields.forEach((name, value) {
      if (value == null) return;
      (topLevelFields.contains(name) ? beside : record)[name] = _write(value);
    });
    final key = envelopeKey;
    return <String, Object?>{
      if (key != null) key: record else ...record,
      ...beside,
    };
  }

  /// Set fields, values under a secret-named key masked.
  @override
  String toString() {
    final shown = <String>[];
    fields.forEach((name, value) {
      if (value == null) return;
      shown.add('$name=${shouldRedact(name) ? redacted : redactValue(value)}');
    });
    return '$runtimeType(${shown.join(', ')})';
  }
}

/// A decoded body as a record keyed by wire name, [envelopeKey] unwrapped when
/// the body carries it.
Map<String, Object?>? readRecord(Object? body, {String? envelopeKey}) {
  if (body is! Map) return null;
  final source = <String, Object?>{
    for (final entry in body.entries) '${entry.key}': entry.value,
  };
  if (envelopeKey == null) return source;
  final inner = source[envelopeKey];
  if (inner is! Map) return source;
  return <String, Object?>{
    for (final entry in inner.entries) '${entry.key}': entry.value,
    for (final entry in source.entries)
      if (entry.key != envelopeKey) entry.key: entry.value,
  };
}

/// A whole number, or `null`. The text `"3"` is not one.
int? readInteger(Object? value) => value is int ? value : null;

/// A decimal, or `null`.
double? readDecimal(Object? value) => value is num ? value.toDouble() : null;

/// Text, or `null`. The number `42` is not text.
String? readText(Object? value) => value is String ? value : null;

/// A boolean, or `null`.
bool? readFlag(Object? value) => value is bool ? value : null;

/// The value exactly as it arrived, for a field whose type is not claimed.
Object? readAny(Object? value) => value;

/// An id or a name, which is what a lookup field takes on the way out.
Object? readIdOrName(Object? value) =>
    value is int || value is String ? value : null;

/// A list whose entries are each read by [readItem], or `null` when the value
/// is not a list.
List<T?>? readList<T>(Object? value, T? Function(Object? value) readItem) =>
    value is List ? List<T?>.unmodifiable(value.map(readItem)) : null;

Object? _write(Object? value) {
  if (value is Dto) {
    final record = value.toMap();
    final key = value.envelopeKey;
    return key == null ? record : record[key];
  }
  if (value is List) return value.map(_write).toList(growable: false);
  if (value is Map) {
    return <String, Object?>{
      for (final entry in value.entries) '${entry.key}': _write(entry.value),
    };
  }
  return value;
}
