/// Typed views over the animation effects bodies.
library;

import '../../../client/dto.dart';

/// The uploaded loader that goes with `enable_custom_preloader`.
class CustomLoader extends Dto {
  const CustomLoader({this.enabled, this.fileName, this.fileUrl});

  static CustomLoader? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomLoader(
      enabled: readFlag(source['enabled']),
      fileName: readText(source['file_name']),
      fileUrl: readText(source['file_url']),
    );
  }

  final bool? enabled;

  final String? fileName;

  final String? fileUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'file_name': fileName,
        'file_url': fileUrl,
      };
}

/// One entry of `preloader_custom_page` as a read sends it.
class PreloaderPage extends Dto {
  const PreloaderPage({this.id, this.name});

  static PreloaderPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreloaderPage(
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

/// The `preloader_design` section — the loader shown while a page loads, and
/// when and where it shows.
class PreloaderDesign extends Dto {
  const PreloaderDesign({
    this.enablePreloader,
    this.enableCustomPreloader,
    this.preloaderPreset,
    this.preloaderSize,
    this.preloaderBackgroundOpacity,
    this.backgroundPreloader,
    this.preloaderHideCondition,
    this.preloaderShowTimeCondition,
    this.preloaderHideAfterTime,
    this.preloaderPage,
    this.preloaderCustomPage,
    this.customLoader,
  });

  static PreloaderDesign? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'preloader_design');
    if (source == null) return null;
    return PreloaderDesign(
      enablePreloader: readFlag(source['enable_preloader']),
      enableCustomPreloader: readFlag(source['enable_custom_preloader']),
      preloaderPreset: readText(source['preloader_preset']),
      preloaderSize: readInteger(source['preloader_size']),
      preloaderBackgroundOpacity:
          readDecimal(source['preloader_background_opacity']),
      backgroundPreloader: readText(source['background_preloader']),
      preloaderHideCondition: readText(source['preloader_hide_condition']),
      preloaderShowTimeCondition:
          readText(source['preloader_show_time_condition']),
      preloaderHideAfterTime: readDecimal(source['preloader_hide_after_time']),
      preloaderPage: readText(source['preloader_page']),
      preloaderCustomPage:
          readList(source['preloader_custom_page'], PreloaderPage.fromMap),
      customLoader: CustomLoader.fromMap(source['custom_loader']),
    );
  }

  final bool? enablePreloader;

  final bool? enableCustomPreloader;

  final String? preloaderPreset;

  final int? preloaderSize;

  final double? preloaderBackgroundOpacity;

  final String? backgroundPreloader;

  final String? preloaderHideCondition;

  final String? preloaderShowTimeCondition;

  final double? preloaderHideAfterTime;

  final String? preloaderPage;

  /// `preloader_custom_page` — the one list in this area.
  final List<PreloaderPage?>? preloaderCustomPage;

  /// `custom_loader` — read-only, and undescribed by `field_metadata`.
  final CustomLoader? customLoader;

  @override
  String? get envelopeKey => 'preloader_design';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_preloader': enablePreloader,
        'enable_custom_preloader': enableCustomPreloader,
        'preloader_preset': preloaderPreset,
        'preloader_size': preloaderSize,
        'preloader_background_opacity': preloaderBackgroundOpacity,
        'background_preloader': backgroundPreloader,
        'preloader_hide_condition': preloaderHideCondition,
        'preloader_show_time_condition': preloaderShowTimeCondition,
        'preloader_hide_after_time': preloaderHideAfterTime,
        'preloader_page': preloaderPage,
        'preloader_custom_page': preloaderCustomPage,
        'custom_loader': customLoader,
      };
}

/// The `widget_transition` section — whether widgets fade in, and over how
/// long.
class WidgetTransition extends Dto {
  const WidgetTransition(
      {this.widgetSmoothRender, this.widgetSmoothRenderDuration});

  static WidgetTransition? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'widget_transition');
    if (source == null) return null;
    return WidgetTransition(
      widgetSmoothRender: readFlag(source['widget_smooth_render']),
      widgetSmoothRenderDuration:
          readInteger(source['widget_smooth_render_duration']),
    );
  }

  final bool? widgetSmoothRender;

  final int? widgetSmoothRenderDuration;

  @override
  String? get envelopeKey => 'widget_transition';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'widget_smooth_render': widgetSmoothRender,
        'widget_smooth_render_duration': widgetSmoothRenderDuration,
      };
}

