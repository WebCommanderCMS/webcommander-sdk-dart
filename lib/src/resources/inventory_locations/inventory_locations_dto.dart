/// Typed views over the inventory location bodies.
library;

import '../../client/dto.dart';

/// One inventory location, in every form the API sends it.
class InventoryLocationRecord extends Dto {
  const InventoryLocationRecord({
    this.id,
    this.name,
    this.address,
    this.active,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `inventory_location` envelope, or a bare listing row.
  static InventoryLocationRecord? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'inventory_location');
    if (source == null) return null;
    return InventoryLocationRecord(
      id: readInteger(source['id']),
      name: readText(source['name']),
      address: readText(source['address']),
      active: readFlag(source['active']),
      isDefault: readFlag(source['default']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  /// `id` — an integer the store assigns; what an `{inventory_location_id}`
  /// slot takes.
  final int? id;

  /// `name` — required on both writes.
  final String? name;

  /// `address` — optional text, `null` when a create omits it and when a
  /// replace does.
  final String? address;

  /// `active` — `true` when a create omits it, and when a replace does.
  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword. Held
  /// by one row at a time.
  final bool? isDefault;

  /// `created_at` — a stamp the store sets; one sent on a write is `400`.
  final String? createdAt;

  /// `updated_at` — a stamp the store moves on every write it applies.
  final String? updatedAt;

  @override
  String? get envelopeKey => 'inventory_location';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'address': address,
        'active': active,
        'default': isDefault,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// An inventory location as the store accepts it — the writable form of
/// [InventoryLocationRecord], shared by the create, the update and the patch.
/// Left unset, the update blanks `address` and turns `active` on; the patch
/// keeps both.
class InventoryLocationInput extends Dto {
  const InventoryLocationInput({
    this.name,
    this.address,
    this.active,
    this.isDefault,
  });

  /// `name` — the one field the create and the update require, 1 to 250
  /// characters.
  final String? name;

  /// `address` — text.
  final String? address;

  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword. `true`
  /// moves the flag off whichever row held it; `false` on the row holding it
  /// is `409`.
  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'address': address,
        'active': active,
        'default': isDefault,
      };
}

/// The body the status sub-path takes, and the only field it accepts.
class InventoryLocationStatusInput extends Dto {
  const InventoryLocationStatusInput({this.active});

  /// `active` — required.
  final bool? active;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'active': active,
      };
}

/// The `pagination` block of the listing and of the stock sub-path.
class InventoryLocationPagination extends Dto {
  const InventoryLocationPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static InventoryLocationPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocationPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  /// `total` — every row matching the filter, not just this page.
  final int? total;

  /// `limit` — the page size applied: the `limit` asked for, or 20.
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

/// One page of the listing: its rows and their `pagination` block.
class InventoryLocationPage extends Dto {
  const InventoryLocationPage({this.inventoryLocations, this.pagination});

  /// Reads a listing body.
  static InventoryLocationPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocationPage(
      inventoryLocations: readList<InventoryLocationRecord>(
          source['inventory_locations'], InventoryLocationRecord.fromMap),
      pagination: InventoryLocationPagination.fromMap(source['pagination']),
    );
  }

  /// `inventory_locations` — the rows.
  final List<InventoryLocationRecord?>? inventoryLocations;

  final InventoryLocationPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'inventory_locations': inventoryLocations,
        'pagination': pagination,
      };
}

/// The `product` of one stock item — the product the holding is of.
class InventoryLocationStockProduct extends Dto {
  const InventoryLocationStockProduct({this.id, this.name, this.sku});

  /// Reads one item's `product`.
  static InventoryLocationStockProduct? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocationStockProduct(
      id: readInteger(source['id']),
      name: readText(source['name']),
      sku: readText(source['sku']),
    );
  }

  final int? id;

  final String? name;

  final String? sku;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'sku': sku,
      };
}

/// One row of the stock sub-path's `items` — a product's holding at one
/// location.
class InventoryLocationStockItem extends Dto {
  const InventoryLocationStockItem({
    this.product,
    this.variation,
    this.availableStock,
    this.lowStockLevel,
    this.defaultForProduct,
  });

  /// Reads one entry of `items`.
  static InventoryLocationStockItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocationStockItem(
      product: InventoryLocationStockProduct.fromMap(source['product']),
      variation: readAny(source['variation']),
      availableStock: readInteger(source['available_stock']),
      lowStockLevel: readInteger(source['low_stock_level']),
      defaultForProduct: readFlag(source['default_for_product']),
    );
  }

  /// `product` — the product this holding is of.
  final InventoryLocationStockProduct? product;

  /// `variation` — untyped.
  final Object? variation;

  /// `available_stock` — how many of the product this location holds.
  final int? availableStock;

  /// `low_stock_level` — the low-stock threshold, when one is set.
  final int? lowStockLevel;

  /// `default_for_product` — the **product's** own flag, not the location's.
  final bool? defaultForProduct;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product': product,
        'variation': variation,
        'available_stock': availableStock,
        'low_stock_level': lowStockLevel,
        'default_for_product': defaultForProduct,
      };
}

/// The stock sub-path's body: the location itself, its items and their own
/// pagination.
class InventoryLocationStock extends Dto {
  const InventoryLocationStock({
    this.inventoryLocation,
    this.items,
    this.pagination,
  });

  /// Reads a stock body.
  static InventoryLocationStock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocationStock(
      inventoryLocation:
          InventoryLocationRecord.fromMap(source['inventory_location']),
      items: readList<InventoryLocationStockItem>(
          source['items'], InventoryLocationStockItem.fromMap),
      pagination: InventoryLocationPagination.fromMap(source['pagination']),
    );
  }

  /// `inventory_location` — the location the holdings are at, all seven fields.
  final InventoryLocationRecord? inventoryLocation;

  /// `items` — the holdings, `[]` for a location that holds nothing.
  final List<InventoryLocationStockItem?>? items;

  /// `pagination` — the same five keys the listing sends, counting the items.
  final InventoryLocationPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'inventory_location': inventoryLocation,
        'items': items,
        'pagination': pagination,
      };
}
