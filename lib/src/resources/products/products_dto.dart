/// Typed views over the product bodies.
library;

import '../../client/dto.dart';

/// A product's `urls`: its slug and its absolute storefront address.
class ProductStorefrontUrls extends Dto {
  const ProductStorefrontUrls({this.url, this.productUrl});

  /// Reads one `urls` block.
  static ProductStorefrontUrls? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductStorefrontUrls(
      url: readText(source['url']),
      productUrl: readText(source['product_url']),
    );
  }

  final String? url;

  final String? productUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'url': url,
        'product_url': productUrl,
      };
}

/// An `id` and a `name`: an author, a page, a customer or a customer group.
class ProductNamedReference extends Dto {
  const ProductNamedReference({this.id, this.name});

  /// Reads one reference.
  static ProductNamedReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductNamedReference(
      id: readInteger(source['id']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
      };
}

/// One category the product is filed under.
class ProductParent extends Dto {
  const ProductParent({
    this.id,
    this.name,
    this.isInTrash,
    this.isParentInTrash,
    this.isDisposable,
  });

  /// Reads one entry of `parents`.
  static ProductParent? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductParent(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isInTrash: readFlag(source['is_in_trash']),
      isParentInTrash: readFlag(source['is_parent_in_trash']),
      isDisposable: readFlag(source['is_disposable']),
    );
  }

  final int? id;

  final String? name;

  final bool? isInTrash;

  final bool? isParentInTrash;

  final bool? isDisposable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'is_in_trash': isInTrash,
        'is_parent_in_trash': isParentInTrash,
        'is_disposable': isDisposable,
      };
}

/// Who `available_for: selected` admits, or whom a restriction names; both
/// lists are empty when nobody is named.
class ProductSelectedCustomers extends Dto {
  const ProductSelectedCustomers({this.customers, this.groups});

  /// Reads `selected_customers`.
  static ProductSelectedCustomers? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductSelectedCustomers(
      customers: readList<ProductSelectedCustomer>(
          source['customers'], ProductSelectedCustomer.fromMap),
      groups: readList<ProductNamedReference>(
          source['groups'], ProductNamedReference.fromMap),
    );
  }

  final List<ProductSelectedCustomer?>? customers;

  final List<ProductNamedReference?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// One day of the weekday schedule.
class ProductWeekday extends Dto {
  const ProductWeekday({
    this.day,
    this.startHour,
    this.startMinute,
    this.endHour,
    this.endMinute,
    this.isFullDay,
    this.enabled,
  });

  /// Reads one entry of `weekdays`.
  static ProductWeekday? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductWeekday(
      day: readText(source['day']),
      startHour: readInteger(source['start_hour']),
      startMinute: readInteger(source['start_minute']),
      endHour: readInteger(source['end_hour']),
      endMinute: readInteger(source['end_minute']),
      isFullDay: readFlag(source['is_full_day']),
      enabled: readFlag(source['enabled']),
    );
  }

  final String? day;

  final int? startHour;

  final int? startMinute;

  final int? endHour;

  final int? endMinute;

  final bool? isFullDay;

  final bool? enabled;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'day': day,
        'start_hour': startHour,
        'start_minute': startMinute,
        'end_hour': endHour,
        'end_minute': endMinute,
        'is_full_day': isFullDay,
        'enabled': enabled,
      };
}

/// The weekday schedule: a switch and the seven days.
class ProductAvailableOnWeekdays extends Dto {
  const ProductAvailableOnWeekdays({this.enabled, this.weekdays});

  /// Reads `available_on_weekdays`.
  static ProductAvailableOnWeekdays? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductAvailableOnWeekdays(
      enabled: readFlag(source['enabled']),
      weekdays:
          readList<ProductWeekday>(source['weekdays'], ProductWeekday.fromMap),
    );
  }

  final bool? enabled;

  final List<ProductWeekday?>? weekdays;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'weekdays': weekdays,
      };
}

/// Dimensions as written; the top level of the product repeats the four numbers
/// read-only.
class ProductProperties extends Dto {
  const ProductProperties({
    this.length,
    this.width,
    this.height,
    this.weight,
    this.lengthUnit,
    this.weightUnit,
  });

  /// Reads `product_properties`.
  static ProductProperties? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductProperties(
      length: readDecimal(source['length']),
      width: readDecimal(source['width']),
      height: readDecimal(source['height']),
      weight: readDecimal(source['weight']),
      lengthUnit: readText(source['length_unit']),
      weightUnit: readText(source['weight_unit']),
    );
  }

  final double? length;

  final double? width;

  final double? height;

  final double? weight;

  final String? lengthUnit;

  final String? weightUnit;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
        'length_unit': lengthUnit,
        'weight_unit': weightUnit,
      };
}

/// Per-product tax overrides, applied only when `overwrite_default_config` is
/// `true`.
class ProductTaxSettings extends Dto {
  const ProductTaxSettings({
    this.overwriteDefaultConfig,
    this.isTaxExempt,
    this.showPriceWithTax,
    this.isPriceWithTax,
    this.systemDefaultTax,
    this.taxMessage,
    this.basePriceRounding,
    this.defaultTaxCode,
    this.customTaxProfileId,
  });

  /// Reads `tax_settings`.
  static ProductTaxSettings? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductTaxSettings(
      overwriteDefaultConfig: readFlag(source['overwrite_default_config']),
      isTaxExempt: readFlag(source['is_tax_exempt']),
      showPriceWithTax: readFlag(source['show_price_with_tax']),
      isPriceWithTax: readFlag(source['is_price_with_tax']),
      systemDefaultTax: readFlag(source['system_default_tax']),
      taxMessage: readText(source['tax_message']),
      basePriceRounding: readText(source['base_price_rounding']),
      defaultTaxCode: readText(source['default_tax_code']),
      customTaxProfileId: readText(source['custom_tax_profile_id']),
    );
  }

  final bool? overwriteDefaultConfig;

  final bool? isTaxExempt;

  final bool? showPriceWithTax;

  final bool? isPriceWithTax;

  final bool? systemDefaultTax;

  final String? taxMessage;

  final String? basePriceRounding;

  final String? defaultTaxCode;

  final String? customTaxProfileId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'overwrite_default_config': overwriteDefaultConfig,
        'is_tax_exempt': isTaxExempt,
        'show_price_with_tax': showPriceWithTax,
        'is_price_with_tax': isPriceWithTax,
        'system_default_tax': systemDefaultTax,
        'tax_message': taxMessage,
        'base_price_rounding': basePriceRounding,
        'default_tax_code': defaultTaxCode,
        'custom_tax_profile_id': customTaxProfileId,
      };
}

/// Which variant price a listing shows, and the labels it shows it with.
/// `lowest_price_label` and `highest_price_label` are second names for the two
/// `label_for_*` fields.
class ProductVariationPriceDisplay extends Dto {
  const ProductVariationPriceDisplay({
    this.method,
    this.labelForLowestPrice,
    this.labelForHighestPrice,
    this.lowestPriceLabel,
    this.highestPriceLabel,
  });

  /// Reads `variation_price_display`.
  static ProductVariationPriceDisplay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationPriceDisplay(
      method: readText(source['method']),
      labelForLowestPrice: readText(source['label_for_lowest_price']),
      labelForHighestPrice: readText(source['label_for_highest_price']),
      lowestPriceLabel: readText(source['lowest_price_label']),
      highestPriceLabel: readText(source['highest_price_label']),
    );
  }

  final String? method;

  final String? labelForLowestPrice;

  final String? labelForHighestPrice;

  final String? lowestPriceLabel;

  final String? highestPriceLabel;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'method': method,
        'label_for_lowest_price': labelForLowestPrice,
        'label_for_highest_price': labelForHighestPrice,
        'lowest_price_label': lowestPriceLabel,
        'highest_price_label': highestPriceLabel,
      };
}

/// One location's units in the legacy shape.
class ProductWarehouseStock extends Dto {
  const ProductWarehouseStock({this.warehouse, this.stock});

  /// Reads one entry of `warehouses`.
  static ProductWarehouseStock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductWarehouseStock(
      warehouse: readText(source['warehouse']),
      stock: readInteger(source['stock']),
    );
  }

  /// `warehouse` — the location id as text, where every other location id is an
  /// integer.
  final String? warehouse;

  final int? stock;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'warehouse': warehouse,
        'stock': stock,
      };
}

/// One location's holding of the product; exactly one row of a product holds
/// `is_default`.
class ProductStockLocation extends Dto {
  const ProductStockLocation({
    this.warehouse,
    this.warehouseName,
    this.stock,
    this.lowStockLevel,
    this.isDefault,
  });

  /// Reads one stock row.
  static ProductStockLocation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductStockLocation(
      warehouse: readInteger(source['warehouse']),
      warehouseName: readText(source['warehouse_name']),
      stock: readInteger(source['stock']),
      lowStockLevel: readInteger(source['low_stock_level']),
      isDefault: readFlag(source['is_default']),
    );
  }

  /// `warehouse` — the location id, what an `{inventory_location_id}` slot
  /// takes.
  final int? warehouse;

  final String? warehouseName;

  final int? stock;

  /// `low_stock_level` — `null` when the row was written without one.
  final int? lowStockLevel;

  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'warehouse': warehouse,
        'warehouse_name': warehouseName,
        'stock': stock,
        'low_stock_level': lowStockLevel,
        'is_default': isDefault,
      };
}

/// The pricing and stock block. `locations` matches the stock sub-path's rows,
/// and `low_level_stock` follows the default location's `low_stock_level`.
class ProductPricingAndStock extends Dto {
  const ProductPricingAndStock({
    this.trackInventory,
    this.availableStock,
    this.lowLevelStock,
    this.warehouses,
    this.minimumOrderQuantity,
    this.maximumOrderQuantity,
    this.taxProfile,
    this.shippingProfile,
    this.enableMultipleOrder,
    this.multipleOrderQuantity,
    this.onSale,
    this.onSalePriceType,
    this.onSalePrice,
    this.expectedToPay,
    this.expectedToPayPrice,
    this.enableCallForPrice,
    this.restrictPriceFor,
    this.restrictPriceForExceptCustomers,
    this.restrictPurchaseFor,
    this.restrictPurchaseForSelectedCustomers,
    this.hidePrice,
    this.enableCombinedStockSellingLimit,
    this.combinedStockSellingLimit,
    this.enableAdvancePricing,
    this.suppliers,
    this.isMultiLocationEnabled,
    this.locations,
  });

