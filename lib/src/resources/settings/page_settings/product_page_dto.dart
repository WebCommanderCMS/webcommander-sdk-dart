/// Typed views over the product page settings bodies.
library;

import '../../../client/dto.dart';

/// The `actions_buttons` block — which buttons a product page carries.
class ActionButtons extends Dto {
  const ActionButtons({
    this.showProductActionButtons,
    this.displayAddToCartButton,
    this.displayBuyNowButton,
    this.displayOnHover,
    this.displayAddToCompareButton,
    this.displayAddToWishlistButton,
  });

  static ActionButtons? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ActionButtons(
      showProductActionButtons: readFlag(source['show_product_action_buttons']),
      displayAddToCartButton: readFlag(source['display_add_to_cart_button']),
      displayBuyNowButton: readFlag(source['display_buy_now_button']),
      displayOnHover: readFlag(source['display_on_hover']),
      displayAddToCompareButton:
          readFlag(source['display_add_to_compare_button']),
      displayAddToWishlistButton:
          readFlag(source['display_add_to_wishlist_button']),
    );
  }

  final bool? showProductActionButtons;

  final bool? displayAddToCartButton;

  final bool? displayBuyNowButton;

  final bool? displayOnHover;

  final bool? displayAddToCompareButton;

  final bool? displayAddToWishlistButton;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_product_action_buttons': showProductActionButtons,
        'display_add_to_cart_button': displayAddToCartButton,
        'display_buy_now_button': displayBuyNowButton,
        'display_on_hover': displayOnHover,
        'display_add_to_compare_button': displayAddToCompareButton,
        'display_add_to_wishlist_button': displayAddToWishlistButton,
      };
}

/// The `details` block — which parts of the product's own description are
/// shown.
class ProductDetails extends Dto {
  const ProductDetails({
    this.displayDescription,
    this.displaySalePercentage,
    this.useStrikeThroughOnPreviousPrice,
    this.displayTaxWithExpectToPayPrice,
  });

  static ProductDetails? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductDetails(
      displayDescription: readFlag(source['display_description']),
      displaySalePercentage: readFlag(source['display_sale_percentage']),
      useStrikeThroughOnPreviousPrice:
          readFlag(source['use_strike_through_on_previous_price']),
      displayTaxWithExpectToPayPrice:
          readFlag(source['display_tax_with_expect_to_pay_price']),
    );
  }

  final bool? displayDescription;

  final bool? displaySalePercentage;

  final bool? useStrikeThroughOnPreviousPrice;

  final bool? displayTaxWithExpectToPayPrice;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'display_description': displayDescription,
        'display_sale_percentage': displaySalePercentage,
        'use_strike_through_on_previous_price': useStrikeThroughOnPreviousPrice,
        'display_tax_with_expect_to_pay_price': displayTaxWithExpectToPayPrice,
      };
}

/// The `social_sharing` block — whether share buttons appear, which networks
/// they cover and the title shown beside them.
class SocialSharing extends Dto {
  const SocialSharing({
    this.enableShareOnSocialMedia,
    this.facebook,
    this.twitter,
    this.pinterest,
    this.messenger,
    this.linkedin,
    this.email,
    this.snapchat,
    this.telegram,
    this.reddit,
    this.instagram,
    this.youtube,
    this.tiktok,
    this.threads,
    this.whatsapp,
    this.bluesky,
    this.mastodon,
    this.copyLink,
    this.displayTitle,
    this.title,
  });

