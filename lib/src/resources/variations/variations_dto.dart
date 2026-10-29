/// Typed views over the variation type and product variant bodies.
library;

import '../../client/dto.dart';

/// An image option's stored picture; `null` on text and color options.
class VariationOptionImage extends Dto {
  const VariationOptionImage({this.url, this.fileName});

  /// Reads one option's `image`.
  static VariationOptionImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationOptionImage(
      url: readText(source['url']),
      fileName: readText(source['file_name']),
    );
  }

  /// `url` — an absolute address on the store's resource host.
  final String? url;

  /// `file_name` — the `filename` the write sent.
  final String? fileName;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'url': url,
        'file_name': fileName,
      };
}

/// One option of a type.
class VariationOption extends Dto {
  const VariationOption({
    this.id,
    this.label,
    this.value,
    this.order,
    this.isDefault,
    this.image,
  });

  /// Reads one entry of a type's `options`.
  static VariationOption? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationOption(
      id: readInteger(source['id']),
      label: readText(source['label']),
      value: readText(source['value']),
      order: readInteger(source['order']),
      isDefault: readFlag(source['default']),
      image: VariationOptionImage.fromMap(source['image']),
    );
  }

  /// `id` — what a `{variation_option_id}` slot takes.
  final int? id;

  final String? label;

  /// `value` — `null` on an image option.
  final String? value;

  final int? order;

  /// `default` on the wire, renamed because `default` is a Dart keyword. Held
  /// by one option of a type at a time.
  final bool? isDefault;

  final VariationOptionImage? image;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'label': label,
        'value': value,
        'order': order,
        'default': isDefault,
        'image': image,
      };
}

/// One variation type: a listing row, a row read and every type write's answer.
class Variation extends Dto {
  const Variation({
    this.id,
    this.name,
    this.standard,
    this.disposable,
    this.options,
    this.fieldMetadata,
  });

  /// Reads a row path's `variation` envelope, or a bare listing row.
  static Variation? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'variation');
    if (source == null) return null;
    return Variation(
      id: readInteger(source['id']),
      name: readText(source['name']),
      standard: readText(source['standard']),
      disposable: readFlag(source['disposable']),
      options:
          readList<VariationOption>(source['options'], VariationOption.fromMap),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `id` — what a `{variation_id}` slot takes.
  final int? id;

  /// `name` — trimmed, unique without regard to case.
  final String? name;

  /// `standard` — `text`, `color` or `image`, stored lower case.
  final String? standard;

  final bool? disposable;

  final List<VariationOption?>? options;

  /// `field_metadata` — the schema, beside the row when it is asked for.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'variation';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'standard': standard,
        'disposable': disposable,
        'options': options,
        'field_metadata': fieldMetadata,
      };
}

/// The listing's five-key `pagination` block.
class VariationPagination extends Dto {
  const VariationPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static VariationPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationPagination(
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

  /// `has_previous` — `false` past the end of the rows, whatever `offset` is.
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

/// One page of the listing, and the schema when `field_metadata` is asked for.
class VariationPage extends Dto {
  const VariationPage({this.variations, this.fieldMetadata, this.pagination});

  /// Reads a listing body.
  static VariationPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationPage(
      variations: readList<Variation>(source['variations'], Variation.fromMap),
      fieldMetadata: readAny(source['field_metadata']),
      pagination: VariationPagination.fromMap(source['pagination']),
    );
  }

  final List<Variation?>? variations;

  final Object? fieldMetadata;

  final VariationPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variations': variations,
        'field_metadata': fieldMetadata,
        'pagination': pagination,
      };
}

/// An image option's upload; written as `filename`, read back as `file_name`.
class VariationOptionImageInput extends Dto {
  const VariationOptionImageInput({this.base64, this.filename});

  /// `base64` — the picture's bytes, base64-encoded.
  final String? base64;

  final String? filename;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'base64': base64,
        'filename': filename,
      };
}

/// One option in a type write; an `id` names an option of this type to change.
class VariationOptionInput extends Dto {
  const VariationOptionInput({
    this.id,
    this.label,
    this.value,
    this.order,
    this.isDefault,
    this.image,
  });

  final int? id;

  final String? label;

