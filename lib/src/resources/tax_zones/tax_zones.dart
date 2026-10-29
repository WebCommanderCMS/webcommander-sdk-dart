import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_zones_dto.dart';
import 'tax_zones_urls.dart';

/// Tax zone endpoints, bound to one client.
class TaxZones {
  /// Bind the resource to a client; normally reached via `client.taxZones`.
  TaxZones(this._client);

  final WebCommanderClient _client;

  /// List the tax zones — `GET /admin/tax_zones`.
  Future<ApiResponse> listTaxZones({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxZones(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/tax_zones`.
  Future<ApiResponse> headTaxZones(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxZones(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a tax zone — `POST /admin/tax_zones`.
  Future<ApiResponse> createTaxZone(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createTaxZone(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one tax zone — `GET /admin/tax_zones/{tax_zone_id}`.
  Future<ApiResponse> getTaxZone(Object taxZoneId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxZone(_client, taxZoneId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one tax zone is there — `HEAD /admin/tax_zones/{tax_zone_id}`.
  Future<ApiResponse> headTaxZone(Object taxZoneId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxZone(_client, taxZoneId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one tax zone — `PUT /admin/tax_zones/{tax_zone_id}`.
  Future<ApiResponse> updateTaxZone(Object taxZoneId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxZone(_client, taxZoneId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one tax zone — `DELETE /admin/tax_zones/{tax_zone_id}`.
  Future<ApiResponse> deleteTaxZone(Object taxZoneId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxZone(_client, taxZoneId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the tax zones — `GET /admin/tax_zones`.
Future<ApiResponse> listTaxZones(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxZoneUrls.taxZones,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxZonePage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/tax_zones`.
Future<ApiResponse> headTaxZones(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxZoneUrls.taxZones,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a tax zone — `POST /admin/tax_zones`.
Future<ApiResponse> createTaxZone(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxZoneUrls.taxZones,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxZone.fromMap);

/// Retrieve one tax zone — `GET /admin/tax_zones/{tax_zone_id}`.
Future<ApiResponse> getTaxZone(WebCommanderClient client, Object taxZoneId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxZoneUrls.taxZone,
        pathParams: {'tax_zone_id': taxZoneId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxZone.fromMap);

/// Ask whether one tax zone is there — `HEAD /admin/tax_zones/{tax_zone_id}`.
Future<ApiResponse> headTaxZone(WebCommanderClient client, Object taxZoneId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxZoneUrls.taxZone,
        pathParams: {'tax_zone_id': taxZoneId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Update one tax zone — `PUT /admin/tax_zones/{tax_zone_id}`.
Future<ApiResponse> updateTaxZone(
        WebCommanderClient client, Object taxZoneId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxZoneUrls.taxZone,
        pathParams: {'tax_zone_id': taxZoneId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxZone.fromMap);

/// Delete one tax zone — `DELETE /admin/tax_zones/{tax_zone_id}`.
Future<ApiResponse> deleteTaxZone(WebCommanderClient client, Object taxZoneId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxZoneUrls.taxZone,
        pathParams: {'tax_zone_id': taxZoneId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxZones = listTaxZones;
final _headTaxZones = headTaxZones;
final _createTaxZone = createTaxZone;
final _getTaxZone = getTaxZone;
final _headTaxZone = headTaxZone;
final _updateTaxZone = updateTaxZone;
final _deleteTaxZone = deleteTaxZone;