  /// Reads `product_pricing_and_stock`.
  static ProductPricingAndStock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPricingAndStock(
      trackInventory: readFlag(source['track_inventory']),
      availableStock: readInteger(source['available_stock']),
      lowLevelStock: readInteger(source['low_level_stock']),
      warehouses: readList<ProductWarehouseStock>(
          source['warehouses'], ProductWarehouseStock.fromMap),
      minimumOrderQuantity: readInteger(source['minimum_order_quantity']),
      maximumOrderQuantity: readInteger(source['maximum_order_quantity']),
      taxProfile: readAny(source['tax_profile']),
      shippingProfile: readAny(source['shipping_profile']),
      enableMultipleOrder: readFlag(source['enable_multiple_order']),
      multipleOrderQuantity: readInteger(source['multiple_order_quantity']),
      onSale: readFlag(source['on_sale']),
      onSalePriceType: readText(source['on_sale_price_type']),
      onSalePrice: readDecimal(source['on_sale_price']),
      expectedToPay: readFlag(source['expected_to_pay']),
      expectedToPayPrice: readDecimal(source['expected_to_pay_price']),
      enableCallForPrice: readFlag(source['enable_call_for_price']),
      restrictPriceFor: readText(source['restrict_price_for']),
      restrictPriceForExceptCustomers: readList<Object>(
          source['restrict_price_for_except_customers'], readAny),
      restrictPurchaseFor: readText(source['restrict_purchase_for']),
      restrictPurchaseForSelectedCustomers: readList<Object>(
          source['restrict_purchase_for_selected_customers'], readAny),
      hidePrice: readFlag(source['hide_price']),
      enableCombinedStockSellingLimit:
          readFlag(source['enable_combined_stock_selling_limit']),
      combinedStockSellingLimit:
          readInteger(source['combined_stock_selling_limit']),
      enableAdvancePricing: readFlag(source['enable_advance_pricing']),
      suppliers: readList<Object>(source['suppliers'], readAny),
      isMultiLocationEnabled: readFlag(source['is_multi_location_enabled']),
      locations: readList<ProductStockLocation>(
          source['locations'], ProductStockLocation.fromMap),
    );
  }

  final bool? trackInventory;

  final int? availableStock;

  final int? lowLevelStock;

  final List<ProductWarehouseStock?>? warehouses;

  final int? minimumOrderQuantity;

  final int? maximumOrderQuantity;

  /// `tax_profile` — `{}` on every product read, so untyped.
  final Object? taxProfile;

  /// `shipping_profile` — `{}` on every product read, so untyped.
  final Object? shippingProfile;

  final bool? enableMultipleOrder;

  final int? multipleOrderQuantity;

  final bool? onSale;

  final String? onSalePriceType;

  final double? onSalePrice;

  final bool? expectedToPay;

  final double? expectedToPayPrice;

  final bool? enableCallForPrice;

  final String? restrictPriceFor;

  final List<Object?>? restrictPriceForExceptCustomers;

  final String? restrictPurchaseFor;

  final List<Object?>? restrictPurchaseForSelectedCustomers;

  final bool? hidePrice;

  final bool? enableCombinedStockSellingLimit;

  final int? combinedStockSellingLimit;

  final bool? enableAdvancePricing;

  final List<Object?>? suppliers;

  final bool? isMultiLocationEnabled;

  final List<ProductStockLocation?>? locations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'track_inventory': trackInventory,
        'available_stock': availableStock,
        'low_level_stock': lowLevelStock,
        'warehouses': warehouses,
        'minimum_order_quantity': minimumOrderQuantity,
        'maximum_order_quantity': maximumOrderQuantity,
        'tax_profile': taxProfile,
        'shipping_profile': shippingProfile,
        'enable_multiple_order': enableMultipleOrder,
        'multiple_order_quantity': multipleOrderQuantity,
        'on_sale': onSale,
        'on_sale_price_type': onSalePriceType,
        'on_sale_price': onSalePrice,
        'expected_to_pay': expectedToPay,
        'expected_to_pay_price': expectedToPayPrice,
        'enable_call_for_price': enableCallForPrice,
        'restrict_price_for': restrictPriceFor,
        'restrict_price_for_except_customers': restrictPriceForExceptCustomers,
        'restrict_purchase_for': restrictPurchaseFor,
        'restrict_purchase_for_selected_customers':
            restrictPurchaseForSelectedCustomers,
        'hide_price': hidePrice,
        'enable_combined_stock_selling_limit': enableCombinedStockSellingLimit,
        'combined_stock_selling_limit': combinedStockSellingLimit,
        'enable_advance_pricing': enableAdvancePricing,
        'suppliers': suppliers,
        'is_multi_location_enabled': isMultiLocationEnabled,
        'locations': locations,
      };
}

/// One product image.
class ProductImage extends Dto {
  const ProductImage({
    this.id,
    this.filename,
    this.altText,
    this.thumbnail,
    this.link,
  });

  /// Reads one entry of `images`.
  static ProductImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductImage(
      id: readInteger(source['id']),
      filename: readText(source['filename']),
      altText: readText(source['alt_text']),
      thumbnail: readText(source['thumbnail']),
      link: readText(source['link']),
    );
  }

  final int? id;

  final String? filename;

  final String? altText;

  final String? thumbnail;

  final String? link;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'filename': filename,
        'alt_text': altText,
        'thumbnail': thumbnail,
        'link': link,
      };
}

/// One video, on the product or on a variant. Not `ProductVideo`, which the
/// product page settings export.
class ProductMediaVideo extends Dto {
  const ProductMediaVideo({this.id, this.filename, this.thumbnail, this.link});

  /// Reads one entry of `videos`.
  static ProductMediaVideo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductMediaVideo(
      id: readInteger(source['id']),
      filename: readText(source['filename']),
      thumbnail: readText(source['thumbnail']),
      link: readText(source['link']),
    );
  }

  final int? id;

  final String? filename;

  final String? thumbnail;

  final String? link;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'filename': filename,
        'thumbnail': thumbnail,
        'link': link,
      };
}

/// The media block.
class ProductImageAndVideo extends Dto {
  const ProductImageAndVideo({this.images, this.videos, this.specs});

  /// Reads `image_and_video`.
  static ProductImageAndVideo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductImageAndVideo(
      images: readList<ProductImage>(source['images'], ProductImage.fromMap),
      videos: readList<ProductMediaVideo>(
          source['videos'], ProductMediaVideo.fromMap),
      specs: readList<Object>(source['specs'], readAny),
    );
  }

  final List<ProductImage?>? images;

  final List<ProductMediaVideo?>? videos;

  final List<Object?>? specs;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'images': images,
        'videos': videos,
        'specs': specs,
      };
}

/// Identifiers and origin; `mpn`, `upc`, `barcode` and `hs_code` are written
/// here, not at the top level, which refuses them.
class ProductAdvanceInformation extends Dto {
  const ProductAdvanceInformation({
    this.globalTradeItemNumber,
    this.enableProductIdentifiers,
    this.gtin,
    this.mpn,
    this.upc,
    this.barcode,
    this.countryOfOrigin,
    this.hsCode,
    this.productCondition,
    this.model,
  });

  /// Reads `advance_information`.
  static ProductAdvanceInformation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductAdvanceInformation(
      globalTradeItemNumber: readText(source['global_trade_item_number']),
      enableProductIdentifiers: readFlag(source['enable_product_identifiers']),
      gtin: readText(source['gtin']),
      mpn: readText(source['mpn']),
      upc: readText(source['upc']),
      barcode: readText(source['barcode']),
      countryOfOrigin: readText(source['country_of_origin']),
      hsCode: readText(source['hs_code']),
      productCondition: readText(source['product_condition']),
      model: readText(source['model']),
    );
  }

  final String? globalTradeItemNumber;

  final bool? enableProductIdentifiers;

  final String? gtin;

  final String? mpn;

  final String? upc;

  final String? barcode;

  final String? countryOfOrigin;

  final String? hsCode;

  final String? productCondition;

  final String? model;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'global_trade_item_number': globalTradeItemNumber,
        'enable_product_identifiers': enableProductIdentifiers,
        'gtin': gtin,
        'mpn': mpn,
        'upc': upc,
        'barcode': barcode,
        'country_of_origin': countryOfOrigin,
        'hs_code': hsCode,
        'product_condition': productCondition,
        'model': model,
      };
}

/// The advanced block.
class ProductAdvanced extends Dto {
  const ProductAdvanced({
    this.advanceInformation,
    this.webtoolDisableTracking,
    this.metaTags,
    this.productFlags,
    this.productDimension,
    this.productIdentifiers,
    this.webtool,
  });

  /// Reads `advanced`.
  static ProductAdvanced? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductAdvanced(
      advanceInformation:
          ProductAdvanceInformation.fromMap(source['advance_information']),
      webtoolDisableTracking: readFlag(source['webtool_disable_tracking']),
      metaTags: readList<Object>(source['meta_tags'], readAny),
      productFlags: ProductFlags.fromMap(source['product_flags']),
      productDimension: ProductDimension.fromMap(source['product_dimension']),
      productIdentifiers:
          ProductIdentifiers.fromMap(source['product_identifiers']),
      webtool: ProductWebtool.fromMap(source['webtool']),
    );
  }

  final ProductAdvanceInformation? advanceInformation;

  final bool? webtoolDisableTracking;

  final List<Object?>? metaTags;

  final ProductFlags? productFlags;

  final ProductDimension? productDimension;

  final ProductIdentifiers? productIdentifiers;

  final ProductWebtool? webtool;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'advance_information': advanceInformation,
        'webtool_disable_tracking': webtoolDisableTracking,
        'meta_tags': metaTags,
        'product_flags': productFlags,
        'product_dimension': productDimension,
        'product_identifiers': productIdentifiers,
        'webtool': webtool,
      };
}

/// A related, similar or up-sell product. A write takes `{"id": ...}`; a list
/// of bare ids in `up_sell_products` is answered `200` and leaves it empty.
class ProductLink extends Dto {
  const ProductLink({
    this.id,
    this.name,
    this.url,
    this.status,
    this.sku,
    this.inStock,
    this.price,
  });

  /// Reads one related, similar or up-sell product.
  static ProductLink? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductLink(
      id: readInteger(source['id']),
      name: readText(source['name']),
      url: readText(source['url']),
      status: readText(source['status']),
      sku: readText(source['sku']),
      inStock: readFlag(source['in_stock']),
      price: readDecimal(source['price']),
    );
  }

  final int? id;

  final String? name;

  final String? url;

  final String? status;

  final String? sku;

  final bool? inStock;

  final double? price;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'url': url,
        'status': status,
        'sku': sku,
        'in_stock': inStock,
        'price': price,
      };
}

/// The bundle block; `bundle` is `null` on a product that is not a bundle.
class ProductBundle extends Dto {
  const ProductBundle({this.priceFixed, this.quantityFlexible, this.items});

  /// Reads a product's `bundle`.
  static ProductBundle? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductBundle(
      priceFixed: readFlag(source['price_fixed']),
      quantityFlexible: readFlag(source['quantity_flexible']),
      items: readList<Object>(source['items'], readAny),
    );
  }

  final bool? priceFixed;

  final bool? quantityFlexible;

  /// `items` — the bundle's items, untyped.
  final List<Object?>? items;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'price_fixed': priceFixed,
        'quantity_flexible': quantityFlexible,
        'items': items,
      };
}

/// One SEO setting on the product.
class ProductSeoConfig extends Dto {
  const ProductSeoConfig({
    this.id,
    this.value,
    this.type,
    this.configKey,
    this.metaTags,
  });

