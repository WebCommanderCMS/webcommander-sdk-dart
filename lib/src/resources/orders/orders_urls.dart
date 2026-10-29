/// Order path templates; the client fills `{api_version}`.
class OrderUrls {
  OrderUrls._();

  /// List and create.
  static const String orders = '/api/{api_version}/admin/orders';

  /// The listing's count.
  static const String ordersCount = '/api/{api_version}/admin/orders/count';

  /// A create that records a payment in the same write.
  static const String ordersWithPayment =
      '/api/{api_version}/admin/orders/with-payment';

  /// One order by its `order_id`.
  static const String order = '/api/{api_version}/admin/orders/{order_id}';

  /// Both addresses, by `PATCH`; an address left out is untouched.
  static const String orderAddresses =
      '/api/{api_version}/admin/orders/{order_id}/addresses';

  /// The cancel, answered `201` with the flat order.
  static const String orderCancel =
      '/api/{api_version}/admin/orders/{order_id}/cancel';

  /// List and add comments.
  static const String orderComments =
      '/api/{api_version}/admin/orders/{order_id}/comments';

  /// Record a payment.
  static const String orderPayments =
      '/api/{api_version}/admin/orders/{order_id}/payments';

  /// An order's refunds: list them or refund against the order.
  static const String orderRefunds =
      '/api/{api_version}/admin/orders/{order_id}/refunds';

  /// How far the order has shipped.
  static const String orderShipmentStatus =
      '/api/{api_version}/admin/orders/{order_id}/shipment-status';

  /// List and create shipments.
  static const String orderShipments =
      '/api/{api_version}/admin/orders/{order_id}/shipments';

  /// One shipment, by its `shipping_id`.
  static const String orderShipment =
      '/api/{api_version}/admin/orders/{order_id}/shipments/{shipment_id}';

  /// Move the order's status, answered with the flat order.
  static const String orderUpdateStatus =
      '/api/{api_version}/admin/orders/{order_id}/update-status';

  /// Resolves the slot against the order's `internal_id`: an `order_id` there
  /// names another order, or none.
  static const String orderCustomFields =
      '/api/{api_version}/admin/orders/{order_internal_id}/custom_fields';

  /// Resolves the slot against the order's `internal_id`, as
  /// [orderCustomFields] does.
  static const String orderSendInvoice =
      '/api/{api_version}/admin/orders/{order_internal_id}/send-invoice';

  /// A payment's refunds, by the payment receipt's `id`.
  static const String paymentRefunds =
      '/api/{api_version}/admin/payment/{payment_id}/refunds';

  /// Add a store-wide custom order status.
  static const String orderStatusAdd =
      '/api/{api_version}/admin/order/add-order-status';

  /// One customer's orders, by the public `customer_id`.
  static const String customerOrders =
      '/api/{api_version}/admin/customers/{customer_id}/orders';

  /// The header a payment refund is refused without; a repeat under one key
  /// replays the first refund.
  static const String idempotencyKeyHeader = 'Idempotency-Key';

  /// Files a created order under this transaction number; it beats a
  /// `transaction_no` body field.
  static const String transactionNoHeader = 'X-Transaction-No';
}
