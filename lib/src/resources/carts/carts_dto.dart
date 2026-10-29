/// Typed views over the cart bodies.
library;

import '../../client/dto.dart';

/// The cart's `totals`; `subtotal` sums each line's `unit_price` times its
/// quantity.
class CartTotals extends Dto {
  const CartTotals({
    this.subtotal,
    this.discount,
    this.shippingDiscount,
    this.tax,
    this.total,
    this.grandTotal,
    this.paid,
  });

  static CartTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartTotals(
      subtotal: readDecimal(source['subtotal']),
      discount: readDecimal(source['discount']),
      shippingDiscount: readDecimal(source['shipping_discount']),
      tax: readDecimal(source['tax']),
      total: readDecimal(source['total']),
      grandTotal: readDecimal(source['grand_total']),
      paid: readDecimal(source['paid']),
    );
  }

  final double? subtotal;

  final double? discount;

  final double? shippingDiscount;

  final double? tax;

  final double? total;

  final double? grandTotal;

  final double? paid;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'subtotal': subtotal,
        'discount': discount,
        'shipping_discount': shippingDiscount,
        'tax': tax,
        'total': total,
        'grand_total': grandTotal,
        'paid': paid,
      };
}

/// The cart's `shipping` block; its two taxes follow the shipping address's
/// country.
class CartShipping extends Dto {
  const CartShipping({
    this.cost,
    this.handlingFee,
    this.handlingTax,
    this.shippingTax,
    this.totalTax,
  });

  static CartShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartShipping(
      cost: readDecimal(source['cost']),
      handlingFee: readDecimal(source['handling_fee']),
      handlingTax: readDecimal(source['handling_tax']),
      shippingTax: readDecimal(source['shipping_tax']),
      totalTax: readDecimal(source['total_tax']),
    );
  }

  final double? cost;

  final double? handlingFee;

  final double? handlingTax;

  final double? shippingTax;

  final double? totalTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cost': cost,
        'handling_fee': handlingFee,
        'handling_tax': handlingTax,
        'shipping_tax': shippingTax,
        'total_tax': totalTax,
      };
}

/// One line's `pricing`.
class CartItemPricing extends Dto {
  const CartItemPricing({
    this.unitPrice,
    this.displayUnitPrice,
    this.total,
    this.discount,
    this.discountTax,
    this.tax,
  });

  static CartItemPricing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartItemPricing(
      unitPrice: readDecimal(source['unit_price']),
      displayUnitPrice: readDecimal(source['display_unit_price']),
      total: readDecimal(source['total']),
      discount: readDecimal(source['discount']),
      discountTax: readDecimal(source['discount_tax']),
      tax: readDecimal(source['tax']),
    );
  }

  final double? unitPrice;

  final double? displayUnitPrice;

  final double? total;

  final double? discount;

  final double? discountTax;

  final double? tax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'unit_price': unitPrice,
        'display_unit_price': displayUnitPrice,
        'total': total,
        'discount': discount,
        'discount_tax': discountTax,
        'tax': tax,
      };
}

/// The product one line holds.
class CartItemProduct extends Dto {
  const CartItemProduct({
    this.id,
    this.sku,
    this.basePrice,
    this.availableStock,
    this.onSale,
    this.costPrice,
    this.salePrice,
    this.url,
    this.name,
    this.productType,
    this.imageLink,
  });

  static CartItemProduct? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartItemProduct(
      id: readInteger(source['id']),
      sku: readText(source['sku']),
      basePrice: readDecimal(source['base_price']),
      availableStock: readInteger(source['available_stock']),
      onSale: readFlag(source['on_sale']),
      costPrice: readDecimal(source['cost_price']),
      salePrice: readDecimal(source['sale_price']),
      url: readText(source['url']),
      name: readText(source['name']),
      productType: readText(source['product_type']),
      imageLink: readText(source['image_link']),
    );
  }

  final int? id;

  final String? sku;

  final double? basePrice;

  /// `available_stock` — the product's, not the line's.
  final int? availableStock;

  final bool? onSale;

  final double? costPrice;

  final double? salePrice;

  final String? url;

  final String? name;

  final String? productType;

  final String? imageLink;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'sku': sku,
        'base_price': basePrice,
        'available_stock': availableStock,
        'on_sale': onSale,
        'cost_price': costPrice,
        'sale_price': salePrice,
        'url': url,
        'name': name,
        'product_type': productType,
        'image_link': imageLink,
      };
}

