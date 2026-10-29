/// Typed views over the payment gateway bodies.
library;

import '../../client/dto.dart';

/// An `{id, name}` pair: the gateway's `zone`, and each audience member it
/// names.
class PaymentGatewayReference extends Dto {
  const PaymentGatewayReference({this.id, this.name});

  /// Reads a `zone`, or one entry of a visibility list.
  static PaymentGatewayReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayReference(
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

/// Who sees the gateway at checkout; the lists fill only under `type`
/// `selected`.
class PaymentGatewayVisibility extends Dto {
  const PaymentGatewayVisibility(
      {this.type, this.customers, this.customerGroups});

  /// Reads a row's `visibility`.
  static PaymentGatewayVisibility? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayVisibility(
      type: readText(source['type']),
      customers: readList<PaymentGatewayReference>(
          source['customers'], PaymentGatewayReference.fromMap),
      customerGroups: readList<PaymentGatewayReference>(
          source['customer_groups'], PaymentGatewayReference.fromMap),
    );
  }

  /// `type` — `everyone`, `customer` or `selected`.
  final String? type;

  final List<PaymentGatewayReference?>? customers;

  final List<PaymentGatewayReference?>? customerGroups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'customers': customers,
        'customer_groups': customerGroups,
      };
}

/// The delivery types the gateway is offered for; `null` on gateways without
/// the choice.
class PaymentGatewayAllowedFor extends Dto {
  const PaymentGatewayAllowedFor(
      {this.shipping, this.delivery, this.storePickup});

  /// Reads a row's `allowed_for`.
  static PaymentGatewayAllowedFor? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayAllowedFor(
      shipping: readFlag(source['shipping']),
      delivery: readFlag(source['delivery']),
      storePickup: readFlag(source['store_pickup']),
    );
  }

  final bool? shipping;

  final bool? delivery;

  final bool? storePickup;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping': shipping,
        'delivery': delivery,
        'store_pickup': storePickup,
      };
}

/// The surcharge block, `null` on gateways without one, and its write;
/// `percent_amount` reads `null` when no percentage is set.
class PaymentGatewaySurcharge extends Dto {
  const PaymentGatewaySurcharge(
      {this.type, this.flatAmount, this.percentAmount, this.ranges});

  /// Reads a row's `surcharge`.
  static PaymentGatewaySurcharge? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewaySurcharge(
      type: readText(source['type']),
      flatAmount: readDecimal(source['flat_amount']),
      percentAmount: readDecimal(source['percent_amount']),
      ranges: readList<Object>(source['ranges'], readAny),
    );
  }

  final String? type;

  final double? flatAmount;

  final double? percentAmount;

  /// `ranges` — each range a map of `id`, `from`, `to` and `amount`, untyped.
  final List<Object?>? ranges;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'flat_amount': flatAmount,
        'percent_amount': percentAmount,
        'ranges': ranges,
      };
}

/// The pending and completed messages; a message the gateway's form lacks
/// reads `null`.
class PaymentGatewayMessages extends Dto {
  const PaymentGatewayMessages({this.pending, this.completed});

  /// Reads a row's `messages`.
  static PaymentGatewayMessages? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayMessages(
      pending: readText(source['pending']),
      completed: readText(source['completed']),
    );
  }

  final String? pending;

  final String? completed;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'pending': pending,
        'completed': completed,
      };
}

/// PayPal's `standard` credentials.
class PaymentGatewayPayPalStandard extends Dto {
  const PaymentGatewayPayPalStandard({this.clientId, this.clientSecret});

  /// Reads PayPal's `standard`.
  static PaymentGatewayPayPalStandard? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayPayPalStandard(
      clientId: readText(source['client_id']),
      clientSecret: readText(source['client_secret']),
    );
  }

  final String? clientId;

  final String? clientSecret;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'client_id': clientId,
        'client_secret': clientSecret,
      };
}

/// PayPal's `classic` account.
class PaymentGatewayPayPalClassic extends Dto {
  const PaymentGatewayPayPalClassic({this.emailAddress});

  /// Reads PayPal's `classic`.
  static PaymentGatewayPayPalClassic? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayPayPalClassic(
      emailAddress: readText(source['email_address']),
    );
  }

  final String? emailAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'email_address': emailAddress,
      };
}

/// A one-key `{"enabled": ...}` switch.
class PaymentGatewayToggle extends Dto {
  const PaymentGatewayToggle({this.enabled});

