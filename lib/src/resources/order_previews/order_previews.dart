import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import '../orders/orders_dto.dart';
import 'order_previews_dto.dart';
import 'order_previews_urls.dart';

/// Order preview endpoints, bound to one client.
class OrderPreviews {
  /// Bind the resource to a client; normally reached via
  /// `client.orderPreviews`.
  OrderPreviews(this._client);

  final WebCommanderClient _client;

  /// Start an order preview — `POST /admin/orders/preview`.
  Future<ApiResponse> createOrderPreview(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderPreview(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read an order preview —
  /// `GET /admin/orders/preview/{preview_session_id}`.
  Future<ApiResponse> getOrderPreview(String previewSessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getOrderPreview(_client, previewSessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Place the order —
  /// `POST /admin/orders/preview/{preview_session_id}/confirm`.
  Future<ApiResponse> confirmOrderPreview(String previewSessionId,
          {Object? payload, bool? raiseOnError, String? responseFormat}) =>
      _confirmOrderPreview(_client, previewSessionId,
          payload: payload,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Apply a coupon —
  /// `POST /admin/orders/preview/{preview_session_id}/coupon`.
  Future<ApiResponse> applyOrderPreviewCoupon(
          String previewSessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _applyOrderPreviewCoupon(_client, previewSessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove the coupon —
  /// `DELETE /admin/orders/preview/{preview_session_id}/coupon`.
  Future<ApiResponse> removeOrderPreviewCoupon(String previewSessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _removeOrderPreviewCoupon(_client, previewSessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Apply a gift card —
  /// `POST /admin/orders/preview/{preview_session_id}/gift-card`.
  Future<ApiResponse> applyOrderPreviewGiftCard(
          String previewSessionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _applyOrderPreviewGiftCard(_client, previewSessionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove the gift card —
  /// `DELETE /admin/orders/preview/{preview_session_id}/gift-card`.
  Future<ApiResponse> removeOrderPreviewGiftCard(String previewSessionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _removeOrderPreviewGiftCard(_client, previewSessionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Start an order preview — `POST /admin/orders/preview`, `201`, a priced
/// session that places no order. `products` is required; read
/// `order.session.session_id`, which every other call takes as
/// `previewSessionId`. The session lasts 30 minutes.
Future<ApiResponse> createOrderPreview(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderPreviewUrls.orderPreviews,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderPreview.fromMap);

/// Read an order preview —
/// `GET /admin/orders/preview/{preview_session_id}`, where the slot takes the
/// `session_id` the start answered. A read does not extend the session. An
/// unknown id is `404`, and a session already confirmed is `410`
/// `session_confirmed`.
Future<ApiResponse> getOrderPreview(
        WebCommanderClient client, String previewSessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderPreviewUrls.orderPreview,
        pathParams: {'preview_session_id': previewSessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderPreview.fromMap);

/// Place the order — `POST /admin/orders/preview/{preview_session_id}/confirm`;
/// `201` with the created order, and [payload] optional. This creates a real
/// order and closes the session, so a second confirm, or any other call on it,
/// is `410` `session_confirmed`. Without a `payment` the order is unpaid, and
/// so it is after a `payment_gateway` alone.
Future<ApiResponse> confirmOrderPreview(
        WebCommanderClient client, String previewSessionId,
        {Object? payload, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderPreviewUrls.orderPreviewConfirm,
        pathParams: {'preview_session_id': previewSessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: FlatOrder.fromMap);

/// Apply a coupon — `POST /admin/orders/preview/{preview_session_id}/coupon`,
/// `200` with `session`, `discounts` and `totals`. One coupon at a time: a
/// second is `409`, and a code the store does not accept is `422`
/// `invalid_coupon`.
Future<ApiResponse> applyOrderPreviewCoupon(
        WebCommanderClient client, String previewSessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderPreviewUrls.orderPreviewCoupon,
        pathParams: {'preview_session_id': previewSessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderPreview.fromMap);

/// Remove the coupon —
/// `DELETE /admin/orders/preview/{preview_session_id}/coupon`, `204` with no
/// body. With none applied it is `404` `coupon_not_applied`.
Future<ApiResponse> removeOrderPreviewCoupon(
        WebCommanderClient client, String previewSessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(OrderPreviewUrls.orderPreviewCoupon,
        pathParams: {'preview_session_id': previewSessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Apply a gift card —
/// `POST /admin/orders/preview/{preview_session_id}/gift-card`, `200` with
/// `session`, `discounts` and `totals`. The card must be the previewed
/// customer's, active, paid, in date and with a balance, else `422`
/// `invalid_gift_card`; a second card is `409`. It lowers `due` and spends
/// nothing until an order is placed with it applied.
Future<ApiResponse> applyOrderPreviewGiftCard(
        WebCommanderClient client, String previewSessionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderPreviewUrls.orderPreviewGiftCard,
        pathParams: {'preview_session_id': previewSessionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderPreview.fromMap);

/// Remove the gift card —
/// `DELETE /admin/orders/preview/{preview_session_id}/gift-card`, `204` with no
/// body. With none applied it is `404` `gift_card_not_applied`.
Future<ApiResponse> removeOrderPreviewGiftCard(
        WebCommanderClient client, String previewSessionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(OrderPreviewUrls.orderPreviewGiftCard,
        pathParams: {'preview_session_id': previewSessionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _createOrderPreview = createOrderPreview;
final _getOrderPreview = getOrderPreview;
final _confirmOrderPreview = confirmOrderPreview;
final _applyOrderPreviewCoupon = applyOrderPreviewCoupon;
final _removeOrderPreviewCoupon = removeOrderPreviewCoupon;
final _applyOrderPreviewGiftCard = applyOrderPreviewGiftCard;
final _removeOrderPreviewGiftCard = removeOrderPreviewGiftCard;
