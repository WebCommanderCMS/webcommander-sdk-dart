import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'payment_gateways_dto.dart';
import 'payment_gateways_urls.dart';

/// Payment gateway endpoints, bound to one client.
class PaymentGateways {
  /// Bind the resource to a client; normally reached via
  /// `client.paymentGateways`.
  PaymentGateways(this._client);

  final WebCommanderClient _client;

  /// List the gateways by ascending `id` — `GET /admin/payment_gateways`.
  Future<ApiResponse> listPaymentGateways({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listPaymentGateways(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable —
  /// `HEAD /admin/payment_gateways`.
  Future<ApiResponse> headPaymentGateways(
          {bool? raiseOnError, String? responseFormat}) =>
      _headPaymentGateways(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many gateways match — `GET /admin/payment_gateways/count`.
  Future<ApiResponse> countPaymentGateways({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countPaymentGateways(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable —
  /// `HEAD /admin/payment_gateways/count`.
  Future<ApiResponse> headPaymentGatewaysCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headPaymentGatewaysCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one gateway —
  /// `GET /admin/payment_gateways/{payment_gateway_id}`.
  Future<ApiResponse> getPaymentGateway(Object paymentGatewayId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getPaymentGateway(_client, paymentGatewayId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one gateway is there —
  /// `HEAD /admin/payment_gateways/{payment_gateway_id}`.
  Future<ApiResponse> headPaymentGateway(Object paymentGatewayId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headPaymentGateway(_client, paymentGatewayId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Write one gateway —
  /// `PUT /admin/payment_gateways/{payment_gateway_id}`.
  Future<ApiResponse> updatePaymentGateway(
          Object paymentGatewayId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updatePaymentGateway(_client, paymentGatewayId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent —
  /// `PATCH /admin/payment_gateways/{payment_gateway_id}`.
  Future<ApiResponse> patchPaymentGateway(
          Object paymentGatewayId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchPaymentGateway(_client, paymentGatewayId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the store's gateways by ascending `id` — `GET /admin/payment_gateways`,
/// rows without `settings`. `limit` is 1 to 100, default 20; `0` or above 100
/// is `400` `out_of_range`. `offset` or `page`; `search` a substring of the
/// name; `exclude` a comma list of codes; `promotional` and `added` filter.
/// Other names, `sort` included, are ignored.
Future<ApiResponse> listPaymentGateways(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PaymentGatewayUrls.paymentGateways,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentGatewayPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/payment_gateways`;
/// no body.
Future<ApiResponse> headPaymentGateways(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PaymentGatewayUrls.paymentGateways,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many gateways match — `GET /admin/payment_gateways/count`, a bare
/// `{"total": N}`. The listing's filters narrow it; `limit` is checked as on
/// the listing, `0` or above 100 `400` `out_of_range`, but changes nothing.
Future<ApiResponse> countPaymentGateways(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PaymentGatewayUrls.paymentGatewaysCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentGatewayCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/payment_gateways/count`;
/// no body.
Future<ApiResponse> headPaymentGatewaysCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PaymentGatewayUrls.paymentGatewaysCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Retrieve one gateway with its `settings`; secrets read `********` when set.
/// `GET /admin/payment_gateways/{payment_gateway_id}`
Future<ApiResponse> getPaymentGateway(
        WebCommanderClient client, Object paymentGatewayId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(PaymentGatewayUrls.paymentGateway,
        pathParams: {'payment_gateway_id': paymentGatewayId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentGateway.fromMap);

/// Ask whether one gateway is there; no body.
/// `HEAD /admin/payment_gateways/{payment_gateway_id}`
Future<ApiResponse> headPaymentGateway(
        WebCommanderClient client, Object paymentGatewayId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PaymentGatewayUrls.paymentGateway,
        pathParams: {'payment_gateway_id': paymentGatewayId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Write one gateway — `PUT /admin/payment_gateways/{payment_gateway_id}`. A
/// bare record merged like the `PATCH`: the fields left out keep their value.
Future<ApiResponse> updatePaymentGateway(
        WebCommanderClient client, Object paymentGatewayId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(PaymentGatewayUrls.paymentGateway,
        pathParams: {'payment_gateway_id': paymentGatewayId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentGateway.fromMap);

/// Change only the fields sent —
/// `PATCH /admin/payment_gateways/{payment_gateway_id}`. A bare record; an
/// empty body is `400`.
Future<ApiResponse> patchPaymentGateway(
        WebCommanderClient client, Object paymentGatewayId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(PaymentGatewayUrls.paymentGateway,
        pathParams: {'payment_gateway_id': paymentGatewayId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PaymentGateway.fromMap);

final _listPaymentGateways = listPaymentGateways;
final _headPaymentGateways = headPaymentGateways;
final _countPaymentGateways = countPaymentGateways;
final _headPaymentGatewaysCount = headPaymentGatewaysCount;
final _getPaymentGateway = getPaymentGateway;
final _headPaymentGateway = headPaymentGateway;
final _updatePaymentGateway = updatePaymentGateway;
final _patchPaymentGateway = patchPaymentGateway;
