/// Typed views over the category page settings bodies.
library;

import '../../../client/dto.dart';

/// The `heading` block — whether the category name is shown, and at which HTML
/// heading level.
class CategoryHeading extends Dto {
  const CategoryHeading({this.enabled, this.style});

  static CategoryHeading? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryHeading(
      enabled: readFlag(source['enabled']),
      style: readText(source['style']),
    );
  }

  final bool? enabled;

  final String? style;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'style': style,
      };
}

/// The `subcategory` block — whether subcategories are listed, and how that
/// list pages.
class Subcategory extends Dto {
  const Subcategory({
    this.enabled,
    this.display,
    this.loadType,
    this.paginationPosition,
    this.perPage,
    this.allowUserPerPage,
    this.perLoad,
    this.displayProducts,
    this.showSummary,
  });

  static Subcategory? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Subcategory(
      enabled: readFlag(source['enabled']),
      display: readFlag(source['display']),
      loadType: readText(source['load_type']),
      paginationPosition: readText(source['pagination_position']),
      perPage: readInteger(source['per_page']),
      allowUserPerPage: readFlag(source['allow_user_per_page']),
      perLoad: readInteger(source['per_load']),
      displayProducts: readFlag(source['display_products']),
      showSummary: readFlag(source['show_summary']),
    );
  }

  final bool? enabled;

  final bool? display;

  final String? loadType;

  final String? paginationPosition;

  final int? perPage;

  final bool? allowUserPerPage;

  final int? perLoad;

  final bool? displayProducts;

  final bool? showSummary;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'display': display,
        'load_type': loadType,
        'pagination_position': paginationPosition,
        'per_page': perPage,
        'allow_user_per_page': allowUserPerPage,
        'per_load': perLoad,
        'display_products': displayProducts,
        'show_summary': showSummary,
      };
}

/// The `category_information` section — what the category itself shows and how
/// its subcategories are listed.
class CategoryInformation extends Dto {
  const CategoryInformation({
    this.heading,
    this.showDescription,
    this.showBannerImage,
    this.showImage,
    this.subcategory,
  });

  static CategoryInformation? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'category_information');
    if (source == null) return null;
    return CategoryInformation(
      heading: CategoryHeading.fromMap(source['heading']),
      showDescription: readFlag(source['show_description']),
      showBannerImage: readFlag(source['show_banner_image']),
      showImage: readFlag(source['show_image']),
      subcategory: Subcategory.fromMap(source['subcategory']),
    );
  }

  final CategoryHeading? heading;

  final bool? showDescription;

  final bool? showBannerImage;

  final bool? showImage;

  final Subcategory? subcategory;

  @override
  String? get envelopeKey => 'category_information';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'heading': heading,
        'show_description': showDescription,
        'show_banner_image': showBannerImage,
        'show_image': showImage,
        'subcategory': subcategory,
      };
}

/// The `interaction_buttons` block — which buttons each product card carries.
class InteractionButtons extends Dto {
  const InteractionButtons({
    this.enabled,
    this.addToCart,
    this.viewDetails,
    this.showOnHover,
    this.addToWishList,
    this.addToCompare,
    this.quickView,
  });

  static InteractionButtons? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InteractionButtons(
      enabled: readFlag(source['enabled']),
      addToCart: readFlag(source['add_to_cart']),
      viewDetails: readFlag(source['view_details']),
      showOnHover: readFlag(source['show_on_hover']),
      addToWishList: readFlag(source['add_to_wish_list']),
      addToCompare: readFlag(source['add_to_compare']),
      quickView: readFlag(source['quick_view']),
    );
  }

  final bool? enabled;

  final bool? addToCart;

  final bool? viewDetails;

  final bool? showOnHover;

  final bool? addToWishList;

  final bool? addToCompare;

  final bool? quickView;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'add_to_cart': addToCart,
        'view_details': viewDetails,
        'show_on_hover': showOnHover,
        'add_to_wish_list': addToWishList,
        'add_to_compare': addToCompare,
        'quick_view': quickView,
      };
}

/// The `price` block — whether a card shows a price, and which price.
class Price extends Dto {
  const Price({
    this.enabled,
    this.expectToPay,
    this.expectToPayWithTax,
    this.strikeThroughPrevious,
  });

  static Price? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Price(
      enabled: readFlag(source['enabled']),
      expectToPay: readFlag(source['expect_to_pay']),
      expectToPayWithTax: readFlag(source['expect_to_pay_with_tax']),
      strikeThroughPrevious: readFlag(source['strike_through_previous']),
    );
  }

  final bool? enabled;

  final bool? expectToPay;

  final bool? expectToPayWithTax;

  final bool? strikeThroughPrevious;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'expect_to_pay': expectToPay,
        'expect_to_pay_with_tax': expectToPayWithTax,
        'strike_through_previous': strikeThroughPrevious,
      };
}