  static SocialSharing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SocialSharing(
      enableShareOnSocialMedia:
          readFlag(source['enable_share_on_social_media']),
      facebook: readFlag(source['facebook']),
      twitter: readFlag(source['twitter']),
      pinterest: readFlag(source['pinterest']),
      messenger: readFlag(source['messenger']),
      linkedin: readFlag(source['linkedin']),
      email: readFlag(source['email']),
      snapchat: readFlag(source['snapchat']),
      telegram: readFlag(source['telegram']),
      reddit: readFlag(source['reddit']),
      instagram: readFlag(source['instagram']),
      youtube: readFlag(source['youtube']),
      tiktok: readFlag(source['tiktok']),
      threads: readFlag(source['threads']),
      whatsapp: readFlag(source['whatsapp']),
      bluesky: readFlag(source['bluesky']),
      mastodon: readFlag(source['mastodon']),
      copyLink: readFlag(source['copy_link']),
      displayTitle: readFlag(source['display_title']),
      title: readText(source['title']),
    );
  }

  final bool? enableShareOnSocialMedia;

  final bool? facebook;

  final bool? twitter;

  final bool? pinterest;

  final bool? messenger;

  final bool? linkedin;

  final bool? email;

  final bool? snapchat;

  final bool? telegram;

  final bool? reddit;

  final bool? instagram;

  final bool? youtube;

  final bool? tiktok;

  final bool? threads;

  final bool? whatsapp;

  final bool? bluesky;

  final bool? mastodon;

  final bool? copyLink;

  final bool? displayTitle;

  /// `title` — the heading beside the share buttons.
  final String? title;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_share_on_social_media': enableShareOnSocialMedia,
        'facebook': facebook,
        'twitter': twitter,
        'pinterest': pinterest,
        'messenger': messenger,
        'linkedin': linkedin,
        'email': email,
        'snapchat': snapchat,
        'telegram': telegram,
        'reddit': reddit,
        'instagram': instagram,
        'youtube': youtube,
        'tiktok': tiktok,
        'threads': threads,
        'whatsapp': whatsapp,
        'bluesky': bluesky,
        'mastodon': mastodon,
        'copy_link': copyLink,
        'display_title': displayTitle,
        'title': title,
      };
}

/// The `set_product_properties` block — which physical properties a product
/// page lists.
class SetProductProperties extends Dto {
  const SetProductProperties({
    this.displayHeight,
    this.displayWidth,
    this.displayLength,
    this.displayWeight,
    this.displayAddToGiftRegistry,
  });

  static SetProductProperties? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SetProductProperties(
      displayHeight: readFlag(source['display_height']),
      displayWidth: readFlag(source['display_width']),
      displayLength: readFlag(source['display_length']),
      displayWeight: readFlag(source['display_weight']),
      displayAddToGiftRegistry:
          readFlag(source['display_add_to_gift_registry']),
    );
  }

  final bool? displayHeight;

  final bool? displayWidth;

  final bool? displayLength;

  final bool? displayWeight;

  final bool? displayAddToGiftRegistry;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'display_height': displayHeight,
        'display_width': displayWidth,
        'display_length': displayLength,
        'display_weight': displayWeight,
        'display_add_to_gift_registry': displayAddToGiftRegistry,
      };
}

/// The `configuration` section — what the product page itself shows, in four
/// blocks.
class Configuration extends Dto {
  const Configuration({
    this.actionsButtons,
    this.details,
    this.socialSharing,
    this.setProductProperties,
  });

  static Configuration? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'configuration');
    if (source == null) return null;
    return Configuration(
      actionsButtons: ActionButtons.fromMap(source['actions_buttons']),
      details: ProductDetails.fromMap(source['details']),
      socialSharing: SocialSharing.fromMap(source['social_sharing']),
      setProductProperties:
          SetProductProperties.fromMap(source['set_product_properties']),
    );
  }

  final ActionButtons? actionsButtons;

  final ProductDetails? details;

  final SocialSharing? socialSharing;

  final SetProductProperties? setProductProperties;

  @override
  String? get envelopeKey => 'configuration';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'actions_buttons': actionsButtons,
        'details': details,
        'social_sharing': socialSharing,
        'set_product_properties': setProductProperties,
      };
}

/// The `labels_and_display` block — how a variation is labelled and drawn.
class LabelsAndDisplay extends Dto {
  const LabelsAndDisplay({
    this.disableVariationLabelForPrice,
    this.displayProductImageAsVariationIcons,
    this.displaySelectedVariationValue,
    this.enableColourTypeVariationImageDisplay,
    this.useStrikeThroughForOutOfStockVariations,
    this.enableSingleClickVariationLoading,
  });

