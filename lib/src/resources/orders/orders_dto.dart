/// Typed views over the order bodies.
library;

import '../../client/dto.dart';

/// A country or a state as an order answers it: `{"id", "name", "code"}`.
class OrderReference extends Dto {
  const OrderReference({this.id, this.name, this.code});

  /// Reads an address's `country` or `state`.
  static OrderReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderReference(
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

/// The order's `customer` section, also sent as `customer_summary`. A listing
/// row carries five of these keys.
class OrderCustomer extends Dto {
  const OrderCustomer({
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

  /// Reads a `customer` or `customer_summary` section.
  static OrderCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomer(
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
      country: OrderReference.fromMap(source['country']),
      state: OrderReference.fromMap(source['state']),
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

  /// `customer_id` — the public id a `{customer_id}` slot takes.
  final int? customerId;

  /// `internal_id` — what the listing's `customerId` filter takes.
  final int? internalId;

  final String? email;

  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  final OrderReference? country;

  final OrderReference? state;

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

/// A billing or shipping address.
class OrderAddress extends Dto {
  const OrderAddress({
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

  /// Reads a `billing_address` or `shipping_address`.
  static OrderAddress? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderAddress(
      id: readInteger(source['id']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
      companyName: readText(source['company_name']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      country: OrderReference.fromMap(source['country']),
      state: OrderReference.fromMap(source['state']),
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

  /// `company_name` — reads `""` whatever was written.
  final String? companyName;

  final String? addressLine1;

  final String? addressLine2;

  final OrderReference? country;

  final OrderReference? state;

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

/// One order line, under `items` or `order_line_details`.
class OrderLine extends Dto {
  const OrderLine({
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

  /// Reads one line.
  static OrderLine? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderLine(
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

  /// `item_id` — what a refund line and a shipment line name as `order_item_id`.
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

  /// `variations` — `[]`, except on a create's answer, which sends `null`.
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

/// The `shipping` section.
class OrderShipping extends Dto {
  const OrderShipping({
    this.deliveryType,
    this.shippingType,
    this.shippingStatus,
    this.shippingCost,
    this.shippingTax,
  });

  /// Reads the section.
  static OrderShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderShipping(
      deliveryType: readText(source['delivery_type']),
      shippingType: readText(source['shipping_type']),
      shippingStatus: readText(source['shipping_status']),
      shippingCost: readDecimal(source['shipping_cost']),
      shippingTax: readDecimal(source['shipping_tax']),
    );
  }

  final String? deliveryType;

  /// `shipping_type` — the first shipment's method.
  final String? shippingType;

  final String? shippingStatus;

  final double? shippingCost;

  final double? shippingTax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'delivery_type': deliveryType,
        'shipping_type': shippingType,
        'shipping_status': shippingStatus,
        'shipping_cost': shippingCost,
        'shipping_tax': shippingTax,
      };
}

/// The `discounts` section.
class OrderDiscounts extends Dto {
  const OrderDiscounts(
      {this.totalDiscount, this.couponCode, this.giftCardCode});

  /// Reads the section.
  static OrderDiscounts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderDiscounts(
      totalDiscount: readDecimal(source['total_discount']),
      couponCode: readText(source['coupon_code']),
      giftCardCode: readText(source['gift_card_code']),
    );
  }

  final double? totalDiscount;

  final String? couponCode;

  final String? giftCardCode;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total_discount': totalDiscount,
        'coupon_code': couponCode,
        'gift_card_code': giftCardCode,
      };
}

/// The `charges_totals` section; a payment refund lowers `paid` and an order
/// refund does not.
class OrderChargesTotals extends Dto {
  const OrderChargesTotals({
    this.subTotal,
    this.totalTax,
    this.handlingCost,
    this.totalSurcharge,
    this.otherCharges,
    this.grandTotal,
    this.paid,
    this.due,
    this.refunded,
    this.refundStatus,
    this.itemsTotal,
  });

  /// Reads the section.
  static OrderChargesTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderChargesTotals(
      subTotal: readDecimal(source['sub_total']),
      totalTax: readDecimal(source['total_tax']),
      handlingCost: readDecimal(source['handling_cost']),
      totalSurcharge: readDecimal(source['total_surcharge']),
      otherCharges: readDecimal(source['other_charges']),
      grandTotal: readDecimal(source['grand_total']),
      paid: readDecimal(source['paid']),
      due: readDecimal(source['due']),
      refunded: readDecimal(source['refunded']),
      refundStatus: readText(source['refund_status']),
      itemsTotal: readInteger(source['items_total']),
    );
  }

  final double? subTotal;

  final double? totalTax;

  final double? handlingCost;

  final double? totalSurcharge;

  final double? otherCharges;

  final double? grandTotal;

  final double? paid;

  final double? due;

  final double? refunded;

  final String? refundStatus;

  final int? itemsTotal;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sub_total': subTotal,
        'total_tax': totalTax,
        'handling_cost': handlingCost,
        'total_surcharge': totalSurcharge,
        'other_charges': otherCharges,
        'grand_total': grandTotal,
        'paid': paid,
        'due': due,
        'refunded': refunded,
        'refund_status': refundStatus,
        'items_total': itemsTotal,
      };
}

/// One entry of an order's `payments`.
class OrderPayment extends Dto {
  const OrderPayment({
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

  /// Reads one payment.
  static OrderPayment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderPayment(
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

  /// `gateway_response` — sent only in the flat shape.
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

/// The `fulfillment` section.
class OrderFulfillment extends Dto {
  const OrderFulfillment({
    this.fulfillmentMode,
    this.fulfillmentTerm,
    this.invoiceMode,
    this.paymentTerm,
    this.customerPoNumber,
    this.externalReferenceOrderId,
    this.externalReferenceStoreId,
    this.externalReferenceOrderNo,
    this.externalReferenceStatus,
    this.externalReferenceUrl,
    this.customFields,
  });

  /// Reads the section.
  static OrderFulfillment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderFulfillment(
      fulfillmentMode: readText(source['fulfillment_mode']),
      fulfillmentTerm: readText(source['fulfillment_term']),
      invoiceMode: readText(source['invoice_mode']),
      paymentTerm: readText(source['payment_term']),
      customerPoNumber: readText(source['customer_po_number']),
      externalReferenceOrderId: readText(source['external_reference_order_id']),
      externalReferenceStoreId: readText(source['external_reference_store_id']),
      externalReferenceOrderNo: readText(source['external_reference_order_no']),
      externalReferenceStatus: readText(source['external_reference_status']),
      externalReferenceUrl: readText(source['external_reference_url']),
      customFields: readList<Object>(source['custom_fields'], readAny),
    );
  }

  final String? fulfillmentMode;

  final String? fulfillmentTerm;

  final String? invoiceMode;

  final String? paymentTerm;

  final String? customerPoNumber;

  final String? externalReferenceOrderId;

  final String? externalReferenceStoreId;

  final String? externalReferenceOrderNo;

  final String? externalReferenceStatus;

  final String? externalReferenceUrl;

  final List<Object?>? customFields;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'fulfillment_mode': fulfillmentMode,
        'fulfillment_term': fulfillmentTerm,
        'invoice_mode': invoiceMode,
        'payment_term': paymentTerm,
        'customer_po_number': customerPoNumber,
        'external_reference_order_id': externalReferenceOrderId,
        'external_reference_store_id': externalReferenceStoreId,
        'external_reference_order_no': externalReferenceOrderNo,
        'external_reference_status': externalReferenceStatus,
        'external_reference_url': externalReferenceUrl,
        'custom_fields': customFields,
      };
}

/// One `group_meta` entry.
class OrderSectionMeta extends Dto {
  const OrderSectionMeta({this.kind, this.writable, this.href});

  /// Reads one entry.
  static OrderSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderSectionMeta(
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

/// The `group_meta` block; the listing's has no entry for the two addresses.
class OrderGroupMeta extends Dto {
  const OrderGroupMeta({
    this.customer,
    this.billingAddress,
    this.shippingAddress,
    this.items,
    this.shipping,
    this.discounts,
    this.chargesTotals,
    this.payments,
    this.fulfillment,
  });

  /// Reads the block.
  static OrderGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderGroupMeta(
      customer: OrderSectionMeta.fromMap(source['customer']),
      billingAddress: OrderSectionMeta.fromMap(source['billing_address']),
      shippingAddress: OrderSectionMeta.fromMap(source['shipping_address']),
      items: OrderSectionMeta.fromMap(source['items']),
      shipping: OrderSectionMeta.fromMap(source['shipping']),
      discounts: OrderSectionMeta.fromMap(source['discounts']),
      chargesTotals: OrderSectionMeta.fromMap(source['charges_totals']),
      payments: OrderSectionMeta.fromMap(source['payments']),
      fulfillment: OrderSectionMeta.fromMap(source['fulfillment']),
    );
  }

  final OrderSectionMeta? customer;

  final OrderSectionMeta? billingAddress;

  final OrderSectionMeta? shippingAddress;

  final OrderSectionMeta? items;

  final OrderSectionMeta? shipping;

  final OrderSectionMeta? discounts;

  final OrderSectionMeta? chargesTotals;

  final OrderSectionMeta? payments;

  final OrderSectionMeta? fulfillment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer': customer,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'items': items,
        'shipping': shipping,
        'discounts': discounts,
        'charges_totals': chargesTotals,
        'payments': payments,
        'fulfillment': fulfillment,
      };
}

/// One order in sections: the row path's body, a `PUT` or `PATCH` answer, and
/// a listing row, which carries no `billing_address` or `shipping_address`.
class Order extends Dto {
  const Order({
    this.orderId,
    this.orderNo,
    this.internalId,
    this.uuid,
    this.orderStatus,
    this.paymentStatus,
    this.shippingStatus,
    this.currencyCode,
    this.transactionNo,
    this.ipAddress,
    this.orderChannel,
    this.createdOn,
    this.lastUpdatedOn,
    this.customer,
    this.billingAddress,
    this.shippingAddress,
    this.items,
    this.shipping,
    this.discounts,
    this.chargesTotals,
    this.payments,
    this.fulfillment,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads a row path's `order` envelope and the blocks beside it, or a bare
  /// listing row.
  static Order? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order');
    if (source == null) return null;
    return Order(
      orderId: readInteger(source['order_id']),
      orderNo: readInteger(source['order_no']),
      internalId: readInteger(source['internal_id']),
      uuid: readText(source['uuid']),
      orderStatus: readText(source['order_status']),
      paymentStatus: readText(source['payment_status']),
      shippingStatus: readText(source['shipping_status']),
      currencyCode: readText(source['currency_code']),
      transactionNo: readText(source['transaction_no']),
      ipAddress: readText(source['ip_address']),
      orderChannel: readText(source['order_channel']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      customer: OrderCustomer.fromMap(source['customer']),
      billingAddress: OrderAddress.fromMap(source['billing_address']),
      shippingAddress: OrderAddress.fromMap(source['shipping_address']),
      items: readList<OrderLine>(source['items'], OrderLine.fromMap),
      shipping: OrderShipping.fromMap(source['shipping']),
      discounts: OrderDiscounts.fromMap(source['discounts']),
      chargesTotals: OrderChargesTotals.fromMap(source['charges_totals']),
      payments:
          readList<OrderPayment>(source['payments'], OrderPayment.fromMap),
      fulfillment: OrderFulfillment.fromMap(source['fulfillment']),
      groupMeta: OrderGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `order_id` — what every order path but two takes; equal to `order_no`.
  final int? orderId;

  final int? orderNo;

  /// `internal_id` — what `custom_fields` and `send-invoice` take.
  final int? internalId;

  /// `uuid` — a UUID string the store assigns; not writable.
  final String? uuid;

  final String? orderStatus;

  final String? paymentStatus;

  /// `shipping_status` — `not_shipped` here where the flat shape says `unshipped`.
  final String? shippingStatus;

  final String? currencyCode;

  final String? transactionNo;

  final String? ipAddress;

  final String? orderChannel;

  final String? createdOn;

  final String? lastUpdatedOn;

  final OrderCustomer? customer;

  final OrderAddress? billingAddress;

  final OrderAddress? shippingAddress;

  final List<OrderLine?>? items;

  final OrderShipping? shipping;

  final OrderDiscounts? discounts;

  final OrderChargesTotals? chargesTotals;

  final List<OrderPayment?>? payments;

  final OrderFulfillment? fulfillment;

  /// `group_meta` — beside the envelope.
  final OrderGroupMeta? groupMeta;

  /// `field_metadata` — beside the envelope, only when it was asked for.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'order';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'order_no': orderNo,
        'internal_id': internalId,
        'uuid': uuid,
        'order_status': orderStatus,
        'payment_status': paymentStatus,
        'shipping_status': shippingStatus,
        'currency_code': currencyCode,
        'transaction_no': transactionNo,
        'ip_address': ipAddress,
        'order_channel': orderChannel,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'customer': customer,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'items': items,
        'shipping': shipping,
        'discounts': discounts,
        'charges_totals': chargesTotals,
        'payments': payments,
        'fulfillment': fulfillment,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The listing's ten-key `pagination` block.
class OrderPagination extends Dto {
  const OrderPagination({
    this.total,
    this.limit,
    this.offset,
    this.count,
    this.currentPage,
    this.totalPages,
    this.hasNext,
    this.hasPrevious,
    this.previousPage,
    this.nextPage,
  });

  /// Reads the block beside the rows.
  static OrderPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      count: readInteger(source['count']),
      currentPage: readInteger(source['current_page']),
      totalPages: readInteger(source['total_pages']),
      hasNext: readFlag(source['has_next']),
      hasPrevious: readFlag(source['has_previous']),
      previousPage: readText(source['previous_page']),
      nextPage: readText(source['next_page']),
    );
  }

  final int? total;

  /// `limit` — the page size applied, at most 20.
  final int? limit;

  final int? offset;

  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  final String? previousPage;

  final String? nextPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'count': count,
        'current_page': currentPage,
        'total_pages': totalPages,
        'has_next': hasNext,
        'has_previous': hasPrevious,
        'previous_page': previousPage,
        'next_page': nextPage,
      };
}

/// One page of the listing, with the `field_metadata` block when it was asked
/// for.
class OrderPage extends Dto {
  const OrderPage(
      {this.orders, this.pagination, this.groupMeta, this.fieldMetadata});

  /// Reads a listing body.
  static OrderPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderPage(
      orders: readList<Order>(source['orders'], Order.fromMap),
      pagination: OrderPagination.fromMap(source['pagination']),
      groupMeta: OrderGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<Order?>? orders;

  final OrderPagination? pagination;

  final OrderGroupMeta? groupMeta;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'orders': orders,
        'pagination': pagination,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's body, `{"orders": {"count": N}}`.
class OrderCount extends Dto {
  const OrderCount({this.count});

  /// Reads the count from inside its `orders` wrapper.
  static OrderCount? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'orders');
    if (source == null) return null;
    return OrderCount(count: readInteger(source['count']));
  }

  final int? count;

  @override
  String? get envelopeKey => 'orders';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
      };
}

/// One order with its totals and fulfilment at the top: what a create, a
/// cancel and a status move answer, and a per-customer listing row.
class FlatOrder extends Dto {
  const FlatOrder({
    this.orderId,
    this.orderNo,
    this.internalId,
    this.uuid,
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
    this.status,
  });

  /// Reads an `order` envelope and the `status` beside it, or a bare row.
  static FlatOrder? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'order');
    if (source == null) return null;
    return FlatOrder(
      orderId: readInteger(source['order_id']),
      orderNo: readInteger(source['order_no']),
      internalId: readInteger(source['internal_id']),
      uuid: readText(source['uuid']),
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
      customerSummary: OrderCustomer.fromMap(source['customer_summary']),
      orderLineDetails:
          readList<OrderLine>(source['order_line_details'], OrderLine.fromMap),
      payments:
          readList<OrderPayment>(source['payments'], OrderPayment.fromMap),
      externalReferenceOrderId: readText(source['external_reference_order_id']),
      externalReferenceStoreId: readText(source['external_reference_store_id']),
      externalReferenceOrderNo: readText(source['external_reference_order_no']),
      externalReferenceStatus: readText(source['external_reference_status']),
      externalReferenceUrl: readText(source['external_reference_url']),
      customerPoNumber: readText(source['customer_po_number']),
      paymentTerm: readText(source['payment_term']),
      fulfillmentMode: readText(source['fulfillment_mode']),
      fulfillmentTerm: readText(source['fulfillment_term']),
      invoiceMode: readText(source['invoice_mode']),
      billingAddress: OrderAddress.fromMap(source['billing_address']),
      shippingAddress: OrderAddress.fromMap(source['shipping_address']),
      customFields: readList<Object>(source['custom_fields'], readAny),
      status: readText(source['status']),
    );
  }

  final int? orderId;

  final int? orderNo;

  final int? internalId;
  final String? uuid;

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

  final OrderCustomer? customerSummary;

  final List<OrderLine?>? orderLineDetails;

  final List<OrderPayment?>? payments;

  final String? externalReferenceOrderId;

  final String? externalReferenceStoreId;

  final String? externalReferenceOrderNo;

  final String? externalReferenceStatus;

  final String? externalReferenceUrl;

  final String? customerPoNumber;

  final String? paymentTerm;

  final String? fulfillmentMode;

  final String? fulfillmentTerm;

  final String? invoiceMode;

  final OrderAddress? billingAddress;

  final OrderAddress? shippingAddress;

  final List<Object?>? customFields;

  /// `status` — beside the envelope, on a create's answer only.
  final String? status;

  @override
  String? get envelopeKey => 'order';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'order_no': orderNo,
        'internal_id': internalId,
        'uuid': uuid,
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
        'status': status,
      };
}

/// One customer's orders, unpaged, cancelled ones left out.
class CustomerOrders extends Dto {
  const CustomerOrders({this.customerId, this.internalId, this.orders});

  /// Reads the per-customer listing.
  static CustomerOrders? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerOrders(
      customerId: readInteger(source['customer_id']),
      internalId: readInteger(source['internal_id']),
      orders: readList<FlatOrder>(source['orders'], FlatOrder.fromMap),
    );
  }

  final int? customerId;

  final int? internalId;

  final List<FlatOrder?>? orders;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'internal_id': internalId,
        'orders': orders,
      };
}

/// What the addresses sub-path answers: both addresses as they now stand.
class OrderAddresses extends Dto {
  const OrderAddresses({
    this.orderId,
    this.internalId,
    this.billingAddress,
    this.shippingAddress,
  });

  /// Reads the sub-path's body.
  static OrderAddresses? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderAddresses(
      orderId: readInteger(source['order_id']),
      internalId: readInteger(source['internal_id']),
      billingAddress: OrderAddress.fromMap(source['billing_address']),
      shippingAddress: OrderAddress.fromMap(source['shipping_address']),
    );
  }

  final int? orderId;

  final int? internalId;

  final OrderAddress? billingAddress;

  final OrderAddress? shippingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'internal_id': internalId,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      };
}

/// One comment on an order.
class OrderCommentRecord extends Dto {
  const OrderCommentRecord({
    this.id,
    this.content,
    this.adminName,
    this.visibleToCustomer,
    this.admin,
    this.created,
  });

  /// Reads a create's `comment` envelope, or a bare listing row.
  static OrderCommentRecord? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'comment');
    if (source == null) return null;
    return OrderCommentRecord(
      id: readInteger(source['id']),
      content: readText(source['content']),
      adminName: readText(source['admin_name']),
      visibleToCustomer: readFlag(source['visible_to_customer']),
      admin: readFlag(source['admin']),
      created: readText(source['created']),
    );
  }

  final int? id;

  final String? content;

  final String? adminName;

  final bool? visibleToCustomer;

  final bool? admin;

  /// `created` — `M/D/YYYY` and a time two spaces apart, not ISO 8601.
  final String? created;

  @override
  String? get envelopeKey => 'comment';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'content': content,
        'admin_name': adminName,
        'visible_to_customer': visibleToCustomer,
        'admin': admin,
        'created': created,
      };
}

/// An order's comments, oldest first and unpaged.
class OrderCommentList extends Dto {
  const OrderCommentList({this.comments});

  /// Reads the comments body.
  static OrderCommentList? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCommentList(
      comments: readList<OrderCommentRecord>(
          source['comments'], OrderCommentRecord.fromMap),
    );
  }

  final List<OrderCommentRecord?>? comments;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'comments': comments,
      };
}

/// An order's custom field values; a `delivery` order adds `delivery_cost`.
class OrderCustomFieldValues extends Dto {
  const OrderCustomFieldValues(
      {this.orderId, this.customFields, this.deliveryCost});

