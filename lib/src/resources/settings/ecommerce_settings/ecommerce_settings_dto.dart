/// Typed views over the ecommerce settings bodies.
library;

import '../../../client/dto.dart';

/// The `continue_shopping` section — where the storefront's continue-shopping
/// link goes.
class ContinueShopping extends Dto {
  const ContinueShopping({
    this.enableContinueShopping,
    this.continueShoppingTarget,
    this.continueShoppingSpecifiedTarget,
  });

  static ContinueShopping? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'continue_shopping');
    if (source == null) return null;
    return ContinueShopping(
      enableContinueShopping: readFlag(source['enable_continue_shopping']),
      continueShoppingTarget: readText(source['continue_shopping_target']),
      continueShoppingSpecifiedTarget:
          readText(source['continue_shopping_specified_target']),
    );
  }

  final bool? enableContinueShopping;

  final String? continueShoppingTarget;

  /// `continue_shopping_specified_target` — a page slug.
  final String? continueShoppingSpecifiedTarget;

  @override
  String? get envelopeKey => 'continue_shopping';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_continue_shopping': enableContinueShopping,
        'continue_shopping_target': continueShoppingTarget,
        'continue_shopping_specified_target': continueShoppingSpecifiedTarget,
      };
}

/// The `product_inventory` section — what the storefront does with stock it
/// does not have, and when a sale draws it down.
class ProductInventory extends Dto {
  const ProductInventory({
    this.showOutOfStockProducts,
    this.lowStockNotification,
    this.outOfStockNotification,
    this.hideOnSaleTagForOutOfStockProduct,
    this.orderQuantityOverStock,
    this.updateStock,
  });

  static ProductInventory? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_inventory');
    if (source == null) return null;
    return ProductInventory(
      showOutOfStockProducts: readFlag(source['show_out_of_stock_products']),
      lowStockNotification: readFlag(source['low_stock_notification']),
      outOfStockNotification: readFlag(source['out_of_stock_notification']),
      hideOnSaleTagForOutOfStockProduct:
          readFlag(source['hide_on_sale_tag_for_out_of_stock_product']),
      orderQuantityOverStock: readText(source['order_quantity_over_stock']),
      updateStock: readText(source['update_stock']),
    );
  }

  final bool? showOutOfStockProducts;

  final bool? lowStockNotification;

  final bool? outOfStockNotification;

  final bool? hideOnSaleTagForOutOfStockProduct;

  final String? orderQuantityOverStock;

  final String? updateStock;

  @override
  String? get envelopeKey => 'product_inventory';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_out_of_stock_products': showOutOfStockProducts,
        'low_stock_notification': lowStockNotification,
        'out_of_stock_notification': outOfStockNotification,
        'hide_on_sale_tag_for_out_of_stock_product':
            hideOnSaleTagForOutOfStockProduct,
        'order_quantity_over_stock': orderQuantityOverStock,
        'update_stock': updateStock,
      };
}

/// The `pricing` section — purchase floors, credit and payment terms.
class Pricing extends Dto {
  const Pricing({
    this.updatePriceRange,
    this.enableMinimumPurchaseAmount,
    this.minimumPurchaseAmount,
    this.enableMinimumPurchaseAmountInCart,
    this.minimumPurchaseAmountInCart,
    this.enableOnAccountPurchase,
    this.assignCreditLimitPerOrder,
    this.creditLimitPerOrder,
    this.enablePaymentTerms,
    this.paymentTerms,
    this.enableCustomerPriceRestriction,
  });