  static LabelsAndDisplay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return LabelsAndDisplay(
      disableVariationLabelForPrice:
          readFlag(source['disable_variation_label_for_price']),
      displayProductImageAsVariationIcons:
          readFlag(source['display_product_image_as_variation_icons']),
      displaySelectedVariationValue:
          readFlag(source['display_selected_variation_value']),
      enableColourTypeVariationImageDisplay:
          readFlag(source['enable_colour_type_variation_image_display']),
      useStrikeThroughForOutOfStockVariations:
          readFlag(source['use_strike_through_for_out_of_stock_variations']),
      enableSingleClickVariationLoading:
          readFlag(source['enable_single_click_variation_loading']),
    );
  }

  final bool? disableVariationLabelForPrice;

  final bool? displayProductImageAsVariationIcons;

  final bool? displaySelectedVariationValue;

  final bool? enableColourTypeVariationImageDisplay;

  final bool? useStrikeThroughForOutOfStockVariations;

  final bool? enableSingleClickVariationLoading;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'disable_variation_label_for_price': disableVariationLabelForPrice,
        'display_product_image_as_variation_icons':
            displayProductImageAsVariationIcons,
        'display_selected_variation_value': displaySelectedVariationValue,
        'enable_colour_type_variation_image_display':
            enableColourTypeVariationImageDisplay,
        'use_strike_through_for_out_of_stock_variations':
            useStrikeThroughForOutOfStockVariations,
        'enable_single_click_variation_loading':
            enableSingleClickVariationLoading,
      };
}

/// One entry of `layout.variation_combinations` — a variation type the store
/// already defines, by [id] and [name].
class ProductPageVariationType extends Dto {
  const ProductPageVariationType({this.id, this.name});

  static ProductPageVariationType? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPageVariationType(
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

/// The `layout` block — how variations are laid out and which price is shown.
class VariationLayout extends Dto {
  const VariationLayout({
    this.selectVariationView,
    this.selectVariationViewType,
    this.displayVariationCombinations,
    this.variationCombinations,
    this.variationPriceDisplayMode,
    this.variationPriceDisplayType,
  });

  static VariationLayout? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return VariationLayout(
      selectVariationView: readFlag(source['select_variation_view']),
      selectVariationViewType: readText(source['select_variation_view_type']),
      displayVariationCombinations:
          readFlag(source['display_variation_combinations']),
      variationCombinations: readList<ProductPageVariationType>(
          source['variation_combinations'], ProductPageVariationType.fromMap),
      variationPriceDisplayMode:
          readFlag(source['variation_price_display_mode']),
      variationPriceDisplayType:
          readText(source['variation_price_display_type']),
    );
  }

  final bool? selectVariationView;

  final String? selectVariationViewType;

  final bool? displayVariationCombinations;

  final List<ProductPageVariationType?>? variationCombinations;

  final bool? variationPriceDisplayMode;

  final String? variationPriceDisplayType;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'select_variation_view': selectVariationView,
        'select_variation_view_type': selectVariationViewType,
        'display_variation_combinations': displayVariationCombinations,
        'variation_combinations': variationCombinations,
        'variation_price_display_mode': variationPriceDisplayMode,
        'variation_price_display_type': variationPriceDisplayType,
      };
}

/// The `variations` section — how a product's variations are labelled and laid
/// out.
class Variations extends Dto {
  const Variations({this.labelsAndDisplay, this.layout});

  static Variations? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'variations');
    if (source == null) return null;
    return Variations(
      labelsAndDisplay: LabelsAndDisplay.fromMap(source['labels_and_display']),
      layout: VariationLayout.fromMap(source['layout']),
    );
  }

  final LabelsAndDisplay? labelsAndDisplay;

  final VariationLayout? layout;

  @override
  String? get envelopeKey => 'variations';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'labels_and_display': labelsAndDisplay,
        'layout': layout,
      };
}

/// The `image_display` block — how product images are laid out and zoomed.
class ImageDisplay extends Dto {
  const ImageDisplay({
    this.enableImageSlider,
    this.productThumbnailVerticalView,
    this.productImageView,
    this.productImageViewType,
    this.imageZoomType,
    this.zoomType,
  });

