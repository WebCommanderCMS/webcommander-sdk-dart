/// Typed views over the order custom field bodies.
library;

import '../../client/dto.dart';

/// One order custom field.
class OrderCustomField extends Dto {
  const OrderCustomField({
    this.id,
    this.fieldType,
    this.label,
    this.name,
    this.isActive,
    this.orderNo,
    this.createdOn,
    this.lastUpdatedOn,
    this.isRequired,
    this.inputFormat,
    this.hasMaxLength,
    this.maxLength,
    this.hoverText,
    this.placeholder,
    this.defaultValue,
    this.htmlClass,
    this.options,
    this.isAllowedForShipping,
    this.isAllowedForDelivery,
    this.isAllowedForStorePickup,
    this.isAllowedForPreOrder,
    this.fieldMetadata,
  });

  /// Reads a row path's `order_custom_field` envelope, with the
  /// `field_metadata` beside it, or a bare listing row.
  static OrderCustomField? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_custom_field');
    if (source == null) return null;
    return OrderCustomField(
      id: readInteger(source['id']),
      fieldType: readText(source['field_type']),
      label: readText(source['label']),
      name: readText(source['name']),
      isActive: readFlag(source['is_active']),
      orderNo: readInteger(source['order_no']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      isRequired: readFlag(source['is_required']),
      inputFormat: readText(source['input_format']),
      hasMaxLength: readFlag(source['has_max_length']),
      maxLength: readInteger(source['max_length']),
      hoverText: readText(source['hover_text']),
      placeholder: readText(source['placeholder']),
      defaultValue: readText(source['default_value']),
      htmlClass: readText(source['html_class']),
      options: readList<String>(source['options'], readText),
      isAllowedForShipping: readFlag(source['is_allowed_for_shipping']),
      isAllowedForDelivery: readFlag(source['is_allowed_for_delivery']),
      isAllowedForStorePickup: readFlag(source['is_allowed_for_store_pickup']),
      isAllowedForPreOrder: readFlag(source['is_allowed_for_pre_order']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `id` — what an `{order_custom_field_id}` slot takes.
  final int? id;

  /// `field_type` — one of the ten types `filterBy` takes.
  final String? fieldType;

  final String? label;

  final String? name;

  final bool? isActive;

  /// `order_no` — typed as the store's `field_metadata` declares it.
  final int? orderNo;

  final String? createdOn;

  final String? lastUpdatedOn;

  final bool? isRequired;

  final String? inputFormat;

  final bool? hasMaxLength;

  final int? maxLength;

  final String? hoverText;

  final String? placeholder;

  final String? defaultValue;

  final String? htmlClass;

  /// `options` — string items, for the four select types.
  final List<String?>? options;

  final bool? isAllowedForShipping;

  final bool? isAllowedForDelivery;

  final bool? isAllowedForStorePickup;

  final bool? isAllowedForPreOrder;

  /// `field_metadata` — untyped, because its entries differ in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'order_custom_field';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'field_type': fieldType,
        'label': label,
        'name': name,
        'is_active': isActive,
        'order_no': orderNo,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'is_required': isRequired,
        'input_format': inputFormat,
        'has_max_length': hasMaxLength,
        'max_length': maxLength,
        'hover_text': hoverText,
        'placeholder': placeholder,
        'default_value': defaultValue,
        'html_class': htmlClass,
        'options': options,
        'is_allowed_for_shipping': isAllowedForShipping,
        'is_allowed_for_delivery': isAllowedForDelivery,
        'is_allowed_for_store_pickup': isAllowedForStorePickup,
        'is_allowed_for_pre_order': isAllowedForPreOrder,
        'field_metadata': fieldMetadata,
      };
}

/// The listing's ten-key `pagination` block.
class OrderCustomFieldPagination extends Dto {
  const OrderCustomFieldPagination({
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
  static OrderCustomFieldPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomFieldPagination(
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

  /// `limit` — the size the store applied, capped at 20.
  final int? limit;

  final int? offset;

  /// `count` — the rows on this page.
  final int? count;

  /// `current_page` — `1` at `offset` 0, and still `1` when nothing matches.
  final int? currentPage;

  /// `total_pages` — `ceil(total / limit)`, and `0` when nothing matches.
  final int? totalPages;

  final bool? hasNext;

  /// `has_previous` — `false` at `offset` 0, and at an `offset` past the last
  /// row.
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

/// The listing's one `group_meta` entry: `kind` `resource`, `writable`
/// `false`.
class OrderCustomFieldResourceMeta extends Dto {
  const OrderCustomFieldResourceMeta({this.kind, this.writable, this.href});

  /// Reads the entry under the collection's own name.
  static OrderCustomFieldResourceMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomFieldResourceMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  final String? kind;

  final bool? writable;

  /// `href` — the listing's own path.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The listing's `group_meta` block, keyed by the collection's own name; the
/// row path and the count send none.
class OrderCustomFieldGroupMeta extends Dto {
  const OrderCustomFieldGroupMeta({this.orderCustomFields});

  /// Reads the block beside the rows.
  static OrderCustomFieldGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomFieldGroupMeta(
      orderCustomFields:
          OrderCustomFieldResourceMeta.fromMap(source['order_custom_fields']),
    );
  }

  final OrderCustomFieldResourceMeta? orderCustomFields;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_custom_fields': orderCustomFields,
      };
}

/// One page of the listing: the rows, where they sit, `group_meta` and any
/// schema.
class OrderCustomFieldPage extends Dto {
  const OrderCustomFieldPage({
    this.orderCustomFields,
    this.pagination,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static OrderCustomFieldPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomFieldPage(
      orderCustomFields: readList<OrderCustomField>(
          source['order_custom_fields'], OrderCustomField.fromMap),
      pagination: OrderCustomFieldPagination.fromMap(source['pagination']),
      groupMeta: OrderCustomFieldGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<OrderCustomField?>? orderCustomFields;

  final OrderCustomFieldPagination? pagination;

  final OrderCustomFieldGroupMeta? groupMeta;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_custom_fields': orderCustomFields,
        'pagination': pagination,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The `validate_timeslot` body; no envelope. `selected_date` is required,
/// `dd/MM/yyyy`; an `order_limit` above 0 makes both hours required and
/// `field_name` read, as text.
class OrderCustomFieldTimeslotInput extends Dto {
  const OrderCustomFieldTimeslotInput({
    this.selectedDate,
    this.fieldName,
    this.weekdayId,
    this.startHour,
    this.endHour,
    this.orderLimit,
  });

  final String? selectedDate;

  final String? fieldName;

  final int? weekdayId;

  /// `start_hour` — 0 to 23.
  final int? startHour;

  /// `end_hour` — 0 to 23.
  final int? endHour;

  /// `order_limit` — `0` is answered fully booked; a negative one, or none,
  /// available.
  final int? orderLimit;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'selected_date': selectedDate,
        'field_name': fieldName,
        'weekday_id': weekdayId,
        'start_hour': startHour,
        'end_hour': endHour,
        'order_limit': orderLimit,
      };
}
