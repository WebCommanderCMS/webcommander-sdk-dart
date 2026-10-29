/// Typed views over the price display settings bodies.
library;

import '../../../client/dto.dart';

/// The storefront surfaces one setting applies to.
class DisplayScopes extends Dto {
  const DisplayScopes({this.shoppingCart, this.checkout, this.orderSuccess});

  static DisplayScopes? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DisplayScopes(
      shoppingCart: readFlag(source['shopping_cart']),
      checkout: readFlag(source['checkout']),
      orderSuccess: readFlag(source['order_success']),
    );
  }

  final bool? shoppingCart;

  final bool? checkout;

  final bool? orderSuccess;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shopping_cart': shoppingCart,
        'checkout': checkout,
        'order_success': orderSuccess,
      };
}

/// A setting with a master switch and optional per-surface control: [enabled]
/// on its own, or [customize] on and [scopes] chosen surface by surface.
class ScopedToggle extends Dto {
  const ScopedToggle({this.enabled, this.customize, this.scopes});

  static ScopedToggle? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ScopedToggle(
      enabled: readFlag(source['enabled']),
      customize: readFlag(source['customize']),
      scopes: DisplayScopes.fromMap(source['scopes']),
    );
  }

  final bool? enabled;

  final bool? customize;

  /// `scopes` — computed rather than stored while [customize] is off, when it
  /// follows [enabled].
  final DisplayScopes? scopes;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'customize': customize,
        'scopes': scopes,
      };
}

/// A setting with nothing but a master switch.
class PlainToggle extends Dto {
  const PlainToggle({this.enabled});

  static PlainToggle? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PlainToggle(enabled: readFlag(source['enabled']));
  }

  final bool? enabled;

  @override
  Map<String, Object?> get fields => <String, Object?>{'enabled': enabled};
}

/// The `subtotal` block — where the subtotal line is shown, and whether it
/// carries tax and discount.
class Subtotal extends Dto {
  const Subtotal({this.show, this.includeTax, this.includeDiscount});

  static Subtotal? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Subtotal(
      show: DisplayScopes.fromMap(source['show']),
      includeTax: ScopedToggle.fromMap(source['include_tax']),
      includeDiscount: ScopedToggle.fromMap(source['include_discount']),
    );
  }

  final DisplayScopes? show;

  final ScopedToggle? includeTax;

  final ScopedToggle? includeDiscount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show': show,
        'include_tax': includeTax,
        'include_discount': includeDiscount,
      };
}

/// The `discount` block — where the discount line is shown, whether it is
/// hidden at zero and whether it carries tax.
class Discount extends Dto {
  const Discount({this.show, this.hideIfZero, this.includeTax});

  static Discount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Discount(
      show: DisplayScopes.fromMap(source['show']),
      hideIfZero: ScopedToggle.fromMap(source['hide_if_zero']),
      includeTax: ScopedToggle.fromMap(source['include_tax']),
    );
  }

  final DisplayScopes? show;

  final ScopedToggle? hideIfZero;

  final ScopedToggle? includeTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show': show,
        'hide_if_zero': hideIfZero,
        'include_tax': includeTax,
      };
}

/// The `shipping_cost` block — where the shipping line is shown, and whether it
/// carries tax and discount.
class ShippingCost extends Dto {
  const ShippingCost({this.show, this.includeTax, this.includeDiscount});

  static ShippingCost? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingCost(
      show: DisplayScopes.fromMap(source['show']),
      includeTax: ScopedToggle.fromMap(source['include_tax']),
      includeDiscount: ScopedToggle.fromMap(source['include_discount']),
    );
  }

  final DisplayScopes? show;

  final ScopedToggle? includeTax;

  final ScopedToggle? includeDiscount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show': show,
        'include_tax': includeTax,
        'include_discount': includeDiscount,
      };
}

/// The `shipping_discount` block — where the shipping discount line is shown,
/// whether it carries tax, and the shipping tax line's own switch.
class ShippingDiscount extends Dto {
  const ShippingDiscount({this.show, this.includeTax, this.shippingTax});