  static ImageDisplay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ImageDisplay(
      enableImageSlider: readFlag(source['enable_image_slider']),
      productThumbnailVerticalView:
          readFlag(source['product_thumbnail_vertical_view']),
      productImageView: readFlag(source['product_image_view']),
      productImageViewType: readText(source['product_image_view_type']),
      imageZoomType: readFlag(source['image_zoom_type']),
      zoomType: readText(source['zoom_type']),
    );
  }

  final bool? enableImageSlider;

  final bool? productThumbnailVerticalView;

  final bool? productImageView;

  final String? productImageViewType;

  final bool? imageZoomType;

  final String? zoomType;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_image_slider': enableImageSlider,
        'product_thumbnail_vertical_view': productThumbnailVerticalView,
        'product_image_view': productImageView,
        'product_image_view_type': productImageViewType,
        'image_zoom_type': imageZoomType,
        'zoom_type': zoomType,
      };
}

/// The `video` block — whether a product video is previewed and where its
/// thumbnail sits.
class ProductVideo extends Dto {
  const ProductVideo({
    this.enableVideoPreview,
    this.displayVideoThumbnailInFirstOrder,
  });

  static ProductVideo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductVideo(
      enableVideoPreview: readFlag(source['enable_video_preview']),
      displayVideoThumbnailInFirstOrder:
          readFlag(source['display_video_thumbnail_in_first_order']),
    );
  }

  final bool? enableVideoPreview;

  final bool? displayVideoThumbnailInFirstOrder;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_video_preview': enableVideoPreview,
        'display_video_thumbnail_in_first_order':
            displayVideoThumbnailInFirstOrder,
      };
}

/// The `image_and_video` section — one field of its own beside two blocks.
class ImageAndVideo extends Dto {
  const ImageAndVideo({
    this.allowSingleFileUploadPerProduct,
    this.imageDisplay,
    this.video,
  });

  static ImageAndVideo? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'image_and_video');
    if (source == null) return null;
    return ImageAndVideo(
      allowSingleFileUploadPerProduct:
          readFlag(source['allow_single_file_upload_per_product']),
      imageDisplay: ImageDisplay.fromMap(source['image_display']),
      video: ProductVideo.fromMap(source['video']),
    );
  }

  final bool? allowSingleFileUploadPerProduct;

  final ImageDisplay? imageDisplay;

  final ProductVideo? video;

  @override
  String? get envelopeKey => 'image_and_video';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'allow_single_file_upload_per_product': allowSingleFileUploadPerProduct,
        'image_display': imageDisplay,
        'video': video,
      };
}

/// The fields a product listing on this page carries.
class ProductListing extends Dto {
  const ProductListing({
    this.numberOfProducts,
    this.allowViewersToChangeDisplayMode,
    this.gridView,
    this.listView,
    this.tabularView,
    this.selectDisplayType,
    this.maximumNumberOfColumnsPerRow,
    this.maximumNumberOfColumnsPerRowList,
    this.shortDescription,
    this.displayOnHover,
    this.displayAddToCartButton,
    this.displayAddToCompareButton,
    this.displayAddToWishlistButton,
    this.price,
    this.showExpectToPayPrice,
    this.displayRating,
    this.displayReviewCount,
  });

  final int? numberOfProducts;

  final bool? allowViewersToChangeDisplayMode;

  final bool? gridView;

  final bool? listView;

  final bool? tabularView;

  final String? selectDisplayType;

  final int? maximumNumberOfColumnsPerRow;

  final int? maximumNumberOfColumnsPerRowList;

  final bool? shortDescription;

  final bool? displayOnHover;

  final bool? displayAddToCartButton;

  final bool? displayAddToCompareButton;

  final bool? displayAddToWishlistButton;

  final bool? price;

  final bool? showExpectToPayPrice;

  final bool? displayRating;