/// The `page_transition` section — the animation between pages and when it
/// plays.
class PageTransition extends Dto {
  const PageTransition({
    this.pageTransitionAnimationType,
    this.transitionAnimationDuration,
    this.animationBeforeEnteringNewPage,
    this.animationAfterEnteringNewPage,
  });

  static PageTransition? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'page_transition');
    if (source == null) return null;
    return PageTransition(
      pageTransitionAnimationType:
          readText(source['page_transition_animation_type']),
      transitionAnimationDuration:
          readDecimal(source['transition_animation_duration']),
      animationBeforeEnteringNewPage:
          readFlag(source['animation_before_entering_new_page']),
      animationAfterEnteringNewPage:
          readFlag(source['animation_after_entering_new_page']),
    );
  }

  final String? pageTransitionAnimationType;

  final double? transitionAnimationDuration;

  final bool? animationBeforeEnteringNewPage;

  final bool? animationAfterEnteringNewPage;

  @override
  String? get envelopeKey => 'page_transition';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page_transition_animation_type': pageTransitionAnimationType,
        'transition_animation_duration': transitionAnimationDuration,
        'animation_before_entering_new_page': animationBeforeEnteringNewPage,
        'animation_after_entering_new_page': animationAfterEnteringNewPage,
      };
}

/// The `image_lazy_effect` section — which listings and detail pages lazy-load
/// their images, and what stands in while one loads.
class ImageLazyEffect extends Dto {
  const ImageLazyEffect({
    this.preloaderImageLazyEffectPreset,
    this.productDetailsPageImageLazyEffect,
    this.flyingCartImageLazyEffect,
    this.productListImageLazyEffect,
    this.propertyListImageLazyEffect,
    this.propertyDetailsPageImageLazyEffect,
    this.blogListImageLazyEffect,
    this.blogDetailsPageImageLazyEffect,
    this.lazyLoaderSize,
    this.backgroundLazyLoader,
    this.contentImageLazyLoadBackground,
  });

  static ImageLazyEffect? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'image_lazy_effect');
    if (source == null) return null;
    return ImageLazyEffect(
      preloaderImageLazyEffectPreset:
          readText(source['preloader_image_lazy_effect_preset']),
      productDetailsPageImageLazyEffect:
          readFlag(source['product_details_page_image_lazy_effect']),
      flyingCartImageLazyEffect:
          readFlag(source['flying_cart_image_lazy_effect']),
      productListImageLazyEffect:
          readFlag(source['product_list_image_lazy_effect']),
      propertyListImageLazyEffect:
          readFlag(source['property_list_image_lazy_effect']),
      propertyDetailsPageImageLazyEffect:
          readFlag(source['property_details_page_image_lazy_effect']),
      blogListImageLazyEffect: readFlag(source['blog_list_image_lazy_effect']),
      blogDetailsPageImageLazyEffect:
          readFlag(source['blog_details_page_image_lazy_effect']),
      lazyLoaderSize: readInteger(source['lazy_loader_size']),
      backgroundLazyLoader: readText(source['background_lazy_loader']),
      contentImageLazyLoadBackground:
          readText(source['content_image_lazy_load_background']),
    );
  }

  final String? preloaderImageLazyEffectPreset;

  final bool? productDetailsPageImageLazyEffect;

  final bool? flyingCartImageLazyEffect;

  final bool? productListImageLazyEffect;

  final bool? propertyListImageLazyEffect;

  final bool? propertyDetailsPageImageLazyEffect;

  final bool? blogListImageLazyEffect;

  final bool? blogDetailsPageImageLazyEffect;

  final int? lazyLoaderSize;

  final String? backgroundLazyLoader;

  final String? contentImageLazyLoadBackground;

  @override
  String? get envelopeKey => 'image_lazy_effect';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'preloader_image_lazy_effect_preset': preloaderImageLazyEffectPreset,
        'product_details_page_image_lazy_effect':
            productDetailsPageImageLazyEffect,
        'flying_cart_image_lazy_effect': flyingCartImageLazyEffect,
        'product_list_image_lazy_effect': productListImageLazyEffect,
        'property_list_image_lazy_effect': propertyListImageLazyEffect,
        'property_details_page_image_lazy_effect':
            propertyDetailsPageImageLazyEffect,
        'blog_list_image_lazy_effect': blogListImageLazyEffect,
        'blog_details_page_image_lazy_effect': blogDetailsPageImageLazyEffect,
        'lazy_loader_size': lazyLoaderSize,
        'background_lazy_loader': backgroundLazyLoader,
        'content_image_lazy_load_background': contentImageLazyLoadBackground,
      };
}

