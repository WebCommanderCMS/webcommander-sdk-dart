import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'order_flags_dto.dart';
import 'order_flags_urls.dart';

/// Order flag endpoints, bound to one client.
class OrderFlags {
  /// Bind the resource to a client; normally reached via `client.orderFlags`.
  OrderFlags(this._client);

  final WebCommanderClient _client;

  /// List the flags — `GET /admin/order_flags`.
  Future<ApiResponse> listOrderFlags({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listOrderFlags(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/order_flags`.
  Future<ApiResponse> headOrderFlags(
          {bool? raiseOnError, String? responseFormat}) =>
      _headOrderFlags(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a flag — `POST /admin/order_flags`.
  Future<ApiResponse> createOrderFlag(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createOrderFlag(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one flag — `GET /admin/order_flags/{order_flag_id}`.
  Future<ApiResponse> getOrderFlag(Object orderFlagId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getOrderFlag(_client, orderFlagId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one flag is there — `HEAD /admin/order_flags/{order_flag_id}`.
  Future<ApiResponse> headOrderFlag(Object orderFlagId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headOrderFlag(_client, orderFlagId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one flag — `PUT /admin/order_flags/{order_flag_id}`.
  Future<ApiResponse> updateOrderFlag(Object orderFlagId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateOrderFlag(_client, orderFlagId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a flag — `DELETE /admin/order_flags/{order_flag_id}`.
  Future<ApiResponse> deleteOrderFlag(Object orderFlagId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteOrderFlag(_client, orderFlagId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the flags — `GET /admin/order_flags`.
Future<ApiResponse> listOrderFlags(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderFlagUrls.orderFlags,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderFlagPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/order_flags`.
Future<ApiResponse> headOrderFlags(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', OrderFlagUrls.orderFlags,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a flag — `POST /admin/order_flags`.
Future<ApiResponse> createOrderFlag(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(OrderFlagUrls.orderFlags,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderFlagRecord.fromMap);

/// Retrieve one flag — `GET /admin/order_flags/{order_flag_id}`.
Future<ApiResponse> getOrderFlag(WebCommanderClient client, Object orderFlagId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(OrderFlagUrls.orderFlag,
        pathParams: {'order_flag_id': orderFlagId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderFlagRecord.fromMap);

/// Ask whether one flag is there — `HEAD /admin/order_flags/{order_flag_id}`.
Future<ApiResponse> headOrderFlag(WebCommanderClient client, Object orderFlagId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', OrderFlagUrls.orderFlag,
        pathParams: {'order_flag_id': orderFlagId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one flag — `PUT /admin/order_flags/{order_flag_id}`.
Future<ApiResponse> updateOrderFlag(
        WebCommanderClient client, Object orderFlagId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(OrderFlagUrls.orderFlag,
        pathParams: {'order_flag_id': orderFlagId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderFlagRecord.fromMap);

/// Delete a flag — `DELETE /admin/order_flags/{order_flag_id}`.
Future<ApiResponse> deleteOrderFlag(
        WebCommanderClient client, Object orderFlagId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(OrderFlagUrls.orderFlag,
        pathParams: {'order_flag_id': orderFlagId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listOrderFlags = listOrderFlags;
final _headOrderFlags = headOrderFlags;
final _createOrderFlag = createOrderFlag;
final _getOrderFlag = getOrderFlag;
final _headOrderFlag = headOrderFlag;
final _updateOrderFlag = updateOrderFlag;
final _deleteOrderFlag = deleteOrderFlag;