/// One line of the cart.
class CartItem extends Dto {
  const CartItem({
    this.id,
    this.quantity,
    this.variations,
    this.taxable,
    this.shippable,
    this.pricing,
    this.product,
  });

  static CartItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartItem(
      id: readInteger(source['id']),
      quantity: readInteger(source['quantity']),
      variations: readAny(source['variations']),
      taxable: readFlag(source['taxable']),
      shippable: readFlag(source['shippable']),
      pricing: CartItemPricing.fromMap(source['pricing']),
      product: CartItemProduct.fromMap(source['product']),
    );
  }

  /// `id` — the `cart_item_id` the line's writes take, unique across carts.
  final int? id;

  final int? quantity;

  final Object? variations;

  final bool? taxable;

  final bool? shippable;

  final CartItemPricing? pricing;

  final CartItemProduct? product;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'quantity': quantity,
        'variations': variations,
        'taxable': taxable,
        'shippable': shippable,
        'pricing': pricing,
        'product': product,
      };
}

/// The cart's `discount` block.
class CartDiscount extends Dto {
  const CartDiscount({
    this.discount,
    this.orderDiscount,
    this.shippingDiscount,
    this.discountOnTax,
    this.discountOnShippingTax,
  });

  static CartDiscount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartDiscount(
      discount: readDecimal(source['discount']),
      orderDiscount: readDecimal(source['order_discount']),
      shippingDiscount: readDecimal(source['shipping_discount']),
      discountOnTax: readDecimal(source['discount_on_tax']),
      discountOnShippingTax: readDecimal(source['discount_on_shipping_tax']),
    );
  }

  final double? discount;

  final double? orderDiscount;

  final double? shippingDiscount;

  final double? discountOnTax;

  final double? discountOnShippingTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'discount': discount,
        'order_discount': orderDiscount,
        'shipping_discount': shippingDiscount,
        'discount_on_tax': discountOnTax,
        'discount_on_shipping_tax': discountOnShippingTax,
      };
}

/// The `discount` entry of `messages`.
class CartDiscountMessage extends Dto {
  const CartDiscountMessage({this.message, this.status});

  static CartDiscountMessage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartDiscountMessage(
      message: readText(source['message']),
      status: readAny(source['status']),
    );
  }

  final String? message;

  final Object? status;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'message': message,
        'status': status,
      };
}

/// The cart's `messages` block.
class CartMessages extends Dto {
  const CartMessages({this.discount});

  static CartMessages? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartMessages(
      discount: CartDiscountMessage.fromMap(source['discount']),
    );
  }

  final CartDiscountMessage? discount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'discount': discount,
      };
}

/// The one entry of `group_meta`.
class CartSectionMeta extends Dto {
  const CartSectionMeta({this.kind, this.writable, this.href});

  static CartSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  final String? kind;

  final bool? writable;

  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block, which only a read sends.
class CartGroupMeta extends Dto {
  const CartGroupMeta({this.cart});

  static CartGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartGroupMeta(cart: CartSectionMeta.fromMap(source['cart']));
  }

  final CartSectionMeta? cart;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cart': cart,
      };
}

/// One cart: the answer of the add, the read and the line update.
class Cart extends Dto {
  const Cart({
    this.customerId,
    this.sessionId,
    this.currencyCode,
    this.currencySymbol,
    this.deliveryType,
    this.totals,
    this.shipping,
    this.items,
    this.discount,
    this.messages,
    this.groupMeta,
  });