  /// Reads the custom fields body.
  static OrderCustomFieldValues? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderCustomFieldValues(
      orderId: readInteger(source['order_id']),
      customFields: readList<Object>(source['custom_fields'], readAny),
      deliveryCost: readDecimal(source['delivery_cost']),
    );
  }

  /// `order_id` — echoes the `internal_id` asked for.
  final int? orderId;

  final List<Object?>? customFields;

  final double? deliveryCost;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'custom_fields': customFields,
        'delivery_cost': deliveryCost,
      };
}

/// The customer a payment receipt names.
class PaymentReceiptCustomer extends Dto {
  const PaymentReceiptCustomer({this.id, this.internalId, this.name});

  /// Reads the receipt's `customer`.
  static PaymentReceiptCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentReceiptCustomer(
      id: readInteger(source['id']),
      internalId: readInteger(source['internal_id']),
      name: readText(source['name']),
    );
  }

  /// `id` — the public `customer_id`.
  final int? id;

  final int? internalId;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'internal_id': internalId,
        'name': name,
      };
}

/// What recording a payment answers.
class PaymentReceipt extends Dto {
  const PaymentReceipt({
    this.status,
    this.id,
    this.date,
    this.transactionDate,
    this.transactionReference,
    this.paymentApplied,
    this.paymentMethod,
    this.payerInfo,
    this.orderId,
    this.orderInternalId,
    this.orderTotal,
    this.dueAmount,
    this.paidAmount,
    this.customer,
    this.createdBy,
    this.createdAt,
  });