  static Pricing? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'pricing');
    if (source == null) return null;
    return Pricing(
      updatePriceRange: readFlag(source['update_price_range']),
      enableMinimumPurchaseAmount:
          readFlag(source['enable_minimum_purchase_amount']),
      minimumPurchaseAmount: readDecimal(source['minimum_purchase_amount']),
      enableMinimumPurchaseAmountInCart:
          readFlag(source['enable_minimum_purchase_amount_in_cart']),
      minimumPurchaseAmountInCart:
          readDecimal(source['minimum_purchase_amount_in_cart']),
      enableOnAccountPurchase: readFlag(source['enable_on_account_purchase']),
      assignCreditLimitPerOrder:
          readFlag(source['assign_credit_limit_per_order']),
      creditLimitPerOrder: readDecimal(source['credit_limit_per_order']),
      enablePaymentTerms: readFlag(source['enable_payment_terms']),
      paymentTerms: readText(source['payment_terms']),
      enableCustomerPriceRestriction:
          readFlag(source['enable_customer_price_restriction']),
    );
  }

  final bool? updatePriceRange;

  final bool? enableMinimumPurchaseAmount;

  /// `minimum_purchase_amount` — declared `decimal` and sent as a whole number,
  /// so typed here against the body.
  final double? minimumPurchaseAmount;

  final bool? enableMinimumPurchaseAmountInCart;

  final double? minimumPurchaseAmountInCart;

  final bool? enableOnAccountPurchase;

  final bool? assignCreditLimitPerOrder;

  final double? creditLimitPerOrder;

  final bool? enablePaymentTerms;

  /// `payment_terms` — a plain `enum` string, not a reference record.
  final String? paymentTerms;

  final bool? enableCustomerPriceRestriction;

  @override
  String? get envelopeKey => 'pricing';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'update_price_range': updatePriceRange,
        'enable_minimum_purchase_amount': enableMinimumPurchaseAmount,
        'minimum_purchase_amount': minimumPurchaseAmount,
        'enable_minimum_purchase_amount_in_cart':
            enableMinimumPurchaseAmountInCart,
        'minimum_purchase_amount_in_cart': minimumPurchaseAmountInCart,
        'enable_on_account_purchase': enableOnAccountPurchase,
        'assign_credit_limit_per_order': assignCreditLimitPerOrder,
        'credit_limit_per_order': creditLimitPerOrder,
        'enable_payment_terms': enablePaymentTerms,
        'payment_terms': paymentTerms,
        'enable_customer_price_restriction': enableCustomerPriceRestriction,
      };
}

/// The `product_restriction` section — one switch, and the narrowest section in
/// the area.
class ProductRestriction extends Dto {
  const ProductRestriction(
      {this.enableProductRestrictionBasedOnParentCategory});

  static ProductRestriction? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_restriction');
    if (source == null) return null;
    return ProductRestriction(
      enableProductRestrictionBasedOnParentCategory: readFlag(
          source['enable_product_restriction_based_on_parent_category']),
    );
  }

  final bool? enableProductRestrictionBasedOnParentCategory;

  @override
  String? get envelopeKey => 'product_restriction';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_product_restriction_based_on_parent_category':
            enableProductRestrictionBasedOnParentCategory,
      };
}

/// The `order_filters` section — the status each admin order list opens on.
class OrderFilters extends Dto {
  const OrderFilters({
    this.defaultOrderStatus,
    this.defaultPaymentStatus,
    this.defaultShipmentStatus,
  });

  static OrderFilters? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_filters');
    if (source == null) return null;
    return OrderFilters(
      defaultOrderStatus: readText(source['default_order_status']),
      defaultPaymentStatus: readText(source['default_payment_status']),
      defaultShipmentStatus: readText(source['default_shipment_status']),
    );
  }

  final String? defaultOrderStatus;

  final String? defaultPaymentStatus;

  final String? defaultShipmentStatus;

  @override
  String? get envelopeKey => 'order_filters';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'default_order_status': defaultOrderStatus,
        'default_payment_status': defaultPaymentStatus,
        'default_shipment_status': defaultShipmentStatus,
      };
}

/// One row of `location_settings.locations` — a stock location as the facade
/// previews it.
class InventoryLocation extends Dto {
  const InventoryLocation({
    this.id,
    this.name,
    this.address,
    this.active,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  static InventoryLocation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InventoryLocation(
      id: readInteger(source['id']),
      name: readText(source['name']),
      address: readText(source['address']),
      active: readFlag(source['active']),
      isDefault: readFlag(source['default']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? address;

  final bool? active;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  final String? createdAt;

  final String? updatedAt;

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

/// The `location_settings` section — the multi-location switch and a read-only
/// preview of the locations themselves.
class LocationSettings extends Dto {
  const LocationSettings({this.enableMultiLocation, this.locations});

  static LocationSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'location_settings');
    if (source == null) return null;
    return LocationSettings(
      enableMultiLocation: readFlag(source['enable_multi_location']),
      locations: readList(source['locations'], InventoryLocation.fromMap),
    );
  }

  final bool? enableMultiLocation;

  /// `locations` — read-only; the rows belong to `/admin/inventory_locations`.
  final List<InventoryLocation?>? locations;

  @override
  String? get envelopeKey => 'location_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_multi_location': enableMultiLocation,
        'locations': locations,
      };
}

/// One row of `order_flags` — a flag as the facade inlines it.
class OrderFlag extends Dto {
  const OrderFlag({
    this.id,
    this.name,
    this.color,
    this.description,
    this.type,
  });

  static OrderFlag? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderFlag(
      id: readInteger(source['id']),
      name: readText(source['name']),
      color: readText(source['color']),
      description: readText(source['description']),
      type: readText(source['type']),
    );
  }

  final int? id;

  final String? name;

  final String? color;

  final String? description;

  /// `type` — a field of the body, not a `field_metadata` entry's `type` key.
  final String? type;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'color': color,
        'description': description,
        'type': type,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class EcommerceSettingsSectionMeta extends Dto {
  const EcommerceSettingsSectionMeta({
    this.kind,
    this.writable,
    this.href,
    this.locationsHref,
  });

  static EcommerceSettingsSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return EcommerceSettingsSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
      locationsHref: readText(source['locations_href']),
    );
  }