  /// Reads the `cart` envelope and the `group_meta` beside it.
  static Cart? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'cart');
    if (source == null) return null;
    return Cart(
      customerId: readInteger(source['customer_id']),
      sessionId: readText(source['session_id']),
      currencyCode: readText(source['currency_code']),
      currencySymbol: readText(source['currency_symbol']),
      deliveryType: readText(source['delivery_type']),
      totals: CartTotals.fromMap(source['totals']),
      shipping: CartShipping.fromMap(source['shipping']),
      items: readList<CartItem>(source['items'], CartItem.fromMap),
      discount: CartDiscount.fromMap(source['discount']),
      messages: CartMessages.fromMap(source['messages']),
      groupMeta: CartGroupMeta.fromMap(source['group_meta']),
    );
  }

  /// `customer_id` — the customer's `internal_id` on the add's answer, `null`
  /// on every read and line update.
  final int? customerId;

  final String? sessionId;

  final String? currencyCode;

  final String? currencySymbol;

  final String? deliveryType;

  final CartTotals? totals;

  final CartShipping? shipping;

  final List<CartItem?>? items;

  final CartDiscount? discount;

  final CartMessages? messages;

  /// `group_meta` — beside the envelope, on the read's answer only.
  final CartGroupMeta? groupMeta;

  @override
  String? get envelopeKey => 'cart';

  @override
  Set<String> get topLevelFields => const <String>{'group_meta'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'session_id': sessionId,
        'currency_code': currencyCode,
        'currency_symbol': currencySymbol,
        'delivery_type': deliveryType,
        'totals': totals,
        'shipping': shipping,
        'items': items,
        'discount': discount,
        'messages': messages,
        'group_meta': groupMeta,
      };
}

/// A `shipping_address` or `billing_address`; the cart answers neither back.
class CartAddressInput extends Dto {
  const CartAddressInput({
    this.firstName,
    this.lastName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postCode,
    this.phone,
    this.mobile,
    this.fax,
    this.email,
    this.countryCode,
    this.stateCode,
  });

  final String? firstName;

  final String? lastName;

  /// `address_line1` — one underscore, where an order's address has two.
  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  final String? postCode;

  final String? phone;

  final String? mobile;

  final String? fax;

  final String? email;

  final String? countryCode;

  final String? stateCode;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name': firstName,
        'last_name': lastName,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'city': city,
        'post_code': postCode,
        'phone': phone,
        'mobile': mobile,
        'fax': fax,
        'email': email,
        'country_code': countryCode,
        'state_code': stateCode,
      };
}

/// The add's body, no envelope; `customer_id` takes the customer's
/// `internal_id`.
class CartItemInput extends Dto {
  const CartItemInput({
    this.productId,
    this.quantity,
    this.customerId,
    this.sessionId,
    this.shippingAddress,
  });

  final int? productId;

  final int? quantity;

  final int? customerId;

  final String? sessionId;

  final CartAddressInput? shippingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_id': productId,
        'quantity': quantity,
        'customer_id': customerId,
        'session_id': sessionId,
        'shipping_address': shippingAddress,
      };
}

/// The line update's body, no envelope; `cart_item_id` and `quantity` are
/// required.
class CartItemUpdateInput extends Dto {
  const CartItemUpdateInput({
    this.cartItemId,
    this.quantity,
    this.shippingAddress,
    this.billingAddress,
  });

  final int? cartItemId;

  final int? quantity;

  final CartAddressInput? shippingAddress;

  final CartAddressInput? billingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'cart_item_id': cartItemId,
        'quantity': quantity,
        'shipping_address': shippingAddress,
        'billing_address': billingAddress,
      };
}

/// The session write's body; an unset `sessionId` sends `{}`.
class CartSessionInput extends Dto {
  const CartSessionInput({this.sessionId});

  final String? sessionId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sessionId': sessionId,
      };
}

/// The session write's answer.
class CartSession extends Dto {
  const CartSession({this.sessionId});

  static CartSession? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartSession(sessionId: readText(source['sessionId']));
  }

  final String? sessionId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sessionId': sessionId,
      };
}

/// The order write's body, no envelope; `customer_id` takes the customer's
/// `customer_id`.
class CartOrderInput extends Dto {
  const CartOrderInput({
    this.customerId,
    this.paymentGateway,
    this.deliveryType,
    this.transactionNo,
  });

  final int? customerId;

  /// `payment_gateway` — `PIS` when omitted.
  final String? paymentGateway;

  final String? deliveryType;

  final String? transactionNo;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'payment_gateway': paymentGateway,
        'delivery_type': deliveryType,
        'transaction_no': transactionNo,
      };
}