/// One entry of `variation_combination.types` — a variation type the store
/// already defines, by [id] and [name].
class VariationType extends Dto {
  const VariationType({this.id, this.name});

  static VariationType? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationType(
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

/// The `variation_combination` block — whether combinations are shown, and
/// which variation types are offered.
class VariationCombination extends Dto {
  const VariationCombination({this.enabled, this.types});

  static VariationCombination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationCombination(
      enabled: readFlag(source['enabled']),
      types: readList<VariationType>(source['types'], VariationType.fromMap),
    );
  }

  final bool? enabled;

  final List<VariationType?>? types;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'types': types,
      };
}

/// The `rating` block — whether the rating is shown, and whether the review
/// count sits beside it.
class Rating extends Dto {
  const Rating({this.enabled, this.showReviewCount});

  static Rating? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Rating(
      enabled: readFlag(source['enabled']),
      showReviewCount: readFlag(source['show_review_count']),
    );
  }

  final bool? enabled;

  final bool? showReviewCount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'show_review_count': showReviewCount,
      };
}

/// The `view_switcher` block — whether a shopper may change the listing's
/// display mode, and which modes are offered.
class ViewSwitcher extends Dto {
  const ViewSwitcher({this.enabled, this.grid, this.list, this.tabular});

  static ViewSwitcher? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ViewSwitcher(
      enabled: readFlag(source['enabled']),
      grid: readFlag(source['grid']),
      list: readFlag(source['list']),
      tabular: readFlag(source['tabular']),
    );
  }

  final bool? enabled;

  final bool? grid;

  final bool? list;

  final bool? tabular;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'grid': grid,
        'list': list,
        'tabular': tabular,
      };
}

/// The `columns_per_row` block inside `default_display` — how many product
/// columns a row holds, per mode.
class ColumnsPerRow extends Dto {
  const ColumnsPerRow({this.grid, this.list});

  static ColumnsPerRow? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ColumnsPerRow(
      grid: readInteger(source['grid']),
      list: readInteger(source['list']),
    );
  }

  final int? grid;

  final int? list;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'grid': grid,
        'list': list,
      };
}

/// The `default_display` block — the mode a listing opens in and how wide its
/// rows are.
class DefaultDisplay extends Dto {
  const DefaultDisplay({
    this.enabled,
    this.mode,
    this.columnsPerRow,
    this.showVariationOptionsLabelInTabular,
  });

  static DefaultDisplay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DefaultDisplay(
      enabled: readFlag(source['enabled']),
      mode: readText(source['mode']),
      columnsPerRow: ColumnsPerRow.fromMap(source['columns_per_row']),
      showVariationOptionsLabelInTabular:
          readFlag(source['show_variation_options_label_in_tabular']),
    );
  }

  final bool? enabled;

  final String? mode;

  final ColumnsPerRow? columnsPerRow;

  final bool? showVariationOptionsLabelInTabular;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'mode': mode,
        'columns_per_row': columnsPerRow,
        'show_variation_options_label_in_tabular':
            showVariationOptionsLabelInTabular,
      };
}

/// The `load` block — how the product listing pages and where its control sits.
class ProductLoad extends Dto {
  const ProductLoad({
    this.enabled,
    this.type,
    this.paginationPosition,
    this.perPage,
    this.allowUserPerPage,
    this.perLoad,
  });

  static ProductLoad? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductLoad(
      enabled: readFlag(source['enabled']),
      type: readText(source['type']),
      paginationPosition: readText(source['pagination_position']),
      perPage: readInteger(source['per_page']),
      allowUserPerPage: readFlag(source['allow_user_per_page']),
      perLoad: readInteger(source['per_load']),
    );
  }

  final bool? enabled;

  final String? type;

  final String? paginationPosition;

  final int? perPage;

  final bool? allowUserPerPage;

  final int? perLoad;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'type': type,
        'pagination_position': paginationPosition,
        'per_page': perPage,
        'allow_user_per_page': allowUserPerPage,
        'per_load': perLoad,
      };
}

/// The `default_sort` block — whether a default order is applied, and which.
class DefaultSort extends Dto {
  const DefaultSort({this.enabled, this.by});

  static DefaultSort? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DefaultSort(
      enabled: readFlag(source['enabled']),
      by: readText(source['by']),
    );
  }

  final bool? enabled;

  final String? by;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'by': by,
      };
}

/// The `sort_options` block — which orders a shopper may switch to.
class SortOptions extends Dto {
  const SortOptions({
    this.enabled,
    this.alphabetic,
    this.featured,
    this.isNew,
    this.topSelling,
    this.price,
    this.date,
  });