/// The `page_skeleton` section — the one-field section of this area.
class PageSkeleton extends Dto {
  const PageSkeleton({this.checkoutPageSkeleton});

  static PageSkeleton? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'page_skeleton');
    if (source == null) return null;
    return PageSkeleton(
        checkoutPageSkeleton: readFlag(source['checkout_page_skeleton']));
  }

  final bool? checkoutPageSkeleton;

  @override
  String? get envelopeKey => 'page_skeleton';

  @override
  Map<String, Object?> get fields =>
      <String, Object?>{'checkout_page_skeleton': checkoutPageSkeleton};
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class AnimationEffectsSectionMeta extends Dto {
  const AnimationEffectsSectionMeta({this.kind, this.writable, this.href});

  static AnimationEffectsSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AnimationEffectsSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on all five entries here.
  final String? kind;

  /// `writable` — `true` on all five entries here.
  final bool? writable;

  /// `href` — the section's own path on this resource, for all five entries.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [AnimationEffectsSectionMeta] per section the
/// area declares.
class AnimationEffectsGroupMeta extends Dto {
  const AnimationEffectsGroupMeta({
    this.preloaderDesign,
    this.widgetTransition,
    this.pageTransition,
    this.imageLazyEffect,
    this.pageSkeleton,
  });

  static AnimationEffectsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AnimationEffectsGroupMeta(
      preloaderDesign:
          AnimationEffectsSectionMeta.fromMap(source['preloader_design']),
      widgetTransition:
          AnimationEffectsSectionMeta.fromMap(source['widget_transition']),
      pageTransition:
          AnimationEffectsSectionMeta.fromMap(source['page_transition']),
      imageLazyEffect:
          AnimationEffectsSectionMeta.fromMap(source['image_lazy_effect']),
      pageSkeleton:
          AnimationEffectsSectionMeta.fromMap(source['page_skeleton']),
    );
  }

  final AnimationEffectsSectionMeta? preloaderDesign;

  final AnimationEffectsSectionMeta? widgetTransition;

  final AnimationEffectsSectionMeta? pageTransition;

  final AnimationEffectsSectionMeta? imageLazyEffect;

  final AnimationEffectsSectionMeta? pageSkeleton;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'preloader_design': preloaderDesign,
        'widget_transition': widgetTransition,
        'page_transition': pageTransition,
        'image_lazy_effect': imageLazyEffect,
        'page_skeleton': pageSkeleton,
      };
}

/// The animation effects settings, as the facade or one section sends them.
class AnimationEffects extends Dto {
  const AnimationEffects({
    this.preloaderDesign,
    this.widgetTransition,
    this.pageTransition,
    this.imageLazyEffect,
    this.pageSkeleton,
    this.groupMeta,
    this.fieldMetadata,
  });

  static AnimationEffects? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'animation_effects');
    if (source == null) return null;
    return AnimationEffects(
      preloaderDesign: PreloaderDesign.fromMap(source['preloader_design']),
      widgetTransition: WidgetTransition.fromMap(source['widget_transition']),
      pageTransition: PageTransition.fromMap(source['page_transition']),
      imageLazyEffect: ImageLazyEffect.fromMap(source['image_lazy_effect']),
      pageSkeleton: PageSkeleton.fromMap(source['page_skeleton']),
      groupMeta: AnimationEffectsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final PreloaderDesign? preloaderDesign;

  final WidgetTransition? widgetTransition;

  final PageTransition? pageTransition;

  final ImageLazyEffect? imageLazyEffect;

  final PageSkeleton? pageSkeleton;

  /// `group_meta` — on the facade's answer only.
  final AnimationEffectsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'animation_effects';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'preloader_design': preloaderDesign,
        'widget_transition': widgetTransition,
        'page_transition': pageTransition,
        'image_lazy_effect': imageLazyEffect,
        'page_skeleton': pageSkeleton,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