  final bool? displayReviewCount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'number_of_products': numberOfProducts,
        'allow_viewers_to_change_display_mode': allowViewersToChangeDisplayMode,
        'grid_view': gridView,
        'list_view': listView,
        'tabular_view': tabularView,
        'select_display_type': selectDisplayType,
        'maximum_number_of_columns_per_row': maximumNumberOfColumnsPerRow,
        'maximum_number_of_columns_per_row_list':
            maximumNumberOfColumnsPerRowList,
        'short_description': shortDescription,
        'display_on_hover': displayOnHover,
        'display_add_to_cart_button': displayAddToCartButton,
        'display_add_to_compare_button': displayAddToCompareButton,
        'display_add_to_wishlist_button': displayAddToWishlistButton,
        'price': price,
        'show_expect_to_pay_price': showExpectToPayPrice,
        'display_rating': displayRating,
        'display_review_count': displayReviewCount,
      };
}

/// The `up_sell` section — the up-sell listing, a flat [ProductListing].
class UpSell extends ProductListing {
  const UpSell({
    super.numberOfProducts,
    super.allowViewersToChangeDisplayMode,
    super.gridView,
    super.listView,
    super.tabularView,
    super.selectDisplayType,
    super.maximumNumberOfColumnsPerRow,
    super.maximumNumberOfColumnsPerRowList,
    super.shortDescription,
    super.displayOnHover,
    super.displayAddToCartButton,
    super.displayAddToCompareButton,
    super.displayAddToWishlistButton,
    super.price,
    super.showExpectToPayPrice,
    super.displayRating,
    super.displayReviewCount,
  });

  static UpSell? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'up_sell');
    if (source == null) return null;
    return UpSell(
      numberOfProducts: readInteger(source['number_of_products']),
      allowViewersToChangeDisplayMode:
          readFlag(source['allow_viewers_to_change_display_mode']),
      gridView: readFlag(source['grid_view']),
      listView: readFlag(source['list_view']),
      tabularView: readFlag(source['tabular_view']),
      selectDisplayType: readText(source['select_display_type']),
      maximumNumberOfColumnsPerRow:
          readInteger(source['maximum_number_of_columns_per_row']),
      maximumNumberOfColumnsPerRowList:
          readInteger(source['maximum_number_of_columns_per_row_list']),
      shortDescription: readFlag(source['short_description']),
      displayOnHover: readFlag(source['display_on_hover']),
      displayAddToCartButton: readFlag(source['display_add_to_cart_button']),
      displayAddToCompareButton:
          readFlag(source['display_add_to_compare_button']),
      displayAddToWishlistButton:
          readFlag(source['display_add_to_wishlist_button']),
      price: readFlag(source['price']),
      showExpectToPayPrice: readFlag(source['show_expect_to_pay_price']),
      displayRating: readFlag(source['display_rating']),
      displayReviewCount: readFlag(source['display_review_count']),
    );
  }

  @override
  String? get envelopeKey => 'up_sell';
}

/// The `related_products` section — the related-products listing, a flat
/// [ProductListing].
class RelatedProducts extends ProductListing {
  const RelatedProducts({
    super.numberOfProducts,
    super.allowViewersToChangeDisplayMode,
    super.gridView,
    super.listView,
    super.tabularView,
    super.selectDisplayType,
    super.maximumNumberOfColumnsPerRow,
    super.maximumNumberOfColumnsPerRowList,
    super.shortDescription,
    super.displayOnHover,
    super.displayAddToCartButton,
    super.displayAddToCompareButton,
    super.displayAddToWishlistButton,
    super.price,
    super.showExpectToPayPrice,
    super.displayRating,
    super.displayReviewCount,
  });

  static RelatedProducts? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'related_products');
    if (source == null) return null;
    return RelatedProducts(
      numberOfProducts: readInteger(source['number_of_products']),
      allowViewersToChangeDisplayMode:
          readFlag(source['allow_viewers_to_change_display_mode']),
      gridView: readFlag(source['grid_view']),
      listView: readFlag(source['list_view']),
      tabularView: readFlag(source['tabular_view']),
      selectDisplayType: readText(source['select_display_type']),
      maximumNumberOfColumnsPerRow:
          readInteger(source['maximum_number_of_columns_per_row']),
      maximumNumberOfColumnsPerRowList:
          readInteger(source['maximum_number_of_columns_per_row_list']),
      shortDescription: readFlag(source['short_description']),
      displayOnHover: readFlag(source['display_on_hover']),
      displayAddToCartButton: readFlag(source['display_add_to_cart_button']),
      displayAddToCompareButton:
          readFlag(source['display_add_to_compare_button']),
      displayAddToWishlistButton:
          readFlag(source['display_add_to_wishlist_button']),
      price: readFlag(source['price']),
      showExpectToPayPrice: readFlag(source['show_expect_to_pay_price']),
      displayRating: readFlag(source['display_rating']),
      displayReviewCount: readFlag(source['display_review_count']),
    );
  }

  @override
  String? get envelopeKey => 'related_products';
}