  /// Reads one entry of `seo_configs`.
  static ProductSeoConfig? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductSeoConfig(
      id: readInteger(source['id']),
      value: readText(source['value']),
      type: readText(source['type']),
      configKey: readText(source['config_key']),
      metaTags: readList<Object>(source['meta_tags'], readAny),
    );
  }

  final int? id;

  final String? value;

  final String? type;

  final String? configKey;

  final List<Object?>? metaTags;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'value': value,
        'type': type,
        'config_key': configKey,
        'meta_tags': metaTags,
      };
}

/// One value of a product tag.
class ProductTagValue extends Dto {
  const ProductTagValue({this.id, this.title, this.value, this.url});

  /// Reads one entry of a tag's `values`.
  static ProductTagValue? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductTagValue(
      id: readInteger(source['id']),
      title: readText(source['title']),
      value: readText(source['value']),
      url: readText(source['url']),
    );
  }

  final int? id;

  final String? title;

  final String? value;

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'title': title,
        'value': value,
        'url': url,
      };
}

/// One tag on the product, with its values.
class ProductTag extends Dto {
  const ProductTag({
    this.id,
    this.tagId,
    this.name,
    this.values,
    this.displayInProductPage,
    this.enableExpandedView,
  });

  /// Reads one entry of `tags`.
  static ProductTag? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductTag(
      id: readInteger(source['id']),
      tagId: readInteger(source['tag_id']),
      name: readText(source['name']),
      values:
          readList<ProductTagValue>(source['values'], ProductTagValue.fromMap),
      displayInProductPage: readFlag(source['display_in_product_page']),
      enableExpandedView: readFlag(source['enable_expanded_view']),
    );
  }

  final int? id;

  final int? tagId;

  final String? name;

  final List<ProductTagValue?>? values;

  final bool? displayInProductPage;

  final bool? enableExpandedView;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'tag_id': tagId,
        'name': name,
        'values': values,
        'display_in_product_page': displayInProductPage,
        'enable_expanded_view': enableExpandedView,
      };
}

/// One custom property.
class ProductCustomProperty extends Dto {
  const ProductCustomProperty({this.id, this.label, this.description});

  /// Reads one entry of `custom_properties`.
  static ProductCustomProperty? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCustomProperty(
      id: readInteger(source['id']),
      label: readText(source['label']),
      description: readText(source['description']),
    );
  }

  final int? id;

  final String? label;

  final String? description;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'label': label,
        'description': description,
      };
}

/// One review on the product. `product_id`, `comment` and `created_at` repeat
/// `productId`, `review` and `date`; `created_at` carries a `Z`.
class ProductReview extends Dto {
  const ProductReview({
    this.id,
    this.productId,
    this.name,
    this.email,
    this.review,
    this.rating,
    this.date,
    this.status,
    this.files,
    this.productIdSnake,
    this.reviewer,
    this.comment,
    this.createdAt,
  });

  /// Reads one entry of `reviews`.
  static ProductReview? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductReview(
      id: readInteger(source['id']),
      productId: readInteger(source['productId']),
      name: readText(source['name']),
      email: readText(source['email']),
      review: readText(source['review']),
      rating: readDecimal(source['rating']),
      date: readText(source['date']),
      status: readText(source['status']),
      files: readList<Object>(source['files'], readAny),
      productIdSnake: readInteger(source['product_id']),
      reviewer: ProductReviewer.fromMap(source['reviewer']),
      comment: readText(source['comment']),
      createdAt: readText(source['created_at']),
    );
  }

  final int? id;

  /// `productId` — the one camelCase key in the body.
  final int? productId;

  final String? name;

  final String? email;

  final String? review;

  final double? rating;

  final String? date;

  final String? status;

  final List<Object?>? files;

  /// `product_id` — `productId` again.
  final int? productIdSnake;

  final ProductReviewer? reviewer;

  final String? comment;

  final String? createdAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'productId': productId,
        'name': name,
        'email': email,
        'review': review,
        'rating': rating,
        'date': date,
        'status': status,
        'files': files,
        'product_id': productIdSnake,
        'reviewer': reviewer,
        'comment': comment,
        'created_at': createdAt,
      };
}

/// One option of a variation type the product uses.
class ProductVariationTypeOption extends Dto {
  const ProductVariationTypeOption({
    this.id,
    this.label,
    this.value,
    this.isDefault,
  });

  /// Reads one entry of a type's `options`.
  static ProductVariationTypeOption? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationTypeOption(
      id: readInteger(source['id']),
      label: readText(source['label']),
      value: readText(source['value']),
      isDefault: readFlag(source['default']),
    );
  }

  final int? id;

  final String? label;

  final String? value;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'label': label,
        'value': value,
        'default': isDefault,
      };
}

/// One variation type the product uses, with its options.
class ProductVariationType extends Dto {
  const ProductVariationType({this.id, this.name, this.standard, this.options});

  /// Reads one entry of `types`.
  static ProductVariationType? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationType(
      id: readInteger(source['id']),
      name: readText(source['name']),
      standard: readText(source['standard']),
      options: readList<ProductVariationTypeOption>(
          source['options'], ProductVariationTypeOption.fromMap),
    );
  }

  final int? id;

  final String? name;

  final String? standard;

  final List<ProductVariationTypeOption?>? options;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'standard': standard,
        'options': options,
      };
}

/// The type one option of a combination belongs to.
class ProductCombinationOptionType extends Dto {
  const ProductCombinationOptionType({
    this.id,
    this.role,
    this.name,
    this.standard,
    this.isDisposable,
  });

  /// Reads one entry of an option's `type`.
  static ProductCombinationOptionType? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinationOptionType(
      id: readInteger(source['id']),
      role: readText(source['role']),
      name: readText(source['name']),
      standard: readText(source['standard']),
      isDisposable: readFlag(source['is_disposable']),
    );
  }

  final int? id;

  final String? role;

  final String? name;

  final String? standard;

  final bool? isDisposable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'role': role,
        'name': name,
        'standard': standard,
        'is_disposable': isDisposable,
      };
}

/// One option of a combination; `type` is a list of one type.
class ProductCombinationOption extends Dto {
  const ProductCombinationOption({
    this.id,
    this.index,
    this.type,
    this.label,
    this.value,
    this.colorHasSwatch,
    this.colorSwatchValue,
    this.imageBaseUrl,
  });

  /// Reads one entry of a combination's `options`.
  static ProductCombinationOption? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinationOption(
      id: readInteger(source['id']),
      index: readInteger(source['index']),
      type: readList<ProductCombinationOptionType>(
          source['type'], ProductCombinationOptionType.fromMap),
      label: readText(source['label']),
      value: readText(source['value']),
      colorHasSwatch: readFlag(source['color_has_swatch']),
      colorSwatchValue: readText(source['color_swatch_value']),
      imageBaseUrl: readText(source['image_base_url']),
    );
  }

  final int? id;

  final int? index;

  final List<ProductCombinationOptionType?>? type;

  final String? label;

  final String? value;

  final bool? colorHasSwatch;

  final String? colorSwatchValue;

  final String? imageBaseUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'index': index,
        'type': type,
        'label': label,
        'value': value,
        'color_has_swatch': colorHasSwatch,
        'color_swatch_value': colorSwatchValue,
        'image_base_url': imageBaseUrl,
      };
}

/// One variant image.
class ProductCombinationImage extends Dto {
  const ProductCombinationImage({this.id, this.thumbnail, this.url});

  /// Reads one entry of a variant's `images`.
  static ProductCombinationImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinationImage(
      id: readInteger(source['id']),
      thumbnail: readText(source['thumbnail']),
      url: readText(source['url']),
    );
  }

  final int? id;

  final String? thumbnail;

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'thumbnail': thumbnail,
        'url': url,
      };
}

/// A variant's pricing and stock block.
class ProductCombinationPriceAndStock extends Dto {
  const ProductCombinationPriceAndStock({
    this.trackInventory,
    this.availableStock,
    this.lowLevelStock,
    this.minimumOrderQuantity,
    this.maximumOrderQuantity,
    this.supportedMaxOrderQuantity,
    this.enableMultipleOrder,
    this.multipleOrderQuantity,
    this.onSale,
    this.soldOut,
    this.soldOutLabel,
    this.onSalePriceType,
    this.onSalePrice,
    this.expectedToPay,
    this.expectedToPayPrice,
    this.enableCallForPrice,
    this.hidePrice,
  });

  /// Reads a variant's `price_and_stock`.
  static ProductCombinationPriceAndStock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinationPriceAndStock(
      trackInventory: readFlag(source['track_inventory']),
      availableStock: readInteger(source['available_stock']),
      lowLevelStock: readInteger(source['low_level_stock']),
      minimumOrderQuantity: readInteger(source['minimum_order_quantity']),
      maximumOrderQuantity: readInteger(source['maximum_order_quantity']),
      supportedMaxOrderQuantity:
          readInteger(source['supported_max_order_quantity']),
      enableMultipleOrder: readFlag(source['enable_multiple_order']),
      multipleOrderQuantity: readInteger(source['multiple_order_quantity']),
      onSale: readFlag(source['on_sale']),
      soldOut: readFlag(source['sold_out']),
      soldOutLabel: readText(source['sold_out_label']),
      onSalePriceType: readText(source['on_sale_price_type']),
      onSalePrice: readDecimal(source['on_sale_price']),
      expectedToPay: readFlag(source['expected_to_pay']),
      expectedToPayPrice: readDecimal(source['expected_to_pay_price']),
      enableCallForPrice: readFlag(source['enable_call_for_price']),
      hidePrice: readFlag(source['hide_price']),
    );
  }

  final bool? trackInventory;

  final int? availableStock;

  final int? lowLevelStock;

  final int? minimumOrderQuantity;

  final int? maximumOrderQuantity;

  final int? supportedMaxOrderQuantity;

  final bool? enableMultipleOrder;

  final int? multipleOrderQuantity;

  final bool? onSale;

  final bool? soldOut;

  final String? soldOutLabel;

  final String? onSalePriceType;

  final double? onSalePrice;

  final bool? expectedToPay;

  final double? expectedToPayPrice;

  final bool? enableCallForPrice;

  final bool? hidePrice;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'track_inventory': trackInventory,
        'available_stock': availableStock,
        'low_level_stock': lowLevelStock,
        'minimum_order_quantity': minimumOrderQuantity,
        'maximum_order_quantity': maximumOrderQuantity,
        'supported_max_order_quantity': supportedMaxOrderQuantity,
        'enable_multiple_order': enableMultipleOrder,
        'multiple_order_quantity': multipleOrderQuantity,
        'on_sale': onSale,
        'sold_out': soldOut,
        'sold_out_label': soldOutLabel,
        'on_sale_price_type': onSalePriceType,
        'on_sale_price': onSalePrice,
        'expected_to_pay': expectedToPay,
        'expected_to_pay_price': expectedToPayPrice,
        'enable_call_for_price': enableCallForPrice,
        'hide_price': hidePrice,
      };
}

