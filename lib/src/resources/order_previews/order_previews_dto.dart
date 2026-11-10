/// Typed views over the order preview bodies.
library;

import '../../client/dto.dart';
import '../orders/orders_dto.dart';

/// The session block. `session_id` starts `PRV-` and is the
/// `preview_session_id` of every other call. `expires_at` is 30 minutes after
/// `created_at`; a coupon or gift card call, applying or removing, moves it 30
/// minutes past that call, and a read does not.
class PreviewSession extends Dto {
  const PreviewSession(
      {this.sessionId, this.status, this.createdAt, this.expiresAt});

  /// Reads the session block.
  static PreviewSession? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewSession(
      sessionId: readText(source['session_id']),
      status: readText(source['status']),
      createdAt: readText(source['created_at']),
      expiresAt: readText(source['expires_at']),
    );
  }

  final String? sessionId;

  final String? status;

  final String? createdAt;

  final String? expiresAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'session_id': sessionId,
        'status': status,
        'created_at': createdAt,
        'expires_at': expiresAt,
      };
}

/// The customer as the preview shows it: the billing address names win over
/// the record's.
class PreviewCustomer extends Dto {
  const PreviewCustomer(
      {this.customerId, this.firstName, this.lastName, this.email});

  /// Reads the customer block.
  static PreviewCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewCustomer(
      customerId: readInteger(source['customer_id']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
    );
  }

  final int? customerId;

  final String? firstName;

  final String? lastName;

  final String? email;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      };
}

/// One line of the preview, priced by the store.
class PreviewItem extends Dto {
  const PreviewItem({
    this.productId,
    this.productName,
    this.sku,
    this.quantity,
    this.price,
    this.discount,
    this.tax,
    this.totalAmount,
    this.taxable,
    this.shippable,
  });

  /// Reads one line.
  static PreviewItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewItem(
      productId: readInteger(source['product_id']),
      productName: readText(source['product_name']),
      sku: readText(source['sku']),
      quantity: readInteger(source['quantity']),
      price: readDecimal(source['price']),
      discount: readDecimal(source['discount']),
      tax: readDecimal(source['tax']),
      totalAmount: readDecimal(source['total_amount']),
      taxable: readFlag(source['taxable']),
      shippable: readFlag(source['shippable']),
    );
  }

  final int? productId;

  final String? productName;

  final String? sku;

  final int? quantity;

  final double? price;

  final double? discount;

  final double? tax;

  final double? totalAmount;

  final bool? taxable;

  final bool? shippable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_id': productId,
        'product_name': productName,
        'sku': sku,
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'tax': tax,
        'total_amount': totalAmount,
        'taxable': taxable,
        'shippable': shippable,
      };
}

/// The delivery the preview was priced for. A `store_pickup` has no shipping
/// cost.
class PreviewShipping extends Dto {
  const PreviewShipping(
      {this.deliveryType,
      this.shippingType,
      this.shippingCost,
      this.shippingTax});

  /// Reads the shipping block.
  static PreviewShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewShipping(
      deliveryType: readText(source['delivery_type']),
      shippingType: readText(source['shipping_type']),
      shippingCost: readDecimal(source['shipping_cost']),
      shippingTax: readDecimal(source['shipping_tax']),
    );
  }

  final String? deliveryType;

  final String? shippingType;

  final double? shippingCost;

  final double? shippingTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'delivery_type': deliveryType,
        'shipping_type': shippingType,
        'shipping_cost': shippingCost,
        'shipping_tax': shippingTax,
      };
}

/// The coupon on the preview: `amount` is the discount it takes off, `status`
/// `applied`.
class PreviewCoupon extends Dto {
  const PreviewCoupon({this.code, this.status, this.amount});

  /// Reads the coupon block.
  static PreviewCoupon? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewCoupon(
      code: readText(source['code']),
      status: readText(source['status']),
      amount: readDecimal(source['amount']),
    );
  }

  final String? code;

  final String? status;

  final double? amount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
        'status': status,
        'amount': amount,
      };
}

/// The gift card on the preview: `applied_amount` is the lesser of its balance
/// and the grand total. `remaining_balance` came back `null`.
class PreviewGiftCard extends Dto {
  const PreviewGiftCard(
      {this.code, this.status, this.appliedAmount, this.remainingBalance});

  /// Reads the gift card block.
  static PreviewGiftCard? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewGiftCard(
      code: readText(source['code']),
      status: readText(source['status']),
      appliedAmount: readDecimal(source['applied_amount']),
      remainingBalance: readDecimal(source['remaining_balance']),
    );
  }

  final String? code;

  final String? status;

  final double? appliedAmount;

  final double? remainingBalance;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
        'status': status,
        'applied_amount': appliedAmount,
        'remaining_balance': remainingBalance,
      };
}

/// At most one coupon and one gift card; `null` for one not applied.
class PreviewDiscounts extends Dto {
  const PreviewDiscounts({this.coupon, this.giftCard});

  /// Reads the discounts block.
  static PreviewDiscounts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewDiscounts(
      coupon: PreviewCoupon.fromMap(source['coupon']),
      giftCard: PreviewGiftCard.fromMap(source['gift_card']),
    );
  }

  final PreviewCoupon? coupon;

  final PreviewGiftCard? giftCard;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'coupon': coupon,
        'gift_card': giftCard,
      };
}