/// The `capabilities` block — what the review plugin makes available.
class ReviewCapabilities extends Dto {
  const ReviewCapabilities({this.available});

  static ReviewCapabilities? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReviewCapabilities(available: readFlag(source['available']));
  }

  final bool? available;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'available': available,
      };
}

/// The `review_and_ratings` section — where reviews appear and which version
/// renders them, beside the plugin's own [ReviewCapabilities].
class ReviewAndRatings extends Dto {
  const ReviewAndRatings({
    this.capabilities,
    this.enableReviewInTab,
    this.enableNewVersion,
  });

  static ReviewAndRatings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'review_and_ratings');
    if (source == null) return null;
    return ReviewAndRatings(
      capabilities: ReviewCapabilities.fromMap(source['capabilities']),
      enableReviewInTab: readFlag(source['enable_review_in_tab']),
      enableNewVersion: readFlag(source['enable_new_version']),
    );
  }

  final ReviewCapabilities? capabilities;

  final bool? enableReviewInTab;

  final bool? enableNewVersion;

  @override
  String? get envelopeKey => 'review_and_ratings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'capabilities': capabilities,
        'enable_review_in_tab': enableReviewInTab,
        'enable_new_version': enableNewVersion,
      };
}

/// The `quick_view` section — the quick-view popup and what it shows.
class QuickView extends Dto {
  const QuickView({
    this.productQuickView,
    this.displayProductName,
    this.displaySku,
    this.displayProductRating,
    this.displayProductStock,
    this.displayProductVariation,
    this.displayProductImage,
    this.displayVariationImage,
    this.displayProductSummary,
    this.displayAddToCartButton,
    this.displayAddToCompareButton,
    this.displayAddToWishlistButton,
  });

  static QuickView? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'quick_view');
    if (source == null) return null;
    return QuickView(
      productQuickView: readFlag(source['product_quick_view']),
      displayProductName: readFlag(source['display_product_name']),
      displaySku: readFlag(source['display_sku']),
      displayProductRating: readFlag(source['display_product_rating']),
      displayProductStock: readFlag(source['display_product_stock']),
      displayProductVariation: readFlag(source['display_product_variation']),
      displayProductImage: readFlag(source['display_product_image']),
      displayVariationImage: readFlag(source['display_variation_image']),
      displayProductSummary: readFlag(source['display_product_summary']),
      displayAddToCartButton: readFlag(source['display_add_to_cart_button']),
      displayAddToCompareButton:
          readFlag(source['display_add_to_compare_button']),
      displayAddToWishlistButton:
          readFlag(source['display_add_to_wishlist_button']),
    );
  }

  final bool? productQuickView;

  final bool? displayProductName;

  final bool? displaySku;

  final bool? displayProductRating;

  final bool? displayProductStock;

  final bool? displayProductVariation;

  final bool? displayProductImage;

  final bool? displayVariationImage;

  final bool? displayProductSummary;

  final bool? displayAddToCartButton;

  final bool? displayAddToCompareButton;

  final bool? displayAddToWishlistButton;

  @override
  String? get envelopeKey => 'quick_view';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_quick_view': productQuickView,
        'display_product_name': displayProductName,
        'display_sku': displaySku,
        'display_product_rating': displayProductRating,
        'display_product_stock': displayProductStock,
        'display_product_variation': displayProductVariation,
        'display_product_image': displayProductImage,
        'display_variation_image': displayVariationImage,
        'display_product_summary': displayProductSummary,
        'display_add_to_cart_button': displayAddToCartButton,
        'display_add_to_compare_button': displayAddToCompareButton,
        'display_add_to_wishlist_button': displayAddToWishlistButton,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written, what
