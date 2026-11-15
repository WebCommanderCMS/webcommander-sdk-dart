/// Typed views over the admin cart and checkout bodies.
library;

import '../../client/dto.dart';
import '../orders/orders_dto.dart';
import 'carts_dto.dart' show CartReference;

/// The session block. `session_id` starts `PRV-` and is the `session_id` of
/// every other call. `expires_at` is 30 minutes after the last write.
class AdminCartSession extends Dto {
  const AdminCartSession({
    this.sessionId,
    this.status,
    this.createdAt,
    this.expiresAt,
  });

  /// Reads the block.
  static AdminCartSession? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AdminCartSession(
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

/// The customer the cart is for; `customer_id` is the customer's normal id.
class AdminCartCustomer extends Dto {
  const AdminCartCustomer({
    this.customerId,
    this.firstName,
    this.lastName,
    this.email,
  });

  /// Reads the block.
  static AdminCartCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AdminCartCustomer(
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

/// One line, priced by the store. `cart_item_id` is what the line's update and
/// delete take; a replace of the cart numbers its lines again.
class AdminCartItem extends Dto {
  const AdminCartItem({
    this.cartItemId,
    this.productId,
    this.productName,
    this.variationId,
    this.variationName,
    this.sku,
    this.price,
    this.quantity,
    this.discount,
    this.tax,
    this.totalAmount,
    this.taxable,
    this.shippable,
  });

  /// Reads the block.
  static AdminCartItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AdminCartItem(
      cartItemId: readInteger(source['cart_item_id']),
      productId: readInteger(source['product_id']),
      productName: readText(source['product_name']),
      variationId: readInteger(source['variation_id']),
      variationName: readText(source['variation_name']),
      sku: readText(source['sku']),
      price: readDecimal(source['price']),
      quantity: readInteger(source['quantity']),
      discount: readDecimal(source['discount']),
      tax: readDecimal(source['tax']),
      totalAmount: readDecimal(source['total_amount']),
      taxable: readFlag(source['taxable']),
      shippable: readFlag(source['shippable']),
    );
  }

  final int? cartItemId;

  final int? productId;

  final String? productName;

  final int? variationId;

  final String? variationName;

  final String? sku;

  final double? price;

  final int? quantity;

  final double? discount;

  final double? tax;

  final double? totalAmount;

  final bool? taxable;

  final bool? shippable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cart_item_id': cartItemId,
        'product_id': productId,
        'product_name': productName,
        'variation_id': variationId,
        'variation_name': variationName,
        'sku': sku,
        'price': price,
        'quantity': quantity,
        'discount': discount,
        'tax': tax,
        'total_amount': totalAmount,
        'taxable': taxable,
        'shippable': shippable,
      };
}

/// The cart's money before shipping.
class AdminCartTotals extends Dto {
  const AdminCartTotals({
    this.subTotal,
    this.totalDiscount,
    this.totalTax,
    this.grandTotal,
  });

  /// Reads the block.
  static AdminCartTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AdminCartTotals(
      subTotal: readDecimal(source['sub_total']),
      totalDiscount: readDecimal(source['total_discount']),
      totalTax: readDecimal(source['total_tax']),
      grandTotal: readDecimal(source['grand_total']),
    );
  }

  final double? subTotal;

  final double? totalDiscount;

  final double? totalTax;

  final double? grandTotal;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sub_total': subTotal,
        'total_discount': totalDiscount,
        'total_tax': totalTax,
        'grand_total': grandTotal,
      };
}

/// A cart: what every cart call but the deletes answers.
class AdminCart extends Dto {
  const AdminCart({
    this.session,
    this.customer,
    this.currencyCode,
    this.items,
    this.totals,
  });

  /// Reads the `cart` envelope.
  static AdminCart? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'cart');
    if (source == null) return null;
    return AdminCart(
      session: AdminCartSession.fromMap(source['session']),
      customer: AdminCartCustomer.fromMap(source['customer']),
      currencyCode: readText(source['currency_code']),
      items: readList<AdminCartItem>(source['items'], AdminCartItem.fromMap),
      totals: AdminCartTotals.fromMap(source['totals']),
    );
  }

  final AdminCartSession? session;

  final AdminCartCustomer? customer;

  final String? currencyCode;

  final List<AdminCartItem?>? items;

  final AdminCartTotals? totals;

  @override
  String? get envelopeKey => 'cart';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'session': session,
        'customer': customer,
        'currency_code': currencyCode,
        'items': items,
        'totals': totals,
      };
}

