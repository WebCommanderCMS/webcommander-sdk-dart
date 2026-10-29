/// Typed views over the shipping class bodies.
library;

import '../../client/dto.dart';

/// One shipping class: a listing row, or a row path's `shipping_class` record,
/// the same four fields either way.
class ShippingClass extends Dto {
  const ShippingClass({
    this.id,
    this.name,
    this.description,
    this.isDefault,
    this.fieldMetadata,
  });

  /// Reads a row path's `shipping_class` envelope, or a bare listing row.
  static ShippingClass? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_class');
    if (source == null) return null;
    return ShippingClass(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      isDefault: readFlag(source['is_default']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  final bool? isDefault;

  /// `field_metadata` — untyped, because its entries differ in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'shipping_class';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'is_default': isDefault,
        'field_metadata': fieldMetadata,
      };
}

/// The body both writes take: `name`, required, unique and 50 characters or
/// fewer, and `description`, 100 characters or fewer.
class ShippingClassInput extends Dto {
  const ShippingClassInput({this.name, this.description});

  final String? name;

  final String? description;

  @override
  String? get envelopeKey => 'shipping_class';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
      };
}

/// The listing's ten-key `pagination` block; `limit` is the size the store applied.
class ShippingClassPagination extends Dto {
  const ShippingClassPagination({
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

  static ShippingClassPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingClassPagination(
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

  final int? total;

  final int? limit;

  final int? offset;

  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  final String? previousPage;

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

/// One page of the listing, with the `field_metadata` block when it was asked for.
class ShippingClassPage extends Dto {
  const ShippingClassPage({
    this.shippingClasses,
    this.pagination,
    this.fieldMetadata,
  });

  static ShippingClassPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingClassPage(
      shippingClasses: readList<ShippingClass>(
          source['shipping_classes'], ShippingClass.fromMap),
      pagination: ShippingClassPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<ShippingClass?>? shippingClasses;

  final ShippingClassPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_classes': shippingClasses,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's `{"shipping_classes": {"count": N}}`.
class ShippingClassCount extends Dto {
  const ShippingClassCount({this.count});

  static ShippingClassCount? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_classes');
    if (source == null) return null;
    return ShippingClassCount(count: readInteger(source['count']));
  }

  final int? count;

  @override
  String? get envelopeKey => 'shipping_classes';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
      };
}