/// One variant. `weight`, `height`, `length` and `width` arrive as a number or
/// as text, so they are not typed.
class ProductCombinationDetails extends Dto {
  const ProductCombinationDetails({
    this.variationId,
    this.available,
    this.productName,
    this.sku,
    this.customSku,
    this.urls,
    this.metaTags,
    this.isInventoryEnabled,
    this.availableStock,
    this.lowStockLevel,
    this.spec,
    this.isMultipleOrderQuantity,
    this.isOnSale,
    this.isExpectToPay,
    this.isCallForPriceEnabled,
    this.isNew,
    this.isFeatured,
    this.onSaleAmountType,
    this.title,
    this.heading,
    this.summary,
    this.description,
    this.model,
    this.productCondition,
    this.featuredLabel,
    this.basePrice,
    this.costPrice,
    this.compareAtPrice,
    this.salePrice,
    this.expectToPayPrice,
    this.weight,
    this.height,
    this.length,
    this.width,
    this.displayPrice,
    this.previousPrice,
    this.priceAndStock,
    this.images,
    this.videos,
    this.specs,
    this.supportedMaxOrderQuantity,
    this.isBase,
    this.barcode,
    this.countryOfOrigin,
    this.hsCode,
    this.tax,
    this.taxMessage,
  });

  /// Reads a combination's `details`.
  static ProductCombinationDetails? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinationDetails(
      variationId: readInteger(source['variation_id']),
      available: readFlag(source['available']),
      productName: readText(source['product_name']),
      sku: readText(source['sku']),
      customSku: readText(source['custom_sku']),
      urls: ProductStorefrontUrls.fromMap(source['urls']),
      metaTags: readList<Object>(source['meta_tags'], readAny),
      isInventoryEnabled: readFlag(source['is_inventory_enabled']),
      availableStock: readInteger(source['available_stock']),
      lowStockLevel: readInteger(source['low_stock_level']),
      spec: readText(source['spec']),
      isMultipleOrderQuantity: readFlag(source['is_multiple_order_quantity']),
      isOnSale: readFlag(source['is_on_sale']),
      isExpectToPay: readFlag(source['is_expect_to_pay']),
      isCallForPriceEnabled: readFlag(source['is_call_for_price_enabled']),
      isNew: readFlag(source['is_new']),
      isFeatured: readFlag(source['is_featured']),
      onSaleAmountType: readText(source['on_sale_amount_type']),
      title: readText(source['title']),
      heading: readText(source['heading']),
      summary: readText(source['summary']),
      description: readText(source['description']),
      model: readText(source['model']),
      productCondition: readText(source['product_condition']),
      featuredLabel: readText(source['featured_label']),
      basePrice: readDecimal(source['base_price']),
      costPrice: readDecimal(source['cost_price']),
      compareAtPrice: readDecimal(source['compare_at_price']),
      salePrice: readDecimal(source['sale_price']),
      expectToPayPrice: readDecimal(source['expect_to_pay_price']),
      weight: readAny(source['weight']),
      height: readAny(source['height']),
      length: readAny(source['length']),
      width: readAny(source['width']),
      displayPrice: readDecimal(source['display_price']),
      previousPrice: readDecimal(source['previous_price']),
      priceAndStock:
          ProductCombinationPriceAndStock.fromMap(source['price_and_stock']),
      images: readList<ProductCombinationImage>(
          source['images'], ProductCombinationImage.fromMap),
      videos: readList<ProductMediaVideo>(
          source['videos'], ProductMediaVideo.fromMap),
      specs: readList<Object>(source['specs'], readAny),
      supportedMaxOrderQuantity:
          readInteger(source['supported_max_order_quantity']),
      isBase: readFlag(source['is_base']),
      barcode: readText(source['barcode']),
      countryOfOrigin: readText(source['country_of_origin']),
      hsCode: readText(source['hs_code']),
      tax: readDecimal(source['tax']),
      taxMessage: readText(source['tax_message']),
    );
  }

  final int? variationId;

  final bool? available;

  final String? productName;

  final String? sku;

  final String? customSku;

  final ProductStorefrontUrls? urls;

  final List<Object?>? metaTags;

  final bool? isInventoryEnabled;

  final int? availableStock;

  final int? lowStockLevel;

  final String? spec;

  final bool? isMultipleOrderQuantity;

  final bool? isOnSale;

  final bool? isExpectToPay;

  final bool? isCallForPriceEnabled;

  final bool? isNew;

  final bool? isFeatured;

  final String? onSaleAmountType;

  final String? title;

  final String? heading;

  final String? summary;

  final String? description;

  final String? model;

  final String? productCondition;

  final String? featuredLabel;

  final double? basePrice;

  final double? costPrice;

  final double? compareAtPrice;

  final double? salePrice;

  final double? expectToPayPrice;

  final Object? weight;

  final Object? height;

  final Object? length;

  final Object? width;

  final double? displayPrice;

  final double? previousPrice;

  final ProductCombinationPriceAndStock? priceAndStock;

  final List<ProductCombinationImage?>? images;

  final List<ProductMediaVideo?>? videos;

  final List<Object?>? specs;

  final int? supportedMaxOrderQuantity;

  final bool? isBase;

  final String? barcode;

  final String? countryOfOrigin;

  final String? hsCode;

  final double? tax;

  final String? taxMessage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variation_id': variationId,
        'available': available,
        'product_name': productName,
        'sku': sku,
        'custom_sku': customSku,
        'urls': urls,
        'meta_tags': metaTags,
        'is_inventory_enabled': isInventoryEnabled,
        'available_stock': availableStock,
        'low_stock_level': lowStockLevel,
        'spec': spec,
        'is_multiple_order_quantity': isMultipleOrderQuantity,
        'is_on_sale': isOnSale,
        'is_expect_to_pay': isExpectToPay,
        'is_call_for_price_enabled': isCallForPriceEnabled,
        'is_new': isNew,
        'is_featured': isFeatured,
        'on_sale_amount_type': onSaleAmountType,
        'title': title,
        'heading': heading,
        'summary': summary,
        'description': description,
        'model': model,
        'product_condition': productCondition,
        'featured_label': featuredLabel,
        'base_price': basePrice,
        'cost_price': costPrice,
        'compare_at_price': compareAtPrice,
        'sale_price': salePrice,
        'expect_to_pay_price': expectToPayPrice,
        'weight': weight,
        'height': height,
        'length': length,
        'width': width,
        'display_price': displayPrice,
        'previous_price': previousPrice,
        'price_and_stock': priceAndStock,
        'images': images,
        'videos': videos,
        'specs': specs,
        'supported_max_order_quantity': supportedMaxOrderQuantity,
        'is_base': isBase,
        'barcode': barcode,
        'country_of_origin': countryOfOrigin,
        'hs_code': hsCode,
        'tax': tax,
        'tax_message': taxMessage,
      };
}

/// One option combination and the variant it makes.
class ProductCombination extends Dto {
  const ProductCombination({this.options, this.details});

  /// Reads one entry of `available_combinations`.
  static ProductCombination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombination(
      options: readList<ProductCombinationOption>(
          source['options'], ProductCombinationOption.fromMap),
      details: ProductCombinationDetails.fromMap(source['details']),
    );
  }

  final List<ProductCombinationOption?>? options;

  final ProductCombinationDetails? details;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'options': options,
        'details': details,
      };
}

/// The variation block; `{}` on a product with no variations, so every field
/// reads `null`.
class ProductVariation extends Dto {
  const ProductVariation({this.types, this.availableCombinations});

  /// Reads `product_variation`.
  static ProductVariation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariation(
      types: readList<ProductVariationType>(
          source['types'], ProductVariationType.fromMap),
      availableCombinations: readList<ProductCombination>(
          source['available_combinations'], ProductCombination.fromMap),
    );
  }

  final List<ProductVariationType?>? types;

  final List<ProductCombination?>? availableCombinations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'types': types,
        'available_combinations': availableCombinations,
      };
}

/// One category the product is filed under, as `categories` lists it; `parents`
/// again.
class ProductCategory extends Dto {
  const ProductCategory({
    this.id,
    this.name,
    this.inTrash,
    this.parentInTrash,
    this.disposable,
  });

  /// Reads one entry of `categories`.
  static ProductCategory? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCategory(
      id: readInteger(source['id']),
      name: readText(source['name']),
      inTrash: readFlag(source['in_trash']),
      parentInTrash: readFlag(source['parent_in_trash']),
      disposable: readFlag(source['disposable']),
    );
  }

  final int? id;

  final String? name;

  final bool? inTrash;

  final bool? parentInTrash;

  final bool? disposable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'in_trash': inTrash,
        'parent_in_trash': parentInTrash,
        'disposable': disposable,
      };
}

/// One image in the media block.
class ProductMediaBlockImage extends Dto {
  const ProductMediaBlockImage({
    this.id,
    this.filename,
    this.position,
    this.primary,
    this.altText,
    this.url,
    this.thumbnailUrl,
  });

  /// Reads one entry of `media.images`.
  static ProductMediaBlockImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductMediaBlockImage(
      id: readInteger(source['id']),
      filename: readText(source['filename']),
      position: readInteger(source['position']),
      primary: readFlag(source['primary']),
      altText: readText(source['alt_text']),
      url: readText(source['url']),
      thumbnailUrl: readText(source['thumbnail_url']),
    );
  }

  final int? id;

  final String? filename;

  final int? position;

  final bool? primary;

  final String? altText;

  final String? url;

  final String? thumbnailUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'filename': filename,
        'position': position,
        'primary': primary,
        'alt_text': altText,
        'url': url,
        'thumbnail_url': thumbnailUrl,
      };
}

/// One video in the media block. Not `ProductMediaVideo`, which
/// `image_and_video` uses.
class ProductMediaBlockVideo extends Dto {
  const ProductMediaBlockVideo({
    this.id,
    this.filename,
    this.position,
    this.url,
    this.thumbnailUrl,
  });

  /// Reads one entry of `media.videos`.
  static ProductMediaBlockVideo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductMediaBlockVideo(
      id: readInteger(source['id']),
      filename: readText(source['filename']),
      position: readInteger(source['position']),
      url: readText(source['url']),
      thumbnailUrl: readText(source['thumbnail_url']),
    );
  }

  final int? id;

  final String? filename;

  final int? position;

  final String? url;

  final String? thumbnailUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'filename': filename,
        'position': position,
        'url': url,
        'thumbnail_url': thumbnailUrl,
      };
}

/// The media block. A write names files the product already holds, by `id`;
/// another id is `400`. `specification_file` was `null` on every product read,
/// so it is not typed.
class ProductMedia extends Dto {
  const ProductMedia({this.images, this.videos, this.specificationFile});

  /// Reads `media`.
  static ProductMedia? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductMedia(
      images: readList<ProductMediaBlockImage>(
          source['images'], ProductMediaBlockImage.fromMap),
      videos: readList<ProductMediaBlockVideo>(
          source['videos'], ProductMediaBlockVideo.fromMap),
      specificationFile: readAny(source['specification_file']),
    );
  }

  final List<ProductMediaBlockImage?>? images;

  final List<ProductMediaBlockVideo?>? videos;

  final Object? specificationFile;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'images': images,
        'videos': videos,
        'specification_file': specificationFile,
      };
}

/// One day of the schedule; times are `HH:mm`.
class ProductWeekdayWindow extends Dto {
  const ProductWeekdayWindow({
    this.enabled,
    this.fullDay,
    this.startTime,
    this.endTime,
  });

