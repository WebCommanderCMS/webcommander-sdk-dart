import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'shipping_rates_dto.dart';
import 'shipping_rates_urls.dart';

/// Shipping rate endpoints, bound to one client.
class ShippingRates {
  /// Bind the resource to a client; normally reached via `client.shippingRates`.
  ShippingRates(this._client);

  final WebCommanderClient _client;

  /// List the rates, newest first — `GET /admin/shipping_rates`.
  Future<ApiResponse> listShippingRates(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _listShippingRates(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/shipping_rates`.
  Future<ApiResponse> headShippingRates(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRates(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many rates match — `GET /admin/shipping_rates/count`.
  Future<ApiResponse> countShippingRates(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _countShippingRates(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable — `HEAD /admin/shipping_rates/count`.
  Future<ApiResponse> headShippingRatesCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRatesCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a rate — `POST /admin/shipping_rates`.
  Future<ApiResponse> createShippingRate(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createShippingRate(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one rate by its `id` — `GET
  /// /admin/shipping_rates/{shipping_rate_id}`.
  Future<ApiResponse> getShippingRate(Object shippingRateId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getShippingRate(_client, shippingRateId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether a rate exists — `HEAD
  /// /admin/shipping_rates/{shipping_rate_id}`.
  Future<ApiResponse> headShippingRate(Object shippingRateId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRate(_client, shippingRateId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one rate — `PUT /admin/shipping_rates/{shipping_rate_id}`.
  Future<ApiResponse> updateShippingRate(Object shippingRateId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateShippingRate(_client, shippingRateId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH
  /// /admin/shipping_rates/{shipping_rate_id}`.
  Future<ApiResponse> patchShippingRate(Object shippingRateId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShippingRate(_client, shippingRateId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one rate — `DELETE /admin/shipping_rates/{shipping_rate_id}`.
  Future<ApiResponse> deleteShippingRate(Object shippingRateId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteShippingRate(_client, shippingRateId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the rates, newest first — `GET /admin/shipping_rates`. `search` (part
/// of the name), `method` (such as `flat_rate` or `ship_by_weight`) and
/// `handling_cost` (`with_handling` or `without_handling`) filter; `sort` is
/// `id`, `name`, `method`, `created_at`, `updated_at` or `transaction_no` with
/// `order` `asc` or `desc`; `limit` is 1 to 100 and defaults to 20, `offset`
/// pages. An unknown value is `400`.
Future<ApiResponse> listShippingRates(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingRateUrls.shippingRates,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRateListing.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/shipping_rates`; no
/// body.
Future<ApiResponse> headShippingRates(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRateUrls.shippingRates,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many rates match — `GET /admin/shipping_rates/count`, a bare `{"total":
/// N}`. The listing's filters narrow it.
Future<ApiResponse> countShippingRates(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingRateUrls.shippingRatesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRateCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/shipping_rates/count`; no
/// body.
Future<ApiResponse> headShippingRatesCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRateUrls.shippingRatesCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a rate — `POST /admin/shipping_rates`, answered `201` with a
/// `Location`. The body is wrapped in `shipping_rate` and needs `name`, unique
/// without regard to case (`409`), and `method`. A flat rate needs
/// `shipping_cost`; `ship_by_price`, `ship_by_quantity`, `ship_by_weight` and
/// `ship_by_variation` take their costs per row in `conditions` and refuse a
/// rate-level `shipping_cost`. `free_shipping` always saves
/// `calculate_for_entire_order` false. `shipping_rule_id` attaches the rate to
/// a rule that has none (`409` otherwise). An unknown field, an `id` or an
/// unwrapped body is `400`. [transactionNo] is sent as `X-Transaction-No`.
Future<ApiResponse> createShippingRate(
        WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingRateUrls.shippingRates,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ShippingRateUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRate.fromMap);

/// Retrieve one rate by its `id` — `GET
/// /admin/shipping_rates/{shipping_rate_id}`, the row under `shipping_rate`. An
/// id that is not plain digits, or unknown, is `404`.
Future<ApiResponse> getShippingRate(
        WebCommanderClient client, Object shippingRateId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ShippingRateUrls.shippingRate,
        pathParams: {'shipping_rate_id': shippingRateId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRate.fromMap);

/// Ask whether a rate exists — `HEAD /admin/shipping_rates/{shipping_rate_id}`;
/// 200 with no body, 404 for an unknown id.
Future<ApiResponse> headShippingRate(
        WebCommanderClient client, Object shippingRateId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRateUrls.shippingRate,
        pathParams: {'shipping_rate_id': shippingRateId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one rate — `PUT /admin/shipping_rates/{shipping_rate_id}`. Every
/// field is required: `name`, `method`, `calculate_for_entire_order`,
/// `price_entered_with_tax`, the costs the method uses and `additional_rule`; a
/// `handling_cost` or `additional_rule` the rate does not use is sent as
/// `null`. A field left out is `400` naming it.
Future<ApiResponse> updateShippingRate(
        WebCommanderClient client, Object shippingRateId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingRateUrls.shippingRate,
        pathParams: {'shipping_rate_id': shippingRateId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRate.fromMap);

/// Change only the fields sent — `PATCH
/// /admin/shipping_rates/{shipping_rate_id}`; the costs, rows and boxes not
/// sent are kept. An empty `shipping_rate` changes nothing and is `200`.
Future<ApiResponse> patchShippingRate(
        WebCommanderClient client, Object shippingRateId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShippingRateUrls.shippingRate,
        pathParams: {'shipping_rate_id': shippingRateId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRate.fromMap);

/// Delete one rate — `DELETE /admin/shipping_rates/{shipping_rate_id}`, `204`.
/// A rate a rule uses is `409` until the rule lets it go.
Future<ApiResponse> deleteShippingRate(
        WebCommanderClient client, Object shippingRateId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ShippingRateUrls.shippingRate,
        pathParams: {'shipping_rate_id': shippingRateId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listShippingRates = listShippingRates;
final _headShippingRates = headShippingRates;
final _countShippingRates = countShippingRates;
final _headShippingRatesCount = headShippingRatesCount;
final _createShippingRate = createShippingRate;
final _getShippingRate = getShippingRate;
final _headShippingRate = headShippingRate;
final _updateShippingRate = updateShippingRate;
final _patchShippingRate = patchShippingRate;
final _deleteShippingRate = deleteShippingRate;
