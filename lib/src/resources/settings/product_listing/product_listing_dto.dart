/// Typed views over the product listing body.
library;

import '../../../client/dto.dart';

/// The *add to cart* and *view details* buttons on a listing tile, and whether
/// they wait for a hover.
class ProductListingInteractionButtons extends Dto {
  const ProductListingInteractionButtons({
    this.enabled,
    this.addToCart,
    this.showViewDetails,
    this.showOnHover,
  });

  static ProductListingInteractionButtons? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingInteractionButtons(
      enabled: readFlag(source['enabled']),
      addToCart: readFlag(source['add_to_cart']),
      showViewDetails: readFlag(source['show_view_details']),
      showOnHover: readFlag(source['show_on_hover']),
    );
  }

  final bool? enabled;

  final bool? addToCart;

  final bool? showViewDetails;

  final bool? showOnHover;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'add_to_cart': addToCart,
        'show_view_details': showViewDetails,
        'show_on_hover': showOnHover,
      };
}

/// Which prices a listing tile shows.
class ListingPrice extends Dto {
  const ListingPrice({
    this.enabled,
    this.expectToPay,
    this.expectToPayWithTax,
  });

  static ListingPrice? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ListingPrice(
      enabled: readFlag(source['enabled']),
      expectToPay: readFlag(source['expect_to_pay']),
      expectToPayWithTax: readFlag(source['expect_to_pay_with_tax']),
    );
  }

  final bool? enabled;

  final bool? expectToPay;

  final bool? expectToPayWithTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'expect_to_pay': expectToPay,
        'expect_to_pay_with_tax': expectToPayWithTax,
      };
}

/// The rating stars on a listing tile and the count beside them.
class Reviews extends Dto {
  const Reviews({this.showRating, this.showReviewCount});

  static Reviews? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Reviews(
      showRating: readFlag(source['show_rating']),
      showReviewCount: readFlag(source['show_review_count']),
    );
  }

  final bool? showRating;

  final bool? showReviewCount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_rating': showRating,
        'show_review_count': showReviewCount,
      };
}

/// Which variation types a listing tile combines.
class ProductListingVariationCombination extends Dto {
  const ProductListingVariationCombination({this.enabled, this.types});

  static ProductListingVariationCombination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingVariationCombination(
      enabled: readFlag(source['enabled']),
      types: readList(source['types'], readText),
    );
  }

  final bool? enabled;

  /// `types` — the one list in this area, and of plain names rather than records.
  final List<String?>? types;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'types': types,
      };
}

/// The `product_information` section — what each product shows on a listing
/// tile.
class ProductListingProductInformation extends Dto {
  const ProductListingProductInformation({
    this.interactionButtons,
    this.showSummary,
    this.showSalePercentage,
    this.showStockAvailability,
    this.showParentCategory,
    this.showLoyaltyPoints,
    this.price,
    this.reviews,
    this.variationCombination,
    this.showVariationsAsProducts,
  });

  static ProductListingProductInformation? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingProductInformation(
      interactionButtons: ProductListingInteractionButtons.fromMap(
          source['interaction_buttons']),
      showSummary: readFlag(source['show_summary']),
      showSalePercentage: readFlag(source['show_sale_percentage']),
      showStockAvailability: readFlag(source['show_stock_availability']),
      showParentCategory: readFlag(source['show_parent_category']),
      showLoyaltyPoints: readFlag(source['show_loyalty_points']),
      price: ListingPrice.fromMap(source['price']),
      reviews: Reviews.fromMap(source['reviews']),
      variationCombination: ProductListingVariationCombination.fromMap(
          source['variation_combination']),
      showVariationsAsProducts: readFlag(source['show_variations_as_products']),
    );
  }

  final ProductListingInteractionButtons? interactionButtons;

  final bool? showSummary;

  final bool? showSalePercentage;

  final bool? showStockAvailability;

  final bool? showParentCategory;

  final bool? showLoyaltyPoints;

  final ListingPrice? price;

  final Reviews? reviews;

  final ProductListingVariationCombination? variationCombination;

  final bool? showVariationsAsProducts;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'interaction_buttons': interactionButtons,
        'show_summary': showSummary,
        'show_sale_percentage': showSalePercentage,
        'show_stock_availability': showStockAvailability,
        'show_parent_category': showParentCategory,
        'show_loyalty_points': showLoyaltyPoints,
        'price': price,
        'reviews': reviews,
        'variation_combination': variationCombination,
        'show_variations_as_products': showVariationsAsProducts,
      };
}

/// Where the pager sits and how many products a page holds.
class ProductListingPagination extends Dto {
  const ProductListingPagination({
    this.position,
    this.perPage,
    this.allowUserPerPage,
  });