/// A country or a state, as an object; a state arrives `{}` when the address
/// has none.
class CartReference extends Dto {
  const CartReference({this.id, this.name, this.code});

  static CartReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartReference(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  final int? id;

  final String? name;

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// The order's `customer_summary`, carrying both of the customer's ids.
class CartOrderCustomer extends Dto {
  const CartOrderCustomer({
    this.firstName,
    this.lastName,
    this.customerGroup,
    this.gender,
    this.customerId,
    this.internalId,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.state,
    this.postCode,
    this.phone,
    this.mobile,
    this.fax,
    this.companyName,
  });

  static CartOrderCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartOrderCustomer(
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      customerGroup: readText(source['customer_group']),
      gender: readText(source['gender']),
      customerId: readInteger(source['customer_id']),
      internalId: readInteger(source['internal_id']),
      email: readText(source['email']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      city: readText(source['city']),
      country: CartReference.fromMap(source['country']),
      state: CartReference.fromMap(source['state']),
      postCode: readText(source['post_code']),
      phone: readText(source['phone']),
      mobile: readText(source['mobile']),
      fax: readText(source['fax']),
      companyName: readText(source['company_name']),
    );
  }

  final String? firstName;

  final String? lastName;

  final String? customerGroup;

  final String? gender;

  final int? customerId;

  final int? internalId;

  final String? email;

  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  final CartReference? country;

  final CartReference? state;

  final String? postCode;

  final String? phone;

  final String? mobile;

  final String? fax;

  final String? companyName;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name': firstName,
        'last_name': lastName,
        'customer_group': customerGroup,
        'gender': gender,
        'customer_id': customerId,
        'internal_id': internalId,
        'email': email,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'country': country,
        'state': state,
        'post_code': postCode,
        'phone': phone,
        'mobile': mobile,
        'fax': fax,
        'company_name': companyName,
      };
}

/// One entry of the order's `order_line_details`.
class CartOrderLine extends Dto {
  const CartOrderLine({
    this.itemId,
    this.productName,
    this.productId,
    this.sku,
    this.quantity,
    this.price,
    this.totalAmount,
    this.tax,
    this.discount,
    this.taxDiscount,
    this.isTaxable,
    this.isShippable,
    this.imageUrl,
    this.variations,
    this.serialBatchNumber,
  });

  static CartOrderLine? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartOrderLine(
      itemId: readInteger(source['item_id']),
      productName: readText(source['product_name']),
      productId: readInteger(source['product_id']),
      sku: readText(source['sku']),
      quantity: readInteger(source['quantity']),
      price: readDecimal(source['price']),
      totalAmount: readDecimal(source['total_amount']),
      tax: readDecimal(source['tax']),
      discount: readDecimal(source['discount']),
      taxDiscount: readDecimal(source['tax_discount']),
      isTaxable: readFlag(source['is_taxable']),
      isShippable: readFlag(source['is_shippable']),
      imageUrl: readText(source['image_url']),
      variations: readList<Object>(source['variations'], readAny),
      serialBatchNumber: readText(source['serial_batch_number']),
    );
  }

  final int? itemId;

  final String? productName;

  final int? productId;

  final String? sku;

  final int? quantity;

  final double? price;

  final double? totalAmount;

  final double? tax;

  final double? discount;

  final double? taxDiscount;

  final bool? isTaxable;

  final bool? isShippable;

  final String? imageUrl;

  final List<Object?>? variations;

  final String? serialBatchNumber;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'item_id': itemId,
        'product_name': productName,
        'product_id': productId,
        'sku': sku,
        'quantity': quantity,
        'price': price,
        'total_amount': totalAmount,
        'tax': tax,
        'discount': discount,
        'tax_discount': taxDiscount,
        'is_taxable': isTaxable,
        'is_shippable': isShippable,
        'image_url': imageUrl,
        'variations': variations,
        'serial_batch_number': serialBatchNumber,
      };
}

