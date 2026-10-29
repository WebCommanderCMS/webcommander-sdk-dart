/// Typed views over the currency bodies.
library;

import '../../client/dto.dart';

/// The country a currency is filed under, as every row answers it.
class CurrencyCountry extends Dto {
  const CurrencyCountry({this.id, this.code, this.name});

  /// Reads a row's `country`.
  static CurrencyCountry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyCountry(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? code;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
      };
}

/// One currency: a listing row, the row path's body and every row write's
/// answer. The base write answers only `id`, `name`, `code` and `base` of it.
class Currency extends Dto {
  const Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.country,
    this.conversionRate,
    this.rounding,
    this.precision,
    this.active,
    this.base,
    this.updatedAt,
    this.fieldMetadata,
  });

  /// Reads a row path's `currency` envelope, or a bare listing row.
  static Currency? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'currency');
    if (source == null) return null;
    return Currency(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
      symbol: readText(source['symbol']),
      country: CurrencyCountry.fromMap(source['country']),
      conversionRate: readDecimal(source['conversion_rate']),
      rounding: readText(source['rounding']),
      precision: readInteger(source['precision']),
      active: readFlag(source['active']),
      base: readFlag(source['base']),
      updatedAt: readText(source['updated_at']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final int? id;

  final String? name;

  /// `code` — three letters, stored upper-case.
  final String? code;

  final String? symbol;

  final CurrencyCountry? country;

  /// `conversion_rate` — kept to 6 decimal places; the store sends `1` as an
  /// integer, read here as `1.0`.
  final double? conversionRate;

  final String? rounding;

  final int? precision;

  final bool? active;

  /// `base` — held by one row; only the base sub-path moves it.
  final bool? base;

  final String? updatedAt;

  /// `field_metadata` — untyped, sent beside the row when asked for.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'currency';

  @override
  Set<String> get topLevelFields => const <String>{'field_metadata'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
        'symbol': symbol,
        'country': country,
        'conversion_rate': conversionRate,
        'rounding': rounding,
        'precision': precision,
        'active': active,
        'base': base,
        'updated_at': updatedAt,
        'field_metadata': fieldMetadata,
      };
}

/// The writable fields, for the create, the `PUT` replace and the `PATCH`; no
/// envelope.
class CurrencyInput extends Dto {
  const CurrencyInput({
    this.name,
    this.code,
    this.symbol,
    this.country,
    this.conversionRate,
    this.rounding,
    this.precision,
    this.active,
  });

  final String? name;

  final String? code;

  final String? symbol;

  /// `country` — a country's id, code, name or a [CurrencyCountry] naming one.
  final Object? country;

  final double? conversionRate;

  final String? rounding;

  final int? precision;

  final bool? active;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'code': code,
        'symbol': symbol,
        'country': country,
        'conversion_rate': conversionRate,
        'rounding': rounding,
        'precision': precision,
        'active': active,
      };
}

/// The five-key `pagination` block; `limit` is the page size applied.
class CurrencyPagination extends Dto {
  const CurrencyPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static CurrencyPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

  final int? limit;

  final int? offset;

  final bool? hasPrevious;

  final bool? hasNext;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'has_previous': hasPrevious,
        'has_next': hasNext,
      };
}

/// One page of the listing: the rows, where they sit and any schema.
class CurrencyPage extends Dto {
  const CurrencyPage({this.currencies, this.pagination, this.fieldMetadata});

  /// Reads a listing body.
  static CurrencyPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyPage(
      currencies: readList<Currency>(source['currencies'], Currency.fromMap),
      pagination: CurrencyPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<Currency?>? currencies;

  final CurrencyPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'currencies': currencies,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class CurrencyCount extends Dto {
  const CurrencyCount({this.total});

  /// Reads a count body.
  static CurrencyCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}

/// The row that held the base flag before a base write.
class CurrencyReference extends Dto {
  const CurrencyReference({this.id, this.code, this.name});

  /// Reads the base write's `previous_base`.
  static CurrencyReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyReference(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? code;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
      };
}

/// The base write's body: the new base, and the row that held the flag or
/// `null`.
class CurrencyBaseChange extends Dto {
  const CurrencyBaseChange({this.currency, this.previousBase});

  /// Reads a base write's body.
  static CurrencyBaseChange? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CurrencyBaseChange(
      currency: Currency.fromMap(source['currency']),
      previousBase: CurrencyReference.fromMap(source['previous_base']),
    );
  }

  final Currency? currency;

  /// `previous_base` — `null` when the row named was already the base.
  final CurrencyReference? previousBase;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'currency': currency,
        'previous_base': previousBase,
      };
}