  static ShippingDiscount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingDiscount(
      show: DisplayScopes.fromMap(source['show']),
      includeTax: ScopedToggle.fromMap(source['include_tax']),
      shippingTax: PlainToggle.fromMap(source['shipping_tax']),
    );
  }

  final DisplayScopes? show;

  final ScopedToggle? includeTax;

  final PlainToggle? shippingTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show': show,
        'include_tax': includeTax,
        'shipping_tax': shippingTax,
      };
}

/// The `handling` block — whether handling is shown apart from shipping, and
/// the two tax settings that go with it.
class Handling extends Dto {
  const Handling({this.showSeparately, this.includeTax, this.handlingTax});

  static Handling? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Handling(
      showSeparately: DisplayScopes.fromMap(source['show_separately']),
      includeTax: ScopedToggle.fromMap(source['include_tax']),
      handlingTax: ScopedToggle.fromMap(source['handling_tax']),
    );
  }

  final DisplayScopes? showSeparately;

  final ScopedToggle? includeTax;

  final ScopedToggle? handlingTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_separately': showSeparately,
        'include_tax': includeTax,
        'handling_tax': handlingTax,
      };
}

/// The `pricing_info` block — a note shown after the total, and whether the due
/// amount is hidden on the order success page.
class PricingInfo extends Dto {
  const PricingInfo({
    this.enabled,
    this.text,
    this.customize,
    this.scopes,
    this.doNotShowDueAmount,
  });

  static PricingInfo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PricingInfo(
      enabled: readFlag(source['enabled']),
      text: readText(source['text']),
      customize: readFlag(source['customize']),
      scopes: DisplayScopes.fromMap(source['scopes']),
      doNotShowDueAmount: readFlag(source['do_not_show_due_amount']),
    );
  }

  final bool? enabled;

  /// `text` — its length is bounded by `field_metadata`.
  final String? text;

  final bool? customize;

  final DisplayScopes? scopes;

  final bool? doNotShowDueAmount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'text': text,
        'customize': customize,
        'scopes': scopes,
        'do_not_show_due_amount': doNotShowDueAmount,
      };
}

/// The `order_item` section — how a line item's own price is displayed, in five
/// [ScopedToggle] blocks.
class OrderItem extends Dto {
  const OrderItem({
    this.priceIncludingTax,
    this.priceIncludingDiscount,
    this.taxInLine,
    this.discountInLineItem,
    this.itemTotalIncludingTax,
  });

  static OrderItem? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_item');
    if (source == null) return null;
    return OrderItem(
      priceIncludingTax: ScopedToggle.fromMap(source['price_including_tax']),
      priceIncludingDiscount:
          ScopedToggle.fromMap(source['price_including_discount']),
      taxInLine: ScopedToggle.fromMap(source['tax_in_line']),
      discountInLineItem: ScopedToggle.fromMap(source['discount_in_line_item']),
      itemTotalIncludingTax:
          ScopedToggle.fromMap(source['item_total_including_tax']),
    );
  }

  final ScopedToggle? priceIncludingTax;

  final ScopedToggle? priceIncludingDiscount;

  final ScopedToggle? taxInLine;

  final ScopedToggle? discountInLineItem;

  final ScopedToggle? itemTotalIncludingTax;

  @override
  String? get envelopeKey => 'order_item';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'price_including_tax': priceIncludingTax,
        'price_including_discount': priceIncludingDiscount,
        'tax_in_line': taxInLine,
        'discount_in_line_item': discountInLineItem,
        'item_total_including_tax': itemTotalIncludingTax,
      };
}

/// The `order_summary` section — which lines the summary panel shows and what
/// each one includes.
class PriceDisplaySettingsOrderSummary extends Dto {
  const PriceDisplaySettingsOrderSummary({
    this.orderTotalExcludingTax,
    this.orderTotalIncludingDiscount,
    this.subtotal,
    this.discount,
    this.subtotalTax,
    this.totalTax,
    this.orderTotal,
    this.shippingCost,
    this.shippingDiscount,
    this.handling,
    this.paymentSurcharge,
    this.pricingInfo,
  });

