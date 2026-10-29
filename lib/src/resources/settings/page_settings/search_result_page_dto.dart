/// Typed views over the search result page settings bodies.
library;

import '../../../client/dto.dart';

/// The `product_interaction_buttons` block — which buttons each result carries.
class ProductInteractionButtons extends Dto {
  const ProductInteractionButtons({
    this.enabled,
    this.displayAddToCartButton,
    this.displayAddToCompareButton,
    this.displayAddToWishlistButton,
    this.displayViewDetailsButton,
    this.displayOnHover,
    this.displayQuickViewButton,
  });

  static ProductInteractionButtons? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductInteractionButtons(
      enabled: readFlag(source['enabled']),
      displayAddToCartButton: readFlag(source['display_add_to_cart_button']),
      displayAddToCompareButton:
          readFlag(source['display_add_to_compare_button']),
      displayAddToWishlistButton:
          readFlag(source['display_add_to_wishlist_button']),
      displayViewDetailsButton: readFlag(source['display_view_details_button']),
      displayOnHover: readFlag(source['display_on_hover']),
      displayQuickViewButton: readFlag(source['display_quick_view_button']),
    );
  }

  final bool? enabled;

  final bool? displayAddToCartButton;

  final bool? displayAddToCompareButton;

  final bool? displayAddToWishlistButton;

  final bool? displayViewDetailsButton;

  final bool? displayOnHover;

  final bool? displayQuickViewButton;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'display_add_to_cart_button': displayAddToCartButton,
        'display_add_to_compare_button': displayAddToCompareButton,
        'display_add_to_wishlist_button': displayAddToWishlistButton,
        'display_view_details_button': displayViewDetailsButton,
        'display_on_hover': displayOnHover,
        'display_quick_view_button': displayQuickViewButton,
      };
}

/// The `number_of_searches_per_result` block — whether results are paginated,
/// and how many sit on a page.
class NumberOfSearchesPerResult extends Dto {
  const NumberOfSearchesPerResult({this.enabled, this.itemsPerPage});

  static NumberOfSearchesPerResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return NumberOfSearchesPerResult(
      enabled: readFlag(source['enabled']),
      itemsPerPage: readInteger(source['items_per_page']),
    );
  }

  final bool? enabled;

  final int? itemsPerPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'items_per_page': itemsPerPage,
      };
}

/// The `set_product_display_preferences` block — how results load and where the
/// pagination controls sit.
class SetProductDisplayPreferences extends Dto {
  const SetProductDisplayPreferences({
    this.enabled,
    this.displayMode,
    this.selectPaginationPosition,
    this.numberOfProductsPerPage,
    this.allowUsersToSelectNumberOfProducts,
    this.numberOfProductsPerLoad,
  });

  static SetProductDisplayPreferences? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SetProductDisplayPreferences(
      enabled: readFlag(source['enabled']),
      displayMode: readText(source['display_mode']),
      selectPaginationPosition: readText(source['select_pagination_position']),
      numberOfProductsPerPage:
          readInteger(source['number_of_products_per_page']),
      allowUsersToSelectNumberOfProducts:
          readFlag(source['allow_users_to_select_number_of_products']),
      numberOfProductsPerLoad:
          readInteger(source['number_of_products_per_load']),
    );
  }

  final bool? enabled;

  final String? displayMode;

  final String? selectPaginationPosition;

  final int? numberOfProductsPerPage;

  final bool? allowUsersToSelectNumberOfProducts;

  final int? numberOfProductsPerLoad;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'display_mode': displayMode,
        'select_pagination_position': selectPaginationPosition,
        'number_of_products_per_page': numberOfProductsPerPage,
        'allow_users_to_select_number_of_products':
            allowUsersToSelectNumberOfProducts,
        'number_of_products_per_load': numberOfProductsPerLoad,
      };
}

/// The `set_product_sorting` block — whether a default sort is applied, and
/// which.
class SetProductSorting extends Dto {
  const SetProductSorting({this.enabled, this.defaultSort});

  static SetProductSorting? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SetProductSorting(
      enabled: readFlag(source['enabled']),
      defaultSort: readText(source['default_sort']),
    );
  }

  final bool? enabled;

  final String? defaultSort;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'default_sort': defaultSort,
      };
}

/// The `configure_sorting_options` block — which sort orders a shopper may
/// switch to.
class ConfigureSortingOptions extends Dto {
  const ConfigureSortingOptions({
    this.enabled,
    this.alphabetical,
    this.featured,
    this.isNew,
    this.topSelling,
    this.price,
    this.createdDate,
  });

  static ConfigureSortingOptions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ConfigureSortingOptions(
      enabled: readFlag(source['enabled']),
      alphabetical: readFlag(source['alphabetical']),
      featured: readFlag(source['featured']),
      isNew: readFlag(source['new']),
      topSelling: readFlag(source['top_selling']),
      price: readFlag(source['price']),
      createdDate: readFlag(source['created_date']),
    );
  }

  final bool? enabled;

  final bool? alphabetical;

  final bool? featured;

  /// `new` on the wire, renamed because `new` is a Dart reserved word.
  final bool? isNew;

  final bool? topSelling;

  final bool? price;

  final bool? createdDate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'alphabetical': alphabetical,
        'featured': featured,
        'new': isNew,
        'top_selling': topSelling,
        'price': price,
        'created_date': createdDate,
      };
}

