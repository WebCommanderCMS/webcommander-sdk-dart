/// Typed views over the tax rule bodies.
library;

import '../../client/dto.dart';

/// The tax code a rule points at, as the rule nests it.
class TaxRuleCode extends Dto {
  const TaxRuleCode({this.id, this.name, this.isDefault});

  /// Reads a rule's `code`, `{}` included.
  static TaxRuleCode? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxRuleCode(
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

/// One tax zone a rule points at, as the rule nests it.
class TaxRuleZone extends Dto {
  const TaxRuleZone(
      {this.id, this.name, this.isSystemGenerated, this.isDefault});

  /// Reads one entry of a rule's `zones`.
  static TaxRuleZone? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxRuleZone(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isSystemGenerated: readFlag(source['is_system_generated']),
      isDefault: readFlag(source['is_default']),
    );
  }

  final int? id;

  final String? name;

  /// `is_system_generated` — the zone's own `system_generated` under another
  /// name here.
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

/// One tax rule, the same ten keys on the listing row and on the row path.
class TaxRule extends Dto {
  const TaxRule({
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

  /// Reads a row path's `tax_rule` envelope, or a bare listing row.
  static TaxRule? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_rule');
    if (source == null) return null;
    return TaxRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: TaxRuleCode.fromMap(source['code']),
      description: readText(source['description']),
      isDefault: readFlag(source['default']),
      roundingType: readText(source['rounding_type']),
      decimalPoint: readInteger(source['decimal_point']),
      zones: readList<TaxRuleZone>(source['zones'], TaxRuleZone.fromMap),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  /// `code` — a read-only projection of a tax code, `{}` on a rule this SDK created.
  final TaxRuleCode? code;

  final String? description;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  /// `rounding_type` — read-only; always `nearest` on a rule this SDK created.
  final String? roundingType;

  /// `decimal_point` — read-only; always `2` on a rule this SDK created.
  final int? decimalPoint;

  /// `zones` — a read-only projection of the tax zones.
  final List<TaxRuleZone?>? zones;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'tax_rule';

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

/// The writable form of [TaxRule], shared by the create and the update.
class TaxRuleInput extends Dto {
  const TaxRuleInput({this.name, this.description});

  /// `name` — required by the create.
  final String? name;

  final String? description;

  @override
  String? get envelopeKey => 'tax_rule';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
      };
}

/// The `pagination` block this listing sends.
class TaxRulePagination extends Dto {
  const TaxRulePagination({
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
  static TaxRulePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxRulePagination(
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

  /// `limit` — the page size in force, `TaxRuleUrls.pageSize` when none is sent,
  /// capped at 100.
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

/// One page of the tax rule listing: its rows and their `pagination` block.
class TaxRulePage extends Dto {
  const TaxRulePage({this.taxRules, this.pagination});

  /// Reads a listing body.
  static TaxRulePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxRulePage(
      taxRules: readList<TaxRule>(source['tax_rules'], TaxRule.fromMap),
      pagination: TaxRulePagination.fromMap(source['pagination']),
    );
  }

  /// `tax_rules` — the rows.
  final List<TaxRule?>? taxRules;

  final TaxRulePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_rules': taxRules,
        'pagination': pagination,
      };
}