  final String? value;

  /// `order` — 0 to 999.
  final int? order;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  final VariationOptionImageInput? image;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'label': label,
        'value': value,
        'order': order,
        'default': isDefault,
        'image': image,
      };
}

/// The type writes' body, `{"variation": {...}}`; `standard` cannot change
/// after the create.
class VariationInput extends Dto {
  const VariationInput({this.name, this.standard, this.options});

  final String? name;

  final String? standard;

  final List<VariationOptionInput?>? options;

  @override
  String? get envelopeKey => 'variation';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'standard': standard,
        'options': options,
      };
}

/// A variant's expected-price display.
class ProductVariantExpectToPay extends Dto {
  const ProductVariantExpectToPay({this.isEnabled, this.price});

  /// Reads a variant's `pricing.expect_to_pay`.
  static ProductVariantExpectToPay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantExpectToPay(
      isEnabled: readFlag(source['is_enabled']),
      price: readDecimal(source['price']),
    );
  }

  final bool? isEnabled;

  final double? price;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'is_enabled': isEnabled,
        'price': price,
      };
}

/// A variant's prices; the full bulk answer carries the first four fields.
class ProductVariantPricing extends Dto {
  const ProductVariantPricing({
    this.basePrice,
    this.costPrice,
    this.salePrice,
    this.isOnSale,
    this.saleAmountType,
    this.hidePrice,
    this.isCallForPrice,
    this.expectToPay,
    this.tieredPricing,
  });

  /// Reads a variant's `pricing`.
  static ProductVariantPricing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantPricing(
      basePrice: readDecimal(source['base_price']),
      costPrice: readDecimal(source['cost_price']),
      salePrice: readDecimal(source['sale_price']),
      isOnSale: readFlag(source['is_on_sale']),
      saleAmountType: readText(source['sale_amount_type']),
      hidePrice: readFlag(source['hide_price']),
      isCallForPrice: readFlag(source['is_call_for_price']),
      expectToPay: ProductVariantExpectToPay.fromMap(source['expect_to_pay']),
      tieredPricing: readAny(source['tiered_pricing']),
    );
  }

  /// `base_price` — net of tax on a tax-inclusive product's read; the bulk
  /// write stores and echoes the price as sent.
  final double? basePrice;

  final double? costPrice;

  final double? salePrice;

  final bool? isOnSale;

  final String? saleAmountType;

  final bool? hidePrice;

  final bool? isCallForPrice;

  final ProductVariantExpectToPay? expectToPay;

  final Object? tieredPricing;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'base_price': basePrice,
        'cost_price': costPrice,
        'sale_price': salePrice,
        'is_on_sale': isOnSale,
        'sale_amount_type': saleAmountType,
        'hide_price': hidePrice,
        'is_call_for_price': isCallForPrice,
        'expect_to_pay': expectToPay,
        'tiered_pricing': tieredPricing,
      };
}

/// A variant's stock; the full bulk answer carries the first three fields.
class ProductVariantInventory extends Dto {
  const ProductVariantInventory({
    this.isEnabled,
    this.quantity,
    this.lowStockThreshold,
    this.isSoldOut,
    this.soldOutLabel,
  });

  /// Reads a variant's `inventory`.
  static ProductVariantInventory? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantInventory(
      isEnabled: readFlag(source['is_enabled']),
      quantity: readInteger(source['quantity']),
      lowStockThreshold: readInteger(source['low_stock_threshold']),
      isSoldOut: readFlag(source['is_sold_out']),
      soldOutLabel: readText(source['sold_out_label']),
    );
  }

  final bool? isEnabled;

  /// `quantity` — what `available_stock` sets, tracking on or off.
  final int? quantity;

  final int? lowStockThreshold;

  final bool? isSoldOut;

  final String? soldOutLabel;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'is_enabled': isEnabled,
        'quantity': quantity,
        'low_stock_threshold': lowStockThreshold,
        'is_sold_out': isSoldOut,
        'sold_out_label': soldOutLabel,
      };
}

/// A variant's order quantities.
class ProductVariantOrdering extends Dto {
  const ProductVariantOrdering({
    this.minQuantity,
    this.maxQuantity,
    this.multipleOf,
    this.isMultipleQuantityRequired,
  });