/// One entry of the order's `payments`.
class CartOrderPayment extends Dto {
  const CartOrderPayment({
    this.id,
    this.status,
    this.amount,
    this.paymentMethod,
    this.trackInfo,
    this.gatewayName,
    this.gatewayCode,
    this.gatewayResponse,
    this.payerInfo,
    this.payingDate,
    this.transactionDate,
    this.transactionReference,
  });

  static CartOrderPayment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartOrderPayment(
      id: readInteger(source['id']),
      status: readText(source['status']),
      amount: readDecimal(source['amount']),
      paymentMethod: readText(source['payment_method']),
      trackInfo: readText(source['track_info']),
      gatewayName: readText(source['gateway_name']),
      gatewayCode: readText(source['gateway_code']),
      gatewayResponse: readText(source['gateway_response']),
      payerInfo: readText(source['payer_info']),
      payingDate: readText(source['paying_date']),
      transactionDate: readText(source['transaction_date']),
      transactionReference: readText(source['transaction_reference']),
    );
  }

  final int? id;

  final String? status;

  final double? amount;

  final String? paymentMethod;

  final String? trackInfo;

  final String? gatewayName;

  final String? gatewayCode;

  final String? gatewayResponse;

  final String? payerInfo;

  final String? payingDate;

  final String? transactionDate;

  final String? transactionReference;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'status': status,
        'amount': amount,
        'payment_method': paymentMethod,
        'track_info': trackInfo,
        'gateway_name': gatewayName,
        'gateway_code': gatewayCode,
        'gateway_response': gatewayResponse,
        'payer_info': payerInfo,
        'paying_date': payingDate,
        'transaction_date': transactionDate,
        'transaction_reference': transactionReference,
      };
}

