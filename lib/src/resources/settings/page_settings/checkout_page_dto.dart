/// Typed views over the checkout page settings bodies.
library;

import '../../../client/dto.dart';

/// One entry of an address section's `fields` — a form field and how it is
/// drawn.
class AddressField extends Dto {
  const AddressField({
    this.key,
    this.label,
    this.active,
    this.required,
    this.order,
    this.group,
  });

  static AddressField? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AddressField(
      key: readText(source['key']),
      label: readText(source['label']),
      active: readFlag(source['active']),
      required: readFlag(source['required']),
      order: readInteger(source['order']),
      group: readText(source['group']),
    );
  }

  final String? key;

  final String? label;

  final bool? active;

  final bool? required;

  final int? order;

  /// `group` — the layout group, which `field_metadata` marks read-only.
  final String? group;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'label': label,
        'active': active,
        'required': required,
        'order': order,
        'group': group,
      };
}

/// An address section's record. The store's `fields` is read into
/// [addressFields], as [Dto.fields] already takes that name.
class AddressForm extends Dto {
  const AddressForm({this.activeFields, this.addressFields});

  /// `active_fields` — the active field keys alone, which is the facade's form.
  final List<String?>? activeFields;

  /// `fields` — every catalog field, which is the section endpoint's form.
  final List<AddressField?>? addressFields;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'active_fields': activeFields,
        'fields': addressFields,
      };
}

/// The `billing_address` section.
class BillingAddress extends AddressForm {
  const BillingAddress({super.activeFields, super.addressFields});

  static BillingAddress? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'billing_address');
    if (source == null) return null;
    return BillingAddress(
      activeFields: readList<String>(source['active_fields'], readText),
      addressFields:
          readList<AddressField>(source['fields'], AddressField.fromMap),
    );
  }

  @override
  String? get envelopeKey => 'billing_address';
}

/// The `shipping_address` section.
class ShippingAddress extends AddressForm {
  const ShippingAddress({super.activeFields, super.addressFields});

  static ShippingAddress? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_address');
    if (source == null) return null;
    return ShippingAddress(
      activeFields: readList<String>(source['active_fields'], readText),
      addressFields:
          readList<AddressField>(source['fields'], AddressField.fromMap),
    );
  }

  @override
  String? get envelopeKey => 'shipping_address';
}

/// The `allow_sign_up` block — whether an account may be created during
/// checkout and whether one is demanded.
class SignUp extends Dto {
  const SignUp({this.enabled, this.required});

  static SignUp? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SignUp(
      enabled: readFlag(source['enabled']),
      required: readFlag(source['required']),
    );
  }

  final bool? enabled;

  final bool? required;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'required': required,
      };
}

/// The `checkout_as_guest` block — whether an order may be placed without an
/// account and whether a guest is offered a one-click sign-up.
class GuestCheckout extends Dto {
  const GuestCheckout({this.enabled, this.quickSignup});

  static GuestCheckout? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GuestCheckout(
      enabled: readFlag(source['enabled']),
      quickSignup: readFlag(source['quick_signup']),
    );
  }

  final bool? enabled;

  final bool? quickSignup;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'quick_signup': quickSignup,
      };
}

/// The `customer_checkout` section — who may check out and how, in three flat
/// booleans and two blocks.
class CustomerCheckout extends Dto {
  const CustomerCheckout({
    this.allowSignIn,
    this.allowSignUp,
    this.checkoutAsGuest,
    this.newsletterSubscription,
    this.multipleShippingMethods,
  });

  static CustomerCheckout? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer_checkout');
    if (source == null) return null;
    return CustomerCheckout(
      allowSignIn: readFlag(source['allow_sign_in']),
      allowSignUp: SignUp.fromMap(source['allow_sign_up']),
      checkoutAsGuest: GuestCheckout.fromMap(source['checkout_as_guest']),
      newsletterSubscription: readFlag(source['newsletter_subscription']),
      multipleShippingMethods: readFlag(source['multiple_shipping_methods']),
    );
  }

  final bool? allowSignIn;

  final SignUp? allowSignUp;

  final GuestCheckout? checkoutAsGuest;

  final bool? newsletterSubscription;

  final bool? multipleShippingMethods;

  @override
  String? get envelopeKey => 'customer_checkout';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'allow_sign_in': allowSignIn,
        'allow_sign_up': allowSignUp,
        'checkout_as_guest': checkoutAsGuest,
        'newsletter_subscription': newsletterSubscription,
        'multiple_shipping_methods': multipleShippingMethods,
      };
}