  /// Reads the `payment` envelope.
  static PaymentReceipt? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'payment');
    if (source == null) return null;
    return PaymentReceipt(
      status: readText(source['status']),
      id: readInteger(source['id']),
      date: readText(source['date']),
      transactionDate: readText(source['transaction_date']),
      transactionReference: readText(source['transaction_reference']),
      paymentApplied: readDecimal(source['payment_applied']),
      paymentMethod: readText(source['payment_method']),
      payerInfo: readText(source['payer_info']),
      orderId: readInteger(source['order_id']),
      orderInternalId: readInteger(source['order_internal_id']),
      orderTotal: readDecimal(source['order_total']),
      dueAmount: readDecimal(source['due_amount']),
      paidAmount: readDecimal(source['paid_amount']),
      customer: PaymentReceiptCustomer.fromMap(source['customer']),
      createdBy: readText(source['created_by']),
      createdAt: readText(source['created_at']),
    );
  }

  final String? status;

  /// `id` — the `{payment_id}` a payment refund takes.
  final int? id;

  final String? date;

  final String? transactionDate;

  final String? transactionReference;

  final double? paymentApplied;

  final String? paymentMethod;

  final String? payerInfo;

  final int? orderId;

  final int? orderInternalId;

  final double? orderTotal;

  final double? dueAmount;

  final double? paidAmount;

  final PaymentReceiptCustomer? customer;

  final String? createdBy;

  final String? createdAt;

  @override
  String? get envelopeKey => 'payment';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'id': id,
        'date': date,
        'transaction_date': transactionDate,
        'transaction_reference': transactionReference,
        'payment_applied': paymentApplied,
        'payment_method': paymentMethod,
        'payer_info': payerInfo,
        'order_id': orderId,
        'order_internal_id': orderInternalId,
        'order_total': orderTotal,
        'due_amount': dueAmount,
        'paid_amount': paidAmount,
        'customer': customer,
        'created_by': createdBy,
        'created_at': createdAt,
      };
}

