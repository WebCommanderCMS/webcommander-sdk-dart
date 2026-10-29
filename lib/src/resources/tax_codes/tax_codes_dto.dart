/// Typed views over the tax code bodies.
library;

import '../../client/dto.dart';

/// One tax code, the same eight keys on the listing row and on the row path.
class TaxCode extends Dto {
  const TaxCode({
    this.id,
    this.name,
    this.label,
    this.description,
    this.rate,
    this.resolverType,
    this.priority,
    this.isDefault,
  });

  /// Reads a row path's `tax_code` envelope, or a bare listing row.
  static TaxCode? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_code');
    if (source == null) return null;
    return TaxCode(
      id: readInteger(source['id']),
      name: readText(source['name']),
      label: readText(source['label']),
      description: readText(source['description']),
      rate: readDecimal(source['rate']),
      resolverType: readText(source['resolver_type']),
      priority: readInteger(source['priority']),
      isDefault: readFlag(source['default']),
    );
  }

  final int? id;

  final String? name;

  final String? label;

  final String? description;

  final double? rate;

  /// `resolver_type` — stored unchecked by the create, and back to `flat` when
  /// an update omits it.
  final String? resolverType;

  /// `priority` — back to `0` when an update omits it.
  final int? priority;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  @override
  String? get envelopeKey => 'tax_code';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'label': label,
        'description': description,
        'rate': rate,
        'resolver_type': resolverType,
        'priority': priority,
        'default': isDefault,
      };
}

/// The writable form of [TaxCode], shared by the create and the update.
class TaxCodeInput extends Dto {
  const TaxCodeInput({
    this.name,
    this.label,
    this.description,
    this.rate,
    this.resolverType,
    this.priority,
  });

  /// `name` — the create's one requirement.
  final String? name;

  final String? label;

  final String? description;

  final double? rate;

  /// `resolver_type` — send it on every update that is to keep it.
  final String? resolverType;

  /// `priority` — send it on every update that is to keep it.
  final int? priority;

  @override
  String? get envelopeKey => 'tax_code';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'label': label,
        'description': description,
        'rate': rate,
        'resolver_type': resolverType,
        'priority': priority,
      };
}

/// The `pagination` block this listing sends.
class TaxCodePagination extends Dto {
  const TaxCodePagination({
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
  static TaxCodePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxCodePagination(
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

  /// `limit` — the page size in force, `TaxCodeUrls.pageSize` when none is sent,
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

/// One page of the tax code listing: its rows and their `pagination` block.
class TaxCodePage extends Dto {
  const TaxCodePage({this.taxCodes, this.pagination});

  /// Reads a listing body.
  static TaxCodePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxCodePage(
      taxCodes: readList<TaxCode>(source['tax_codes'], TaxCode.fromMap),
      pagination: TaxCodePagination.fromMap(source['pagination']),
    );
  }

  /// `tax_codes` — the rows.
  final List<TaxCode?>? taxCodes;

  final TaxCodePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_codes': taxCodes,
        'pagination': pagination,
      };
}
