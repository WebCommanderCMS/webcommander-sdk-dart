/// Typed views over the tax profile bodies.
library;

import '../../client/dto.dart';

/// The tax code a profile's nested rule points at.
class TaxProfileRuleCode extends Dto {
  const TaxProfileRuleCode({this.id, this.name, this.isDefault});

  /// Reads a nested rule's `code`.
  static TaxProfileRuleCode? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfileRuleCode(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isDefault: readFlag(source['is_default']),
    );
  }

  final int? id;

  final String? name;

  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'is_default': isDefault,
      };
}

/// One tax zone a profile's nested rule points at.
class TaxProfileRuleZone extends Dto {
  const TaxProfileRuleZone(
      {this.id, this.name, this.isSystemGenerated, this.isDefault});

  /// Reads one entry of a nested rule's `zones`.
  static TaxProfileRuleZone? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfileRuleZone(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isSystemGenerated: readFlag(source['is_system_generated']),
      isDefault: readFlag(source['is_default']),
    );
  }

  final int? id;

  final String? name;

  final bool? isSystemGenerated;

  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'is_system_generated': isSystemGenerated,
        'is_default': isDefault,
      };
}

/// One tax rule as a profile nests it, the same ten keys a `/admin/tax_rules`
/// read sends.
class TaxProfileRule extends Dto {
  const TaxProfileRule({
    this.id,
    this.name,
    this.code,
    this.description,
    this.isDefault,
    this.roundingType,
    this.decimalPoint,
    this.zones,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads one entry of a profile's `tax_rules`.
  static TaxProfileRule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfileRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: TaxProfileRuleCode.fromMap(source['code']),
      description: readText(source['description']),
      isDefault: readFlag(source['default']),
      roundingType: readText(source['rounding_type']),
      decimalPoint: readInteger(source['decimal_point']),
      zones: readList<TaxProfileRuleZone>(
          source['zones'], TaxProfileRuleZone.fromMap),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final TaxProfileRuleCode? code;

  final String? description;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  final String? roundingType;

  final int? decimalPoint;

  final List<TaxProfileRuleZone?>? zones;

  final String? createdAt;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
        'description': description,
        'default': isDefault,
        'rounding_type': roundingType,
        'decimal_point': decimalPoint,
        'zones': zones,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// One tax profile, the same seven keys on the listing row and on the row path;
/// a new profile's `tax_rules` is empty.
class TaxProfile extends Dto {
  const TaxProfile({
    this.id,
    this.name,
    this.description,
    this.isDefault,
    this.taxRules,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `tax_profile` envelope, or a bare listing row.
  static TaxProfile? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_profile');
    if (source == null) return null;
    return TaxProfile(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      isDefault: readFlag(source['default']),
      taxRules:
          readList<TaxProfileRule>(source['tax_rules'], TaxProfileRule.fromMap),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  final List<TaxProfileRule?>? taxRules;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'tax_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'default': isDefault,
        'tax_rules': taxRules,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable form of [TaxProfile], shared by the create and the update.
class TaxProfileInput extends Dto {
  const TaxProfileInput({this.name, this.description, this.isDefault});

  /// `name` — required by the create.
  final String? name;

  final String? description;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  @override
  String? get envelopeKey => 'tax_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'default': isDefault,
      };
}

/// The `pagination` block this listing sends.
class TaxProfilePagination extends Dto {
  const TaxProfilePagination({
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
  static TaxProfilePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfilePagination(
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

  /// `limit` — the page size in force, capped at `TaxProfileUrls.pageSize`.
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

/// One page of the tax profile listing: its rows and their `pagination` block.
class TaxProfilePage extends Dto {
  const TaxProfilePage({this.taxProfiles, this.pagination});

  /// Reads a listing body.
  static TaxProfilePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfilePage(
      taxProfiles:
          readList<TaxProfile>(source['tax_profiles'], TaxProfile.fromMap),
      pagination: TaxProfilePagination.fromMap(source['pagination']),
    );
  }

  /// `tax_profiles` — the rows, at most one of them holding `default`.
  final List<TaxProfile?>? taxProfiles;

  final TaxProfilePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_profiles': taxProfiles,
        'pagination': pagination,
      };
}