/// What an order refund answers.
class OrderRefund extends Dto {
  const OrderRefund({
    this.status,
    this.refundId,
    this.orderId,
    this.internalId,
    this.amount,
  });

  /// Reads the refund body.
  static OrderRefund? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderRefund(
      status: readText(source['status']),
      refundId: readInteger(source['refund_id']),
      orderId: readInteger(source['order_id']),
      internalId: readInteger(source['internal_id']),
      amount: readText(source['amount']),
    );
  }

  final String? status;

  final int? refundId;

  final int? orderId;

  final int? internalId;

  /// `amount` — the text that was sent.
  final String? amount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'refund_id': refundId,
        'order_id': orderId,
        'internal_id': internalId,
        'amount': amount,
      };
}

/// One order line a refund was spread over; the money fields are decimal text
/// such as `"1.00"`. `ext_item_referer` was `null` on every line read, so it is
/// not typed.
class OrderRefundRecordLine extends Dto {
  const OrderRefundRecordLine({
    this.orderItemId,
    this.productSku,
    this.productName,
    this.extItemReferer,
    this.pluginLine,
    this.quantity,
    this.linePaid,
    this.amount,
    this.lineRefundedTotal,
    this.lineFullyRefunded,
  });

  /// Reads one entry of `lines`.
  static OrderRefundRecordLine? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderRefundRecordLine(
      orderItemId: readInteger(source['order_item_id']),
      productSku: readText(source['product_sku']),
      productName: readText(source['product_name']),
      extItemReferer: readAny(source['ext_item_referer']),
      pluginLine: readFlag(source['plugin_line']),
      quantity: readInteger(source['quantity']),
      linePaid: readText(source['line_paid']),
      amount: readText(source['amount']),
      lineRefundedTotal: readText(source['line_refunded_total']),
      lineFullyRefunded: readFlag(source['line_fully_refunded']),
    );
  }

  final int? orderItemId;

  final String? productSku;

  final String? productName;

  final Object? extItemReferer;

  final bool? pluginLine;

  final int? quantity;

  final String? linePaid;

  final String? amount;

  final String? lineRefundedTotal;

  final bool? lineFullyRefunded;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item_id': orderItemId,
        'product_sku': productSku,
        'product_name': productName,
        'ext_item_referer': extItemReferer,
        'plugin_line': pluginLine,
        'quantity': quantity,
        'line_paid': linePaid,
        'amount': amount,
        'line_refunded_total': lineRefundedTotal,
        'line_fully_refunded': lineFullyRefunded,
      };
}