  /// Reads one day of `schedule.weekdays`.
  static ProductWeekdayWindow? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductWeekdayWindow(
      enabled: readFlag(source['enabled']),
      fullDay: readFlag(source['full_day']),
      startTime: readText(source['start_time']),
      endTime: readText(source['end_time']),
    );
  }

  final bool? enabled;

  final bool? fullDay;

  final String? startTime;

  final String? endTime;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'full_day': fullDay,
        'start_time': startTime,
        'end_time': endTime,
      };
}

/// The seven days of the schedule, each always present.
class ProductScheduleWeekdays extends Dto {
  const ProductScheduleWeekdays({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  /// Reads `schedule.weekdays`.
  static ProductScheduleWeekdays? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductScheduleWeekdays(
      monday: ProductWeekdayWindow.fromMap(source['monday']),
      tuesday: ProductWeekdayWindow.fromMap(source['tuesday']),
      wednesday: ProductWeekdayWindow.fromMap(source['wednesday']),
      thursday: ProductWeekdayWindow.fromMap(source['thursday']),
      friday: ProductWeekdayWindow.fromMap(source['friday']),
      saturday: ProductWeekdayWindow.fromMap(source['saturday']),
      sunday: ProductWeekdayWindow.fromMap(source['sunday']),
    );
  }

  final ProductWeekdayWindow? monday;

  final ProductWeekdayWindow? tuesday;

  final ProductWeekdayWindow? wednesday;

  final ProductWeekdayWindow? thursday;

  final ProductWeekdayWindow? friday;

  final ProductWeekdayWindow? saturday;

  final ProductWeekdayWindow? sunday;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
      };
}

/// When the product is on sale. `type` is `schedule_type` (`date_range` or
/// `custom_schedule`), `preset` is `custom_schedule_option` (`all_days`,
/// `weekdays`, `business_hour`, `weekends` or `custom`).
class ProductSchedule extends Dto {
  const ProductSchedule({
    this.enabled,
    this.type,
    this.startDate,
    this.endDate,
    this.preset,
    this.weekdays,
  });

  /// Reads `schedule`.
  static ProductSchedule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductSchedule(
      enabled: readFlag(source['enabled']),
      type: readText(source['type']),
      startDate: readText(source['start_date']),
      endDate: readText(source['end_date']),
      preset: readText(source['preset']),
      weekdays: ProductScheduleWeekdays.fromMap(source['weekdays']),
    );
  }

  final bool? enabled;

  final String? type;

  final String? startDate;

  final String? endDate;

  final String? preset;

  final ProductScheduleWeekdays? weekdays;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'type': type,
        'start_date': startDate,
        'end_date': endDate,
        'preset': preset,
        'weekdays': weekdays,
      };
}

/// `password_protected` and `password` again; a set password reads `***`.
class ProductPasswordProtection extends Dto {
  const ProductPasswordProtection({this.enabled, this.password});

  /// Reads `password_protection`.
  static ProductPasswordProtection? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPasswordProtection(
      enabled: readFlag(source['enabled']),
      password: readText(source['password']),
    );
  }

  final bool? enabled;

  final String? password;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'password': password,
      };
}

/// Availability in one block: `enabled` is `available`, `active` is
/// `administrative_status`, `who_can_view` is `available_for`.
/// `restrict_for_selected_customers` is read-only.
class ProductAvailableForPurchase extends Dto {
  const ProductAvailableForPurchase({
    this.enabled,
    this.active,
    this.whoCanView,
    this.selectedCustomers,
    this.restrictForSelectedCustomers,
    this.schedule,
    this.passwordProtection,
  });

  /// Reads `available_for_purchase`.
  static ProductAvailableForPurchase? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductAvailableForPurchase(
      enabled: readFlag(source['enabled']),
      active: readFlag(source['active']),
      whoCanView: readText(source['who_can_view']),
      selectedCustomers:
          ProductSelectedCustomers.fromMap(source['selected_customers']),
      restrictForSelectedCustomers: ProductSelectedCustomers.fromMap(
          source['restrict_for_selected_customers']),
      schedule: ProductSchedule.fromMap(source['schedule']),
      passwordProtection:
          ProductPasswordProtection.fromMap(source['password_protection']),
    );
  }

  final bool? enabled;

  final bool? active;

  final String? whoCanView;

  final ProductSelectedCustomers? selectedCustomers;

  final ProductSelectedCustomers? restrictForSelectedCustomers;

  final ProductSchedule? schedule;

  final ProductPasswordProtection? passwordProtection;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'active': active,
        'who_can_view': whoCanView,
        'selected_customers': selectedCustomers,
        'restrict_for_selected_customers': restrictForSelectedCustomers,
        'schedule': schedule,
        'password_protection': passwordProtection,
      };
}

/// The availability block to write. While `enabled` is `false` the store
/// answers `200` and keeps none of `who_can_view`, `schedule` or
/// `password_protection`.
class ProductAvailableForPurchaseInput extends Dto {
  const ProductAvailableForPurchaseInput({
    this.enabled,
    this.active,
    this.whoCanView,
    this.selectedCustomers,
    this.schedule,
    this.passwordProtection,
  });

  final bool? enabled;

  final bool? active;

  final String? whoCanView;

  final ProductSelectedCustomersInput? selectedCustomers;

  final ProductSchedule? schedule;

  final ProductPasswordProtection? passwordProtection;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'active': active,
        'who_can_view': whoCanView,
        'selected_customers': selectedCustomers,
        'schedule': schedule,
        'password_protection': passwordProtection,
      };
}

/// The sale price; `amount_type` is `on_sale_price_type`.
class ProductOnSale extends Dto {
  const ProductOnSale({this.enabled, this.discountedPrice, this.amountType});

  /// Reads `pricing.on_sale`.
  static ProductOnSale? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductOnSale(
      enabled: readFlag(source['enabled']),
      discountedPrice: readDecimal(source['discounted_price']),
      amountType: readText(source['amount_type']),
    );
  }

  final bool? enabled;

  final double? discountedPrice;

  final String? amountType;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'discounted_price': discountedPrice,
        'amount_type': amountType,
      };
}

/// Order in multiples of `multiple_of`.
class ProductQuantityMultiple extends Dto {
  const ProductQuantityMultiple({this.enabled, this.multipleOf});

  /// Reads `quantity_multiple`.
  static ProductQuantityMultiple? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductQuantityMultiple(
      enabled: readFlag(source['enabled']),
      multipleOf: readInteger(source['multiple_of']),
    );
  }

  final bool? enabled;

  final int? multipleOf;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'multiple_of': multipleOf,
      };
}

/// The expect-to-pay price.
class ProductExpectToPay extends Dto {
  const ProductExpectToPay({this.enabled, this.price});

  /// Reads `expect_to_pay`.
  static ProductExpectToPay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductExpectToPay(
      enabled: readFlag(source['enabled']),
      price: readDecimal(source['price']),
    );
  }

  final bool? enabled;

  final double? price;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'price': price,
      };
}

/// The advanced pricing switches.
class ProductAdvancedPricing extends Dto {
  const ProductAdvancedPricing({
    this.enabled,
    this.quantityMultiple,
    this.expectToPay,
    this.callForPrice,
  });

  /// Reads `pricing.advanced_pricing`.
  static ProductAdvancedPricing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductAdvancedPricing(
      enabled: readFlag(source['enabled']),
      quantityMultiple:
          ProductQuantityMultiple.fromMap(source['quantity_multiple']),
      expectToPay: ProductExpectToPay.fromMap(source['expect_to_pay']),
      callForPrice: readFlag(source['call_for_price']),
    );
  }

  final bool? enabled;

  final ProductQuantityMultiple? quantityMultiple;

  final ProductExpectToPay? expectToPay;

  final bool? callForPrice;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'quantity_multiple': quantityMultiple,
        'expect_to_pay': expectToPay,
        'call_for_price': callForPrice,
      };
}

/// Prices in one block; `rrp_price` is `compare_at_price`. On a create
/// `base_price` here stands in for the top-level one.
class ProductPricing extends Dto {
  const ProductPricing({
    this.basePrice,
    this.costPrice,
    this.rrpPrice,
    this.onSale,
    this.advancedPricing,
  });

  /// Reads `pricing`.
  static ProductPricing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPricing(
      basePrice: readDecimal(source['base_price']),
      costPrice: readDecimal(source['cost_price']),
      rrpPrice: readDecimal(source['rrp_price']),
      onSale: ProductOnSale.fromMap(source['on_sale']),
      advancedPricing:
          ProductAdvancedPricing.fromMap(source['advanced_pricing']),
    );
  }

  final double? basePrice;

  final double? costPrice;

  final double? rrpPrice;

  final ProductOnSale? onSale;

  final ProductAdvancedPricing? advancedPricing;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'base_price': basePrice,
        'cost_price': costPrice,
        'rrp_price': rrpPrice,
        'on_sale': onSale,
        'advanced_pricing': advancedPricing,
      };
}

/// Stock tracking; `suppliers` echoes the ids written.
class ProductInventoryTracking extends Dto {
  const ProductInventoryTracking({
    this.enabled,
    this.availableStock,
    this.lowStockLevel,
    this.suppliers,
  });

  /// Reads `inventory.tracking`.
  static ProductInventoryTracking? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductInventoryTracking(
      enabled: readFlag(source['enabled']),
      availableStock: readInteger(source['available_stock']),
      lowStockLevel: readInteger(source['low_stock_level']),
      suppliers: readList<Object>(source['suppliers'], readAny),
    );
  }

  final bool? enabled;

  final int? availableStock;

  final int? lowStockLevel;

  final List<Object?>? suppliers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'available_stock': availableStock,
        'low_stock_level': lowStockLevel,
        'suppliers': suppliers,
      };
}

/// The combined stock selling limit.
class ProductCombinedStockLimit extends Dto {
  const ProductCombinedStockLimit({this.enabled, this.units});

  /// Reads `inventory.combined_stock_limit`.
  static ProductCombinedStockLimit? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCombinedStockLimit(
      enabled: readFlag(source['enabled']),
      units: readInteger(source['units']),
    );
  }

  final bool? enabled;

  final int? units;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'units': units,
      };
}

/// Stock in one block; `preorder` is `preorder_enabled`. Not
/// `ProductInventory`, which the ecommerce settings export.
class ProductInventoryBlock extends Dto {
  const ProductInventoryBlock(
      {this.tracking, this.combinedStockLimit, this.preorder});

  /// Reads `inventory`.
  static ProductInventoryBlock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductInventoryBlock(
      tracking: ProductInventoryTracking.fromMap(source['tracking']),
      combinedStockLimit:
          ProductCombinedStockLimit.fromMap(source['combined_stock_limit']),
      preorder: readFlag(source['preorder']),
    );
  }

  final ProductInventoryTracking? tracking;

  final ProductCombinedStockLimit? combinedStockLimit;

  final bool? preorder;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tracking': tracking,
        'combined_stock_limit': combinedStockLimit,
        'preorder': preorder,
      };
}

