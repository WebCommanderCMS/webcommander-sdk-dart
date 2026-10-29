/// Typed views over the city listing.
library;

import '../../client/dto.dart';

/// The state a city row carries. `id` is the one a country's `states` listing
/// answers.
class CityState extends Dto {
  const CityState({
    this.id,
    this.code,
    this.name,
    this.active,
    this.isDefault,
  });

  /// Reads the `state` inside a row.
  static CityState? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CityState(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
      active: readFlag(source['active']),
      isDefault: readFlag(source['default']),
    );
  }

  final int? id;

  final String? code;

  final String? name;

  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  /// Follows the `administration` section's `default_state`.
  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
        'active': active,
        'default': isDefault,
      };
}

/// The country a city row carries; `id` is the one the `countries` listing
/// answers.
class CityCountry extends Dto {
  const CityCountry({this.id, this.code, this.name});

  /// Reads the `country` inside a row.
  static CityCountry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CityCountry(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
    );
  }

  final int? id;

  /// `code` — two upper-case letters.
  final String? code;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
      };
}

/// One listing row.
class City extends Dto {
  const City({this.id, this.name, this.postCode, this.state, this.country});

  /// Reads a listing row.
  static City? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return City(
      id: readInteger(source['id']),
      name: readText(source['name']),
      postCode: readText(source['post_code']),
      state: CityState.fromMap(source['state']),
      country: CityCountry.fromMap(source['country']),
    );
  }

  final int? id;

  final String? name;

  final String? postCode;

  final CityState? state;

  final CityCountry? country;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'post_code': postCode,
        'state': state,
        'country': country,
      };
}

/// The five-key `pagination` block: `total` is the number of rows that
/// matched, `limit` the page size applied and `offset` the start.
class CityPagination extends Dto {
  const CityPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static CityPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CityPagination(
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

/// One page of the city listing: its rows and their `pagination` block.
class CityPage extends Dto {
  const CityPage({this.cities, this.pagination});

  /// Reads a listing body.
  static CityPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CityPage(
      cities: readList<City>(source['cities'], City.fromMap),
      pagination: CityPagination.fromMap(source['pagination']),
    );
  }

  final List<City?>? cities;

  final CityPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cities': cities,
        'pagination': pagination,
      };
}