/// One refund an order holds. `order_id` is the order's internal id. A payment
/// refund fills `record_only` to `lines`; an order refund leaves them `null`
/// and `lines` empty. `gateway_charge_id`, `gateway_refund_id` and
/// `failure_cause` were `null` on every refund read, so they are not typed.
class OrderRefundRecord extends Dto {
  const OrderRefundRecord({
    this.gateway,
    this.gatewayChargeId,
    this.gatewayRefundId,
    this.recordOnly,
    this.initiatedBy,
    this.cancelledWithOrder,
    this.notifyCustomer,
    this.allocation,
    this.otherAmount,
    this.lines,
    this.refundId,
    this.paymentId,
    this.orderId,
    this.amount,
    this.status,
    this.transactionStatus,
    this.transactionId,
    this.reason,
    this.failureCause,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads one entry of `refunds`.
  static OrderRefundRecord? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderRefundRecord(
      gateway: readText(source['gateway']),
      gatewayChargeId: readAny(source['gateway_charge_id']),
      gatewayRefundId: readAny(source['gateway_refund_id']),
      recordOnly: readFlag(source['record_only']),
      initiatedBy: readText(source['initiated_by']),
      cancelledWithOrder: readFlag(source['cancelled_with_order']),
      notifyCustomer: readFlag(source['notify_customer']),
      allocation: readText(source['allocation']),
      otherAmount: readText(source['other_amount']),
      lines: readList<OrderRefundRecordLine>(
          source['lines'], OrderRefundRecordLine.fromMap),
      refundId: readInteger(source['refund_id']),
      paymentId: readInteger(source['payment_id']),
      orderId: readInteger(source['order_id']),
      amount: readDecimal(source['amount']),
      status: readText(source['status']),
      transactionStatus: readText(source['transaction_status']),
      transactionId: readText(source['transaction_id']),
      reason: readText(source['reason']),
      failureCause: readAny(source['failure_cause']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final String? gateway;

  final Object? gatewayChargeId;

  final Object? gatewayRefundId;

  final bool? recordOnly;

  final String? initiatedBy;

  final bool? cancelledWithOrder;

  final bool? notifyCustomer;

  final String? allocation;

  final String? otherAmount;

  final List<OrderRefundRecordLine?>? lines;

  final int? refundId;

  final int? paymentId;

  final int? orderId;

  final double? amount;

  final String? status;

  final String? transactionStatus;

  final String? transactionId;

  final String? reason;

  final Object? failureCause;

  final String? createdAt;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'gateway': gateway,
        'gateway_charge_id': gatewayChargeId,
        'gateway_refund_id': gatewayRefundId,
        'record_only': recordOnly,
        'initiated_by': initiatedBy,
        'cancelled_with_order': cancelledWithOrder,
        'notify_customer': notifyCustomer,
        'allocation': allocation,
        'other_amount': otherAmount,
        'lines': lines,
        'refund_id': refundId,
        'payment_id': paymentId,
        'order_id': orderId,
        'amount': amount,
        'status': status,
        'transaction_status': transactionStatus,
        'transaction_id': transactionId,
        'reason': reason,
        'failure_cause': failureCause,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// One page of an order's refunds, newest first. `order_id` is the order's
/// internal id and `order_no` the `{order_id}` the path took.
class OrderRefundPage extends Dto {
  const OrderRefundPage({
    this.orderId,
    this.orderNo,
    this.refunds,
    this.pagination,
  });

  /// Reads a refund listing body.
  static OrderRefundPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderRefundPage(
      orderId: readInteger(source['order_id']),
      orderNo: readInteger(source['order_no']),
      refunds: readList<OrderRefundRecord>(
          source['refunds'], OrderRefundRecord.fromMap),
      pagination: OrderPagination.fromMap(source['pagination']),
    );
  }

  final int? orderId;

  final int? orderNo;

  final List<OrderRefundRecord?>? refunds;

  final OrderPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'order_no': orderNo,
        'refunds': refunds,
        'pagination': pagination,
      };
}

/// What a payment refund answers; a replay drops four flags and adds
/// `idempotent_replay`.
class PaymentRefund extends Dto {
  const PaymentRefund({
    this.status,
    this.refundId,
    this.paymentId,
    this.orderId,
    this.orderNo,
    this.currency,
    this.amount,
    this.reason,
    this.gatewayRefund,
    this.gatewayTransactionId,
    this.transactionStatus,
    this.paymentStatus,
    this.paymentRefundStatus,
    this.orderRefundStatus,
    this.orderRefundedTotal,
    this.orderAdjustment,
    this.orderTotal,
    this.availableForRefund,
    this.adjustWithOrder,
    this.refundEmailQueued,
    this.inventoryReadjusted,
    this.refundedAt,
    this.idempotentReplay,
  });

  /// Reads the refund body.
  static PaymentRefund? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PaymentRefund(
      status: readText(source['status']),
      refundId: readInteger(source['refund_id']),
      paymentId: readInteger(source['payment_id']),
      orderId: readInteger(source['order_id']),
      orderNo: readInteger(source['order_no']),
      currency: readText(source['currency']),
      amount: readDecimal(source['amount']),
      reason: readText(source['reason']),
      gatewayRefund: readFlag(source['gateway_refund']),
      gatewayTransactionId: readText(source['gateway_transaction_id']),
      transactionStatus: readText(source['transaction_status']),
      paymentStatus: readText(source['payment_status']),
      paymentRefundStatus: readText(source['payment_refund_status']),
      orderRefundStatus: readText(source['order_refund_status']),
      orderRefundedTotal: readDecimal(source['order_refunded_total']),
      orderAdjustment: readDecimal(source['order_adjustment']),
      orderTotal: readDecimal(source['order_total']),
      availableForRefund: readDecimal(source['available_for_refund']),
      adjustWithOrder: readFlag(source['adjust_with_order']),
      refundEmailQueued: readFlag(source['refund_email_queued']),
      inventoryReadjusted: readFlag(source['inventory_readjusted']),
      refundedAt: readText(source['refunded_at']),
      idempotentReplay: readFlag(source['idempotent_replay']),
    );
  }

  final String? status;

  final int? refundId;

  final int? paymentId;

  /// `order_id` — the order's `internal_id`, not its `order_id`.
  final int? orderId;

  /// `order_no` — the order's `order_id`.
  final int? orderNo;

  final String? currency;

  final double? amount;

  final String? reason;

  final bool? gatewayRefund;

  final String? gatewayTransactionId;

  final String? transactionStatus;

  final String? paymentStatus;

  final String? paymentRefundStatus;

  final String? orderRefundStatus;

  final double? orderRefundedTotal;

  final double? orderAdjustment;

  final double? orderTotal;

  final double? availableForRefund;

  final bool? adjustWithOrder;

  final bool? refundEmailQueued;

  final bool? inventoryReadjusted;

  final String? refundedAt;

  final bool? idempotentReplay;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'refund_id': refundId,
        'payment_id': paymentId,
        'order_id': orderId,
        'order_no': orderNo,
        'currency': currency,
        'amount': amount,
        'reason': reason,
        'gateway_refund': gatewayRefund,
        'gateway_transaction_id': gatewayTransactionId,
        'transaction_status': transactionStatus,
        'payment_status': paymentStatus,
        'payment_refund_status': paymentRefundStatus,
        'order_refund_status': orderRefundStatus,
        'order_refunded_total': orderRefundedTotal,
        'order_adjustment': orderAdjustment,
        'order_total': orderTotal,
        'available_for_refund': availableForRefund,
        'adjust_with_order': adjustWithOrder,
        'refund_email_queued': refundEmailQueued,
        'inventory_readjusted': inventoryReadjusted,
        'refunded_at': refundedAt,
        'idempotent_replay': idempotentReplay,
      };
}

/// What sending an invoice answers: who it went to and when.
class InvoiceDispatch extends Dto {
  const InvoiceDispatch({
    this.status,
    this.orderId,
    this.internalId,
    this.sentTo,
    this.template,
    this.invoiceDocument,
    this.sentAt,
  });

