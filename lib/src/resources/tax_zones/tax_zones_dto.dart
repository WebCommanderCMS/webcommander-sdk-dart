/// Typed views over the tax zone bodies.
library;

import '../../client/dto.dart';

/// A country as a tax zone nests it in `countries`.
class TaxCountry extends Dto {
  const TaxCountry({this.id, this.name, this.code});

  /// Reads one nested country.
  static TaxCountry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxCountry(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  /// `id` — the one field a zone write is resolved by.
  final int? id;

  final String? name;

  /// `code` — the country's own ISO code.
  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// A state as a tax zone nests it in `states`, the same three keys a country
/// carries.
class TaxState extends Dto {
  const TaxState({this.id, this.name, this.code});

  /// Reads one nested state.
  static TaxState? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxState(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  /// `id` — the one field a zone write is resolved by.
  final int? id;

  final String? name;

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// One tax zone, the same twelve keys on the listing row and on the row path.
class TaxZone extends Dto {
  const TaxZone({
    this.id,
    this.name,
    this.systemGenerated,
    this.isDefault,
    this.useRadius,
    this.radius,
    this.startLocation,
    this.countries,
    this.states,
    this.postCode,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `tax_zone` envelope, or a bare listing row.
  static TaxZone? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_zone');
    if (source == null) return null;
    return TaxZone(
      id: readInteger(source['id']),
      name: readText(source['name']),
      systemGenerated: readFlag(source['system_generated']),
      isDefault: readFlag(source['default']),
      useRadius: readFlag(source['use_radius']),
      radius: readDecimal(source['radius']),
      startLocation: readText(source['start_location']),
      countries: readList<TaxCountry>(source['countries'], TaxCountry.fromMap),
      states: readList<TaxState>(source['states'], TaxState.fromMap),
      postCode: readList<String>(source['post_code'], readText),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  /// `system_generated` — read-only; a row carrying it is the store's own.
  final bool? systemGenerated;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  /// `use_radius` — what makes the store read [radius] and [startLocation] at all.
  final bool? useRadius;

  /// `radius` — truncated to a whole number, so `7.5` sent reads back `7`.
  final double? radius;

  final String? startLocation;

  /// `countries` — records a write sends as `{"id": n}`.
  final List<TaxCountry?>? countries;

  /// `states` — records a write sends as `{"id": n}`.
  final List<TaxState?>? states;

  /// `post_code` — the flat list of strings a write sends.
  final List<String?>? postCode;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'tax_zone';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'system_generated': systemGenerated,
        'default': isDefault,
        'use_radius': useRadius,
        'radius': radius,
        'start_location': startLocation,
        'countries': countries,
        'states': states,
        'post_code': postCode,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable form of [TaxZone], shared by the create and the update.
class TaxZoneInput extends Dto {
  const TaxZoneInput({
    this.name,
    this.countries,
    this.states,
    this.postCode,
    this.radius,
    this.startLocation,
    this.useRadius,
  });

  /// `name` — required by both writes.
  final String? name;

  /// `countries` — records; the nested type drops its own envelope, so each
  /// renders as the bare `{"id": n}` the store resolves.
  final List<TaxCountry>? countries;

  /// `states` — records, as [countries] are.
  final List<TaxState>? states;

  /// `post_code` — a flat list of strings; a nested list is `500`.
  final List<String>? postCode;

  /// `radius` — read only with [useRadius] `true`, and truncated to a whole number.
  final double? radius;

  /// `start_location` — read only with [useRadius] `true`.
  final String? startLocation;

  final bool? useRadius;

  @override
  String? get envelopeKey => 'tax_zone';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'countries': countries,
        'states': states,
        'post_code': postCode,
        'radius': radius,
        'start_location': startLocation,
        'use_radius': useRadius,
      };
}

/// The `pagination` block this listing sends.
class TaxZonePagination extends Dto {
  const TaxZonePagination({
    this.total,
    this.limit,
    this.offset,
    this.count,
    this.currentPage,
    this.totalPages,
    this.hasNext,
    this.hasPrevious,
    this.previousPage,
    this.nextPage,
  });

  /// Reads the block beside the rows.
  static TaxZonePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxZonePagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      count: readInteger(source['count']),
      currentPage: readInteger(source['current_page']),
      totalPages: readInteger(source['total_pages']),
      hasNext: readFlag(source['has_next']),
      hasPrevious: readFlag(source['has_previous']),
      previousPage: readText(source['previous_page']),
      nextPage: readText(source['next_page']),
    );
  }

  /// `total` — every row matching, not just this page.
  final int? total;

  /// `limit` — the page size in force, capped at `TaxZoneUrls.pageSize`.
  final int? limit;

  /// `offset` — `(page - 1) * limit` when the request named `page` instead.
  final int? offset;

  /// `count` — the rows on this page, which is what a window advances by.
  final int? count;

  final int? currentPage;

  /// `total_pages` — `ceil(total / limit)`, with the `limit` in force.
  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  /// `previous_page` — a whole URL carrying the query, `null` on the first page.
  final String? previousPage;

  /// `next_page` — a whole URL carrying the query, `null` on the last.
  final String? nextPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'count': count,
        'current_page': currentPage,
        'total_pages': totalPages,
        'has_next': hasNext,
        'has_previous': hasPrevious,
        'previous_page': previousPage,
        'next_page': nextPage,
      };
}

/// One page of the tax zone listing: its rows and their `pagination` block.
class TaxZonePage extends Dto {
  const TaxZonePage({this.taxZones, this.pagination});

  /// Reads a listing body.
  static TaxZonePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxZonePage(
      taxZones: readList<TaxZone>(source['tax_zones'], TaxZone.fromMap),
      pagination: TaxZonePagination.fromMap(source['pagination']),
    );
  }

  /// `tax_zones` — the rows.
  final List<TaxZone?>? taxZones;

  final TaxZonePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_zones': taxZones,
        'pagination': pagination,
      };
}