/// The `delivery_options` section — which delivery choices checkout offers.
class DeliveryOptions extends Dto {
  const DeliveryOptions({
    this.enableShipping,
    this.enableStorePickup,
    this.enableShippingQuote,
    this.enableDeliveryService,
  });

  static DeliveryOptions? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'delivery_options');
    if (source == null) return null;
    return DeliveryOptions(
      enableShipping: readFlag(source['enable_shipping']),
      enableStorePickup: readFlag(source['enable_store_pickup']),
      enableShippingQuote: readFlag(source['enable_shipping_quote']),
      enableDeliveryService: readFlag(source['enable_delivery_service']),
    );
  }

  final bool? enableShipping;

  final bool? enableStorePickup;

  final bool? enableShippingQuote;

  final bool? enableDeliveryService;

  @override
  String? get envelopeKey => 'delivery_options';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_shipping': enableShipping,
        'enable_store_pickup': enableStorePickup,
        'enable_shipping_quote': enableShippingQuote,
        'enable_delivery_service': enableDeliveryService,
      };
}

/// The `order_summary` section — what the checkout's summary panel shows.
class OrderSummary extends Dto {
  const OrderSummary({
    this.showProductThumbnail,
    this.showQuantity,
    this.enablePaymentExpandView,
    this.orderConfirmCaptcha,
  });

  static OrderSummary? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order_summary');
    if (source == null) return null;
    return OrderSummary(
      showProductThumbnail: readFlag(source['show_product_thumbnail']),
      showQuantity: readFlag(source['show_quantity']),
      enablePaymentExpandView: readFlag(source['enable_payment_expand_view']),
      orderConfirmCaptcha: readFlag(source['order_confirm_captcha']),
    );
  }

  final bool? showProductThumbnail;

  final bool? showQuantity;

  final bool? enablePaymentExpandView;

  final bool? orderConfirmCaptcha;

  @override
  String? get envelopeKey => 'order_summary';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_product_thumbnail': showProductThumbnail,
        'show_quantity': showQuantity,
        'enable_payment_expand_view': enablePaymentExpandView,
        'order_confirm_captcha': orderConfirmCaptcha,
      };
}

/// The `comment` block — whether an order may carry a customer comment and
/// whether staff are notified of one.
class OrderComment extends Dto {
  const OrderComment({this.enabled, this.sendNotification});

  static OrderComment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderComment(
      enabled: readFlag(source['enabled']),
      sendNotification: readFlag(source['send_notification']),
    );
  }

  final bool? enabled;

  final bool? sendNotification;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'send_notification': sendNotification,
      };
}

/// The `terms_and_condition.ref` block — where the terms text comes from.
class TermsReference extends Dto {
  const TermsReference({this.page, this.link, this.text});

  static TermsReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TermsReference(
      page: readAny(source['page']),
      link: readText(source['link']),
      text: readText(source['text']),
    );
  }

  /// `page` — untyped, because `field_metadata` types it a string and describes
  /// it as a reference record.
  final Object? page;

  final String? link;

  final String? text;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page': page,
        'link': link,
        'text': text,
      };
}

/// The `terms_and_condition` block — whether terms must be accepted, the
/// wording around the link and where the terms themselves live.
class TermsAndCondition extends Dto {
  const TermsAndCondition({
    this.enabled,
    this.text,
    this.linkLabel,
    this.type,
    this.ref,
  });

  static TermsAndCondition? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TermsAndCondition(
      enabled: readFlag(source['enabled']),
      text: readText(source['text']),
      linkLabel: readText(source['link_label']),
      type: readText(source['type']),
      ref: TermsReference.fromMap(source['ref']),
    );
  }

  final bool? enabled;

  final String? text;

  final String? linkLabel;

  /// `type` — which field of [TermsReference] holds the terms.
  final String? type;

  final TermsReference? ref;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'text': text,
        'link_label': linkLabel,
        'type': type,
        'ref': ref,
      };
}