  /// Reads the send-invoice body.
  static InvoiceDispatch? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return InvoiceDispatch(
      status: readText(source['status']),
      orderId: readInteger(source['order_id']),
      internalId: readInteger(source['internal_id']),
      sentTo: readText(source['sent_to']),
      template: readText(source['template']),
      invoiceDocument: readAny(source['invoice_document']),
      sentAt: readText(source['sent_at']),
    );
  }

  final String? status;

  final int? orderId;

  final int? internalId;

  /// `sent_to` — the billing address's email.
  final String? sentTo;

  final String? template;

  /// `invoice_document` — untyped.
  final Object? invoiceDocument;

  final String? sentAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'order_id': orderId,
        'internal_id': internalId,
        'sent_to': sentTo,
        'template': template,
        'invoice_document': invoiceDocument,
        'sent_at': sentAt,
      };
}

/// One shipment as the shipment status lists it.
class ShipmentTracking extends Dto {
  const ShipmentTracking(
      {this.shippingProvider, this.trackingNumber, this.lastUpdated});

  /// Reads one entry of `shipments_info`.
  static ShipmentTracking? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShipmentTracking(
      shippingProvider: readText(source['shipping_provider']),
      trackingNumber: readText(source['tracking_number']),
      lastUpdated: readText(source['last_updated']),
    );
  }

  final String? shippingProvider;

  final String? trackingNumber;

  final String? lastUpdated;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_provider': shippingProvider,
        'tracking_number': trackingNumber,
        'last_updated': lastUpdated,
      };
}

/// The shipment status: `unshipped`, `partial` or `shipped`.
class ShipmentStatus extends Dto {
  const ShipmentStatus({
    this.orderId,
    this.internalId,
    this.shipmentStatus,
    this.shipmentsInfo,
  });

  /// Reads the shipment-status body.
  static ShipmentStatus? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShipmentStatus(
      orderId: readInteger(source['order_id']),
      internalId: readInteger(source['internal_id']),
      shipmentStatus: readText(source['shipment_status']),
      shipmentsInfo: readList<ShipmentTracking>(
          source['shipments_info'], ShipmentTracking.fromMap),
    );
  }

  final int? orderId;

  final int? internalId;

  final String? shipmentStatus;

  final List<ShipmentTracking?>? shipmentsInfo;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'internal_id': internalId,
        'shipment_status': shipmentStatus,
        'shipments_info': shipmentsInfo,
      };
}

/// One line a shipment carries.
class ShipmentItem extends Dto {
  const ShipmentItem({
    this.orderItemId,
    this.productId,
    this.productName,
    this.productSku,
    this.shippingClass,
    this.orderQuantity,
    this.shippedQuantity,
    this.totalAmount,
  });

  /// Reads one entry of a shipment's `items`.
  static ShipmentItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShipmentItem(
      orderItemId: readInteger(source['order_item_id']),
      productId: readInteger(source['product_id']),
      productName: readText(source['product_name']),
      productSku: readText(source['product_sku']),
      shippingClass: readText(source['shipping_class']),
      orderQuantity: readInteger(source['order_quantity']),
      shippedQuantity: readInteger(source['shipped_quantity']),
      totalAmount: readDecimal(source['total_amount']),
    );
  }

  final int? orderItemId;

  final int? productId;

  final String? productName;

  final String? productSku;

  final String? shippingClass;

  final int? orderQuantity;

  final int? shippedQuantity;

  final double? totalAmount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item_id': orderItemId,
        'product_id': productId,
        'product_name': productName,
        'product_sku': productSku,
        'shipping_class': shippingClass,
        'order_quantity': orderQuantity,
        'shipped_quantity': shippedQuantity,
        'total_amount': totalAmount,
      };
}

/// One shipment. A write's `method`, `tracking_info` and `shipping_date` read
/// back as `shipping_method`, `tracking_number` and `date_created`.
class OrderShipment extends Dto {
  const OrderShipment({
    this.shippingId,
    this.orderId,
    this.orderInternalId,
    this.customerId,
    this.customerInternalId,
    this.orderAddressId,
    this.dateCreated,
    this.trackingNumber,
    this.shippingMethod,
    this.shippingAddress,
    this.billingAddress,
    this.items,
    this.status,
  });