  /// Reads a variant's `ordering`.
  static ProductVariantOrdering? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantOrdering(
      minQuantity: readInteger(source['min_quantity']),
      maxQuantity: readInteger(source['max_quantity']),
      multipleOf: readInteger(source['multiple_of']),
      isMultipleQuantityRequired:
          readFlag(source['is_multiple_quantity_required']),
    );
  }

  final int? minQuantity;

  /// `max_quantity` — `0` is no maximum.
  final int? maxQuantity;

  final int? multipleOf;

  final bool? isMultipleQuantityRequired;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'min_quantity': minQuantity,
        'max_quantity': maxQuantity,
        'multiple_of': multipleOf,
        'is_multiple_quantity_required': isMultipleQuantityRequired,
      };
}

/// A variant's size and weight.
class ProductVariantDimensions extends Dto {
  const ProductVariantDimensions({
    this.length,
    this.width,
    this.height,
    this.weight,
  });

  /// Reads a variant's `dimensions`.
  static ProductVariantDimensions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantDimensions(
      length: readDecimal(source['length']),
      width: readDecimal(source['width']),
      height: readDecimal(source['height']),
      weight: readDecimal(source['weight']),
    );
  }

  final double? length;

  final double? width;

  final double? height;

  final double? weight;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
      };
}

/// A variant's two badges.
class ProductVariantBadges extends Dto {
  const ProductVariantBadges({this.isFeatured, this.isNewArrival});

  /// Reads a variant's `badges`.
  static ProductVariantBadges? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantBadges(
      isFeatured: readFlag(source['is_featured']),
      isNewArrival: readFlag(source['is_new_arrival']),
    );
  }

  final bool? isFeatured;

  final bool? isNewArrival;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'is_featured': isFeatured,
        'is_new_arrival': isNewArrival,
      };
}

/// One variant of a product.
class ProductVariant extends Dto {
  const ProductVariant({
    this.variationId,
    this.available,
    this.isBase,
    this.key,
    this.name,
    this.sku,
    this.customSku,
    this.title,
    this.summary,
    this.description,
    this.barcode,
    this.countryOfOrigin,
    this.hsCode,
    this.pricing,
    this.inventory,
    this.ordering,
    this.dimensions,
    this.badges,
    this.images,
  });

  /// Reads one entry of a group's `variants`.
  static ProductVariant? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariant(
      variationId: readInteger(source['variation_id']),
      available: readFlag(source['available']),
      isBase: readFlag(source['is_base']),
      key: readText(source['key']),
      name: readText(source['name']),
      sku: readText(source['sku']),
      customSku: readText(source['custom_sku']),
      title: readText(source['title']),
      summary: readText(source['summary']),
      description: readText(source['description']),
      barcode: readText(source['barcode']),
      countryOfOrigin: readText(source['country_of_origin']),
      hsCode: readText(source['hs_code']),
      pricing: ProductVariantPricing.fromMap(source['pricing']),
      inventory: ProductVariantInventory.fromMap(source['inventory']),
      ordering: ProductVariantOrdering.fromMap(source['ordering']),
      dimensions: ProductVariantDimensions.fromMap(source['dimensions']),
      badges: ProductVariantBadges.fromMap(source['badges']),
      images: readList<Object>(source['images'], readAny),
    );
  }

  /// `variation_id` — what the bulk write's `variation_ids` names.
  final int? variationId;

  final bool? available;

  final bool? isBase;

  /// `key` — the variant's option labels joined with `/`.
  final String? key;

  final String? name;

  final String? sku;

  final String? customSku;

  final String? title;

  final String? summary;

  final String? description;

  final String? barcode;

  final String? countryOfOrigin;

  final String? hsCode;

  final ProductVariantPricing? pricing;

  final ProductVariantInventory? inventory;

  final ProductVariantOrdering? ordering;

  final ProductVariantDimensions? dimensions;

  final ProductVariantBadges? badges;

  /// `images` — `[]` on every variant read, so its entries are not typed.
  final List<Object?>? images;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variation_id': variationId,
        'available': available,
        'is_base': isBase,
        'key': key,
        'name': name,
        'sku': sku,
        'custom_sku': customSku,
        'title': title,
        'summary': summary,
        'description': description,
        'barcode': barcode,
        'country_of_origin': countryOfOrigin,
        'hs_code': hsCode,
        'pricing': pricing,
        'inventory': inventory,
        'ordering': ordering,
        'dimensions': dimensions,
        'badges': badges,
        'images': images,
      };
}