/// The `others` section — the checkout page's chrome: its logo, its login link,
/// its own HTML and two blocks.
class Others extends Dto {
  const Others({
    this.showLogo,
    this.loginUrl,
    this.customHtml,
    this.comment,
    this.termsAndCondition,
  });

  static Others? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'others');
    if (source == null) return null;
    return Others(
      showLogo: readFlag(source['show_logo']),
      loginUrl: readText(source['login_url']),
      customHtml: readText(source['custom_html']),
      comment: OrderComment.fromMap(source['comment']),
      termsAndCondition:
          TermsAndCondition.fromMap(source['terms_and_condition']),
    );
  }

  final bool? showLogo;

  /// `login_url` — the one field `field_metadata` marks required in this area.
  final String? loginUrl;

  final String? customHtml;

  final OrderComment? comment;

  final TermsAndCondition? termsAndCondition;

  @override
  String? get envelopeKey => 'others';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_logo': showLogo,
        'login_url': loginUrl,
        'custom_html': customHtml,
        'comment': comment,
        'terms_and_condition': termsAndCondition,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class CheckoutPageSectionMeta extends Dto {
  const CheckoutPageSectionMeta({this.kind, this.writable, this.href});

  static CheckoutPageSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutPageSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on all six entries here.
  final String? kind;

  /// `writable` — `false` on the two address sections, `true` on the other four.
  final bool? writable;

  /// `href` — the section's own path on this resource, for every entry.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [CheckoutPageSectionMeta] per section the area
/// declares.
class CheckoutPageGroupMeta extends Dto {
  const CheckoutPageGroupMeta({
    this.billingAddress,
    this.shippingAddress,
    this.customerCheckout,
    this.deliveryOptions,
    this.orderSummary,
    this.others,
  });

  static CheckoutPageGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutPageGroupMeta(
      billingAddress:
          CheckoutPageSectionMeta.fromMap(source['billing_address']),
      shippingAddress:
          CheckoutPageSectionMeta.fromMap(source['shipping_address']),
      customerCheckout:
          CheckoutPageSectionMeta.fromMap(source['customer_checkout']),
      deliveryOptions:
          CheckoutPageSectionMeta.fromMap(source['delivery_options']),
      orderSummary: CheckoutPageSectionMeta.fromMap(source['order_summary']),
      others: CheckoutPageSectionMeta.fromMap(source['others']),
    );
  }

  final CheckoutPageSectionMeta? billingAddress;

  final CheckoutPageSectionMeta? shippingAddress;

  final CheckoutPageSectionMeta? customerCheckout;

  final CheckoutPageSectionMeta? deliveryOptions;

  final CheckoutPageSectionMeta? orderSummary;

  final CheckoutPageSectionMeta? others;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'customer_checkout': customerCheckout,
        'delivery_options': deliveryOptions,
        'order_summary': orderSummary,
        'others': others,
      };
}

/// The checkout page settings, as the facade or one section sends them.
class CheckoutPage extends Dto {
  const CheckoutPage({
    this.billingAddress,
    this.shippingAddress,
    this.customerCheckout,
    this.deliveryOptions,
    this.orderSummary,
    this.others,
    this.groupMeta,
    this.fieldMetadata,
  });

  static CheckoutPage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'checkout_page');
    if (source == null) return null;
    return CheckoutPage(
      billingAddress: BillingAddress.fromMap(source['billing_address']),
      shippingAddress: ShippingAddress.fromMap(source['shipping_address']),
      customerCheckout: CustomerCheckout.fromMap(source['customer_checkout']),
      deliveryOptions: DeliveryOptions.fromMap(source['delivery_options']),
      orderSummary: OrderSummary.fromMap(source['order_summary']),
      others: Others.fromMap(source['others']),
      groupMeta: CheckoutPageGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final BillingAddress? billingAddress;

  final ShippingAddress? shippingAddress;

  final CustomerCheckout? customerCheckout;

  final DeliveryOptions? deliveryOptions;

  final OrderSummary? orderSummary;

  final Others? others;

  /// `group_meta` — on the facade's answer only.
  final CheckoutPageGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its keys and entries differ by form.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'checkout_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'customer_checkout': customerCheckout,
        'delivery_options': deliveryOptions,
        'order_summary': orderSummary,
        'others': others,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
