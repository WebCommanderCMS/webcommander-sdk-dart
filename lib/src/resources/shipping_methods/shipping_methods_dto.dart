/// Typed views over the shipping method bodies.
library;

import '../../client/dto.dart';

/// One shipping method, in either of the two forms the API sends — a listing
/// row, and a row path's `{"shipping_method": {...}}`.
class ShippingMethod extends Dto {
  const ShippingMethod({
    this.id,
    this.name,
    this.isDefault,
    this.fieldMetadata,
  });

  /// Reads a row path's `shipping_method` envelope, or a bare listing row.
  static ShippingMethod? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_method');
    if (source == null) return null;
    return ShippingMethod(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isDefault: readFlag(source['is_default']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `id` — an integer the store assigns; what a `{shipping_method_id}` slot takes.
  final int? id;

  /// `name` — the one writable field, unique across the store and 100
  /// characters at most.
  final String? name;

  /// `is_default` — held by exactly one row at a time, and read-only on this path.
  final bool? isDefault;

  /// `field_metadata` — untyped, because its entries differ in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'shipping_method';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'is_default': isDefault,
        'field_metadata': fieldMetadata,
      };
}

/// A shipping method as the store accepts it — the writable form of
/// [ShippingMethod], shared by the create and the update.
class ShippingMethodInput extends Dto {
  const ShippingMethodInput({this.name});

  /// `name` — unique across the store; one another method holds is `409 conflict`.
  final String? name;

  @override
  String? get envelopeKey => 'shipping_method';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
      };
}

/// The `pagination` block of the listing.
class ShippingMethodPagination extends Dto {
  const ShippingMethodPagination({
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
  static ShippingMethodPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingMethodPagination(
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

  /// `total` — the whole collection, nothing here filtering it.
  final int? total;

  /// `limit` — the size the store applied, clamped to the page size.
  final int? limit;

  /// `offset` — `(page - 1) * limit` when the request named `page` instead.
  final int? offset;

  /// `count` — the rows on this page.
  final int? count;

  /// `current_page` — the page `offset` falls in, clamped to `total_pages`:
  /// `limit=1&offset=1` reads `2`.
  final int? currentPage;

  /// `total_pages` — `ceil(total / limit)`.
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

/// One page of the listing, with the schema block `field_metadata=true` adds.
class ShippingMethodPage extends Dto {
  const ShippingMethodPage({
    this.shippingMethods,
    this.pagination,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static ShippingMethodPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingMethodPage(
      shippingMethods: readList<ShippingMethod>(
          source['shipping_methods'], ShippingMethod.fromMap),
      pagination: ShippingMethodPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `shipping_methods` — the rows.
  final List<ShippingMethod?>? shippingMethods;

  final ShippingMethodPagination? pagination;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_methods': shippingMethods,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's body, `{"shipping_methods": {"count": N}}`.
class ShippingMethodCount extends Dto {
  const ShippingMethodCount({this.count});

  /// Reads a count body, the plural key unwrapped.
  static ShippingMethodCount? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_methods');
    if (source == null) return null;
    return ShippingMethodCount(count: readInteger(source['count']));
  }

  /// `count` — every row in the collection.
  final int? count;

  @override
  String? get envelopeKey => 'shipping_methods';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
      };
}
