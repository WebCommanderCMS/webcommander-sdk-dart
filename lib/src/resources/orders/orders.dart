import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'orders_dto.dart';
import 'orders_urls.dart';

/// Order endpoints, bound to one client.
class Orders {
  /// Bind the resource to a client; normally reached via `client.orders`.
  Orders(this._client);

  final WebCommanderClient _client;

  /// List orders — `GET /admin/orders`, newest first.
  Future<ApiResponse> listOrders({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listOrders(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Count orders — `GET /admin/orders/count`.
  Future<ApiResponse> countOrders({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countOrders(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create an order — `POST /admin/orders`.
  Future<ApiResponse> createOrder(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createOrder(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create an order and record a payment on it —
  /// `POST /admin/orders/with-payment`.
  Future<ApiResponse> createOrderWithPayment(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderWithPayment(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one order — `GET /admin/orders/{order_id}`.
  Future<ApiResponse> getOrder(
    Object orderId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getOrder(_client, orderId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Update an order — `PUT /admin/orders/{order_id}`.
  Future<ApiResponse> updateOrder(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateOrder(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change named fields — `PATCH /admin/orders/{order_id}`.
  Future<ApiResponse> patchOrder(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchOrder(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete an order — `DELETE /admin/orders/{order_id}`.
  Future<ApiResponse> deleteOrder(Object orderId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteOrder(_client, orderId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one or both addresses —
  /// `PATCH /admin/orders/{order_id}/addresses`.
  Future<ApiResponse> updateOrderAddresses(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateOrderAddresses(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Cancel an order — `POST /admin/orders/{order_id}/cancel`.
  Future<ApiResponse> cancelOrder(Object orderId,
          {Object? payload, bool? raiseOnError, String? responseFormat}) =>
      _cancelOrder(_client, orderId,
          payload: payload,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// An order's comments — `GET /admin/orders/{order_id}/comments`.
  Future<ApiResponse> listOrderComments(Object orderId,
          {bool? raiseOnError, String? responseFormat}) =>
      _listOrderComments(_client, orderId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add a comment — `POST /admin/orders/{order_id}/comments`.
  Future<ApiResponse> createOrderComment(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderComment(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// An order's custom field values —
  /// `GET /admin/orders/{order_internal_id}/custom_fields`.
  Future<ApiResponse> getOrderCustomFields(Object orderInternalId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getOrderCustomFields(_client, orderInternalId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Record a payment — `POST /admin/orders/{order_id}/payments`.
  Future<ApiResponse> createOrderPayment(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderPayment(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List an order's refunds — `GET /admin/orders/{order_id}/refunds`.
  Future<ApiResponse> listOrderRefunds(
    Object orderId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listOrderRefunds(_client, orderId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Refund against an order — `POST /admin/orders/{order_id}/refunds`.
  Future<ApiResponse> createOrderRefund(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderRefund(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Refund part of a payment — `POST /admin/payment/{payment_id}/refunds`.
  Future<ApiResponse> createPaymentRefund(
          Object paymentId, Object payload, String idempotencyKey,
          {bool? raiseOnError, String? responseFormat}) =>
      _createPaymentRefund(_client, paymentId, payload, idempotencyKey,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Email the invoice —
  /// `POST /admin/orders/{order_internal_id}/send-invoice`.
  Future<ApiResponse> sendOrderInvoice(Object orderInternalId,
          {bool? raiseOnError, String? responseFormat}) =>
      _sendOrderInvoice(_client, orderInternalId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How far an order has shipped —
  /// `GET /admin/orders/{order_id}/shipment-status`.
  Future<ApiResponse> getOrderShipmentStatus(Object orderId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getOrderShipmentStatus(_client, orderId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List an order's shipments — `GET /admin/orders/{order_id}/shipments`.
  Future<ApiResponse> listOrderShipments(Object orderId,
          {bool? raiseOnError, String? responseFormat}) =>
      _listOrderShipments(_client, orderId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ship order lines — `POST /admin/orders/{order_id}/shipments`.
  Future<ApiResponse> createOrderShipment(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderShipment(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change a shipment —
  /// `PATCH /admin/orders/{order_id}/shipments/{shipment_id}`.
  Future<ApiResponse> updateOrderShipment(
          Object orderId, Object shipmentId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateOrderShipment(_client, orderId, shipmentId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move an order's status —
  /// `PATCH /admin/orders/{order_id}/update-status`.
  Future<ApiResponse> updateOrderStatus(Object orderId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateOrderStatus(_client, orderId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add a custom order status — `POST /admin/order/add-order-status`.
  Future<ApiResponse> createOrderStatus(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderStatus(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// One customer's orders — `GET /admin/customers/{customer_id}/orders`.
  Future<ApiResponse> listCustomerOrders(Object customerId,
          {bool? raiseOnError, String? responseFormat}) =>
      _listCustomerOrders(_client, customerId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List orders — `GET /admin/orders`, newest first; cancelled only under
/// `order_status`. `limit` caps at 20 and `customerId` takes an `internal_id`.
Future<ApiResponse> listOrders(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderUrls.orders,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderPage.fromMap);

/// Count orders — `GET /admin/orders/count`, `{"orders": {"count": N}}`. The
/// listing's filters narrow it; its paging, sort and `field_metadata` do not.
Future<ApiResponse> countOrders(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderUrls.ordersCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCount.fromMap);

/// Create an order — `POST /admin/orders`, `201` with the flat order shape and
/// `status`. Only `products` is required; `payment_gateway` takes a code such as `PIS`.
/// [transactionNo] is sent as `X-Transaction-No` and files the order under that
/// number.
Future<ApiResponse> createOrder(WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orders,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {OrderUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// Create an order and record a payment on it — `POST /admin/orders/with-payment`;
/// `201`. `payment` is required and filed under gateway `API`.
Future<ApiResponse> createOrderWithPayment(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.ordersWithPayment,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// Retrieve one order — `GET /admin/orders/{order_id}`. `field_metadata` adds
/// the listing's schema block; any other parameter is ignored.
Future<ApiResponse> getOrder(
  WebCommanderClient client,
  Object orderId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderUrls.order,
        pathParams: {'order_id': orderId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Order.fromMap);

/// Update an order — `PUT /admin/orders/{order_id}`: the customer and the
/// addresses, merged. Sections left out are kept; `items` is `400`.
Future<ApiResponse> updateOrder(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(OrderUrls.order,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Order.fromMap);

/// Change named fields — `PATCH /admin/orders/{order_id}`: `order_status`, the
/// addresses, `customer_po_number`, `payment_term`, `order_channel` and
/// `ip_address`, flat or under `fulfillment`.
Future<ApiResponse> patchOrder(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(OrderUrls.order,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Order.fromMap);

/// Delete an order — `DELETE /admin/orders/{order_id}`; hard. Read `status`:
/// `deleted`, or `not_found` for an id no order holds, both at `200`.
Future<ApiResponse> deleteOrder(WebCommanderClient client, Object orderId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(OrderUrls.order,
        pathParams: {'order_id': orderId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one or both addresses — `PATCH /admin/orders/{order_id}/addresses`;
/// an address left out is untouched.
Future<ApiResponse> updateOrderAddresses(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(OrderUrls.orderAddresses,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderAddresses.fromMap);

/// Cancel an order — `POST /admin/orders/{order_id}/cancel`; `201`, [payload]
/// optional. A second cancel is `409`; `updateOrderStatus` can move it back.
Future<ApiResponse> cancelOrder(WebCommanderClient client, Object orderId,
        {Object? payload, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderCancel,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// An order's comments, oldest first and unpaged —
/// `GET /admin/orders/{order_id}/comments`.
Future<ApiResponse> listOrderComments(WebCommanderClient client, Object orderId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderUrls.orderComments,
        pathParams: {'order_id': orderId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCommentList.fromMap);

/// Add a comment — `POST /admin/orders/{order_id}/comments`; `201`. A bare
/// record: a `comment` wrapper hides `content` and is `400`.
Future<ApiResponse> createOrderComment(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderComments,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCommentRecord.fromMap);

/// An order's custom field values —
/// `GET /admin/orders/{order_internal_id}/custom_fields`, by `internal_id`.
Future<ApiResponse> getOrderCustomFields(
        WebCommanderClient client, Object orderInternalId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderUrls.orderCustomFields,
        pathParams: {'order_internal_id': orderInternalId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCustomFieldValues.fromMap);

/// Record a payment — `POST /admin/orders/{order_id}/payments`; `201`. The
/// `payment` wrapper is required, and the receipt's `id` is a payment refund's.
Future<ApiResponse> createOrderPayment(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderPayments,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentReceipt.fromMap);

/// List an order's refunds, newest first —
/// `GET /admin/orders/{order_id}/refunds`, by the order's `order_id`. `limit` is
/// 1 to 20 (above 20 is capped, `0` is `400`), with `offset` or a 1-based
/// `page`; any other name is ignored.
Future<ApiResponse> listOrderRefunds(
  WebCommanderClient client,
  Object orderId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderUrls.orderRefunds,
        pathParams: {'order_id': orderId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderRefundPage.fromMap);

/// Refund against an order — `POST /admin/orders/{order_id}/refunds`; `201`.
/// It raises `refunded` and leaves `paid` alone.
Future<ApiResponse> createOrderRefund(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderRefunds,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderRefund.fromMap);

/// Refund part of a payment — `POST /admin/payment/{payment_id}/refunds`;
/// `200`. A repeat under the same [idempotencyKey] replays the first refund.
Future<ApiResponse> createPaymentRefund(WebCommanderClient client,
        Object paymentId, Object payload, String idempotencyKey,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.paymentRefunds,
        pathParams: {'payment_id': paymentId},
        jsonBody: payload,
        headers: {OrderUrls.idempotencyKeyHeader: idempotencyKey},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentRefund.fromMap);

/// Email the invoice — `POST /admin/orders/{order_internal_id}/send-invoice`,
/// by `internal_id`; no body.
Future<ApiResponse> sendOrderInvoice(
        WebCommanderClient client, Object orderInternalId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderSendInvoice,
        pathParams: {'order_internal_id': orderInternalId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InvoiceDispatch.fromMap);

/// How far an order has shipped —
/// `GET /admin/orders/{order_id}/shipment-status`.
Future<ApiResponse> getOrderShipmentStatus(
        WebCommanderClient client, Object orderId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderUrls.orderShipmentStatus,
        pathParams: {'order_id': orderId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShipmentStatus.fromMap);

/// List an order's shipments — `GET /admin/orders/{order_id}/shipments`;
/// unpaged.
Future<ApiResponse> listOrderShipments(
        WebCommanderClient client, Object orderId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderUrls.orderShipments,
        pathParams: {'order_id': orderId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderShipmentList.fromMap);

/// Ship order lines — `POST /admin/orders/{order_id}/shipments`; `201`.
/// `method`, `shipping_date` and `shipment_items` are required.
Future<ApiResponse> createOrderShipment(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderShipments,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderShipment.fromMap);

/// Change a shipment — `PATCH /admin/orders/{order_id}/shipments/{shipment_id}`,
/// by its `shipping_id`; `shipment_items` needs `change_note`.
Future<ApiResponse> updateOrderShipment(WebCommanderClient client,
        Object orderId, Object shipmentId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(OrderUrls.orderShipment,
        pathParams: {'order_id': orderId, 'shipment_id': shipmentId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderShipment.fromMap);

/// Move an order's status — `PATCH /admin/orders/{order_id}/update-status`,
/// answered flat. A completed or cancelled order can be moved again.
Future<ApiResponse> updateOrderStatus(
        WebCommanderClient client, Object orderId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(OrderUrls.orderUpdateStatus,
        pathParams: {'order_id': orderId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// Add a custom order status — `POST /admin/order/add-order-status`; `201
/// {"success": "true"}`. No endpoint lists, applies or deletes one.
Future<ApiResponse> createOrderStatus(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderUrls.orderStatusAdd,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// One customer's orders — `GET /admin/customers/{customer_id}/orders`, by the
/// public `customer_id`; unpaged, cancelled orders left out.
Future<ApiResponse> listCustomerOrders(
        WebCommanderClient client, Object customerId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderUrls.customerOrders,
        pathParams: {'customer_id': customerId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerOrders.fromMap);

final _listOrders = listOrders;
final _countOrders = countOrders;
final _createOrder = createOrder;
final _createOrderWithPayment = createOrderWithPayment;
final _getOrder = getOrder;
final _updateOrder = updateOrder;
final _patchOrder = patchOrder;
final _deleteOrder = deleteOrder;
final _updateOrderAddresses = updateOrderAddresses;
final _cancelOrder = cancelOrder;
final _listOrderComments = listOrderComments;
final _createOrderComment = createOrderComment;
final _getOrderCustomFields = getOrderCustomFields;
final _createOrderPayment = createOrderPayment;
final _listOrderRefunds = listOrderRefunds;
final _createOrderRefund = createOrderRefund;
final _createPaymentRefund = createPaymentRefund;
final _sendOrderInvoice = sendOrderInvoice;
final _getOrderShipmentStatus = getOrderShipmentStatus;
final _listOrderShipments = listOrderShipments;
final _createOrderShipment = createOrderShipment;
final _updateOrderShipment = updateOrderShipment;
final _updateOrderStatus = updateOrderStatus;
final _createOrderStatus = createOrderStatus;
final _listCustomerOrders = listCustomerOrders;
