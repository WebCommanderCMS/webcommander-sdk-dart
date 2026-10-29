import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'shipping_methods_dto.dart';
import 'shipping_methods_urls.dart';

/// Shipping method endpoints, bound to one client.
class ShippingMethods {
  /// Bind the resource to a client; normally reached via `client.shippingMethods`.
  ShippingMethods(this._client);

  final WebCommanderClient _client;

  /// List the methods — `GET /admin/shipping_methods`.
  Future<ApiResponse> listShippingMethods({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listShippingMethods(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/shipping_methods`.
  Future<ApiResponse> headShippingMethods(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingMethods(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many methods the store holds — `GET /admin/shipping_methods/count`.
  Future<ApiResponse> countShippingMethods({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countShippingMethods(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a method — `POST /admin/shipping_methods`.
  Future<ApiResponse> createShippingMethod(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createShippingMethod(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one method — `GET /admin/shipping_methods/{shipping_method_id}`.
  Future<ApiResponse> getShippingMethod(
    Object shippingMethodId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getShippingMethod(_client, shippingMethodId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether one method is there —
  /// `HEAD /admin/shipping_methods/{shipping_method_id}`.
  Future<ApiResponse> headShippingMethod(Object shippingMethodId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingMethod(_client, shippingMethodId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Rename one method — `PUT /admin/shipping_methods/{shipping_method_id}`.
  Future<ApiResponse> updateShippingMethod(
          Object shippingMethodId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateShippingMethod(_client, shippingMethodId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a method — `DELETE /admin/shipping_methods/{shipping_method_id}`.
  Future<ApiResponse> deleteShippingMethod(Object shippingMethodId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteShippingMethod(_client, shippingMethodId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Make one method the store default —
  /// `PUT /admin/shipping_methods/{shipping_method_id}/default`.
  Future<ApiResponse> setShippingMethodDefault(Object shippingMethodId,
          {bool? raiseOnError, String? responseFormat}) =>
      _setShippingMethodDefault(_client, shippingMethodId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the methods — `GET /admin/shipping_methods`.
Future<ApiResponse> listShippingMethods(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingMethodUrls.shippingMethods,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethodPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/shipping_methods`.
Future<ApiResponse> headShippingMethods(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingMethodUrls.shippingMethods,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many methods the store holds — `GET /admin/shipping_methods/count`.
Future<ApiResponse> countShippingMethods(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingMethodUrls.shippingMethodsCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethodCount.fromMap);

/// Create a method — `POST /admin/shipping_methods`.
Future<ApiResponse> createShippingMethod(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingMethodUrls.shippingMethods,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethod.fromMap);

/// Retrieve one method — `GET /admin/shipping_methods/{shipping_method_id}`.
Future<ApiResponse> getShippingMethod(
  WebCommanderClient client,
  Object shippingMethodId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingMethodUrls.shippingMethod,
        pathParams: {'shipping_method_id': shippingMethodId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethod.fromMap);

/// Ask whether one method is there —
/// `HEAD /admin/shipping_methods/{shipping_method_id}`.
Future<ApiResponse> headShippingMethod(
        WebCommanderClient client, Object shippingMethodId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingMethodUrls.shippingMethod,
        pathParams: {'shipping_method_id': shippingMethodId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Rename one method — `PUT /admin/shipping_methods/{shipping_method_id}`.
Future<ApiResponse> updateShippingMethod(
        WebCommanderClient client, Object shippingMethodId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingMethodUrls.shippingMethod,
        pathParams: {'shipping_method_id': shippingMethodId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethod.fromMap);

/// Delete a method — `DELETE /admin/shipping_methods/{shipping_method_id}`.
Future<ApiResponse> deleteShippingMethod(
        WebCommanderClient client, Object shippingMethodId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ShippingMethodUrls.shippingMethod,
        pathParams: {'shipping_method_id': shippingMethodId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Make one method the store default —
/// `PUT /admin/shipping_methods/{shipping_method_id}/default`.
Future<ApiResponse> setShippingMethodDefault(
        WebCommanderClient client, Object shippingMethodId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingMethodUrls.shippingMethodDefault,
        pathParams: {'shipping_method_id': shippingMethodId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingMethod.fromMap);

final _listShippingMethods = listShippingMethods;
final _headShippingMethods = headShippingMethods;
final _countShippingMethods = countShippingMethods;
final _createShippingMethod = createShippingMethod;
final _getShippingMethod = getShippingMethod;
final _headShippingMethod = headShippingMethod;
final _updateShippingMethod = updateShippingMethod;
final _deleteShippingMethod = deleteShippingMethod;
final _setShippingMethodDefault = setShippingMethodDefault;
