import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'shipping_classes_dto.dart';
import 'shipping_classes_urls.dart';

/// Shipping class endpoints, bound to one client.
class ShippingClasses {
  /// Bind the resource to a client; normally reached via `client.shippingClasses`.
  ShippingClasses(this._client);

  final WebCommanderClient _client;

  /// List the classes — `GET /admin/shipping_classes`.
  Future<ApiResponse> listShippingClasses({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listShippingClasses(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection answers — `HEAD /admin/shipping_classes`.
  Future<ApiResponse> headShippingClasses(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingClasses(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many classes the store holds — `GET /admin/shipping_classes/count`.
  Future<ApiResponse> countShippingClasses({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countShippingClasses(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a class — `POST /admin/shipping_classes`.
  Future<ApiResponse> createShippingClass(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createShippingClass(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one class — `GET /admin/shipping_classes/{shipping_class_id}`.
  Future<ApiResponse> getShippingClass(
    Object shippingClassId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getShippingClass(_client, shippingClassId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether a class's path answers — `HEAD .../{shipping_class_id}`.
  Future<ApiResponse> headShippingClass(Object shippingClassId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingClass(_client, shippingClassId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one class — `PUT /admin/shipping_classes/{shipping_class_id}`.
  Future<ApiResponse> updateShippingClass(
          Object shippingClassId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateShippingClass(_client, shippingClassId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one class — `DELETE /admin/shipping_classes/{shipping_class_id}`.
  Future<ApiResponse> deleteShippingClass(Object shippingClassId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteShippingClass(_client, shippingClassId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Make one class the default — `PUT .../{shipping_class_id}/default`.
  Future<ApiResponse> setShippingClassDefault(Object shippingClassId,
          {bool? raiseOnError, String? responseFormat}) =>
      _setShippingClassDefault(_client, shippingClassId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the classes — `GET /admin/shipping_classes`.
Future<ApiResponse> listShippingClasses(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingClassUrls.shippingClasses,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClassPage.fromMap);

/// Ask whether the collection answers — `HEAD /admin/shipping_classes`; `200`, no body.
Future<ApiResponse> headShippingClasses(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingClassUrls.shippingClasses,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many classes the store holds — `GET /admin/shipping_classes/count`.
Future<ApiResponse> countShippingClasses(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingClassUrls.shippingClassesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClassCount.fromMap);

/// Create a class — `POST /admin/shipping_classes`.
Future<ApiResponse> createShippingClass(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingClassUrls.shippingClasses,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClass.fromMap);

/// Retrieve one class — `GET /admin/shipping_classes/{shipping_class_id}`.
Future<ApiResponse> getShippingClass(
  WebCommanderClient client,
  Object shippingClassId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingClassUrls.shippingClass,
        pathParams: {'shipping_class_id': shippingClassId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClass.fromMap);

/// Ask whether a class's path answers — `HEAD .../{shipping_class_id}`.
Future<ApiResponse> headShippingClass(
        WebCommanderClient client, Object shippingClassId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingClassUrls.shippingClass,
        pathParams: {'shipping_class_id': shippingClassId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one class — `PUT /admin/shipping_classes/{shipping_class_id}`.
Future<ApiResponse> updateShippingClass(
        WebCommanderClient client, Object shippingClassId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingClassUrls.shippingClass,
        pathParams: {'shipping_class_id': shippingClassId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClass.fromMap);

/// Delete one class — `DELETE /admin/shipping_classes/{shipping_class_id}`.
Future<ApiResponse> deleteShippingClass(
        WebCommanderClient client, Object shippingClassId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ShippingClassUrls.shippingClass,
        pathParams: {'shipping_class_id': shippingClassId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Make one class the default — `PUT .../{shipping_class_id}/default`.
Future<ApiResponse> setShippingClassDefault(
        WebCommanderClient client, Object shippingClassId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingClassUrls.shippingClassDefault,
        pathParams: {'shipping_class_id': shippingClassId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingClass.fromMap);

final _listShippingClasses = listShippingClasses;
final _headShippingClasses = headShippingClasses;
final _countShippingClasses = countShippingClasses;
final _createShippingClass = createShippingClass;
final _getShippingClass = getShippingClass;
final _headShippingClass = headShippingClass;
final _updateShippingClass = updateShippingClass;
final _deleteShippingClass = deleteShippingClass;
final _setShippingClassDefault = setShippingClassDefault;