/// A product's variants, under `product_key`: its type names joined with `/`.
class ProductVariationGroup extends Dto {
  const ProductVariationGroup({this.productKey, this.variants});

  /// Reads one entry of the product read's `variations`.
  static ProductVariationGroup? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationGroup(
      productKey: readText(source['product_key']),
      variants:
          readList<ProductVariant>(source['variants'], ProductVariant.fromMap),
    );
  }

  final String? productKey;

  final List<ProductVariant?>? variants;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_key': productKey,
        'variants': variants,
      };
}

/// The product read's body; `variations` is empty for a product without
/// variants.
class ProductVariations extends Dto {
  const ProductVariations({this.variations});

  /// Reads a product read's body.
  static ProductVariations? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariations(
      variations: readList<ProductVariationGroup>(
          source['variations'], ProductVariationGroup.fromMap),
    );
  }

  final List<ProductVariationGroup?>? variations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variations': variations,
      };
}

/// One option a variant carries, in the full bulk answer.
class ProductVariantOptionReference extends Dto {
  const ProductVariantOptionReference({this.id, this.type, this.label});

  /// Reads one entry of a written variant's `options`.
  static ProductVariantOptionReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantOptionReference(
      id: readInteger(source['id']),
      type: readText(source['type']),
      label: readText(source['label']),
    );
  }

  final int? id;

  /// `type` — the option's type name.
  final String? type;

  final String? label;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'type': type,
        'label': label,
      };
}

/// One written variant: `id` and `name`, and the rest with `response=full`.
class ProductVariantUpdate extends Dto {
  const ProductVariantUpdate({
    this.id,
    this.name,
    this.sku,
    this.customSku,
    this.barcode,
    this.countryOfOrigin,
    this.hsCode,
    this.available,
    this.options,
    this.pricing,
    this.inventory,
    this.ordering,
    this.transactionNo,
    this.url,
  });

  /// Reads one entry of the bulk write's `updated`.
  static ProductVariantUpdate? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariantUpdate(
      id: readInteger(source['id']),
      name: readText(source['name']),
      sku: readText(source['sku']),
      customSku: readText(source['custom_sku']),
      barcode: readText(source['barcode']),
      countryOfOrigin: readText(source['country_of_origin']),
      hsCode: readText(source['hs_code']),
      available: readFlag(source['available']),
      options: readList<ProductVariantOptionReference>(
          source['options'], ProductVariantOptionReference.fromMap),
      pricing: ProductVariantPricing.fromMap(source['pricing']),
      inventory: ProductVariantInventory.fromMap(source['inventory']),
      ordering: ProductVariantOrdering.fromMap(source['ordering']),
      transactionNo: readText(source['transaction_no']),
      url: readText(source['url']),
    );
  }

  /// `id` — the variant's `variation_id`.
  final int? id;

  final String? name;

  final String? sku;

  /// `custom_sku` — `null` here where the product read answers `""`, as are
  /// `barcode`, `country_of_origin` and `hs_code`.
  final String? customSku;

  final String? barcode;

  final String? countryOfOrigin;

  final String? hsCode;

  final bool? available;

  final List<ProductVariantOptionReference?>? options;

  final ProductVariantPricing? pricing;

  final ProductVariantInventory? inventory;

  final ProductVariantOrdering? ordering;

  final String? transactionNo;

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'sku': sku,
        'custom_sku': customSku,
        'barcode': barcode,
        'country_of_origin': countryOfOrigin,
        'hs_code': hsCode,
        'available': available,
        'options': options,
        'pricing': pricing,
        'inventory': inventory,
        'ordering': ordering,
        'transaction_no': transactionNo,
        'url': url,
      };
}

/// The bulk write's answer; `failed` stays empty, as a refused id refuses the
/// whole write.
class ProductVariationsBulkResult extends Dto {
  const ProductVariationsBulkResult({
    this.status,
    this.message,
    this.updated,
    this.failed,
  });

