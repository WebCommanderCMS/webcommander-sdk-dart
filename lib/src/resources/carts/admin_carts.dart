import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import '../orders/orders_dto.dart';
import 'admin_carts_dto.dart';
import 'admin_carts_urls.dart';

/// Admin cart and checkout endpoints, bound to one client.
class AdminCarts {
  /// Bind the resource to a client; normally reached via `client.adminCarts`.
  AdminCarts(this._client);

  final WebCommanderClient _client;

  /// Start a cart for a customer — `POST /admin/orders/carts`, `201`.
  /// `customer_id` is the customer's `customer_id` and `products` (`product_id`
  /// and `quantity`) is required. Keep `cart.session.session_id`: every other
  /// call takes it as `sessionId`. The session lasts 30 minutes from the last
  /// write.
  Future<ApiResponse> createAdminCart(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createAdminCart(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read the cart — `GET /admin/orders/carts/{session_id}`, where the slot
  /// takes `cart.session.session_id`. A deleted cart is `410` `session_deleted`
  /// and one an order was placed from is `410` `session_confirmed`.
  Future<ApiResponse> getAdminCart(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getAdminCart(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace the cart's customer and lines —
  /// `PUT /admin/orders/carts/{session_id}`, `200`. `customer_id` and
  /// `products` are both sent. The lines are put on again, so each gets a new
  /// `cart_item_id`.
  Future<ApiResponse> replaceAdminCart(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _replaceAdminCart(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change the cart's customer — `PATCH /admin/orders/carts/{session_id}`,
  /// `200`. Only `customer_id` is taken, and it is required: `products` is
  /// `400` `unknown_field`.
  Future<ApiResponse> updateAdminCart(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateAdminCart(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete the cart — `DELETE /admin/orders/carts/{session_id}`; `204` with no
  /// body, after which every call on the session is `410`.
  Future<ApiResponse> deleteAdminCart(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteAdminCart(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Put products on the cart —
  /// `POST /admin/orders/carts/{session_id}/cart_items`, `201` with the whole
  /// cart. `products` is required; one already on the cart raises that line's
  /// quantity.
  Future<ApiResponse> addAdminCartItems(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _addAdminCartItems(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Take every line off the cart —
  /// `DELETE /admin/orders/carts/{session_id}/cart_items`, `200` with the empty
  /// cart. The session stays.
  Future<ApiResponse> clearAdminCartItems(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _clearAdminCartItems(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Set one line's quantity —
  /// `PATCH /admin/orders/carts/{session_id}/cart_items/{cart_item_id}`, `200`
  /// with the cart. `cart_item_id` is a line's `cart_item_id` and `quantity` is
  /// required. A line the cart does not hold is `404`.
  Future<ApiResponse> updateAdminCartItem(
          String sessionId, Object cartItemId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateAdminCartItem(_client, sessionId, cartItemId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Take one line off the cart —
  /// `DELETE /admin/orders/carts/{session_id}/cart_items/{cart_item_id}`, `200`
  /// with the cart. `cart_item_id` is a line's `cart_item_id`; one the cart
  /// does not hold is `404`.
  Future<ApiResponse> deleteAdminCartItem(String sessionId, Object cartItemId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteAdminCartItem(_client, sessionId, cartItemId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read the checkout of a cart — `GET /admin/orders/checkout/{session_id}`.
  /// `issues` lists what still blocks a confirm, `delivery_type` `required`
  /// until one is set; the addresses start as the customer's.
  Future<ApiResponse> getCheckout(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCheckout(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Set the delivery and addresses —
  /// `PATCH /admin/orders/checkout/{session_id}`, `200` with the priced
  /// checkout. Only `delivery_type`, `billing_address` and `shipping_address`
  /// are taken. The shipping and handling cost follow the shipping address, so
  /// set it with `delivery_type`.
  Future<ApiResponse> updateCheckout(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCheckout(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Place the order — `POST /admin/orders/checkout/{session_id}/confirm`;
  /// `201` with the order, and the body optional. This creates a real order and
  /// closes the session, so every later call on it is `410`
  /// `session_confirmed`. A checkout with `issues` is `422`
  /// `checkout_incomplete`. Without a `payment` the order is unpaid.
  /// [transactionNo] is sent as `X-Transaction-No` and files the order under
  /// that number; a different `transaction_no` in the body is `400`
  /// `header_body_mismatch`.
  Future<ApiResponse> confirmCheckout(String sessionId,
          {Object? payload,
          String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _confirmCheckout(_client, sessionId,
          payload: payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Apply a coupon — `POST /admin/orders/checkout/{session_id}/coupon`, `200`.
  /// `code` is required. One coupon at a time: a second is `409`, and a code
  /// the store does not accept is `422` `invalid_coupon`.
  Future<ApiResponse> applyCheckoutCoupon(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _applyCheckoutCoupon(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove the coupon — `DELETE /admin/orders/checkout/{session_id}/coupon`.
  /// With none applied it is `404` `coupon_not_applied`.
  Future<ApiResponse> removeCheckoutCoupon(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _removeCheckoutCoupon(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Apply a gift card — `POST /admin/orders/checkout/{session_id}/gift_card`,
  /// `200`. `code` is required. The card must be usable by the cart's customer,
  /// else `422` `invalid_gift_card`; a second card is `409`. It lowers `due`
  /// and spends nothing until an order is placed.
  Future<ApiResponse> applyCheckoutGiftCard(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _applyCheckoutGiftCard(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove the gift card —
  /// `DELETE /admin/orders/checkout/{session_id}/gift_card`. With none applied
  /// it is `404` `gift_card_not_applied`.
  Future<ApiResponse> removeCheckoutGiftCard(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _removeCheckoutGiftCard(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read the chosen delivery schedule —
  /// `GET /admin/orders/checkout/{session_id}/delivery_schedules`, with
  /// `session` and `delivery_schedule`, which is `null` until one is set.
  Future<ApiResponse> getCheckoutDeliverySchedules(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCheckoutDeliverySchedules(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Choose a delivery schedule and date —
  /// `PUT /admin/orders/checkout/{session_id}/delivery_schedules`. `id` and
  /// `date` are both required. Only a `delivery_type` of `delivery` takes one
  /// (else `422`), an unknown `id` is `404` and one that does not apply to the
  /// order is `422` `schedule_not_applicable`.
  Future<ApiResponse> setCheckoutDeliverySchedule(
          String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _setCheckoutDeliverySchedule(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Clear the delivery schedule —
  /// `DELETE /admin/orders/checkout/{session_id}/delivery_schedules`; `204`
  /// with no body, and also when none was set.
  Future<ApiResponse> clearCheckoutDeliverySchedule(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _clearCheckoutDeliverySchedule(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Start a cart for a customer — `POST /admin/orders/carts`, `201`.
/// `customer_id` is the customer's `customer_id` and `products` (`product_id`
/// and `quantity`) is required. Keep `cart.session.session_id`: every other
/// call takes it as `sessionId`. The session lasts 30 minutes from the last
/// write.
Future<ApiResponse> createAdminCart(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(AdminCartUrls.adminCarts,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Read the cart — `GET /admin/orders/carts/{session_id}`, where the slot takes
/// `cart.session.session_id`. A deleted cart is `410` `session_deleted` and one
/// an order was placed from is `410` `session_confirmed`.
Future<ApiResponse> getAdminCart(WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(AdminCartUrls.adminCart,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Replace the cart's customer and lines —
/// `PUT /admin/orders/carts/{session_id}`, `200`. `customer_id` and `products`
/// are both sent. The lines are put on again, so each gets a new
/// `cart_item_id`.
Future<ApiResponse> replaceAdminCart(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(AdminCartUrls.adminCart,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Change the cart's customer — `PATCH /admin/orders/carts/{session_id}`,
/// `200`. Only `customer_id` is taken, and it is required: `products` is `400`
/// `unknown_field`.
Future<ApiResponse> updateAdminCart(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(AdminCartUrls.adminCart,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Delete the cart — `DELETE /admin/orders/carts/{session_id}`; `204` with no
/// body, after which every call on the session is `410`.
Future<ApiResponse> deleteAdminCart(WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCart,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Put products on the cart —
/// `POST /admin/orders/carts/{session_id}/cart_items`, `201` with the whole
/// cart. `products` is required; one already on the cart raises that line's
/// quantity.
Future<ApiResponse> addAdminCartItems(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(AdminCartUrls.adminCartItems,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Take every line off the cart —
/// `DELETE /admin/orders/carts/{session_id}/cart_items`, `200` with the empty
/// cart. The session stays.
Future<ApiResponse> clearAdminCartItems(
        WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCartItems,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Set one line's quantity —
/// `PATCH /admin/orders/carts/{session_id}/cart_items/{cart_item_id}`, `200`
/// with the cart. `cart_item_id` is a line's `cart_item_id` and `quantity` is
/// required. A line the cart does not hold is `404`.
Future<ApiResponse> updateAdminCartItem(WebCommanderClient client,
        String sessionId, Object cartItemId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(AdminCartUrls.adminCartItem,
        pathParams: {'session_id': sessionId, 'cart_item_id': cartItemId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Take one line off the cart —
/// `DELETE /admin/orders/carts/{session_id}/cart_items/{cart_item_id}`, `200`
/// with the cart. `cart_item_id` is a line's `cart_item_id`; one the cart does
/// not hold is `404`.
Future<ApiResponse> deleteAdminCartItem(
        WebCommanderClient client, String sessionId, Object cartItemId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCartItem,
        pathParams: {'session_id': sessionId, 'cart_item_id': cartItemId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCart.fromMap);

/// Read the checkout of a cart — `GET /admin/orders/checkout/{session_id}`.
/// `issues` lists what still blocks a confirm, `delivery_type` `required` until
/// one is set; the addresses start as the customer's.
Future<ApiResponse> getCheckout(WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(AdminCartUrls.adminCheckout,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Set the delivery and addresses —
/// `PATCH /admin/orders/checkout/{session_id}`, `200` with the priced checkout.
/// Only `delivery_type`, `billing_address` and `shipping_address` are taken.
/// The shipping and handling cost follow the shipping address, so set it with
/// `delivery_type`.
Future<ApiResponse> updateCheckout(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(AdminCartUrls.adminCheckout,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Place the order — `POST /admin/orders/checkout/{session_id}/confirm`; `201`
/// with the order, and the body optional. This creates a real order and closes
/// the session, so every later call on it is `410` `session_confirmed`. A
/// checkout with `issues` is `422` `checkout_incomplete`. Without a `payment`
/// the order is unpaid. [transactionNo] is sent as `X-Transaction-No` and files
/// the order under that number; a different `transaction_no` in the body is
/// `400` `header_body_mismatch`.
Future<ApiResponse> confirmCheckout(WebCommanderClient client, String sessionId,
        {Object? payload,
        String? transactionNo,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendPostRequest(AdminCartUrls.adminCheckoutConfirm,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {AdminCartUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// Apply a coupon — `POST /admin/orders/checkout/{session_id}/coupon`, `200`.
/// `code` is required. One coupon at a time: a second is `409`, and a code the
/// store does not accept is `422` `invalid_coupon`.
Future<ApiResponse> applyCheckoutCoupon(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(AdminCartUrls.adminCheckoutCoupon,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Remove the coupon — `DELETE /admin/orders/checkout/{session_id}/coupon`.
/// With none applied it is `404` `coupon_not_applied`.
Future<ApiResponse> removeCheckoutCoupon(
        WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCheckoutCoupon,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Apply a gift card — `POST /admin/orders/checkout/{session_id}/gift_card`,
/// `200`. `code` is required. The card must be usable by the cart's customer,
/// else `422` `invalid_gift_card`; a second card is `409`. It lowers `due` and
/// spends nothing until an order is placed.
Future<ApiResponse> applyCheckoutGiftCard(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(AdminCartUrls.adminCheckoutGiftCard,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Remove the gift card —
/// `DELETE /admin/orders/checkout/{session_id}/gift_card`. With none applied it
/// is `404` `gift_card_not_applied`.
Future<ApiResponse> removeCheckoutGiftCard(
        WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCheckoutGiftCard,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Read the chosen delivery schedule —
/// `GET /admin/orders/checkout/{session_id}/delivery_schedules`, with `session`
/// and `delivery_schedule`, which is `null` until one is set.
Future<ApiResponse> getCheckoutDeliverySchedules(
        WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(AdminCartUrls.adminCheckoutDeliverySchedules,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Choose a delivery schedule and date —
/// `PUT /admin/orders/checkout/{session_id}/delivery_schedules`. `id` and
/// `date` are both required. Only a `delivery_type` of `delivery` takes one
/// (else `422`), an unknown `id` is `404` and one that does not apply to the
/// order is `422` `schedule_not_applicable`.
Future<ApiResponse> setCheckoutDeliverySchedule(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(AdminCartUrls.adminCheckoutDeliverySchedules,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AdminCheckout.fromMap);

/// Clear the delivery schedule —
/// `DELETE /admin/orders/checkout/{session_id}/delivery_schedules`; `204` with
/// no body, and also when none was set.
Future<ApiResponse> clearCheckoutDeliverySchedule(
        WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AdminCartUrls.adminCheckoutDeliverySchedules,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _createAdminCart = createAdminCart;
final _getAdminCart = getAdminCart;
final _replaceAdminCart = replaceAdminCart;
final _updateAdminCart = updateAdminCart;
final _deleteAdminCart = deleteAdminCart;
final _addAdminCartItems = addAdminCartItems;
final _clearAdminCartItems = clearAdminCartItems;
final _updateAdminCartItem = updateAdminCartItem;
final _deleteAdminCartItem = deleteAdminCartItem;
final _getCheckout = getCheckout;
final _updateCheckout = updateCheckout;
final _confirmCheckout = confirmCheckout;
final _applyCheckoutCoupon = applyCheckoutCoupon;
final _removeCheckoutCoupon = removeCheckoutCoupon;
final _applyCheckoutGiftCard = applyCheckoutGiftCard;
final _removeCheckoutGiftCard = removeCheckoutGiftCard;
final _getCheckoutDeliverySchedules = getCheckoutDeliverySchedules;
final _setCheckoutDeliverySchedule = setCheckoutDeliverySchedule;
final _clearCheckoutDeliverySchedule = clearCheckoutDeliverySchedule;