/// The order quantity limits; a `max_quantity` of `0` is no maximum.
class ProductOrdering extends Dto {
  const ProductOrdering({this.minQuantity, this.maxQuantity});

  /// Reads `ordering`.
  static ProductOrdering? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductOrdering(
      minQuantity: readInteger(source['min_quantity']),
      maxQuantity: readInteger(source['max_quantity']),
    );
  }

  final int? minQuantity;

  final int? maxQuantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'min_quantity': minQuantity,
        'max_quantity': maxQuantity,
      };
}

/// A price or purchase restriction. Only `mode` is written; `enabled` is read-
/// only and `customers` is answered `200` but kept empty.
class ProductPriceRestriction extends Dto {
  const ProductPriceRestriction({this.enabled, this.mode, this.customers});

  /// Reads `restrictions.price` or `restrictions.purchase`.
  static ProductPriceRestriction? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPriceRestriction(
      enabled: readFlag(source['enabled']),
      mode: readText(source['mode']),
      customers: readList<Object>(source['customers'], readAny),
    );
  }

  final bool? enabled;

  final String? mode;

  final List<Object?>? customers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'mode': mode,
        'customers': customers,
      };
}

/// `restrict_price_for` and `restrict_purchase_for` in one block; `enabled` and
/// `display_only` are read-only.
class ProductRestrictions extends Dto {
  const ProductRestrictions({
    this.enabled,
    this.price,
    this.purchase,
    this.displayOnly,
  });

  /// Reads `restrictions`.
  static ProductRestrictions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductRestrictions(
      enabled: readFlag(source['enabled']),
      price: ProductPriceRestriction.fromMap(source['price']),
      purchase: ProductPriceRestriction.fromMap(source['purchase']),
      displayOnly: readFlag(source['display_only']),
    );
  }

  final bool? enabled;

  final ProductPriceRestriction? price;

  final ProductPriceRestriction? purchase;

  final bool? displayOnly;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'price': price,
        'purchase': purchase,
        'display_only': displayOnly,
      };
}

/// Whether `base_price` includes tax, and how it is rounded.
class ProductPriceIncludesTax extends Dto {
  const ProductPriceIncludesTax({this.enabled, this.basePriceRounding});

  /// Reads `tax.price_includes_tax`.
  static ProductPriceIncludesTax? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPriceIncludesTax(
      enabled: readFlag(source['enabled']),
      basePriceRounding: readText(source['base_price_rounding']),
    );
  }

  final bool? enabled;

  final String? basePriceRounding;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'base_price_rounding': basePriceRounding,
      };
}

/// `tax_settings` in one block; `enabled` is `overwrite_default_config`. A
/// write takes `custom_tax_profile` as an id or `{"id": ...}` of a custom tax
/// profile.
class ProductTax extends Dto {
  const ProductTax({
    this.enabled,
    this.exempt,
    this.customTaxProfile,
    this.message,
    this.showPriceWithTax,
    this.priceIncludesTax,
  });

  /// Reads `tax`.
  static ProductTax? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductTax(
      enabled: readFlag(source['enabled']),
      exempt: readFlag(source['exempt']),
      customTaxProfile:
          ProductNamedReference.fromMap(source['custom_tax_profile']),
      message: readText(source['message']),
      showPriceWithTax: readFlag(source['show_price_with_tax']),
      priceIncludesTax:
          ProductPriceIncludesTax.fromMap(source['price_includes_tax']),
    );
  }

  final bool? enabled;

  final bool? exempt;

  final ProductNamedReference? customTaxProfile;

  final String? message;

  final bool? showPriceWithTax;

  final ProductPriceIncludesTax? priceIncludesTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'exempt': exempt,
        'custom_tax_profile': customTaxProfile,
        'message': message,
        'show_price_with_tax': showPriceWithTax,
        'price_includes_tax': priceIncludesTax,
      };
}

/// The shipping profile; `enabled` is read-only and true while a profile is
/// set. A create drops `profile`; an update takes it as an id or `{"id": ...}`.
class ProductShipping extends Dto {
  const ProductShipping({this.enabled, this.profile});

  /// Reads `shipping`.
  static ProductShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductShipping(
      enabled: readFlag(source['enabled']),
      profile: ProductNamedReference.fromMap(source['profile']),
    );
  }

  final bool? enabled;

  final ProductNamedReference? profile;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'profile': profile,
      };
}

/// API paths of the product and its sub-paths, read-only.
class ProductLinks extends Dto {
  const ProductLinks({
    this.self,
    this.variations,
    this.stock,
    this.reviews,
  });

  /// Reads `links`.
  static ProductLinks? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductLinks(
      self: readText(source['self']),
      variations: readText(source['variations']),
      stock: readText(source['stock']),
      reviews: readText(source['reviews']),
    );
  }

  final String? self;

  final String? variations;

  final String? stock;

  final String? reviews;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'self': self,
        'variations': variations,
        'stock': stock,
        'reviews': reviews,
      };
}

/// A flag and the label shown with it.
class ProductFlag extends Dto {
  const ProductFlag({this.enabled, this.label});

  /// Reads `featured` or `sold_out`.
  static ProductFlag? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductFlag(
      enabled: readFlag(source['enabled']),
      label: readText(source['label']),
    );
  }

  final bool? enabled;

  final String? label;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'label': label,
      };
}

/// The flags in blocks: `is_featured`, `is_new`, `sold_out` and `model` again.
/// `sold_out` is read-only.
class ProductFlags extends Dto {
  const ProductFlags({
    this.featured,
    this.newProduct,
    this.soldOut,
    this.modelNumber,
  });

  /// Reads `product_flags`.
  static ProductFlags? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductFlags(
      featured: ProductFlag.fromMap(source['featured']),
      newProduct: readFlag(source['new_product']),
      soldOut: ProductFlag.fromMap(source['sold_out']),
      modelNumber: readText(source['model_number']),
    );
  }

  final ProductFlag? featured;

  final bool? newProduct;

  final ProductFlag? soldOut;

  final String? modelNumber;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'featured': featured,
        'new_product': newProduct,
        'sold_out': soldOut,
        'model_number': modelNumber,
      };
}

/// `product_properties` again; the two units are read-only here.
class ProductDimension extends Dto {
  const ProductDimension({
    this.lengthUnit,
    this.weightUnit,
    this.width,
    this.height,
    this.length,
    this.weight,
  });

  /// Reads `product_dimension`.
  static ProductDimension? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductDimension(
      lengthUnit: readText(source['length_unit']),
      weightUnit: readText(source['weight_unit']),
      width: readDecimal(source['width']),
      height: readDecimal(source['height']),
      length: readDecimal(source['length']),
      weight: readDecimal(source['weight']),
    );
  }

  final String? lengthUnit;

  final String? weightUnit;

  final double? width;

  final double? height;

  final double? length;

  final double? weight;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'length_unit': lengthUnit,
        'weight_unit': weightUnit,
        'width': width,
        'height': height,
        'length': length,
        'weight': weight,
      };
}

/// `advance_information` again: a write here changes it there, `condition`
/// being its `product_condition`.
class ProductIdentifiers extends Dto {
  const ProductIdentifiers({
    this.enabled,
    this.gtin,
    this.condition,
    this.barcode,
    this.hsCode,
    this.countryOfOrigin,
    this.mpn,
    this.upc,
  });

  /// Reads `product_identifiers`.
  static ProductIdentifiers? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductIdentifiers(
      enabled: readFlag(source['enabled']),
      gtin: readText(source['gtin']),
      condition: readText(source['condition']),
      barcode: readText(source['barcode']),
      hsCode: readText(source['hs_code']),
      countryOfOrigin: readText(source['country_of_origin']),
      mpn: readText(source['mpn']),
      upc: readText(source['upc']),
    );
  }

  final bool? enabled;

  final String? gtin;

  final String? condition;

  final String? barcode;

  final String? hsCode;

  final String? countryOfOrigin;

  final String? mpn;

  final String? upc;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'gtin': gtin,
        'condition': condition,
        'barcode': barcode,
        'hs_code': hsCode,
        'country_of_origin': countryOfOrigin,
        'mpn': mpn,
        'upc': upc,
      };
}

/// `webtool_disable_tracking` again, read-only.
class ProductWebtool extends Dto {
  const ProductWebtool({this.disableTracking});

  /// Reads `webtool`.
  static ProductWebtool? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductWebtool(
      disableTracking: readFlag(source['disable_tracking']),
    );
  }

  final bool? disableTracking;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'disable_tracking': disableTracking,
      };
}

/// Who wrote a review; `name` and `email` again.
class ProductReviewer extends Dto {
  const ProductReviewer({this.name, this.email});

  /// Reads `reviewer`.
  static ProductReviewer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductReviewer(
      name: readText(source['name']),
      email: readText(source['email']),
    );
  }

  final String? name;

  final String? email;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'email': email,
      };
}

/// One customer an audience names: `id` is the customer's `customer_id`,
/// `internal_id` its `internal_id`.
class ProductSelectedCustomer extends Dto {
  const ProductSelectedCustomer({this.id, this.internalId, this.name});

  /// Reads one entry of `customers`.
  static ProductSelectedCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductSelectedCustomer(
      id: readInteger(source['id']),
      internalId: readInteger(source['internal_id']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final int? internalId;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'internal_id': internalId,
        'name': name,
      };
}

/// An audience to write: customer and group ids. A group written as `{"id":
/// ...}` is `400`.
class ProductSelectedCustomersInput extends Dto {
  const ProductSelectedCustomersInput({this.customers, this.groups});

  final List<int?>? customers;

  final List<int?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// The five-key `pagination` block; `limit` is the page size applied.
class ProductPagination extends Dto {
  const ProductPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static ProductPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

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

/// One page of the listing: full product records, where they sit and any
/// schema.
class ProductListPage extends Dto {
  const ProductListPage({this.products, this.pagination, this.fieldMetadata});

