/// Typed views over the country and state bodies.
library;

import '../../client/dto.dart';

/// One country: a listing row, and the row path's body.
class Country extends Dto {
  const Country({
    this.id,
    this.code,
    this.name,
    this.stateCount,
    this.active,
    this.isDefault,
  });

  /// Reads a row path's `country` envelope, or a bare listing row.
  static Country? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'country');
    if (source == null) return null;
    return Country(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
      stateCount: readInteger(source['state_count']),
      active: readFlag(source['active']),
      isDefault: readFlag(source['default']),
    );
  }

  final int? id;

  /// `code` — two upper-case letters.
  final String? code;

  final String? name;

  /// `state_count` — equal to the `total` of the country's state listing.
  final int? stateCount;

  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword. Held
  /// by one country.
  final bool? isDefault;

  @override
  String? get envelopeKey => 'country';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
        'state_count': stateCount,
        'active': active,
        'default': isDefault,
      };
}

/// The short parent country a state listing and a state read carry beside the
/// state.
class CountryReference extends Dto {
  const CountryReference({this.id, this.code, this.name});

  /// Reads the `country` beside the states or the state.
  static CountryReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryReference(
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

/// One state: a listing row, and the state path's body with its parent
/// `country` beside it.
class CountryState extends Dto {
  const CountryState({
    this.id,
    this.code,
    this.name,
    this.active,
    this.isDefault,
    this.country,
  });

  /// Reads a state path's `state` envelope with the `country` beside it, or a
  /// bare listing row.
  static CountryState? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'state');
    if (source == null) return null;
    return CountryState(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
      active: readFlag(source['active']),
      isDefault: readFlag(source['default']),
      country: CountryReference.fromMap(source['country']),
    );
  }

  final int? id;

  final String? code;

  final String? name;

  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  /// `country` — the short parent on a state read, `null` on a listing row.
  final CountryReference? country;

  @override
  String? get envelopeKey => 'state';

  @override
  Set<String> get topLevelFields => const <String>{'country'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
        'active': active,
        'default': isDefault,
        'country': country,
      };
}

/// The five-key `pagination` block of both listings.
class CountryPagination extends Dto {
  const CountryPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static CountryPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

  /// `limit` — the page size applied: the one asked for, 20, or under
  /// `limit=all` the number of rows that arrived.
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

/// One page of the country listing: its rows and their `pagination` block.
class CountryPage extends Dto {
  const CountryPage({this.countries, this.pagination});

  /// Reads a listing body.
  static CountryPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryPage(
      countries: readList<Country>(source['countries'], Country.fromMap),
      pagination: CountryPagination.fromMap(source['pagination']),
    );
  }

  final List<Country?>? countries;

  final CountryPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'countries': countries,
        'pagination': pagination,
      };
}

/// One page of a country's states, beside the short parent country.
class CountryStatePage extends Dto {
  const CountryStatePage({this.country, this.states, this.pagination});

  /// Reads a state listing body.
  static CountryStatePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryStatePage(
      country: CountryReference.fromMap(source['country']),
      states: readList<CountryState>(source['states'], CountryState.fromMap),
      pagination: CountryPagination.fromMap(source['pagination']),
    );
  }

  final CountryReference? country;

  final List<CountryState?>? states;

  final CountryPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country': country,
        'states': states,
        'pagination': pagination,
      };
}