  /// Reads the card processor's `wallet_payment`.
  static PaymentGatewayToggle? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayToggle(enabled: readFlag(source['enabled']));
  }

  final bool? enabled;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
      };
}

/// The card gateway's processor; the client id and secret read `********` when
/// set.
class PaymentGatewayCardProcessor extends Dto {
  const PaymentGatewayCardProcessor({
    this.type,
    this.mode,
    this.merchantCode,
    this.clientId,
    this.clientSecret,
    this.walletPayment,
  });

  /// Reads the card gateway's `processor`.
  static PaymentGatewayCardProcessor? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayCardProcessor(
      type: readText(source['type']),
      mode: readText(source['mode']),
      merchantCode: readText(source['merchant_code']),
      clientId: readText(source['client_id']),
      clientSecret: readText(source['client_secret']),
      walletPayment: PaymentGatewayToggle.fromMap(source['wallet_payment']),
    );
  }

  final String? type;

  final String? mode;

  final String? merchantCode;

  final String? clientId;

  final String? clientSecret;

  final PaymentGatewayToggle? walletPayment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'mode': mode,
        'merchant_code': merchantCode,
        'client_id': clientId,
        'client_secret': clientSecret,
        'wallet_payment': walletPayment,
      };
}

/// The card logos shown at checkout.
class PaymentGatewayCardLogo extends Dto {
  const PaymentGatewayCardLogo({this.type, this.cards, this.customImage});

  /// Reads the card gateway's `card_logo`.
  static PaymentGatewayCardLogo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayCardLogo(
      type: readText(source['type']),
      cards: readList<String>(source['cards'], readText),
      customImage: readAny(source['custom_image']),
    );
  }

  final String? type;

  final List<String?>? cards;

  /// `custom_image` — `null` on every gateway read, so not typed.
  final Object? customImage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'cards': cards,
        'custom_image': customImage,
      };
}

/// Express Checkout's Google Pay block.
class PaymentGatewayGooglePay extends Dto {
  const PaymentGatewayGooglePay({
    this.enabled,
    this.paymentMode,
    this.merchantName,
    this.merchantId,
    this.processor,
    this.secretKey,
    this.publicKey,
    this.freeShippingConditionAmount,
    this.shippingCost,
  });

  /// Reads Express Checkout's `google_pay`.
  static PaymentGatewayGooglePay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayGooglePay(
      enabled: readFlag(source['enabled']),
      paymentMode: readText(source['payment_mode']),
      merchantName: readText(source['merchant_name']),
      merchantId: readText(source['merchant_id']),
      processor: readText(source['processor']),
      secretKey: readText(source['secret_key']),
      publicKey: readText(source['public_key']),
      freeShippingConditionAmount:
          readDecimal(source['free_shipping_condition_amount']),
      shippingCost: readDecimal(source['shipping_cost']),
    );
  }

  final bool? enabled;

  final String? paymentMode;

  final String? merchantName;

  final String? merchantId;

  final String? processor;

  final String? secretKey;

  final String? publicKey;

  final double? freeShippingConditionAmount;

  final double? shippingCost;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'payment_mode': paymentMode,
        'merchant_name': merchantName,
        'merchant_id': merchantId,
        'processor': processor,
        'secret_key': secretKey,
        'public_key': publicKey,
        'free_shipping_condition_amount': freeShippingConditionAmount,
        'shipping_cost': shippingCost,
      };
}

/// Express Checkout's Apple Pay block.
class PaymentGatewayApplePay extends Dto {
  const PaymentGatewayApplePay({
    this.enabled,
    this.paymentMode,
    this.merchantIdentifier,
    this.domainName,
    this.displayName,
    this.processor,
    this.secretKey,
    this.publicKey,
  });

  /// Reads Express Checkout's `apple_pay`.
  static PaymentGatewayApplePay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayApplePay(
      enabled: readFlag(source['enabled']),
      paymentMode: readText(source['payment_mode']),
      merchantIdentifier: readText(source['merchant_identifier']),
      domainName: readText(source['domain_name']),
      displayName: readText(source['display_name']),
      processor: readText(source['processor']),
      secretKey: readText(source['secret_key']),
      publicKey: readText(source['public_key']),
    );
  }

  final bool? enabled;

  final String? paymentMode;

  final String? merchantIdentifier;

  final String? domainName;

  final String? displayName;

  final String? processor;

  final String? secretKey;

  final String? publicKey;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'payment_mode': paymentMode,
        'merchant_identifier': merchantIdentifier,
        'domain_name': domainName,
        'display_name': displayName,
        'processor': processor,
        'secret_key': secretKey,
        'public_key': publicKey,
      };
}

