import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'currencies_dto.dart';
import 'currencies_urls.dart';

/// Currency endpoints, bound to one client.
class Currencies {
  /// Bind the resource to a client; normally reached via `client.currencies`.
  Currencies(this._client);

  final WebCommanderClient _client;

  /// List the currencies by ascending `id` — `GET /admin/currencies`.
  Future<ApiResponse> listCurrencies({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCurrencies(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/currencies`.
  Future<ApiResponse> headCurrencies(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCurrencies(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many currencies match — `GET /admin/currencies/count`.
  Future<ApiResponse> countCurrencies({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countCurrencies(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable — `HEAD /admin/currencies/count`.
  Future<ApiResponse> headCurrenciesCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCurrenciesCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a currency — `POST /admin/currencies`.
  Future<ApiResponse> createCurrency(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createCurrency(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one currency — `GET /admin/currencies/{currency_id}`.
  Future<ApiResponse> getCurrency(
    Object currencyId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCurrency(_client, currencyId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether one currency is there — `HEAD /admin/currencies/{currency_id}`.
  Future<ApiResponse> headCurrency(Object currencyId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headCurrency(_client, currencyId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one currency — `PUT /admin/currencies/{currency_id}`.
  Future<ApiResponse> updateCurrency(Object currencyId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCurrency(_client, currencyId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH /admin/currencies/{currency_id}`.
  Future<ApiResponse> patchCurrency(Object currencyId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCurrency(_client, currencyId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a currency — `DELETE /admin/currencies/{currency_id}`.
  Future<ApiResponse> deleteCurrency(Object currencyId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCurrency(_client, currencyId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Make one currency the store's base —
  /// `PUT /admin/currencies/{currency_id}/base`.
  Future<ApiResponse> setBaseCurrency(Object currencyId,
          {bool? raiseOnError, String? responseFormat}) =>
      _setBaseCurrency(_client, currencyId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the currencies by ascending `id` — `GET /admin/currencies`. `search`
/// matches `name` or `code`, `active` filters, `sort` and `dir` order, `limit`
/// is 1 to 100.
Future<ApiResponse> listCurrencies(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CurrencyUrls.currencies,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CurrencyPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/currencies`; no body.
Future<ApiResponse> headCurrencies(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CurrencyUrls.currencies,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many currencies match — `GET /admin/currencies/count`, a bare
/// `{"total": N}`. `search` and `active` narrow it; `limit` is ignored.
Future<ApiResponse> countCurrencies(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CurrencyUrls.currenciesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CurrencyCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/currencies/count`; no body.
Future<ApiResponse> headCurrenciesCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CurrencyUrls.currenciesCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a currency — `POST /admin/currencies`, answered `201`. A bare record:
/// `name`, `code` and `symbol` are required, and `name` and `code` must be free.
/// [transactionNo] is sent as `X-Transaction-No` and files the currency under
/// that number.
Future<ApiResponse> createCurrency(WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CurrencyUrls.currencies,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {CurrencyUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Currency.fromMap);

/// Retrieve one currency, with an `ETag`; `field_metadata` adds the schema
/// beside it. `GET /admin/currencies/{currency_id}`
Future<ApiResponse> getCurrency(
  WebCommanderClient client,
  Object currencyId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CurrencyUrls.currency,
        pathParams: {'currency_id': currencyId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Currency.fromMap);

/// Ask whether one currency is there; no body, the `ETag` its `GET` carries.
/// `HEAD /admin/currencies/{currency_id}`
Future<ApiResponse> headCurrency(WebCommanderClient client, Object currencyId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CurrencyUrls.currency,
        pathParams: {'currency_id': currencyId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one currency — `PUT /admin/currencies/{currency_id}`. `name`, `code`
/// and `symbol` are required and every field left out is reset to its default;
/// not the base.
Future<ApiResponse> updateCurrency(
        WebCommanderClient client, Object currencyId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CurrencyUrls.currency,
        pathParams: {'currency_id': currencyId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Currency.fromMap);

/// Change only the fields sent — `PATCH /admin/currencies/{currency_id}`. An
/// empty body is `400`, and the base currency is read-only here as on `PUT`.
Future<ApiResponse> patchCurrency(
        WebCommanderClient client, Object currencyId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CurrencyUrls.currency,
        pathParams: {'currency_id': currencyId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Currency.fromMap);

/// Delete a currency — `DELETE /admin/currencies/{currency_id}`; `204`. The
/// base currency is `409`: make another currency the base first.
Future<ApiResponse> deleteCurrency(WebCommanderClient client, Object currencyId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CurrencyUrls.currency,
        pathParams: {'currency_id': currencyId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Make an active currency the store's base; takes no body. Every rate is
/// divided by the new base's old rate. `PUT /admin/currencies/{currency_id}/base`
Future<ApiResponse> setBaseCurrency(
        WebCommanderClient client, Object currencyId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CurrencyUrls.currencyBase,
        pathParams: {'currency_id': currencyId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CurrencyBaseChange.fromMap);

final _listCurrencies = listCurrencies;
final _headCurrencies = headCurrencies;
final _countCurrencies = countCurrencies;
final _headCurrenciesCount = headCurrenciesCount;
final _createCurrency = createCurrency;
final _getCurrency = getCurrency;
final _headCurrency = headCurrency;
final _updateCurrency = updateCurrency;
final _patchCurrency = patchCurrency;
final _deleteCurrency = deleteCurrency;
final _setBaseCurrency = setBaseCurrency;