  /// Reads a `shipment` envelope and the `status` beside it, or a bare row.
  static OrderShipment? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipment');
    if (source == null) return null;
    return OrderShipment(
      shippingId: readInteger(source['shipping_id']),
      orderId: readInteger(source['order_id']),
      orderInternalId: readInteger(source['order_internal_id']),
      customerId: readInteger(source['customer_id']),
      customerInternalId: readInteger(source['customer_internal_id']),
      orderAddressId: readInteger(source['order_address_id']),
      dateCreated: readText(source['date_created']),
      trackingNumber: readText(source['tracking_number']),
      shippingMethod: readText(source['shipping_method']),
      shippingAddress: OrderAddress.fromMap(source['shipping_address']),
      billingAddress: OrderAddress.fromMap(source['billing_address']),
      items: readList<ShipmentItem>(source['items'], ShipmentItem.fromMap),
      status: readText(source['status']),
    );
  }

  /// `shipping_id` — what a `{shipment_id}` slot takes.
  final int? shippingId;

  final int? orderId;

  final int? orderInternalId;

  final int? customerId;

  final int? customerInternalId;

  final int? orderAddressId;

  final String? dateCreated;

  final String? trackingNumber;

  final String? shippingMethod;

  final OrderAddress? shippingAddress;

  final OrderAddress? billingAddress;

  final List<ShipmentItem?>? items;

  /// `status` — beside the envelope, on a write's answer.
  final String? status;

  @override
  String? get envelopeKey => 'shipment';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_id': shippingId,
        'order_id': orderId,
        'order_internal_id': orderInternalId,
        'customer_id': customerId,
        'customer_internal_id': customerInternalId,
        'order_address_id': orderAddressId,
        'date_created': dateCreated,
        'tracking_number': trackingNumber,
        'shipping_method': shippingMethod,
        'shipping_address': shippingAddress,
        'billing_address': billingAddress,
        'items': items,
        'status': status,
      };
}

/// An order's shipments, unpaged.
class OrderShipmentList extends Dto {
  const OrderShipmentList({this.shipments});

  /// Reads the shipments body.
  static OrderShipmentList? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderShipmentList(
      shipments:
          readList<OrderShipment>(source['shipments'], OrderShipment.fromMap),
    );
  }

  final List<OrderShipment?>? shipments;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipments': shipments,
      };
}

/// An address to write, replacing the whole one: a field left out reads `""`.
class OrderAddressInput extends Dto {
  const OrderAddressInput({
    this.firstName,
    this.lastName,
    this.email,
    this.companyName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postCode,
    this.phone,
    this.mobile,
    this.fax,
    this.countryCode,
    this.stateCode,
  });

  final String? firstName;

  final String? lastName;

  final String? email;

  final String? companyName;

  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  final String? postCode;

  final String? phone;

  final String? mobile;

  final String? fax;

  final String? countryCode;

  final String? stateCode;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'company_name': companyName,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'post_code': postCode,
        'phone': phone,
        'mobile': mobile,
        'fax': fax,
        'country_code': countryCode,
        'state_code': stateCode,
      };
}

/// One line to order, by the product's `id`.
class OrderProductInput extends Dto {
  const OrderProductInput({this.productId, this.quantity});

  final int? productId;

  final int? quantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product_id': productId,
        'quantity': quantity,
      };
}

/// The create body, with no envelope. `paymentGateway` takes a code, `PIS` for
/// pay in store, and `deliveryType` is lower case; `PAY_IN_STORE` and
/// `SHIPPING` are `400`.
class OrderInput extends Dto {
  const OrderInput({
    this.customerId,
    this.paymentGateway,
    this.deliveryType,
    this.isSendEmail,
    this.transactionNo,
    this.externalReferenceOrderId,
    this.billingAddress,
    this.shippingAddress,
    this.products,
    this.orderChannel,
    this.ipAddress,
  });

  final int? customerId;

  final String? paymentGateway;

  final String? deliveryType;

  final bool? isSendEmail;

  final String? transactionNo;

  final String? externalReferenceOrderId;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  /// `products` — the one field a create requires.
  final List<OrderProductInput?>? products;

  final String? orderChannel;

  final String? ipAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'payment_gateway': paymentGateway,
        'delivery_type': deliveryType,
        'is_send_email': isSendEmail,
        'transaction_no': transactionNo,
        'external_reference_order_id': externalReferenceOrderId,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'products': products,
        'order_channel': orderChannel,
        'ip_address': ipAddress,
      };
}

/// The payment a create-with-payment records. It is filed under method `API`,
/// and `payerInfo`, `transactionReference` and `transactionDate` are not kept.
class InitialPaymentInput extends Dto {
  const InitialPaymentInput({
    this.amount,
    this.surcharge,
    this.status,
    this.paymentMethod,
    this.trackInfo,
    this.payerInfo,
    this.transactionReference,
    this.transactionDate,
  });

  final double? amount;

  final double? surcharge;

  final String? status;

  final String? paymentMethod;

  final String? trackInfo;

  final String? payerInfo;

  final String? transactionReference;

  final String? transactionDate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'surcharge': surcharge,
        'status': status,
        'payment_method': paymentMethod,
        'track_info': trackInfo,
        'payer_info': payerInfo,
        'transaction_reference': transactionReference,
        'transaction_date': transactionDate,
      };
}

/// The create-with-payment body: a create's fields and the `payment` it
/// records; `transactionNo`, `externalReferenceOrderId`, `orderChannel` and
/// `ipAddress` are not kept.
class OrderWithPaymentInput extends OrderInput {
  const OrderWithPaymentInput({
    super.customerId,
    super.paymentGateway,
    super.deliveryType,
    super.isSendEmail,
    super.transactionNo,
    super.externalReferenceOrderId,
    super.billingAddress,
    super.shippingAddress,
    super.products,
    super.orderChannel,
    super.ipAddress,
    this.payment,
  });

  /// `payment` — required here.
  final InitialPaymentInput? payment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'payment': payment,
      };
}

/// The `PUT` body; it writes the customer and the two addresses, and nothing
/// else.
class OrderUpdateInput extends Dto {
  const OrderUpdateInput(
      {this.customerId, this.billingAddress, this.shippingAddress});

  final int? customerId;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  @override
  String? get envelopeKey => 'order';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      };
}