/// The money. `grand_total` is `sub_total` less `total_discount` plus the tax,
/// shipping (and its tax), handling and surcharge; a gift card lowers `due`,
/// not `grand_total`.
class PreviewTotals extends Dto {
  const PreviewTotals({
    this.subTotal,
    this.totalDiscount,
    this.totalTax,
    this.shippingCost,
    this.handlingCost,
    this.totalSurcharge,
    this.giftCardApplied,
    this.grandTotal,
    this.due,
  });

  /// Reads the totals block.
  static PreviewTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PreviewTotals(
      subTotal: readDecimal(source['sub_total']),
      totalDiscount: readDecimal(source['total_discount']),
      totalTax: readDecimal(source['total_tax']),
      shippingCost: readDecimal(source['shipping_cost']),
      handlingCost: readDecimal(source['handling_cost']),
      totalSurcharge: readDecimal(source['total_surcharge']),
      giftCardApplied: readDecimal(source['gift_card_applied']),
      grandTotal: readDecimal(source['grand_total']),
      due: readDecimal(source['due']),
    );
  }

  final double? subTotal;

  final double? totalDiscount;

  final double? totalTax;

  final double? shippingCost;

  final double? handlingCost;

  final double? totalSurcharge;

  final double? giftCardApplied;

  final double? grandTotal;

  final double? due;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sub_total': subTotal,
        'total_discount': totalDiscount,
        'total_tax': totalTax,
        'shipping_cost': shippingCost,
        'handling_cost': handlingCost,
        'total_surcharge': totalSurcharge,
        'gift_card_applied': giftCardApplied,
        'grand_total': grandTotal,
        'due': due,
      };
}

/// A preview. The start and the read answer every field; a coupon or gift card
/// call answers only `session`, `discounts` and `totals`.
class OrderPreview extends Dto {
  const OrderPreview({
    this.session,
    this.customer,
    this.deliveryType,
    this.currencyCode,
    this.items,
    this.shipping,
    this.discounts,
    this.totals,
  });

  /// Reads the `order` envelope.
  static OrderPreview? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order');
    if (source == null) return null;
    return OrderPreview(
      session: PreviewSession.fromMap(source['session']),
      customer: PreviewCustomer.fromMap(source['customer']),
      deliveryType: readText(source['delivery_type']),
      currencyCode: readText(source['currency_code']),
      items: readList<PreviewItem>(source['items'], PreviewItem.fromMap),
      shipping: PreviewShipping.fromMap(source['shipping']),
      discounts: PreviewDiscounts.fromMap(source['discounts']),
      totals: PreviewTotals.fromMap(source['totals']),
    );
  }

  final PreviewSession? session;

  final PreviewCustomer? customer;

  final String? deliveryType;

  final String? currencyCode;

  final List<PreviewItem?>? items;

  final PreviewShipping? shipping;

  final PreviewDiscounts? discounts;

  final PreviewTotals? totals;

  @override
  String? get envelopeKey => 'order';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'session': session,
        'customer': customer,
        'delivery_type': deliveryType,
        'currency_code': currencyCode,
        'items': items,
        'shipping': shipping,
        'discounts': discounts,
        'totals': totals,
      };
}

/// The start body, bare. `products` is required. Without `customer_id` the
/// billing address is required, and a shipping address too unless
/// `delivery_type` is `store_pickup`. `delivery_type` is `shipping` unless it
/// is `delivery`, `others_shipping` or `store_pickup`. An unknown field, such
/// as `coupon_code` or a product line's `price`, is `400`.
class OrderPreviewInput extends Dto {
  const OrderPreviewInput({
    this.customerId,
    this.deliveryType,
    this.billingAddress,
    this.shippingAddress,
    this.products,
  });

  final int? customerId;

  final String? deliveryType;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  final List<OrderProductInput?>? products;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'delivery_type': deliveryType,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'products': products,
      };
}

/// The body of a coupon or gift card call: `code`, required, at most 100
/// characters.
class OrderPreviewCodeInput extends Dto {
  const OrderPreviewCodeInput({this.code});

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{'code': code};
}

/// The payment a confirm records. `amount` above what is due is `422`, a
/// missing `payment_method` is `400`, and `payment_status` `failed` leaves the
/// order unpaid.
class OrderPreviewPaymentInput extends Dto {
  const OrderPreviewPaymentInput({
    this.amount,
    this.paymentStatus,
    this.paymentMethod,
    this.transactionReference,
    this.transactionDate,
  });

  final double? amount;

  final String? paymentStatus;

  final String? paymentMethod;

  final String? transactionReference;

  final String? transactionDate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'payment_status': paymentStatus,
        'payment_method': paymentMethod,
        'transaction_reference': transactionReference,
        'transaction_date': transactionDate,
      };
}

/// The confirm body, bare, and optional. `payment_gateway` takes a code such
/// as `PIS` and leaves the order unpaid; an unknown field is `400`.
class OrderPreviewConfirmInput extends Dto {
  const OrderPreviewConfirmInput(
      {this.paymentGateway, this.transactionNo, this.sendEmail, this.payment});

  final String? paymentGateway;

  final String? transactionNo;

  final bool? sendEmail;

  final OrderPreviewPaymentInput? payment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'payment_gateway': paymentGateway,
        'transaction_no': transactionNo,
        'send_email': sendEmail,
        'payment': payment,
      };
}
