import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'inventory_locations_dto.dart';
import 'inventory_locations_urls.dart';

/// Inventory location endpoints, bound to one client.
class InventoryLocations {
  /// Bind the resource to a client; normally reached via `client.inventoryLocations`.
  InventoryLocations(this._client);

  final WebCommanderClient _client;

  /// List the locations — `GET /admin/inventory_locations`.
  Future<ApiResponse> listInventoryLocations({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listInventoryLocations(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/inventory_locations`.
  Future<ApiResponse> headInventoryLocations(
          {bool? raiseOnError, String? responseFormat}) =>
      _headInventoryLocations(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a location — `POST /admin/inventory_locations`.
  Future<ApiResponse> createInventoryLocation(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createInventoryLocation(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one location —
  /// `GET /admin/inventory_locations/{inventory_location_id}`.
  Future<ApiResponse> getInventoryLocation(Object inventoryLocationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getInventoryLocation(_client, inventoryLocationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one location is there —
  /// `HEAD /admin/inventory_locations/{inventory_location_id}`.
  Future<ApiResponse> headInventoryLocation(Object inventoryLocationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headInventoryLocation(_client, inventoryLocationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one location —
  /// `PUT /admin/inventory_locations/{inventory_location_id}`.
  Future<ApiResponse> updateInventoryLocation(
          Object inventoryLocationId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateInventoryLocation(_client, inventoryLocationId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent on one location —
  /// `PATCH /admin/inventory_locations/{inventory_location_id}`.
  Future<ApiResponse> patchInventoryLocation(
          Object inventoryLocationId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchInventoryLocation(_client, inventoryLocationId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a location —
  /// `DELETE /admin/inventory_locations/{inventory_location_id}`.
  Future<ApiResponse> deleteInventoryLocation(Object inventoryLocationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteInventoryLocation(_client, inventoryLocationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// What one location holds —
  /// `GET /admin/inventory_locations/{inventory_location_id}/stock`.
  Future<ApiResponse> getInventoryLocationStock(
    Object inventoryLocationId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getInventoryLocationStock(_client, inventoryLocationId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Make one location the default —
  /// `PUT /admin/inventory_locations/{inventory_location_id}/default`.
  Future<ApiResponse> setInventoryLocationDefault(Object inventoryLocationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _setInventoryLocationDefault(_client, inventoryLocationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Activate or deactivate one location —
  /// `PUT /admin/inventory_locations/{inventory_location_id}/status`.
  Future<ApiResponse> updateInventoryLocationStatus(
          Object inventoryLocationId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateInventoryLocationStatus(_client, inventoryLocationId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the locations — `GET /admin/inventory_locations`.
Future<ApiResponse> listInventoryLocations(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(InventoryLocationUrls.inventoryLocations,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/inventory_locations`.
Future<ApiResponse> headInventoryLocations(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', InventoryLocationUrls.inventoryLocations,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a location — `POST /admin/inventory_locations`.
Future<ApiResponse> createInventoryLocation(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(InventoryLocationUrls.inventoryLocations,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

/// Retrieve one location —
/// `GET /admin/inventory_locations/{inventory_location_id}`.
Future<ApiResponse> getInventoryLocation(
        WebCommanderClient client, Object inventoryLocationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(InventoryLocationUrls.inventoryLocation,
        pathParams: {'inventory_location_id': inventoryLocationId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

/// Ask whether one location is there —
/// `HEAD /admin/inventory_locations/{inventory_location_id}`.
Future<ApiResponse> headInventoryLocation(
        WebCommanderClient client, Object inventoryLocationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', InventoryLocationUrls.inventoryLocation,
        pathParams: {'inventory_location_id': inventoryLocationId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one location —
/// `PUT /admin/inventory_locations/{inventory_location_id}`.
Future<ApiResponse> updateInventoryLocation(
        WebCommanderClient client, Object inventoryLocationId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(InventoryLocationUrls.inventoryLocation,
        pathParams: {'inventory_location_id': inventoryLocationId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

/// Change only the fields sent on one location —
/// `PATCH /admin/inventory_locations/{inventory_location_id}`; a bare record of
/// at least one field, and what it leaves out keeps its stored value.
Future<ApiResponse> patchInventoryLocation(
        WebCommanderClient client, Object inventoryLocationId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(InventoryLocationUrls.inventoryLocation,
        pathParams: {'inventory_location_id': inventoryLocationId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

/// Delete a location —
/// `DELETE /admin/inventory_locations/{inventory_location_id}`.
Future<ApiResponse> deleteInventoryLocation(
        WebCommanderClient client, Object inventoryLocationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(InventoryLocationUrls.inventoryLocation,
        pathParams: {'inventory_location_id': inventoryLocationId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// What one location holds —
/// `GET /admin/inventory_locations/{inventory_location_id}/stock`.
Future<ApiResponse> getInventoryLocationStock(
  WebCommanderClient client,
  Object inventoryLocationId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(InventoryLocationUrls.inventoryLocationStock,
        pathParams: {'inventory_location_id': inventoryLocationId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationStock.fromMap);

/// Make one location the default —
/// `PUT /admin/inventory_locations/{inventory_location_id}/default`.
Future<ApiResponse> setInventoryLocationDefault(
        WebCommanderClient client, Object inventoryLocationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(InventoryLocationUrls.inventoryLocationDefault,
        pathParams: {'inventory_location_id': inventoryLocationId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

/// Activate or deactivate one location —
/// `PUT /admin/inventory_locations/{inventory_location_id}/status`.
Future<ApiResponse> updateInventoryLocationStatus(
        WebCommanderClient client, Object inventoryLocationId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(InventoryLocationUrls.inventoryLocationStatus,
        pathParams: {'inventory_location_id': inventoryLocationId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: InventoryLocationRecord.fromMap);

final _listInventoryLocations = listInventoryLocations;
final _headInventoryLocations = headInventoryLocations;
final _createInventoryLocation = createInventoryLocation;
final _getInventoryLocation = getInventoryLocation;
final _headInventoryLocation = headInventoryLocation;
final _updateInventoryLocation = updateInventoryLocation;
final _patchInventoryLocation = patchInventoryLocation;
final _deleteInventoryLocation = deleteInventoryLocation;
final _getInventoryLocationStock = getInventoryLocationStock;
final _setInventoryLocationDefault = setInventoryLocationDefault;
final _updateInventoryLocationStatus = updateInventoryLocationStatus;