/// to call it and where it is managed.
class ProductPageSectionMeta extends Dto {
  const ProductPageSectionMeta({
    this.kind,
    this.writable,
    this.plugin,
    this.available,
    this.uiLabel,
    this.href,
  });

  static ProductPageSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPageSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      plugin: readText(source['plugin']),
      available: readFlag(source['available']),
      uiLabel: readText(source['ui_label']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on all seven entries here.
  final String? kind;

  final bool? writable;

  /// `plugin` — on the one entry a plugin backs, [available] beside it.
  final String? plugin;

  final bool? available;

  final String? uiLabel;

  /// `href` — the section's own path on this resource, for every entry.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'plugin': plugin,
        'available': available,
        'ui_label': uiLabel,
        'href': href,
      };
}

/// The `group_meta` block — one [ProductPageSectionMeta] per section the area
/// declares.
class ProductPageGroupMeta extends Dto {
  const ProductPageGroupMeta({
    this.configuration,
    this.variations,
    this.imageAndVideo,
    this.upSell,
    this.relatedProducts,
    this.reviewAndRatings,
    this.quickView,
  });

  static ProductPageGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductPageGroupMeta(
      configuration: ProductPageSectionMeta.fromMap(source['configuration']),
      variations: ProductPageSectionMeta.fromMap(source['variations']),
      imageAndVideo: ProductPageSectionMeta.fromMap(source['image_and_video']),
      upSell: ProductPageSectionMeta.fromMap(source['up_sell']),
      relatedProducts:
          ProductPageSectionMeta.fromMap(source['related_products']),
      reviewAndRatings:
          ProductPageSectionMeta.fromMap(source['review_and_ratings']),
      quickView: ProductPageSectionMeta.fromMap(source['quick_view']),
    );
  }

  final ProductPageSectionMeta? configuration;

  final ProductPageSectionMeta? variations;

  final ProductPageSectionMeta? imageAndVideo;

  final ProductPageSectionMeta? upSell;

  final ProductPageSectionMeta? relatedProducts;

  final ProductPageSectionMeta? reviewAndRatings;

  final ProductPageSectionMeta? quickView;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'configuration': configuration,
        'variations': variations,
        'image_and_video': imageAndVideo,
        'up_sell': upSell,
        'related_products': relatedProducts,
        'review_and_ratings': reviewAndRatings,
        'quick_view': quickView,
      };
}

/// The product page settings, as the facade or one section sends them.
class ProductPage extends Dto {
  const ProductPage({
    this.configuration,
    this.variations,
    this.imageAndVideo,
    this.upSell,
    this.relatedProducts,
    this.reviewAndRatings,
    this.quickView,
    this.groupMeta,
    this.fieldMetadata,
  });

  static ProductPage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'product_page');
    if (source == null) return null;
    return ProductPage(
      configuration: Configuration.fromMap(source['configuration']),
      variations: Variations.fromMap(source['variations']),
      imageAndVideo: ImageAndVideo.fromMap(source['image_and_video']),
      upSell: UpSell.fromMap(source['up_sell']),
      relatedProducts: RelatedProducts.fromMap(source['related_products']),
      reviewAndRatings: ReviewAndRatings.fromMap(source['review_and_ratings']),
      quickView: QuickView.fromMap(source['quick_view']),
      groupMeta: ProductPageGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final Configuration? configuration;

  final Variations? variations;

  final ImageAndVideo? imageAndVideo;

  final UpSell? upSell;

  final RelatedProducts? relatedProducts;

  final ReviewAndRatings? reviewAndRatings;

  final QuickView? quickView;

  /// `group_meta` — on the facade's answer only.
  final ProductPageGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type and
  /// the store nests the block the way the section it describes nests.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'product_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'configuration': configuration,
        'variations': variations,
        'image_and_video': imageAndVideo,
        'up_sell': upSell,
        'related_products': relatedProducts,
        'review_and_ratings': reviewAndRatings,
        'quick_view': quickView,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