  static PriceDisplaySettingsOrderSummary? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_summary');
    if (source == null) return null;
    return PriceDisplaySettingsOrderSummary(
      orderTotalExcludingTax:
          ScopedToggle.fromMap(source['order_total_excluding_tax']),
      orderTotalIncludingDiscount:
          ScopedToggle.fromMap(source['order_total_including_discount']),
      subtotal: Subtotal.fromMap(source['subtotal']),
      discount: Discount.fromMap(source['discount']),
      subtotalTax: PlainToggle.fromMap(source['subtotal_tax']),
      totalTax: PlainToggle.fromMap(source['total_tax']),
      orderTotal: PlainToggle.fromMap(source['order_total']),
      shippingCost: ShippingCost.fromMap(source['shipping_cost']),
      shippingDiscount: ShippingDiscount.fromMap(source['shipping_discount']),
      handling: Handling.fromMap(source['handling']),
      paymentSurcharge: ScopedToggle.fromMap(source['payment_surcharge']),
      pricingInfo: PricingInfo.fromMap(source['pricing_info']),
    );
  }

  final ScopedToggle? orderTotalExcludingTax;

  final ScopedToggle? orderTotalIncludingDiscount;

  final Subtotal? subtotal;

  final Discount? discount;

  final PlainToggle? subtotalTax;

  final PlainToggle? totalTax;

  final PlainToggle? orderTotal;

  final ShippingCost? shippingCost;

  final ShippingDiscount? shippingDiscount;

  final Handling? handling;

  final ScopedToggle? paymentSurcharge;

  final PricingInfo? pricingInfo;

  @override
  String? get envelopeKey => 'order_summary';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_total_excluding_tax': orderTotalExcludingTax,
        'order_total_including_discount': orderTotalIncludingDiscount,
        'subtotal': subtotal,
        'discount': discount,
        'subtotal_tax': subtotalTax,
        'total_tax': totalTax,
        'order_total': orderTotal,
        'shipping_cost': shippingCost,
        'shipping_discount': shippingDiscount,
        'handling': handling,
        'payment_surcharge': paymentSurcharge,
        'pricing_info': pricingInfo,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class PriceDisplaySettingsSectionMeta extends Dto {
  const PriceDisplaySettingsSectionMeta({this.kind, this.writable, this.href});

  static PriceDisplaySettingsSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PriceDisplaySettingsSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on both entries here.
  final String? kind;

  /// `writable` — `true` on both entries here.
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

/// The `group_meta` block — one [PriceDisplaySettingsSectionMeta] per section
/// the area declares.
class PriceDisplaySettingsGroupMeta extends Dto {
  const PriceDisplaySettingsGroupMeta({this.orderItem, this.orderSummary});

  static PriceDisplaySettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PriceDisplaySettingsGroupMeta(
      orderItem: PriceDisplaySettingsSectionMeta.fromMap(source['order_item']),
      orderSummary:
          PriceDisplaySettingsSectionMeta.fromMap(source['order_summary']),
    );
  }

  final PriceDisplaySettingsSectionMeta? orderItem;

  final PriceDisplaySettingsSectionMeta? orderSummary;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item': orderItem,
        'order_summary': orderSummary,
      };
}

/// The price display settings, as the facade or one section sends them.
class PriceDisplaySettings extends Dto {
  const PriceDisplaySettings({
    this.orderItem,
    this.orderSummary,
    this.groupMeta,
    this.fieldMetadata,
  });

  static PriceDisplaySettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'price_display_settings');
    if (source == null) return null;
    return PriceDisplaySettings(
      orderItem: OrderItem.fromMap(source['order_item']),
      orderSummary:
          PriceDisplaySettingsOrderSummary.fromMap(source['order_summary']),
      groupMeta: PriceDisplaySettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final OrderItem? orderItem;

  final PriceDisplaySettingsOrderSummary? orderSummary;

  /// `group_meta` — on the facade's answer only.
  final PriceDisplaySettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type and
  /// it nests the way the settings themselves nest.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'price_display_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item': orderItem,
        'order_summary': orderSummary,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