  /// Reads a bulk write's body.
  static ProductVariationsBulkResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationsBulkResult(
      status: readText(source['status']),
      message: readText(source['message']),
      updated: readList<ProductVariantUpdate>(
          source['updated'], ProductVariantUpdate.fromMap),
      failed: readList<Object>(source['failed'], readAny),
    );
  }

  final String? status;

  final String? message;

  final List<ProductVariantUpdate?>? updated;

  final List<Object?>? failed;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'message': message,
        'updated': updated,
        'failed': failed,
      };
}

/// The bulk write's body, no envelope: the variant ids and at least one of the
/// six fields.
class ProductVariationsBulkInput extends Dto {
  const ProductVariationsBulkInput({
    this.variationIds,
    this.available,
    this.basePrice,
    this.costPrice,
    this.availableStock,
    this.minOrderQuantity,
    this.maxOrderQuantity,
  });

  /// `variation_ids` — variants of the product in the path; one of another
  /// product is `400` and nothing is written.
  final List<int>? variationIds;

  final bool? available;

  final double? basePrice;

  final double? costPrice;

  final int? availableStock;

  final int? minOrderQuantity;

  final int? maxOrderQuantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'variation_ids': variationIds,
        'available': available,
        'base_price': basePrice,
        'cost_price': costPrice,
        'available_stock': availableStock,
        'min_order_quantity': minOrderQuantity,
        'max_order_quantity': maxOrderQuantity,
      };
}

/// One variant to import; `key` joins one option label per type with `/` and is
/// required. A key the product has is that variant, changed; an unknown field is
/// `400 unknown_field`.
class ProductVariantInput extends Dto {
  const ProductVariantInput({
    this.key,
    this.name,
    this.sku,
    this.customSku,
    this.title,
    this.summary,
    this.description,
    this.barcode,
    this.countryOfOrigin,
    this.hsCode,
    this.pricing,
    this.inventory,
    this.ordering,
    this.dimensions,
    this.badges,
    this.images,
  });

  final String? key;

  final String? name;

  final String? sku;

  final String? customSku;

  final String? title;

  final String? summary;

  final String? description;

  final String? barcode;

  final String? countryOfOrigin;

  final String? hsCode;

  final ProductVariantPricing? pricing;

  final ProductVariantInventory? inventory;

  final ProductVariantOrdering? ordering;

  final ProductVariantDimensions? dimensions;

  final ProductVariantBadges? badges;

  final List<Object?>? images;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'name': name,
        'sku': sku,
        'custom_sku': customSku,
        'title': title,
        'summary': summary,
        'description': description,
        'barcode': barcode,
        'country_of_origin': countryOfOrigin,
        'hs_code': hsCode,
        'pricing': pricing,
        'inventory': inventory,
        'ordering': ordering,
        'dimensions': dimensions,
        'badges': badges,
        'images': images,
      };
}

/// One group to import: `product_key` names the types, joined with `/`, and
/// `variants` must not be empty. A type name the store has is reused, an option
/// label it lacks is added.
class ProductVariationGroupInput extends Dto {
  const ProductVariationGroupInput({this.productKey, this.variants});

  final String? productKey;

  final List<ProductVariantInput?>? variants;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_key': productKey,
        'variants': variants,
      };
}

/// The import's body, no envelope; `variations` must not be empty.
class ProductVariationsImportInput extends Dto {
  const ProductVariationsImportInput({this.transactionNo, this.variations});

  final String? transactionNo;

  final List<ProductVariationGroupInput?>? variations;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'variations': variations,
      };
}

/// The import's answer: `status`, a `message` counting the variants and
/// `total_variants`.
class ProductVariationsImportResult extends Dto {
  const ProductVariationsImportResult({
    this.status,
    this.message,
    this.totalVariants,
  });

  /// Reads an import's body.
  static ProductVariationsImportResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVariationsImportResult(
      status: readText(source['status']),
      message: readText(source['message']),
      totalVariants: readInteger(source['total_variants']),
    );
  }

  final String? status;

  final String? message;

  final int? totalVariants;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'message': message,
        'total_variants': totalVariants,
      };
}