/// A billing or shipping address as the checkout reads it back; `state` is `{}`
/// when the address has none.
class CheckoutAddress extends Dto {
  const CheckoutAddress({
    this.firstName,
    this.lastName,
    this.email,
    this.companyName,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.city,
    this.postCode,
    this.mobile,
    this.phone,
    this.fax,
  });

  /// Reads the block.
  static CheckoutAddress? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutAddress(
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
      companyName: readText(source['company_name']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      country: CartReference.fromMap(source['country']),
      state: CartReference.fromMap(source['state']),
      city: readText(source['city']),
      postCode: readText(source['post_code']),
      mobile: readText(source['mobile']),
      phone: readText(source['phone']),
      fax: readText(source['fax']),
    );
  }

  final String? firstName;

  final String? lastName;

  final String? email;

  final String? companyName;

  final String? addressLine1;

  final String? addressLine2;

  final CartReference? country;

  final CartReference? state;

  final String? city;

  final String? postCode;

  final String? mobile;

  final String? phone;

  final String? fax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'company_name': companyName,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'country': country,
        'state': state,
        'city': city,
        'post_code': postCode,
        'mobile': mobile,
        'phone': phone,
        'fax': fax,
      };
}

/// The delivery the checkout was priced for; empty until a `delivery_type` is
/// set.
class CheckoutShipping extends Dto {
  const CheckoutShipping({
    this.deliveryType,
    this.shippingType,
    this.shippingCost,
    this.shippingTax,
  });

  /// Reads the block.
  static CheckoutShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutShipping(
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

/// The coupon applied: `applied_amount` is the discount it takes off.
class CheckoutCoupon extends Dto {
  const CheckoutCoupon({
    this.code,
    this.status,
    this.appliedAmount,
  });

  /// Reads the block.
  static CheckoutCoupon? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutCoupon(
      code: readText(source['code']),
      status: readText(source['status']),
      appliedAmount: readDecimal(source['applied_amount']),
    );
  }

  final String? code;

  final String? status;

  final double? appliedAmount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
        'status': status,
        'applied_amount': appliedAmount,
      };
}

/// The gift card applied: `applied_amount` is the lesser of its balance and the
/// grand total.
class CheckoutGiftCard extends Dto {
  const CheckoutGiftCard({
    this.code,
    this.status,
    this.appliedAmount,
    this.remainingBalance,
  });

  /// Reads the block.
  static CheckoutGiftCard? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutGiftCard(
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
class CheckoutDiscounts extends Dto {
  const CheckoutDiscounts({
    this.coupon,
    this.giftCard,
  });

  /// Reads the block.
  static CheckoutDiscounts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutDiscounts(
      coupon: CheckoutCoupon.fromMap(source['coupon']),
      giftCard: CheckoutGiftCard.fromMap(source['gift_card']),
    );
  }

  final CheckoutCoupon? coupon;

  final CheckoutGiftCard? giftCard;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'coupon': coupon,
        'gift_card': giftCard,
      };
}

/// The money. A gift card lowers `due`, not `grand_total`.
class CheckoutTotals extends Dto {
  const CheckoutTotals({
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

  /// Reads the block.
  static CheckoutTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutTotals(
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

/// One thing still blocking a confirm, such as `field` `delivery_type` with
/// `code` `required`.
class CheckoutIssue extends Dto {
  const CheckoutIssue({
    this.field,
    this.code,
    this.message,
  });

  /// Reads the block.
  static CheckoutIssue? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CheckoutIssue(
      field: readText(source['field']),
      code: readText(source['code']),
      message: readText(source['message']),
    );
  }

  final String? field;

  final String? code;

  final String? message;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'field': field,
        'code': code,
        'message': message,
      };
}

/// The checkout. The read and the update answer every field; the coupon, gift
/// card and delivery schedule calls answer the parts they change.
/// `delivery_schedule` is `null` until one is set.
class AdminCheckout extends Dto {
  const AdminCheckout({
    this.session,
    this.customer,
    this.deliveryType,
    this.currencyCode,
    this.items,
    this.billingAddress,
    this.shippingAddress,
    this.shipping,
    this.discounts,
    this.deliverySchedule,
    this.totals,
    this.issues,
  });

  /// Reads the `checkout` envelope.
  static AdminCheckout? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'checkout');
    if (source == null) return null;
    return AdminCheckout(
      session: AdminCartSession.fromMap(source['session']),
      customer: AdminCartCustomer.fromMap(source['customer']),
      deliveryType: readText(source['delivery_type']),
      currencyCode: readText(source['currency_code']),
      items: readList<AdminCartItem>(source['items'], AdminCartItem.fromMap),
      billingAddress: CheckoutAddress.fromMap(source['billing_address']),
      shippingAddress: CheckoutAddress.fromMap(source['shipping_address']),
      shipping: CheckoutShipping.fromMap(source['shipping']),
      discounts: CheckoutDiscounts.fromMap(source['discounts']),
      deliverySchedule: readAny(source['delivery_schedule']),
      totals: CheckoutTotals.fromMap(source['totals']),
      issues: readList<CheckoutIssue>(source['issues'], CheckoutIssue.fromMap),
    );
  }