  /// Reads a listing body.
  static ProductListPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListPage(
      products: readList<Product>(source['products'], Product.fromMap),
      pagination: ProductPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<Product?>? products;

  final ProductPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'products': products,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// One product: the row read's body and every write's answer, 87 fields.
/// `field_metadata` sits beside `product` when the read asks for it.
class Product extends Dto {
  const Product({
    this.id,
    this.name,
    this.sku,
    this.status,
    this.urls,
    this.heading,
    this.parents,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.transactionNo,
    this.productType,
    this.customType,
    this.isVirtual,
    this.invoiceNote,
    this.available,
    this.productPage,
    this.productLayout,
    this.customClass,
    this.availableOnDateRange,
    this.availableFromDate,
    this.availableToDate,
    this.availableFor,
    this.selectedCustomers,
    this.restrictForSelectedCustomers,
    this.passwordProtected,
    this.password,
    this.availableOnWeekdays,
    this.basePrice,
    this.costPrice,
    this.compareAtPrice,
    this.isOnSale,
    this.salePrice,
    this.soldOut,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.soldOutLabel,
    this.isFeatured,
    this.featuredLabel,
    this.isNew,
    this.featured,
    this.newFlag,
    this.model,
    this.productProperties,
    this.version,
    this.createdOn,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.scheduleType,
    this.customScheduleOption,
    this.taxSettings,
    this.variationPriceDisplay,
    this.administrativeStatus,
    this.isDraft,
    this.productSummary,
    this.productDescription,
    this.productPricingAndStock,
    this.imageAndVideo,
    this.advanced,
    this.relatedProducts,
    this.similarProducts,
    this.bundle,
    this.seoConfigs,
    this.tags,
    this.customProperties,
    this.reviews,
    this.productVariation,
    this.preorderEnabled,
    this.hasVariations,
    this.productUrl,
    this.updatedBy,
    this.virtual,
    this.summary,
    this.description,
    this.categories,
    this.upSellProducts,
    this.media,
    this.availableForPurchase,
    this.pricing,
    this.inventory,
    this.ordering,
    this.restrictions,
    this.tax,
    this.shipping,
    this.links,
    this.fieldMetadata,
  });

  /// Reads the row path's `product` envelope, with the `field_metadata` beside
  /// it.
  static Product? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product');
    if (source == null) return null;
    return Product(
      id: readInteger(source['id']),
      name: readText(source['name']),
      sku: readText(source['sku']),
      status: readText(source['status']),
      urls: ProductStorefrontUrls.fromMap(source['urls']),
      heading: readText(source['heading']),
      parents:
          readList<ProductParent>(source['parents'], ProductParent.fromMap),
      createdBy: ProductNamedReference.fromMap(source['created_by']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
      transactionNo: readText(source['transaction_no']),
      productType: readText(source['product_type']),
      customType: readText(source['custom_type']),
      isVirtual: readFlag(source['is_virtual']),
      invoiceNote: readText(source['invoice_note']),
      available: readFlag(source['available']),
      productPage: ProductNamedReference.fromMap(source['product_page']),
      productLayout: readAny(source['product_layout']),
      customClass: readText(source['custom_class']),
      availableOnDateRange: readFlag(source['available_on_date_range']),
      availableFromDate: readText(source['available_from_date']),
      availableToDate: readText(source['available_to_date']),
      availableFor: readText(source['available_for']),
      selectedCustomers:
          ProductSelectedCustomers.fromMap(source['selected_customers']),
      restrictForSelectedCustomers: ProductSelectedCustomers.fromMap(
          source['restrict_for_selected_customers']),
      passwordProtected: readFlag(source['password_protected']),
      password: readText(source['password']),
      availableOnWeekdays:
          ProductAvailableOnWeekdays.fromMap(source['available_on_weekdays']),
      basePrice: readDecimal(source['base_price']),
      costPrice: readDecimal(source['cost_price']),
      compareAtPrice: readDecimal(source['compare_at_price']),
      isOnSale: readFlag(source['is_on_sale']),
      salePrice: readDecimal(source['sale_price']),
      soldOut: readFlag(source['sold_out']),
      length: readDecimal(source['length']),
      width: readDecimal(source['width']),
      height: readDecimal(source['height']),
      weight: readDecimal(source['weight']),
      soldOutLabel: readText(source['sold_out_label']),
      isFeatured: readFlag(source['is_featured']),
      featuredLabel: readText(source['featured_label']),
      isNew: readFlag(source['is_new']),
      featured: readFlag(source['featured']),
      newFlag: readFlag(source['new']),
      model: readText(source['model']),
      productProperties:
          ProductProperties.fromMap(source['product_properties']),
      version: readInteger(source['version']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      lastUpdatedBy: ProductNamedReference.fromMap(source['last_updated_by']),
      scheduleType: readText(source['schedule_type']),
      customScheduleOption: readText(source['custom_schedule_option']),
      taxSettings: ProductTaxSettings.fromMap(source['tax_settings']),
      variationPriceDisplay: ProductVariationPriceDisplay.fromMap(
          source['variation_price_display']),
      administrativeStatus: readFlag(source['administrative_status']),
      isDraft: readFlag(source['is_draft']),
      productSummary: readText(source['product_summary']),
      productDescription: readText(source['product_description']),
      productPricingAndStock:
          ProductPricingAndStock.fromMap(source['product_pricing_and_stock']),
      imageAndVideo: ProductImageAndVideo.fromMap(source['image_and_video']),
      advanced: ProductAdvanced.fromMap(source['advanced']),
      relatedProducts: readList<ProductLink>(
          source['related_products'], ProductLink.fromMap),
      similarProducts: readList<ProductLink>(
          source['similar_products'], ProductLink.fromMap),
      bundle: ProductBundle.fromMap(source['bundle']),
      seoConfigs: readList<ProductSeoConfig>(
          source['seo_configs'], ProductSeoConfig.fromMap),
      tags: readList<ProductTag>(source['tags'], ProductTag.fromMap),
      customProperties: readList<ProductCustomProperty>(
          source['custom_properties'], ProductCustomProperty.fromMap),
      reviews:
          readList<ProductReview>(source['reviews'], ProductReview.fromMap),
      productVariation: ProductVariation.fromMap(source['product_variation']),
      preorderEnabled: readFlag(source['preorder_enabled']),
      hasVariations: readFlag(source['has_variations']),
      productUrl: readText(source['product_url']),
      updatedBy: ProductNamedReference.fromMap(source['updated_by']),
      virtual: readFlag(source['virtual']),
      summary: readText(source['summary']),
      description: readText(source['description']),
      categories: readList<ProductCategory>(
          source['categories'], ProductCategory.fromMap),
      upSellProducts: readList<ProductLink>(
          source['up_sell_products'], ProductLink.fromMap),
      media: ProductMedia.fromMap(source['media']),
      availableForPurchase:
          ProductAvailableForPurchase.fromMap(source['available_for_purchase']),
      pricing: ProductPricing.fromMap(source['pricing']),
      inventory: ProductInventoryBlock.fromMap(source['inventory']),
      ordering: ProductOrdering.fromMap(source['ordering']),
      restrictions: ProductRestrictions.fromMap(source['restrictions']),
      tax: ProductTax.fromMap(source['tax']),
      shipping: ProductShipping.fromMap(source['shipping']),
      links: ProductLinks.fromMap(source['links']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `id` — what a `{product_id}` slot takes.
  final int? id;

  final String? name;

  final String? sku;

  /// `status` — read-only; a write naming it is `400 unknown_field`.
  final String? status;

  final ProductStorefrontUrls? urls;

  final String? heading;

  final List<ProductParent?>? parents;

  final ProductNamedReference? createdBy;

  final String? createdAt;

  final String? updatedAt;

  final String? transactionNo;

  final String? productType;

  final String? customType;

  final bool? isVirtual;

  final String? invoiceNote;

  final bool? available;

  final ProductNamedReference? productPage;

  /// `product_layout` — `{}` on every product read, so untyped.
  final Object? productLayout;

  final String? customClass;

  final bool? availableOnDateRange;

  final String? availableFromDate;

  final String? availableToDate;

  final String? availableFor;

  final ProductSelectedCustomers? selectedCustomers;

  final ProductSelectedCustomers? restrictForSelectedCustomers;

  final bool? passwordProtected;

  /// `password` — `***` when one is set, `""` otherwise.
  final String? password;

  final ProductAvailableOnWeekdays? availableOnWeekdays;

  final double? basePrice;

  final double? costPrice;

  final double? compareAtPrice;

  final bool? isOnSale;

  final double? salePrice;

  final bool? soldOut;

  final double? length;

  final double? width;

  final double? height;

  final double? weight;

  final String? soldOutLabel;

  final bool? isFeatured;

  final String? featuredLabel;

  final bool? isNew;

  final bool? featured;

  /// `new` on the wire, renamed because `new` is a Dart keyword; read-only.
  final bool? newFlag;

  final String? model;

  final ProductProperties? productProperties;

  final int? version;

  final String? createdOn;

  final String? lastUpdatedOn;

  final ProductNamedReference? lastUpdatedBy;

  final String? scheduleType;

  final String? customScheduleOption;

  final ProductTaxSettings? taxSettings;

  final ProductVariationPriceDisplay? variationPriceDisplay;

  final bool? administrativeStatus;

  final bool? isDraft;

  final String? productSummary;

  final String? productDescription;

  final ProductPricingAndStock? productPricingAndStock;

  final ProductImageAndVideo? imageAndVideo;

  final ProductAdvanced? advanced;

  final List<ProductLink?>? relatedProducts;

  final List<ProductLink?>? similarProducts;

  /// `bundle` — `null` on a product that is not a bundle.
  final ProductBundle? bundle;

  final List<ProductSeoConfig?>? seoConfigs;

  final List<ProductTag?>? tags;

  final List<ProductCustomProperty?>? customProperties;

  final List<ProductReview?>? reviews;

  final ProductVariation? productVariation;

  final bool? preorderEnabled;

  final bool? hasVariations;

  final String? productUrl;

  final ProductNamedReference? updatedBy;

  final bool? virtual;

  final String? summary;

  final String? description;

  final List<ProductCategory?>? categories;

  final List<ProductLink?>? upSellProducts;

  final ProductMedia? media;

  final ProductAvailableForPurchase? availableForPurchase;

  final ProductPricing? pricing;

  final ProductInventoryBlock? inventory;

  final ProductOrdering? ordering;

  final ProductRestrictions? restrictions;

  final ProductTax? tax;

  final ProductShipping? shipping;

  final ProductLinks? links;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'product';

  @override
  Set<String> get topLevelFields => const <String>{'field_metadata'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'sku': sku,
        'status': status,
        'urls': urls,
        'heading': heading,
        'parents': parents,
        'created_by': createdBy,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'transaction_no': transactionNo,
        'product_type': productType,
        'custom_type': customType,
        'is_virtual': isVirtual,
        'invoice_note': invoiceNote,
        'available': available,
        'product_page': productPage,
        'product_layout': productLayout,
        'custom_class': customClass,
        'available_on_date_range': availableOnDateRange,
        'available_from_date': availableFromDate,
        'available_to_date': availableToDate,
        'available_for': availableFor,
        'selected_customers': selectedCustomers,
        'restrict_for_selected_customers': restrictForSelectedCustomers,
        'password_protected': passwordProtected,
        'password': password,
        'available_on_weekdays': availableOnWeekdays,
        'base_price': basePrice,
        'cost_price': costPrice,
        'compare_at_price': compareAtPrice,
        'is_on_sale': isOnSale,
        'sale_price': salePrice,
        'sold_out': soldOut,
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
        'sold_out_label': soldOutLabel,
        'is_featured': isFeatured,
        'featured_label': featuredLabel,
        'is_new': isNew,
        'featured': featured,
        'new': newFlag,
        'model': model,
        'product_properties': productProperties,
        'version': version,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'last_updated_by': lastUpdatedBy,
        'schedule_type': scheduleType,
        'custom_schedule_option': customScheduleOption,
        'tax_settings': taxSettings,
        'variation_price_display': variationPriceDisplay,
        'administrative_status': administrativeStatus,
        'is_draft': isDraft,
        'product_summary': productSummary,
        'product_description': productDescription,
        'product_pricing_and_stock': productPricingAndStock,
        'image_and_video': imageAndVideo,
        'advanced': advanced,
        'related_products': relatedProducts,
        'similar_products': similarProducts,
        'bundle': bundle,
        'seo_configs': seoConfigs,
        'tags': tags,
        'custom_properties': customProperties,
        'reviews': reviews,
        'product_variation': productVariation,
        'preorder_enabled': preorderEnabled,
        'has_variations': hasVariations,
        'product_url': productUrl,
        'updated_by': updatedBy,
        'virtual': virtual,
        'summary': summary,
        'description': description,
        'categories': categories,
        'up_sell_products': upSellProducts,
        'media': media,
        'available_for_purchase': availableForPurchase,
        'pricing': pricing,
        'inventory': inventory,
        'ordering': ordering,
        'restrictions': restrictions,
        'tax': tax,
        'shipping': shipping,
        'links': links,
        'field_metadata': fieldMetadata,
      };
}

/// The create's, `PUT`'s and `PATCH`'s bare record; an update merges it at
/// every level, and a `PUT` also needs the ten fields `updateProduct` lists. A
/// changed read-only field is `400 read_only_field`; `product_url`, `links` and
/// `restrict_for_selected_customers` are read-only, and `updated_by` is
/// answered `200` and ignored.
class ProductInput extends Dto {
  const ProductInput({
    this.name,
    this.sku,
    this.transactionNo,
    this.heading,
    this.productType,
    this.customType,
    this.isVirtual,
    this.invoiceNote,
    this.available,
    this.availableOnDateRange,
    this.availableFromDate,
    this.availableToDate,
    this.availableFor,
    this.selectedCustomers,
    this.passwordProtected,
    this.password,
    this.availableOnWeekdays,
    this.basePrice,
    this.costPrice,
    this.compareAtPrice,
    this.isOnSale,
    this.salePrice,
    this.isFeatured,
    this.featuredLabel,
    this.isNew,
    this.productProperties,
    this.scheduleType,
    this.customScheduleOption,
    this.taxSettings,
    this.variationPriceDisplay,
    this.administrativeStatus,
    this.productSummary,
    this.productDescription,
    this.productPricingAndStock,
    this.imageAndVideo,
    this.advanced,
    this.parents,
    this.relatedProducts,
    this.similarProducts,
    this.tags,
    this.preorderEnabled,
    this.virtual,
    this.summary,
    this.description,
    this.categories,
    this.upSellProducts,
    this.media,
    this.availableForPurchase,
    this.pricing,
    this.inventory,
    this.ordering,
    this.restrictions,
    this.tax,
    this.shipping,
  });

  final String? name;

  final String? sku;

  /// `transaction_no` — stored on a create; an update stores it only on a
  /// product without one, else drops it.
  final String? transactionNo;

  final String? heading;

  final String? productType;

  final String? customType;

  final bool? isVirtual;

  final String? invoiceNote;

  final bool? available;

  final bool? availableOnDateRange;

  final String? availableFromDate;

  final String? availableToDate;

  final String? availableFor;

  final ProductSelectedCustomersInput? selectedCustomers;

  final bool? passwordProtected;

  final String? password;

  final ProductAvailableOnWeekdays? availableOnWeekdays;

  final double? basePrice;

  final double? costPrice;

  final double? compareAtPrice;

  final bool? isOnSale;

  final double? salePrice;

  final bool? isFeatured;

  final String? featuredLabel;

  final bool? isNew;

  final ProductProperties? productProperties;

  final String? scheduleType;

  final String? customScheduleOption;

  final ProductTaxSettings? taxSettings;

  final ProductVariationPriceDisplay? variationPriceDisplay;

  final bool? administrativeStatus;

  final String? productSummary;

  final String? productDescription;

  final ProductPricingAndStock? productPricingAndStock;

  final ProductImageAndVideo? imageAndVideo;

  final ProductAdvanced? advanced;

  /// `parents` — category ids.
  final List<int?>? parents;

  final List<Object?>? relatedProducts;

  final List<Object?>? similarProducts;

  final List<Object?>? tags;

  final bool? preorderEnabled;

  final bool? virtual;

  final String? summary;

  final String? description;

  /// `categories` — category ids or `{"id": ...}` records; `[]` is answered
  /// `200` and changes nothing.
  final List<int?>? categories;

  final List<ProductLink?>? upSellProducts;

  final ProductMedia? media;

  final ProductAvailableForPurchaseInput? availableForPurchase;

  final ProductPricing? pricing;

  final ProductInventoryBlock? inventory;

  final ProductOrdering? ordering;

  final ProductRestrictions? restrictions;

  final ProductTax? tax;

  final ProductShipping? shipping;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'sku': sku,
        'transaction_no': transactionNo,
        'heading': heading,
        'product_type': productType,
        'custom_type': customType,
        'is_virtual': isVirtual,
        'invoice_note': invoiceNote,
        'available': available,
        'available_on_date_range': availableOnDateRange,
        'available_from_date': availableFromDate,
        'available_to_date': availableToDate,
        'available_for': availableFor,
        'selected_customers': selectedCustomers,
        'password_protected': passwordProtected,
        'password': password,
        'available_on_weekdays': availableOnWeekdays,
        'base_price': basePrice,
        'cost_price': costPrice,
        'compare_at_price': compareAtPrice,
        'is_on_sale': isOnSale,
        'sale_price': salePrice,
        'is_featured': isFeatured,
        'featured_label': featuredLabel,
        'is_new': isNew,
        'product_properties': productProperties,
        'schedule_type': scheduleType,
        'custom_schedule_option': customScheduleOption,
        'tax_settings': taxSettings,
        'variation_price_display': variationPriceDisplay,
        'administrative_status': administrativeStatus,
        'product_summary': productSummary,
        'product_description': productDescription,
        'product_pricing_and_stock': productPricingAndStock,
        'image_and_video': imageAndVideo,
        'advanced': advanced,
        'parents': parents,
        'related_products': relatedProducts,
        'similar_products': similarProducts,
        'tags': tags,
        'preorder_enabled': preorderEnabled,
        'virtual': virtual,
        'summary': summary,
        'description': description,
        'categories': categories,
        'up_sell_products': upSellProducts,
        'media': media,
        'available_for_purchase': availableForPurchase,
        'pricing': pricing,
        'inventory': inventory,
        'ordering': ordering,
        'restrictions': restrictions,
        'tax': tax,
        'shipping': shipping,
      };
}

/// The review import's answer: every review the product holds, the ones just
/// added last.
class ProductReviews extends Dto {
  const ProductReviews({this.reviews});

  /// Reads the review import's `product` envelope.
  static ProductReviews? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product');
    if (source == null) return null;
    return ProductReviews(
      reviews:
          readList<ProductReview>(source['reviews'], ProductReview.fromMap),
    );
  }

  final List<ProductReview?>? reviews;

  @override
  String? get envelopeKey => 'product';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'reviews': reviews,
      };
}

/// One review to add. `name`, `email` and a `rating` of 1 to 5 are required; a
/// second review under an `email` the product already has overwrites that
/// review, keeping its `id`.
class ProductReviewInput extends Dto {
  const ProductReviewInput({
    this.name,
    this.email,
    this.rating,
    this.review,
    this.comment,
    this.status,
    this.dateCreated,
  });

  final String? name;

  final String? email;

  final double? rating;

  final String? review;

  /// `comment` — the same text as `review`, under the name the collection sends.
  final String? comment;

  final String? status;

  /// `dateCreated` — `yyyy-MM-ddTHH:mm:ss`; the read's `date` key is refused on
  /// the write.
  final String? dateCreated;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'email': email,
        'rating': rating,
        'review': review,
        'comment': comment,
        'status': status,
        'dateCreated': dateCreated,
      };
}

/// The review import's body: `{"product": {"reviews": [...]}}` with
/// `transaction_no` beside the envelope; `reviews` must not be empty.
class ProductReviewsImportInput extends Dto {
  const ProductReviewsImportInput({this.reviews, this.transactionNo});

  final List<ProductReviewInput?>? reviews;

  final String? transactionNo;

  @override
  String? get envelopeKey => 'product';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'reviews': reviews,
        'transaction_no': transactionNo,
      };
}

/// One variant's stock on a product with variations; `locations` was `[]` on
/// every one read.
class ProductStockVariation extends Dto {
  const ProductStockVariation({
    this.variationId,
    this.productId,
    this.name,
    this.sku,
    this.availableStock,
    this.locations,
  });