  static ProductListingPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingPagination(
      position: readText(source['position']),
      perPage: readInteger(source['per_page']),
      allowUserPerPage: readFlag(source['allow_user_per_page']),
    );
  }

  final String? position;

  final int? perPage;

  final bool? allowUserPerPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'position': position,
        'per_page': perPage,
        'allow_user_per_page': allowUserPerPage,
      };
}

/// How many products each press of *load more* adds. Bounded `1`–`999999`.
class LoadMore extends Dto {
  const LoadMore({this.perLoad});

  static LoadMore? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return LoadMore(perLoad: readInteger(source['per_load']));
  }

  final int? perLoad;

  @override
  Map<String, Object?> get fields => <String, Object?>{'per_load': perLoad};
}

/// The `load` section — whether a listing pages or loads more, and the settings
/// of whichever it is.
class Load extends Dto {
  const Load({this.enabled, this.type, this.pagination, this.loadMore});

  static Load? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Load(
      enabled: readFlag(source['enabled']),
      type: readText(source['type']),
      pagination: ProductListingPagination.fromMap(source['pagination']),
      loadMore: LoadMore.fromMap(source['load_more']),
    );
  }

  final bool? enabled;

  final String? type;

  final ProductListingPagination? pagination;

  final LoadMore? loadMore;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'type': type,
        'pagination': pagination,
        'load_more': loadMore,
      };
}

/// The `sorting` section — the order a listing arrives in.
class Sorting extends Dto {
  const Sorting({this.enabled, this.sortBy});

  static Sorting? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Sorting(
      enabled: readFlag(source['enabled']),
      sortBy: readText(source['sort_by']),
    );
  }

  final bool? enabled;

  final String? sortBy;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'sort_by': sortBy,
      };
}

/// Which orders a shopper may pick from.
class SortableOptions extends Dto {
  const SortableOptions({
    this.alphabetic,
    this.featured,
    this.newest,
    this.topSelling,
    this.price,
    this.createdDate,
  });

  static SortableOptions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SortableOptions(
      alphabetic: readFlag(source['alphabetic']),
      featured: readFlag(source['featured']),
      newest: readFlag(source['new']),
      topSelling: readFlag(source['top_selling']),
      price: readFlag(source['price']),
      createdDate: readFlag(source['created_date']),
    );
  }

  final bool? alphabetic;

  final bool? featured;

  /// `new` on the wire, which is a Dart reserved word.
  final bool? newest;

  final bool? topSelling;

  final bool? price;

  final bool? createdDate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'alphabetic': alphabetic,
        'featured': featured,
        'new': newest,
        'top_selling': topSelling,
        'price': price,
        'created_date': createdDate,
      };
}

/// The `sortable_items` section — whether a shopper may re-sort a listing, and
/// by what.
class SortableItems extends Dto {
  const SortableItems({this.enabled, this.options});

  static SortableItems? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SortableItems(
      enabled: readFlag(source['enabled']),
      options: SortableOptions.fromMap(source['options']),
    );
  }

  final bool? enabled;

  final SortableOptions? options;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'options': options,
      };
}

/// The one entry of `group_meta`: what the area is, whether it is writable and
/// where it lives.
class ProductListingSectionMeta extends Dto {
  const ProductListingSectionMeta({this.kind, this.writable, this.href});

  static ProductListingSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"`.
  final String? kind;

  final bool? writable;

  /// `href` — the area's own path, `/api/v4/admin/settings/product_listing`.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — a single entry for the whole area, not one per
/// section.
class ProductListingGroupMeta extends Dto {
  const ProductListingGroupMeta({this.productListing});

  static ProductListingGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductListingGroupMeta(
      productListing:
          ProductListingSectionMeta.fromMap(source['product_listing']),
    );
  }

  final ProductListingSectionMeta? productListing;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_listing': productListing,
      };
}

/// The product listing settings, all four sections inlined under one key.
class ProductListingSettings extends Dto {
  const ProductListingSettings({
    this.productInformation,
    this.load,
    this.sorting,
    this.sortableItems,
    this.groupMeta,
    this.fieldMetadata,
  });

  static ProductListingSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_listing');
    if (source == null) return null;
    return ProductListingSettings(
      productInformation: ProductListingProductInformation.fromMap(
          source['product_information']),
      load: Load.fromMap(source['load']),
      sorting: Sorting.fromMap(source['sorting']),
      sortableItems: SortableItems.fromMap(source['sortable_items']),
      groupMeta: ProductListingGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final ProductListingProductInformation? productInformation;

  final Load? load;

  final Sorting? sorting;

  final SortableItems? sortableItems;

  /// `group_meta` — beside the settings on every answer this area sends.
  final ProductListingGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'product_listing';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_information': productInformation,
        'load': load,
        'sorting': sorting,
        'sortable_items': sortableItems,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