  final AdminCartSession? session;

  final AdminCartCustomer? customer;

  final String? deliveryType;

  final String? currencyCode;

  final List<AdminCartItem?>? items;

  final CheckoutAddress? billingAddress;

  final CheckoutAddress? shippingAddress;

  final CheckoutShipping? shipping;

  final CheckoutDiscounts? discounts;

  final Object? deliverySchedule;

  final CheckoutTotals? totals;

  final List<CheckoutIssue?>? issues;

  @override
  String? get envelopeKey => 'checkout';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'session': session,
        'customer': customer,
        'delivery_type': deliveryType,
        'currency_code': currencyCode,
        'items': items,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'shipping': shipping,
        'discounts': discounts,
        'delivery_schedule': deliverySchedule,
        'totals': totals,
        'issues': issues,
      };
}

/// One product line to put on a cart. `product_id` and `quantity` are required;
/// `variation_id` picks a variation.
class AdminCartProductInput extends Dto {
  const AdminCartProductInput({
    this.productId,
    this.variationId,
    this.quantity,
  });

  final int? productId;

  final int? variationId;

  final int? quantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_id': productId,
        'variation_id': variationId,
        'quantity': quantity,
      };
}

/// The create and replace body, bare. `products` is required, and so is
/// `customer_id` on a replace; `session_id` on a create names the session
/// yourself, in the `PRV-` form. An unknown field is `400 unknown_field`.
class AdminCartInput extends Dto {
  const AdminCartInput({
    this.customerId,
    this.sessionId,
    this.products,
  });

  final int? customerId;

  final String? sessionId;

  final List<AdminCartProductInput?>? products;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'session_id': sessionId,
        'products': products,
      };
}

/// The cart update body: the customer to move the cart to. `customer_id` is
/// required.
class AdminCartCustomerInput extends Dto {
  const AdminCartCustomerInput({this.customerId});

  final int? customerId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
      };
}

/// The add-lines body. Adding a product already on the cart raises that line's
/// quantity.
class AdminCartItemsInput extends Dto {
  const AdminCartItemsInput({this.products});

  final List<AdminCartProductInput?>? products;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'products': products,
      };
}

/// The line update body: the new `quantity`, required.
class AdminCartItemUpdateInput extends Dto {
  const AdminCartItemUpdateInput({this.quantity});

  final int? quantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'quantity': quantity,
      };
}

/// The checkout update body. `delivery_type` is `shipping`, `delivery`,
/// `others_shipping` or `store_pickup`; an address replaces the whole one.
class AdminCheckoutInput extends Dto {
  const AdminCheckoutInput({
    this.deliveryType,
    this.billingAddress,
    this.shippingAddress,
  });

  final String? deliveryType;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'delivery_type': deliveryType,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      };
}

/// The body of a coupon or gift card call: `code`, required.
class AdminCheckoutCodeInput extends Dto {
  const AdminCheckoutCodeInput({this.code});

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
      };
}

/// The payment a confirm records. `amount` and `payment_method` are required;
/// an `amount` above what is due is refused.
class AdminCheckoutPaymentInput extends Dto {
  const AdminCheckoutPaymentInput({
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

/// The confirm body, bare, and optional. `payment_gateway` takes one of the
/// store's codes, such as `PIS`; an unknown field is `400`.
class AdminCheckoutConfirmInput extends Dto {
  const AdminCheckoutConfirmInput({
    this.paymentGateway,
    this.transactionNo,
    this.sendEmail,
    this.payment,
  });

  final String? paymentGateway;

  final String? transactionNo;

  final bool? sendEmail;

  final AdminCheckoutPaymentInput? payment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'payment_gateway': paymentGateway,
        'transaction_no': transactionNo,
        'send_email': sendEmail,
        'payment': payment,
      };
}

/// The delivery schedule to choose: its `id` and the `date` wanted, both
/// required.
class AdminCheckoutDeliveryScheduleInput extends Dto {
  const AdminCheckoutDeliveryScheduleInput({
    this.id,
    this.date,
  });

  final int? id;

  final String? date;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'date': date,
      };
}