/// Express Checkout's PayPal block.
class PaymentGatewayExpressPayPal extends Dto {
  const PaymentGatewayExpressPayPal({this.showInstallmentAmount});

  /// Reads Express Checkout's `paypal`.
  static PaymentGatewayExpressPayPal? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayExpressPayPal(
      showInstallmentAmount: readFlag(source['show_installment_amount']),
    );
  }

  final bool? showInstallmentAmount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'show_installment_amount': showInstallmentAmount,
      };
}

/// The row read's gateway-specific `settings`, every key any gateway answers;
/// each gateway fills its own few and offline gateways answer `{}`.
class PaymentGatewaySettings extends Dto {
  const PaymentGatewaySettings({
    this.version,
    this.mode,
    this.standard,
    this.classic,
    this.processor,
    this.cardLogo,
    this.googlePay,
    this.applePay,
    this.paypal,
    this.showInstallmentAmount,
    this.showInProductDetails,
    this.apiKey,
    this.defaultTerm,
    this.amountPer100Points,
    this.merchantId,
    this.merchantSecretKey,
    this.image,
  });

  /// Reads a row's `settings`.
  static PaymentGatewaySettings? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewaySettings(
      version: readText(source['version']),
      mode: readText(source['mode']),
      standard: PaymentGatewayPayPalStandard.fromMap(source['standard']),
      classic: PaymentGatewayPayPalClassic.fromMap(source['classic']),
      processor: PaymentGatewayCardProcessor.fromMap(source['processor']),
      cardLogo: PaymentGatewayCardLogo.fromMap(source['card_logo']),
      googlePay: PaymentGatewayGooglePay.fromMap(source['google_pay']),
      applePay: PaymentGatewayApplePay.fromMap(source['apple_pay']),
      paypal: PaymentGatewayExpressPayPal.fromMap(source['paypal']),
      showInstallmentAmount: readFlag(source['show_installment_amount']),
      showInProductDetails: readFlag(source['show_in_product_details']),
      apiKey: readText(source['api_key']),
      defaultTerm: readInteger(source['default_term']),
      amountPer100Points: readDecimal(source['amount_per_100_points']),
      merchantId: readText(source['merchant_id']),
      merchantSecretKey: readText(source['merchant_secret_key']),
      image: readAny(source['image']),
    );
  }

  final String? version;

  final String? mode;

  final PaymentGatewayPayPalStandard? standard;

  final PaymentGatewayPayPalClassic? classic;

  final PaymentGatewayCardProcessor? processor;

  final PaymentGatewayCardLogo? cardLogo;

  final PaymentGatewayGooglePay? googlePay;

  final PaymentGatewayApplePay? applePay;

  final PaymentGatewayExpressPayPal? paypal;

  final bool? showInstallmentAmount;

  final bool? showInProductDetails;

  final String? apiKey;

  final int? defaultTerm;

  final double? amountPer100Points;

  final String? merchantId;

  final String? merchantSecretKey;

  /// `image` — `null` on every gateway read, so not typed.
  final Object? image;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'version': version,
        'mode': mode,
        'standard': standard,
        'classic': classic,
        'processor': processor,
        'card_logo': cardLogo,
        'google_pay': googlePay,
        'apple_pay': applePay,
        'paypal': paypal,
        'show_installment_amount': showInstallmentAmount,
        'show_in_product_details': showInProductDetails,
        'api_key': apiKey,
        'default_term': defaultTerm,
        'amount_per_100_points': amountPer100Points,
        'merchant_id': merchantId,
        'merchant_secret_key': merchantSecretKey,
        'image': image,
      };
}

/// One gateway: a listing row, and the row path's and every write's body,
/// which add `settings`.
class PaymentGateway extends Dto {
  const PaymentGateway({
    this.id,
    this.code,
    this.name,
    this.added,
    this.enabled,
    this.isDefault,
    this.promotional,
    this.zone,
    this.information,
    this.visibility,
    this.allowedFor,
    this.surcharge,
    this.messages,
    this.settings,
  });