/// The `display_price` block — whether a result shows a price, and which price.
class DisplayPrice extends Dto {
  const DisplayPrice({
    this.enabled,
    this.displayExpectToPayPrice,
    this.showTaxWithTheExpectToPayPrice,
  });

  static DisplayPrice? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DisplayPrice(
      enabled: readFlag(source['enabled']),
      displayExpectToPayPrice: readFlag(source['display_expect_to_pay_price']),
      showTaxWithTheExpectToPayPrice:
          readFlag(source['show_tax_with_the_expect_to_pay_price']),
    );
  }

  final bool? enabled;

  final bool? displayExpectToPayPrice;

  final bool? showTaxWithTheExpectToPayPrice;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'display_expect_to_pay_price': displayExpectToPayPrice,
        'show_tax_with_the_expect_to_pay_price': showTaxWithTheExpectToPayPrice,
      };
}

/// The `product_information` section — what each search result shows and how
/// the list behaves.
class ProductInformation extends Dto {
  const ProductInformation({
    this.useDefaultProductListingConfigurations,
    this.productInteractionButtons,
    this.displayContentPage,
    this.numberOfSearchesPerResult,
    this.displayShortDescription,
    this.displayVariationsCombination,
    this.setProductDisplayPreferences,
    this.setProductSorting,
    this.configureSortingOptions,
    this.displayLoyaltyPoints,
    this.displayPrice,
    this.labelForPrice,
  });

  static ProductInformation? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_information');
    if (source == null) return null;
    return ProductInformation(
      useDefaultProductListingConfigurations:
          readFlag(source['use_default_product_listing_configurations']),
      productInteractionButtons: ProductInteractionButtons.fromMap(
          source['product_interaction_buttons']),
      displayContentPage: readFlag(source['display_content_page']),
      numberOfSearchesPerResult: NumberOfSearchesPerResult.fromMap(
          source['number_of_searches_per_result']),
      displayShortDescription: readFlag(source['display_short_description']),
      displayVariationsCombination:
          readFlag(source['display_variations_combination']),
      setProductDisplayPreferences: SetProductDisplayPreferences.fromMap(
          source['set_product_display_preferences']),
      setProductSorting:
          SetProductSorting.fromMap(source['set_product_sorting']),
      configureSortingOptions:
          ConfigureSortingOptions.fromMap(source['configure_sorting_options']),
      displayLoyaltyPoints: readFlag(source['display_loyalty_points']),
      displayPrice: DisplayPrice.fromMap(source['display_price']),
      labelForPrice: readText(source['label_for_price']),
    );
  }

  final bool? useDefaultProductListingConfigurations;

  final ProductInteractionButtons? productInteractionButtons;

  final bool? displayContentPage;

  final NumberOfSearchesPerResult? numberOfSearchesPerResult;

  final bool? displayShortDescription;

  final bool? displayVariationsCombination;

  final SetProductDisplayPreferences? setProductDisplayPreferences;

  final SetProductSorting? setProductSorting;

  final ConfigureSortingOptions? configureSortingOptions;

  final bool? displayLoyaltyPoints;

  final DisplayPrice? displayPrice;

  final String? labelForPrice;

  @override
  String? get envelopeKey => 'product_information';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'use_default_product_listing_configurations':
            useDefaultProductListingConfigurations,
        'product_interaction_buttons': productInteractionButtons,
        'display_content_page': displayContentPage,
        'number_of_searches_per_result': numberOfSearchesPerResult,
        'display_short_description': displayShortDescription,
        'display_variations_combination': displayVariationsCombination,
        'set_product_display_preferences': setProductDisplayPreferences,
        'set_product_sorting': setProductSorting,
        'configure_sorting_options': configureSortingOptions,
        'display_loyalty_points': displayLoyaltyPoints,
        'display_price': displayPrice,
        'label_for_price': labelForPrice,
      };
}

/// The `seo` section — two read-only markers rather than settings.
class Seo extends Dto {
  const Seo({this.readOnly, this.pageKind});

  static Seo? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'seo');
    if (source == null) return null;
    return Seo(
      readOnly: readFlag(source['read_only']),
      pageKind: readText(source['page_kind']),
    );
  }

  final bool? readOnly;

  final String? pageKind;

  @override
  String? get envelopeKey => 'seo';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'read_only': readOnly,
        'page_kind': pageKind,
      };
}

/// The `reinitialise` section — one field naming the verb its `group_meta`
/// `href` takes.
class Reinitialise extends Dto {
  const Reinitialise({this.action});

  static Reinitialise? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'reinitialise');
    if (source == null) return null;
    return Reinitialise(action: readText(source['action']));
  }

  final String? action;

  @override
  String? get envelopeKey => 'reinitialise';

  @override
  Map<String, Object?> get fields => <String, Object?>{'action': action};
}