  /// Reads one entry of `variations`.
  static ProductStockVariation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductStockVariation(
      variationId: readInteger(source['variation_id']),
      productId: readInteger(source['product_id']),
      name: readText(source['name']),
      sku: readText(source['sku']),
      availableStock: readInteger(source['available_stock']),
      locations: readList<ProductStockLocation>(
          source['locations'], ProductStockLocation.fromMap),
    );
  }

  final int? variationId;

  final int? productId;

  final String? name;

  final String? sku;

  final int? availableStock;

  final List<ProductStockLocation?>? locations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variation_id': variationId,
        'product_id': productId,
        'name': name,
        'sku': sku,
        'available_stock': availableStock,
        'locations': locations,
      };
}

/// The stock sub-path's body, read and written. `available_stock` is the sum of
/// the rows' `stock`; `variations` is there only on a product with variations.
class ProductStock extends Dto {
  const ProductStock({
    this.status,
    this.productId,
    this.multiLocationEnabled,
    this.trackInventory,
    this.availableStock,
    this.locations,
    this.variations,
  });

  /// Reads a stock body.
  static ProductStock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductStock(
      status: readText(source['status']),
      productId: readInteger(source['product_id']),
      multiLocationEnabled: readFlag(source['multi_location_enabled']),
      trackInventory: readFlag(source['track_inventory']),
      availableStock: readInteger(source['available_stock']),
      locations: readList<ProductStockLocation>(
          source['locations'], ProductStockLocation.fromMap),
      variations: readList<ProductStockVariation>(
          source['variations'], ProductStockVariation.fromMap),
    );
  }

  final String? status;

  final int? productId;

  final bool? multiLocationEnabled;

  final bool? trackInventory;

  final int? availableStock;

  final List<ProductStockLocation?>? locations;

  final List<ProductStockVariation?>? variations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'product_id': productId,
        'multi_location_enabled': multiLocationEnabled,
        'track_inventory': trackInventory,
        'available_stock': availableStock,
        'locations': locations,
        'variations': variations,
      };
}

/// One row of the stock write. An omitted `low_stock_level` is stored `null`;
/// with no row marked `is_default`, the first row sent becomes the default.
class ProductStockLocationInput extends Dto {
  const ProductStockLocationInput({
    this.warehouse,
    this.stock,
    this.lowStockLevel,
    this.isDefault,
  });

  final int? warehouse;

  final int? stock;

  final int? lowStockLevel;

  final bool? isDefault;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'warehouse': warehouse,
        'stock': stock,
        'low_stock_level': lowStockLevel,
        'is_default': isDefault,
      };
}

/// The stock write's body: `locations` is required and replaces the product's
/// whole set, so a location left out is unassigned whatever it holds.
class ProductStockInput extends Dto {
  const ProductStockInput({this.note, this.locations});

  final String? note;

  final List<ProductStockLocationInput?>? locations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'note': note,
        'locations': locations,
      };
}