  static SortOptions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SortOptions(
      enabled: readFlag(source['enabled']),
      alphabetic: readFlag(source['alphabetic']),
      featured: readFlag(source['featured']),
      isNew: readFlag(source['new']),
      topSelling: readFlag(source['top_selling']),
      price: readFlag(source['price']),
      date: readFlag(source['date']),
    );
  }

  final bool? enabled;

  final bool? alphabetic;

  final bool? featured;

  /// `new` on the wire, renamed because `new` is a Dart reserved word.
  final bool? isNew;

  final bool? topSelling;

  final bool? price;

  final bool? date;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'alphabetic': alphabetic,
        'featured': featured,
        'new': isNew,
        'top_selling': topSelling,
        'price': price,
        'date': date,
      };
}

/// The `product_information` section — what each product card on a category
/// page shows and how the listing behaves.
class CategoryPageProductInformation extends Dto {
  const CategoryPageProductInformation({
    this.useGlobalDefaults,
    this.interactionButtons,
    this.showSummary,
    this.showSalePercentage,
    this.showStockAvailability,
    this.showParentCategory,
    this.price,
    this.variationCombination,
    this.rating,
    this.viewSwitcher,
    this.defaultDisplay,
    this.load,
    this.defaultSort,
    this.sortOptions,
  });

  static CategoryPageProductInformation? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_information');
    if (source == null) return null;
    return CategoryPageProductInformation(
      useGlobalDefaults: readFlag(source['use_global_defaults']),
      interactionButtons:
          InteractionButtons.fromMap(source['interaction_buttons']),
      showSummary: readFlag(source['show_summary']),
      showSalePercentage: readFlag(source['show_sale_percentage']),
      showStockAvailability: readFlag(source['show_stock_availability']),
      showParentCategory: readFlag(source['show_parent_category']),
      price: Price.fromMap(source['price']),
      variationCombination:
          VariationCombination.fromMap(source['variation_combination']),
      rating: Rating.fromMap(source['rating']),
      viewSwitcher: ViewSwitcher.fromMap(source['view_switcher']),
      defaultDisplay: DefaultDisplay.fromMap(source['default_display']),
      load: ProductLoad.fromMap(source['load']),
      defaultSort: DefaultSort.fromMap(source['default_sort']),
      sortOptions: SortOptions.fromMap(source['sort_options']),
    );
  }

  final bool? useGlobalDefaults;

  final InteractionButtons? interactionButtons;

  final bool? showSummary;

  final bool? showSalePercentage;

  final bool? showStockAvailability;

  final bool? showParentCategory;

  final Price? price;

  final VariationCombination? variationCombination;

  final Rating? rating;

  final ViewSwitcher? viewSwitcher;

  final DefaultDisplay? defaultDisplay;

  final ProductLoad? load;

  final DefaultSort? defaultSort;

  final SortOptions? sortOptions;

  @override
  String? get envelopeKey => 'product_information';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'use_global_defaults': useGlobalDefaults,
        'interaction_buttons': interactionButtons,
        'show_summary': showSummary,
        'show_sale_percentage': showSalePercentage,
        'show_stock_availability': showStockAvailability,
        'show_parent_category': showParentCategory,
        'price': price,
        'variation_combination': variationCombination,
        'rating': rating,
        'view_switcher': viewSwitcher,
        'default_display': defaultDisplay,
        'load': load,
        'default_sort': defaultSort,
        'sort_options': sortOptions,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written, and
/// where it is managed.
class CategoryPageSectionMeta extends Dto {
  const CategoryPageSectionMeta({this.kind, this.writable, this.href});

  static CategoryPageSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryPageSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on both entries here.
  final String? kind;

  final bool? writable;

  /// `href` — the section's own path on this resource, for both entries.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [CategoryPageSectionMeta] per section the area
/// declares.
class CategoryPageGroupMeta extends Dto {
  const CategoryPageGroupMeta(
      {this.categoryInformation, this.productInformation});

  static CategoryPageGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryPageGroupMeta(
      categoryInformation:
          CategoryPageSectionMeta.fromMap(source['category_information']),
      productInformation:
          CategoryPageSectionMeta.fromMap(source['product_information']),
    );
  }

  final CategoryPageSectionMeta? categoryInformation;

  final CategoryPageSectionMeta? productInformation;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'category_information': categoryInformation,
        'product_information': productInformation,
      };
}

/// The category page settings, as the facade or one section sends them.
class CategoryPage extends Dto {
  const CategoryPage({
    this.categoryInformation,
    this.productInformation,
    this.groupMeta,
    this.fieldMetadata,
  });

  static CategoryPage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'category_page');
    if (source == null) return null;
    return CategoryPage(
      categoryInformation:
          CategoryInformation.fromMap(source['category_information']),
      productInformation:
          CategoryPageProductInformation.fromMap(source['product_information']),
      groupMeta: CategoryPageGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final CategoryInformation? categoryInformation;

  final CategoryPageProductInformation? productInformation;

  /// `group_meta` — on the facade's answer only.
  final CategoryPageGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because the store keys it differently in the
  /// two forms: by section on the facade, by field name on a section.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'category_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'category_information': categoryInformation,
        'product_information': productInformation,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
