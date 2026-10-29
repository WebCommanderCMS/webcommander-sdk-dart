/// Typed views over the order flag bodies.
library;

import '../../client/dto.dart';

/// One order flag, in either of the two forms the API sends — a listing row,
/// and a row path's `{"order_flag": {...}}`.
class OrderFlagRecord extends Dto {
  const OrderFlagRecord({
    this.id,
    this.name,
    this.color,
    this.description,
    this.type,
  });

  /// Reads a row path's `order_flag` envelope, or a bare listing row.
  static OrderFlagRecord? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_flag');
    if (source == null) return null;
    return OrderFlagRecord(
      id: readInteger(source['id']),
      name: readText(source['name']),
      color: readText(source['color']),
      description: readText(source['description']),
      type: readText(source['type']),
    );
  }

  /// `id` — an integer the store assigns; what a `{order_flag_id}` slot takes.
  final int? id;

  final String? name;

  /// `color` — a hex code like `#FF6868`; the store refuses anything else.
  final String? color;

  /// `description` — `null` on a create that omits it, and on an update that does.
  final String? description;

  /// `type` — always `order`; not writable.
  final String? type;

  @override
  String? get envelopeKey => 'order_flag';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'color': color,
        'description': description,
        'type': type,
      };
}

/// An order flag as the store accepts it — the writable form of
/// [OrderFlagRecord], shared by the create and the update.
class OrderFlagInput extends Dto {
  const OrderFlagInput({this.name, this.color, this.description});

  /// `name` — unique across the store; one another flag holds is `409 conflict`.
  final String? name;

  /// `color` — a hex code like `#FF6868`.
  final String? color;

  final String? description;

  @override
  String? get envelopeKey => 'order_flag';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'color': color,
        'description': description,
      };
}

/// The `pagination` block of the listing.
class OrderFlagPagination extends Dto {
  const OrderFlagPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasNext,
    this.hasPrevious,
  });

  /// Reads the block beside the rows.
  static OrderFlagPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderFlagPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasNext: readFlag(source['has_next']),
      hasPrevious: readFlag(source['has_previous']),
    );
  }

  /// `total` — every flag, not just this page.
  final int? total;

  final int? limit;

  /// `offset` — `(page - 1) * limit` when the request named `page` instead.
  final int? offset;

  final bool? hasNext;

  final bool? hasPrevious;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'has_next': hasNext,
        'has_previous': hasPrevious,
      };
}

/// One page of the listing: its rows and their `pagination` block.
class OrderFlagPage extends Dto {
  const OrderFlagPage({this.orderFlags, this.pagination});

  /// Reads a listing body.
  static OrderFlagPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderFlagPage(
      orderFlags: readList<OrderFlagRecord>(
          source['order_flags'], OrderFlagRecord.fromMap),
      pagination: OrderFlagPagination.fromMap(source['pagination']),
    );
  }

  /// `order_flags` — the rows, ordered by `name`.
  final List<OrderFlagRecord?>? orderFlags;

  final OrderFlagPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_flags': orderFlags,
        'pagination': pagination,
      };
}