/// The `product_promotion` block the facade inlines — a marker only.
class ProductPromotionPreview extends Dto {
  const ProductPromotionPreview({this.readOnly});

  static ProductPromotionPreview? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPromotionPreview(readOnly: readFlag(source['read_only']));
  }

  final bool? readOnly;

  @override
  Map<String, Object?> get fields => <String, Object?>{'read_only': readOnly};
}

/// One promotion row: the store's [id] and [created]/[updated] stamps, the
/// three fields a create must carry, and the six it may.
class ProductPromotion extends Dto {
  const ProductPromotion({
    this.id,
    this.name,
    this.rule,
    this.position,
    this.specificKeywords,
    this.isActive,
    this.isAlwaysAvailable,
    this.availableFromDate,
    this.availableToDate,
    this.productIds,
    this.created,
    this.updated,
  });

  static ProductPromotion? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_promotion');
    if (source == null) return null;
    return ProductPromotion(
      id: readInteger(source['id']),
      name: readText(source['name']),
      rule: readText(source['rule']),
      position: readText(source['position']),
      specificKeywords: readText(source['specific_keywords']),
      isActive: readFlag(source['is_active']),
      isAlwaysAvailable: readFlag(source['is_always_available']),
      availableFromDate: readText(source['available_from_date']),
      availableToDate: readText(source['available_to_date']),
      productIds: readList<int>(source['product_ids'], readInteger),
      created: readText(source['created']),
      updated: readText(source['updated']),
    );
  }

  /// `id` — the store's, and what a `{promotion_id}` path slot takes.
  final int? id;

  final String? name;

  /// `rule` — when the promoted products are injected; an enum whose
  /// `allowed_values` the collection's `field_metadata` names.
  final String? rule;

  /// `position` — where they appear in the result list; likewise an enum.
  final String? position;

  final String? specificKeywords;

  final bool? isActive;

  final bool? isAlwaysAvailable;

  final String? availableFromDate;

  final String? availableToDate;

  final List<int?>? productIds;

  final String? created;

  final String? updated;

  @override
  String? get envelopeKey => 'product_promotion';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'rule': rule,
        'position': position,
        'specific_keywords': specificKeywords,
        'is_active': isActive,
        'is_always_available': isAlwaysAvailable,
        'available_from_date': availableFromDate,
        'available_to_date': availableToDate,
        'product_ids': productIds,
        'created': created,
        'updated': updated,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written, what
/// to call it and where it is managed.
class SearchResultPageSectionMeta extends Dto {
  const SearchResultPageSectionMeta({
    this.kind,
    this.writable,
    this.uiLabel,
    this.href,
  });

  static SearchResultPageSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchResultPageSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      uiLabel: readText(source['ui_label']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"`, `"resource"` or `"action"`.
  final String? kind;

  final bool? writable;

  final String? uiLabel;

  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'ui_label': uiLabel,
        'href': href,
      };
}

/// The `group_meta` block — one [SearchResultPageSectionMeta] per thing the
/// area declares, across three kinds.
class SearchResultPageGroupMeta extends Dto {
  const SearchResultPageGroupMeta({
    this.productInformation,
    this.seo,
    this.productPromotion,
    this.reinitialise,
  });

  static SearchResultPageGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchResultPageGroupMeta(
      productInformation:
          SearchResultPageSectionMeta.fromMap(source['product_information']),
      seo: SearchResultPageSectionMeta.fromMap(source['seo']),
      productPromotion:
          SearchResultPageSectionMeta.fromMap(source['product_promotion']),
      reinitialise: SearchResultPageSectionMeta.fromMap(source['reinitialise']),
    );
  }

  final SearchResultPageSectionMeta? productInformation;

  final SearchResultPageSectionMeta? seo;

  final SearchResultPageSectionMeta? productPromotion;

  final SearchResultPageSectionMeta? reinitialise;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_information': productInformation,
        'seo': seo,
        'product_promotion': productPromotion,
        'reinitialise': reinitialise,
      };
}

/// The search result page settings, as the facade or one section sends them.
class SearchResultPage extends Dto {
  const SearchResultPage({
    this.productInformation,
    this.seo,
    this.productPromotion,
    this.reinitialise,
    this.groupMeta,
    this.fieldMetadata,
  });

  static SearchResultPage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'search_result_page');
    if (source == null) return null;
    return SearchResultPage(
      productInformation:
          ProductInformation.fromMap(source['product_information']),
      seo: Seo.fromMap(source['seo']),
      productPromotion:
          ProductPromotionPreview.fromMap(source['product_promotion']),
      reinitialise: Reinitialise.fromMap(source['reinitialise']),
      groupMeta: SearchResultPageGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final ProductInformation? productInformation;

  final Seo? seo;

  /// `product_promotion` — the collection's marker, not its rows.
  final ProductPromotionPreview? productPromotion;

  final Reinitialise? reinitialise;

  /// `group_meta` — on the facade's answer only.
  final SearchResultPageGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because the store keys it differently in the
  /// two forms: by section on the facade, by field name on a section.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'search_result_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_information': productInformation,
        'seo': seo,
        'product_promotion': productPromotion,
        'reinitialise': reinitialise,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