/// The `PATCH` body: the seven fields it writes; an address sent replaces that
/// address.
class OrderPatchInput extends Dto {
  const OrderPatchInput({
    this.orderStatus,
    this.customerPoNumber,
    this.paymentTerm,
    this.billingAddress,
    this.shippingAddress,
    this.orderChannel,
    this.ipAddress,
  });

  /// `order_status` — `cancelled`, `completed`, `draft`, `in_progress`,
  /// `paused` or `reopened`.
  final String? orderStatus;

  final String? customerPoNumber;

  final String? paymentTerm;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  final String? orderChannel;

  final String? ipAddress;

  @override
  String? get envelopeKey => 'order';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_status': orderStatus,
        'customer_po_number': customerPoNumber,
        'payment_term': paymentTerm,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'order_channel': orderChannel,
        'ip_address': ipAddress,
      };
}

/// The addresses sub-path's body; at least one address, and one left out is
/// untouched.
class OrderAddressesInput extends Dto {
  const OrderAddressesInput(
      {this.transactionNo, this.billingAddress, this.shippingAddress});

  final String? transactionNo;

  final OrderAddressInput? billingAddress;

  final OrderAddressInput? shippingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      };
}

/// The cancel body; every field is optional and an empty request cancels too.
class OrderCancelInput extends Dto {
  const OrderCancelInput({
    this.transactionNo,
    this.reason,
    this.refundAutomatically,
    this.isGatewayRefund,
  });

  final String? transactionNo;

  final String? reason;

  final bool? refundAutomatically;

  final bool? isGatewayRefund;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'reason': reason,
        'refund_automatically': refundAutomatically,
        'is_gateway_refund': isGatewayRefund,
      };
}

/// The comment body, with no envelope; `content` is required.
class OrderCommentInput extends Dto {
  const OrderCommentInput({this.content, this.saveAndSend, this.transactionNo});

  final String? content;

  /// `save_and_send` — `true` makes the comment `visible_to_customer`.
  final bool? saveAndSend;

  final String? transactionNo;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'content': content,
        'save_and_send': saveAndSend,
        'transaction_no': transactionNo,
      };
}

/// The payment body: `{"payment": {...}}` with `transaction_no` beside the
/// envelope.
class OrderPaymentInput extends Dto {
  const OrderPaymentInput({
    this.amount,
    this.paymentMethod,
    this.paymentStatus,
    this.trackInfo,
    this.payerInfo,
    this.transactionDate,
    this.transactionReference,
    this.surcharge,
    this.transactionNo,
  });

  final double? amount;

  /// `payment_method` — required.
  final String? paymentMethod;

  final String? paymentStatus;

  final String? trackInfo;

  final String? payerInfo;

  final String? transactionDate;

  final String? transactionReference;

  final double? surcharge;

  final String? transactionNo;

  @override
  String? get envelopeKey => 'payment';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'track_info': trackInfo,
        'payer_info': payerInfo,
        'transaction_date': transactionDate,
        'transaction_reference': transactionReference,
        'surcharge': surcharge,
        'transaction_no': transactionNo,
      };
}

/// One line an order refund names, by the order line's `item_id`.
class RefundLineInput extends Dto {
  const RefundLineInput({this.orderItemId, this.quantity, this.amount});

  final int? orderItemId;

  final int? quantity;

  final double? amount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item_id': orderItemId,
        'quantity': quantity,
        'amount': amount,
      };
}

/// The order refund body, `{"refund": {...}}`; `refundDate` is required, and
/// `amount` may not pass what was paid less earlier refunds.
class OrderRefundInput extends Dto {
  const OrderRefundInput(
      {this.amount, this.refundDate, this.reason, this.lineItems});

  final String? amount;

  final String? refundDate;

  final String? reason;

  final List<RefundLineInput?>? lineItems;

  @override
  String? get envelopeKey => 'refund';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'refund_date': refundDate,
        'reason': reason,
        'line_items': lineItems,
      };
}

/// The payment refund body: `{"refund": {...}}` with `transaction_no` beside
/// it.
class PaymentRefundInput extends Dto {
  const PaymentRefundInput({
    this.amount,
    this.reason,
    this.isGatewayRefund,
    this.sendRefundEmail,
    this.adjustWithOrder,
    this.transactionNo,
  });

  final String? amount;

  final String? reason;

  final bool? isGatewayRefund;

  final bool? sendRefundEmail;

  final bool? adjustWithOrder;

  final String? transactionNo;

  @override
  String? get envelopeKey => 'refund';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'reason': reason,
        'is_gateway_refund': isGatewayRefund,
        'send_refund_email': sendRefundEmail,
        'adjust_with_order': adjustWithOrder,
        'transaction_no': transactionNo,
      };
}

/// One line to ship, by the order line's `item_id`.
class ShipmentItemInput extends Dto {
  const ShipmentItemInput({this.orderItemId, this.quantity});

  final int? orderItemId;

  final int? quantity;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_item_id': orderItemId,
        'quantity': quantity,
      };
}

/// The shipment body; a create needs `method`, `shippingDate` and
/// `shipmentItems`, and an update's `shipmentItems` need `changeNote`.
class OrderShipmentInput extends Dto {
  const OrderShipmentInput({
    this.transactionNo,
    this.method,
    this.trackingInfo,
    this.shippingDate,
    this.shipmentItems,
    this.changeNote,
  });

  final String? transactionNo;

  final String? method;

  final String? trackingInfo;

  final String? shippingDate;

  final List<ShipmentItemInput?>? shipmentItems;

  final String? changeNote;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'method': method,
        'tracking_info': trackingInfo,
        'shipping_date': shippingDate,
        'shipment_items': shipmentItems,
        'change_note': changeNote,
      };
}

/// The status body; `status` is required: `cancelled`, `completed`, `draft`,
/// `in_progress`, `paused` or `reopened`.
class OrderStatusInput extends Dto {
  const OrderStatusInput(
      {this.status, this.transactionNo, this.refundAutomatically});

  final String? status;

  final String? transactionNo;

  final bool? refundAutomatically;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'transaction_no': transactionNo,
        'refund_automatically': refundAutomatically,
      };
}

/// The custom status body; `orderId` is required.
class CustomOrderStatusInput extends Dto {
  const CustomOrderStatusInput({
    this.orderId,
    this.orderStatusValue,
    this.orderStatusLabel,
    this.orderType,
    this.statusType,
  });

  final int? orderId;

  final String? orderStatusValue;

  final String? orderStatusLabel;

  final String? orderType;

  final String? statusType;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'order_id': orderId,
        'order_status_value': orderStatusValue,
        'order_status_label': orderStatusLabel,
        'order_type': orderType,
        'status_type': statusType,
      };
}