  /// `kind` — `"setting"` on the six sections and `"collection"` on `order_flags`.
  final String? kind;

  /// `writable` — `true` on the six sections and `false` on `order_flags`.
  final bool? writable;

  /// `href` — the section's own path on this resource for the six; for
  /// `order_flags` a top-level path outside `/settings/` altogether.
  final String? href;

  /// `locations_href` — `location_settings` alone carries it, and it points at
  /// `/admin/inventory_locations`; `null` on the other six.
  final String? locationsHref;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
        'locations_href': locationsHref,
      };
}

/// The `group_meta` block — one [EcommerceSettingsSectionMeta] per key the area
/// declares.
class EcommerceSettingsGroupMeta extends Dto {
  const EcommerceSettingsGroupMeta({
    this.continueShopping,
    this.productInventory,
    this.pricing,
    this.productRestriction,
    this.orderFilters,
    this.locationSettings,
    this.orderFlags,
  });

  static EcommerceSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return EcommerceSettingsGroupMeta(
      continueShopping:
          EcommerceSettingsSectionMeta.fromMap(source['continue_shopping']),
      productInventory:
          EcommerceSettingsSectionMeta.fromMap(source['product_inventory']),
      pricing: EcommerceSettingsSectionMeta.fromMap(source['pricing']),
      productRestriction:
          EcommerceSettingsSectionMeta.fromMap(source['product_restriction']),
      orderFilters:
          EcommerceSettingsSectionMeta.fromMap(source['order_filters']),
      locationSettings:
          EcommerceSettingsSectionMeta.fromMap(source['location_settings']),
      orderFlags: EcommerceSettingsSectionMeta.fromMap(source['order_flags']),
    );
  }

  final EcommerceSettingsSectionMeta? continueShopping;

  final EcommerceSettingsSectionMeta? productInventory;

  final EcommerceSettingsSectionMeta? pricing;

  final EcommerceSettingsSectionMeta? productRestriction;

  final EcommerceSettingsSectionMeta? orderFilters;

  /// `location_settings` — the one entry four fields wide.
  final EcommerceSettingsSectionMeta? locationSettings;

  /// `order_flags` — declared here, and no section of this area.
  final EcommerceSettingsSectionMeta? orderFlags;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'continue_shopping': continueShopping,
        'product_inventory': productInventory,
        'pricing': pricing,
        'product_restriction': productRestriction,
        'order_filters': orderFilters,
        'location_settings': locationSettings,
        'order_flags': orderFlags,
      };
}

/// The ecommerce settings, as the facade or one section sends them.
class EcommerceSettings extends Dto {
  const EcommerceSettings({
    this.continueShopping,
    this.productInventory,
    this.pricing,
    this.productRestriction,
    this.orderFilters,
    this.locationSettings,
    this.orderFlags,
    this.groupMeta,
    this.fieldMetadata,
  });

  static EcommerceSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'ecommerce_settings');
    if (source == null) return null;
    return EcommerceSettings(
      continueShopping: ContinueShopping.fromMap(source['continue_shopping']),
      productInventory: ProductInventory.fromMap(source['product_inventory']),
      pricing: Pricing.fromMap(source['pricing']),
      productRestriction:
          ProductRestriction.fromMap(source['product_restriction']),
      orderFilters: OrderFilters.fromMap(source['order_filters']),
      locationSettings: LocationSettings.fromMap(source['location_settings']),
      orderFlags: readList(source['order_flags'], OrderFlag.fromMap),
      groupMeta: EcommerceSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final ContinueShopping? continueShopping;

  final ProductInventory? productInventory;

  final Pricing? pricing;

  final ProductRestriction? productRestriction;

  final OrderFilters? orderFilters;

  final LocationSettings? locationSettings;

  /// `order_flags` — read-only rows, not a section of this area.
  final List<OrderFlag?>? orderFlags;

  /// `group_meta` — on the facade's answer only.
  final EcommerceSettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'ecommerce_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'continue_shopping': continueShopping,
        'product_inventory': productInventory,
        'pricing': pricing,
        'product_restriction': productRestriction,
        'order_filters': orderFilters,
        'location_settings': locationSettings,
        'order_flags': orderFlags,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
