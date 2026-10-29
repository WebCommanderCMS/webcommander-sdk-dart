/// Typed views over the shopping cart settings bodies.
library;

import '../../../client/dto.dart';

/// The `cart_page` section — what the cart page itself offers a shopper.
class CartPage extends Dto {
  const CartPage({
    this.showProductThumbnail,
    this.enableClearCart,
    this.saveCart,
  });

  static CartPage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'cart_page');
    if (source == null) return null;
    return CartPage(
      showProductThumbnail: readFlag(source['show_product_thumbnail']),
      enableClearCart: readFlag(source['enable_clear_cart']),
      saveCart: readFlag(source['save_cart']),
    );
  }

  final bool? showProductThumbnail;

  final bool? enableClearCart;

  final bool? saveCart;

  @override
  String? get envelopeKey => 'cart_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_product_thumbnail': showProductThumbnail,
        'enable_clear_cart': enableClearCart,
        'save_cart': saveCart,
      };
}

/// The `flying_cart` section — the slide-out cart and what it offers.
class FlyingCart extends Dto {
  const FlyingCart({this.enabled, this.enableClearCart, this.saveCart});

  static FlyingCart? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'flying_cart');
    if (source == null) return null;
    return FlyingCart(
      enabled: readFlag(source['enabled']),
      enableClearCart: readFlag(source['enable_clear_cart']),
      saveCart: readFlag(source['save_cart']),
    );
  }

  final bool? enabled;

  final bool? enableClearCart;

  final bool? saveCart;

  @override
  String? get envelopeKey => 'flying_cart';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'enable_clear_cart': enableClearCart,
        'save_cart': saveCart,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written, and
/// where it is managed.
class ShoppingCartSectionMeta extends Dto {
  const ShoppingCartSectionMeta({this.kind, this.writable, this.href});

  static ShoppingCartSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShoppingCartSectionMeta(
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

/// The `group_meta` block — one [ShoppingCartSectionMeta] per section the area
/// declares.
class ShoppingCartGroupMeta extends Dto {
  const ShoppingCartGroupMeta({this.cartPage, this.flyingCart});

  static ShoppingCartGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShoppingCartGroupMeta(
      cartPage: ShoppingCartSectionMeta.fromMap(source['cart_page']),
      flyingCart: ShoppingCartSectionMeta.fromMap(source['flying_cart']),
    );
  }

  final ShoppingCartSectionMeta? cartPage;

  final ShoppingCartSectionMeta? flyingCart;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cart_page': cartPage,
        'flying_cart': flyingCart,
      };
}

/// The shopping cart settings, as the facade or one section sends them.
class ShoppingCart extends Dto {
  const ShoppingCart({
    this.cartPage,
    this.flyingCart,
    this.groupMeta,
    this.fieldMetadata,
  });

  static ShoppingCart? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shopping_cart');
    if (source == null) return null;
    return ShoppingCart(
      cartPage: CartPage.fromMap(source['cart_page']),
      flyingCart: FlyingCart.fromMap(source['flying_cart']),
      groupMeta: ShoppingCartGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final CartPage? cartPage;

  final FlyingCart? flyingCart;

  /// `group_meta` — on the facade's answer only.
  final ShoppingCartGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because the store keys it differently in the
  /// two forms: by section on the facade, by field name on a section.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'shopping_cart';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cart_page': cartPage,
        'flying_cart': flyingCart,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