  /// Reads a row path's `payment_gateway` envelope, or a bare listing row.
  static PaymentGateway? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'payment_gateway');
    if (source == null) return null;
    return PaymentGateway(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
      added: readFlag(source['added']),
      enabled: readFlag(source['enabled']),
      isDefault: readFlag(source['default']),
      promotional: readFlag(source['promotional']),
      zone: PaymentGatewayReference.fromMap(source['zone']),
      information: readText(source['information']),
      visibility: PaymentGatewayVisibility.fromMap(source['visibility']),
      allowedFor: PaymentGatewayAllowedFor.fromMap(source['allowed_for']),
      surcharge: PaymentGatewaySurcharge.fromMap(source['surcharge']),
      messages: PaymentGatewayMessages.fromMap(source['messages']),
      settings: PaymentGatewaySettings.fromMap(source['settings']),
    );
  }

  final int? id;

  /// `code` — fixed per gateway type, and read-only.
  final String? code;

  final String? name;

  final bool? added;

  final bool? enabled;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  /// `promotional` — read-only.
  final bool? promotional;

  final PaymentGatewayReference? zone;

  final String? information;

  final PaymentGatewayVisibility? visibility;

  final PaymentGatewayAllowedFor? allowedFor;

  final PaymentGatewaySurcharge? surcharge;

  final PaymentGatewayMessages? messages;

  /// `settings` — absent from listing rows.
  final PaymentGatewaySettings? settings;

  @override
  String? get envelopeKey => 'payment_gateway';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
        'added': added,
        'enabled': enabled,
        'default': isDefault,
        'promotional': promotional,
        'zone': zone,
        'information': information,
        'visibility': visibility,
        'allowed_for': allowedFor,
        'surcharge': surcharge,
        'messages': messages,
        'settings': settings,
      };
}

/// The visibility a write takes: customers and customer groups by id.
class PaymentGatewayVisibilityInput extends Dto {
  const PaymentGatewayVisibilityInput(
      {this.type, this.customers, this.customerGroups});

  final String? type;

  final List<int>? customers;

  final List<int>? customerGroups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'customers': customers,
        'customer_groups': customerGroups,
      };
}

/// The writable fields, for the `PUT` and the `PATCH`; no envelope. `code` and
/// `promotional` are read-only.
class PaymentGatewayInput extends Dto {
  const PaymentGatewayInput({
    this.name,
    this.added,
    this.enabled,
    this.isDefault,
    this.zone,
    this.information,
    this.visibility,
    this.allowedFor,
    this.surcharge,
    this.messages,
    this.settings,
  });

  final String? name;

  final bool? added;

  final bool? enabled;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final bool? isDefault;

  /// `zone` — a zone's id or a [PaymentGatewayReference] naming one.
  final Object? zone;

  final String? information;

  final PaymentGatewayVisibilityInput? visibility;

  final PaymentGatewayAllowedFor? allowedFor;

  final PaymentGatewaySurcharge? surcharge;

  final PaymentGatewayMessages? messages;

  final PaymentGatewaySettings? settings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'added': added,
        'enabled': enabled,
        'default': isDefault,
        'zone': zone,
        'information': information,
        'visibility': visibility,
        'allowed_for': allowedFor,
        'surcharge': surcharge,
        'messages': messages,
        'settings': settings,
      };
}

/// The five-key `pagination` block; `limit` is the page size applied.
/// `has_previous` is `true` past the first page and `false` on a page past the
/// end.
class PaymentGatewayPagination extends Dto {
  const PaymentGatewayPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static PaymentGatewayPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayPagination(
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

  /// `has_previous` — `false` at `page=2` although `offset` reads `20`.
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

/// One page of the listing: the rows, without `settings`, and where they sit.
class PaymentGatewayPage extends Dto {
  const PaymentGatewayPage({this.paymentGateways, this.pagination});

  /// Reads a listing body.
  static PaymentGatewayPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayPage(
      paymentGateways: readList<PaymentGateway>(
          source['payment_gateways'], PaymentGateway.fromMap),
      pagination: PaymentGatewayPagination.fromMap(source['pagination']),
    );
  }

  final List<PaymentGateway?>? paymentGateways;

  final PaymentGatewayPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'payment_gateways': paymentGateways,
        'pagination': pagination,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class PaymentGatewayCount extends Dto {
  const PaymentGatewayCount({this.total});

  /// Reads a count body.
  static PaymentGatewayCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentGatewayCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}