/// The order's billing or shipping address.
class CartOrderAddress extends Dto {
  const CartOrderAddress({
    this.id,
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

  static CartOrderAddress? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CartOrderAddress(
      id: readInteger(source['id']),
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

  final int? id;

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
        'id': id,
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

/// The order a cart became, with the write's `status` read from beside the
/// envelope.
class CartOrder extends Dto {
  const CartOrder({
    this.status,
    this.orderId,
    this.internalId,
    this.orderNo,
    this.transactionNo,
    this.currencyCode,
    this.orderStatus,
    this.paymentStatus,
    this.shippingStatus,
    this.subTotal,
    this.shippingCost,
    this.shippingTax,
    this.handlingCost,
    this.totalSurcharge,
    this.totalDiscount,
    this.totalTax,
    this.grandTotal,
    this.paid,
    this.due,
    this.itemsTotal,
    this.ipAddress,
    this.orderChannel,
    this.createdAt,
    this.updatedAt,
    this.customerSummary,
    this.orderLineDetails,
    this.payments,
    this.externalReferenceOrderId,
    this.externalReferenceStoreId,
    this.externalReferenceOrderNo,
    this.externalReferenceStatus,
    this.externalReferenceUrl,
    this.customerPoNumber,
    this.paymentTerm,
    this.fulfillmentMode,
    this.fulfillmentTerm,
    this.invoiceMode,
    this.billingAddress,
    this.shippingAddress,
    this.customFields,
  });

  /// Reads the `order` envelope and the `status` beside it.
  static CartOrder? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order');
    if (source == null) return null;
    return CartOrder(
      status: readText(source['status']),
      orderId: readInteger(source['order_id']),
      internalId: readInteger(source['internal_id']),
      orderNo: readInteger(source['order_no']),
      transactionNo: readText(source['transaction_no']),
      currencyCode: readText(source['currency_code']),
      orderStatus: readText(source['order_status']),
      paymentStatus: readText(source['payment_status']),
      shippingStatus: readText(source['shipping_status']),
      subTotal: readDecimal(source['sub_total']),
      shippingCost: readDecimal(source['shipping_cost']),
      shippingTax: readDecimal(source['shipping_tax']),
      handlingCost: readDecimal(source['handling_cost']),
      totalSurcharge: readDecimal(source['total_surcharge']),
      totalDiscount: readDecimal(source['total_discount']),
      totalTax: readDecimal(source['total_tax']),
      grandTotal: readDecimal(source['grand_total']),
      paid: readDecimal(source['paid']),
      due: readDecimal(source['due']),
      itemsTotal: readInteger(source['items_total']),
      ipAddress: readText(source['ip_address']),
      orderChannel: readText(source['order_channel']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
      customerSummary: CartOrderCustomer.fromMap(source['customer_summary']),
      orderLineDetails: readList<CartOrderLine>(
          source['order_line_details'], CartOrderLine.fromMap),
      payments: readList<CartOrderPayment>(
          source['payments'], CartOrderPayment.fromMap),
      externalReferenceOrderId: readAny(source['external_reference_order_id']),
      externalReferenceStoreId: readAny(source['external_reference_store_id']),
      externalReferenceOrderNo: readAny(source['external_reference_order_no']),
      externalReferenceStatus: readAny(source['external_reference_status']),
      externalReferenceUrl: readAny(source['external_reference_url']),
      customerPoNumber: readText(source['customer_po_number']),
      paymentTerm: readText(source['payment_term']),
      fulfillmentMode: readText(source['fulfillment_mode']),
      fulfillmentTerm: readText(source['fulfillment_term']),
      invoiceMode: readText(source['invoice_mode']),
      billingAddress: CartOrderAddress.fromMap(source['billing_address']),
      shippingAddress: CartOrderAddress.fromMap(source['shipping_address']),
      customFields: readList<Object>(source['custom_fields'], readAny),
    );
  }

  /// `status` — beside the envelope, `success` on a conversion.
  final String? status;

  final int? orderId;

  final int? internalId;

  final int? orderNo;

  /// `transaction_no` — `null` here even when the write stored one.
  final String? transactionNo;

  final String? currencyCode;

  final String? orderStatus;

  final String? paymentStatus;

  final String? shippingStatus;

  final double? subTotal;

  final double? shippingCost;

  final double? shippingTax;

  final double? handlingCost;

  final double? totalSurcharge;

  final double? totalDiscount;

  final double? totalTax;

  final double? grandTotal;

  final double? paid;

  final double? due;

  final int? itemsTotal;

  final String? ipAddress;

  final String? orderChannel;

  final String? createdAt;

  final String? updatedAt;

  final CartOrderCustomer? customerSummary;

  final List<CartOrderLine?>? orderLineDetails;

  final List<CartOrderPayment?>? payments;

  final Object? externalReferenceOrderId;

  final Object? externalReferenceStoreId;

  final Object? externalReferenceOrderNo;

  final Object? externalReferenceStatus;

  final Object? externalReferenceUrl;

  final String? customerPoNumber;

  final String? paymentTerm;

  final String? fulfillmentMode;

  final String? fulfillmentTerm;

  final String? invoiceMode;

  final CartOrderAddress? billingAddress;

  final CartOrderAddress? shippingAddress;

  final List<Object?>? customFields;

  @override
  String? get envelopeKey => 'order';

  @override
  Set<String> get topLevelFields => const <String>{'status'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'order_id': orderId,
        'internal_id': internalId,
        'order_no': orderNo,
        'transaction_no': transactionNo,
        'currency_code': currencyCode,
        'order_status': orderStatus,
        'payment_status': paymentStatus,
        'shipping_status': shippingStatus,
        'sub_total': subTotal,
        'shipping_cost': shippingCost,
        'shipping_tax': shippingTax,
        'handling_cost': handlingCost,
        'total_surcharge': totalSurcharge,
        'total_discount': totalDiscount,
        'total_tax': totalTax,
        'grand_total': grandTotal,
        'paid': paid,
        'due': due,
        'items_total': itemsTotal,
        'ip_address': ipAddress,
        'order_channel': orderChannel,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'customer_summary': customerSummary,
        'order_line_details': orderLineDetails,
        'payments': payments,
        'external_reference_order_id': externalReferenceOrderId,
        'external_reference_store_id': externalReferenceStoreId,
        'external_reference_order_no': externalReferenceOrderNo,
        'external_reference_status': externalReferenceStatus,
        'external_reference_url': externalReferenceUrl,
        'customer_po_number': customerPoNumber,
        'payment_term': paymentTerm,
        'fulfillment_mode': fulfillmentMode,
        'fulfillment_term': fulfillmentTerm,
        'invoice_mode': invoiceMode,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'custom_fields': customFields,
      };
}
