import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'carts_dto.dart';
import 'carts_urls.dart';

/// Cart endpoints, bound to one client: the storefront cart under `/carts` and
/// the order write under `/admin`.
class Carts {
  /// Bind the resource to a client; normally reached via `client.carts`.
  Carts(this._client);

  final WebCommanderClient _client;

  /// Add a product to the cart `session_id` names, creating it —
  /// `POST /carts`.
  Future<ApiResponse> addCartItem(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _addCartItem(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve the cart — `GET /carts/{session_id}`.
  Future<ApiResponse> getCart(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCart(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask which session id to use — `PUT /carts/{session_id}`.
  Future<ApiResponse> resolveCartSession(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _resolveCartSession(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change one line's quantity — `PATCH /carts/{session_id}`.
  Future<ApiResponse> updateCartItem(String sessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCartItem(_client, sessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Empty the cart — `DELETE /carts/{session_id}`.
  Future<ApiResponse> deleteCart(String sessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCart(_client, sessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove one line —
  /// `DELETE /carts/{session_id}/cart_items/{cart_item_id}`.
  Future<ApiResponse> deleteCartItem(String sessionId, Object cartItemId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCartItem(_client, sessionId, cartItemId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Turn the cart into an order —
  /// `POST /admin/orders/carts/{session_id}`.
  Future<ApiResponse> createOrderFromCart(String sessionId, Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createOrderFromCart(_client, sessionId, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// Add a product to the cart `session_id` names, creating it — `POST /carts`,
/// `201`; re-adding raises the line's quantity. `customer_id` is the customer's
/// `internal_id`.
Future<ApiResponse> addCartItem(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CartUrls.carts,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Cart.fromMap);

/// Retrieve the cart — `GET /carts/{session_id}`, with `group_meta` beside it.
/// A cart with no line is `400` `Your shopping cart is empty`.
Future<ApiResponse> getCart(WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CartUrls.cart,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Cart.fromMap);

/// Ask which session id to use — `PUT /carts/{session_id}`; nothing is stored.
/// Answers the body's `sessionId`, the HTTP session's id when that is empty or
/// `null`, else the path's.
Future<ApiResponse> resolveCartSession(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CartUrls.cart,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        // Under `application/json; charset=utf-8` the store ignores this body.
        headers: const {'Content-Type': 'application/json'},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CartSession.fromMap);

/// Change one line's quantity — `PATCH /carts/{session_id}`. `cart_item_id`
/// and `quantity` are required; the addresses are optional.
Future<ApiResponse> updateCartItem(
        WebCommanderClient client, String sessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CartUrls.cart,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Cart.fromMap);

/// Empty the cart — `DELETE /carts/{session_id}`; `204`, after which a read is
/// `400`.
Future<ApiResponse> deleteCart(WebCommanderClient client, String sessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CartUrls.cart,
        pathParams: {'session_id': sessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Remove one line — `DELETE /carts/{session_id}/cart_items/{cart_item_id}`;
/// `204`. [cartItemId] is a line's `id`; removing the last line empties the cart.
Future<ApiResponse> deleteCartItem(
        WebCommanderClient client, String sessionId, Object cartItemId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CartUrls.cartItem,
        pathParams: {'session_id': sessionId, 'cart_item_id': cartItemId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Turn the cart into an order — `POST /admin/orders/carts/{session_id}`,
/// `201`, and the cart is gone. `customer_id` is the customer's `customer_id`,
/// not its `internal_id`. [transactionNo] is sent as `X-Transaction-No` and
/// files the order under that number.
Future<ApiResponse> createOrderFromCart(
        WebCommanderClient client, String sessionId, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CartUrls.cartOrder,
        pathParams: {'session_id': sessionId},
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {CartUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CartOrder.fromMap);

final _addCartItem = addCartItem;
final _getCart = getCart;
final _resolveCartSession = resolveCartSession;
final _updateCartItem = updateCartItem;
final _deleteCart = deleteCart;
final _deleteCartItem = deleteCartItem;
final _createOrderFromCart = createOrderFromCart;
