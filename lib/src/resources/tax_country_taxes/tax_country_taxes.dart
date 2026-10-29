import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_country_taxes_dto.dart';
import 'tax_country_taxes_urls.dart';

/// Country tax endpoints, bound to one client; no path here serves `HEAD`.
class TaxCountryTaxes {
  /// Bind the resource to a client; normally reached via `client.taxCountryTaxes`.
  TaxCountryTaxes(this._client);

  final WebCommanderClient _client;

  /// List the country taxes — `GET /admin/tax/country-taxes`.
  Future<ApiResponse> listTaxCountryTaxes({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxCountryTaxes(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a country tax — `POST /admin/tax/country-taxes`.
  Future<ApiResponse> createTaxCountryTax(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createTaxCountryTax(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one country tax —
  /// `GET /admin/tax/country-taxes/{country_tax_id}`.
  Future<ApiResponse> getTaxCountryTax(Object countryTaxId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxCountryTax(_client, countryTaxId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one country tax — `PUT /admin/tax/country-taxes/{country_tax_id}`.
  Future<ApiResponse> updateTaxCountryTax(Object countryTaxId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxCountryTax(_client, countryTaxId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one country tax —
  /// `DELETE /admin/tax/country-taxes/{country_tax_id}`.
  Future<ApiResponse> deleteTaxCountryTax(Object countryTaxId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxCountryTax(_client, countryTaxId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the country taxes — `GET /admin/tax/country-taxes`, newest first.
/// `limit` is 1 to 100 with the cap echoed, `offset` or `page` move the window,
/// `sort` takes `id` or `name`.
Future<ApiResponse> listTaxCountryTaxes(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxCountryTaxUrls.taxCountryTaxes,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryTaxPage.fromMap);

/// Create a country tax — `POST /admin/tax/country-taxes`, answered `201`. The
/// body is wrapped in `country_tax` and needs `country_code`, a field no read
/// sends. [transactionNo] is sent as `X-Transaction-No` and files the row under
/// that number.
Future<ApiResponse> createTaxCountryTax(
        WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxCountryTaxUrls.taxCountryTaxes,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {TaxCountryTaxUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryTax.fromMap);

/// Retrieve one country tax — `GET /admin/tax/country-taxes/{country_tax_id}`;
/// with an `ETag`, and only the row path and the update carry `state_rules`.
Future<ApiResponse> getTaxCountryTax(
        WebCommanderClient client, Object countryTaxId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxCountryTaxUrls.taxCountryTax,
        pathParams: {'country_tax_id': countryTaxId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryTax.fromMap);

/// Update one country tax — `PUT /admin/tax/country-taxes/{country_tax_id}`;
/// a merge, wrapped in `country_tax`, answered `200` with an `ETag`.
Future<ApiResponse> updateTaxCountryTax(
        WebCommanderClient client, Object countryTaxId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxCountryTaxUrls.taxCountryTax,
        pathParams: {'country_tax_id': countryTaxId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryTax.fromMap);

/// Delete one country tax —
/// `DELETE /admin/tax/country-taxes/{country_tax_id}`; `204`.
Future<ApiResponse> deleteTaxCountryTax(
        WebCommanderClient client, Object countryTaxId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxCountryTaxUrls.taxCountryTax,
        pathParams: {'country_tax_id': countryTaxId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxCountryTaxes = listTaxCountryTaxes;
final _createTaxCountryTax = createTaxCountryTax;
final _getTaxCountryTax = getTaxCountryTax;
final _updateTaxCountryTax = updateTaxCountryTax;
final _deleteTaxCountryTax = deleteTaxCountryTax;
