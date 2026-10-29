import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_codes_dto.dart';
import 'tax_codes_urls.dart';

/// Tax code endpoints, bound to one client.
class TaxCodes {
  /// Bind the resource to a client; normally reached via `client.taxCodes`.
  TaxCodes(this._client);

  final WebCommanderClient _client;

  /// List the tax codes — `GET /admin/tax_codes`.
  Future<ApiResponse> listTaxCodes({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxCodes(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/tax_codes`.
  Future<ApiResponse> headTaxCodes(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxCodes(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a tax code — `POST /admin/tax_codes`.
  Future<ApiResponse> createTaxCode(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createTaxCode(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one tax code — `GET /admin/tax_codes/{tax_code_id}`.
  Future<ApiResponse> getTaxCode(Object taxCodeId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxCode(_client, taxCodeId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one tax code is there — `HEAD /admin/tax_codes/{tax_code_id}`.
  Future<ApiResponse> headTaxCode(Object taxCodeId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxCode(_client, taxCodeId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one tax code — `PUT /admin/tax_codes/{tax_code_id}`.
  Future<ApiResponse> updateTaxCode(Object taxCodeId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxCode(_client, taxCodeId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one tax code — `DELETE /admin/tax_codes/{tax_code_id}`.
  Future<ApiResponse> deleteTaxCode(Object taxCodeId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxCode(_client, taxCodeId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the tax codes — `GET /admin/tax_codes`. `limit` is capped at 100.
Future<ApiResponse> listTaxCodes(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxCodeUrls.taxCodes,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxCodePage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/tax_codes`.
Future<ApiResponse> headTaxCodes(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxCodeUrls.taxCodes,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a tax code — `POST /admin/tax_codes`.
Future<ApiResponse> createTaxCode(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxCodeUrls.taxCodes,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxCode.fromMap);

/// Retrieve one tax code — `GET /admin/tax_codes/{tax_code_id}`.
Future<ApiResponse> getTaxCode(WebCommanderClient client, Object taxCodeId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxCodeUrls.taxCode,
        pathParams: {'tax_code_id': taxCodeId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxCode.fromMap);

/// Ask whether one tax code is there — `HEAD /admin/tax_codes/{tax_code_id}`.
Future<ApiResponse> headTaxCode(WebCommanderClient client, Object taxCodeId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxCodeUrls.taxCode,
        pathParams: {'tax_code_id': taxCodeId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Update one tax code — `PUT /admin/tax_codes/{tax_code_id}`.
Future<ApiResponse> updateTaxCode(
        WebCommanderClient client, Object taxCodeId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxCodeUrls.taxCode,
        pathParams: {'tax_code_id': taxCodeId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxCode.fromMap);

/// Delete one tax code — `DELETE /admin/tax_codes/{tax_code_id}`.
Future<ApiResponse> deleteTaxCode(WebCommanderClient client, Object taxCodeId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxCodeUrls.taxCode,
        pathParams: {'tax_code_id': taxCodeId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxCodes = listTaxCodes;
final _headTaxCodes = headTaxCodes;
final _createTaxCode = createTaxCode;
final _getTaxCode = getTaxCode;
final _headTaxCode = headTaxCode;
final _updateTaxCode = updateTaxCode;
final _deleteTaxCode = deleteTaxCode;
