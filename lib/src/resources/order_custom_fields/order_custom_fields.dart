import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'order_custom_fields_dto.dart';
import 'order_custom_fields_urls.dart';

/// Order custom field endpoints, bound to one client.
class OrderCustomFields {
  /// Bind the resource to a client; normally reached via
  /// `client.orderCustomFields`.
  OrderCustomFields(this._client);

  final WebCommanderClient _client;

  /// List the fields — `GET /admin/order_custom_fields`.
  Future<ApiResponse> listOrderCustomFields({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listOrderCustomFields(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// How many fields the store holds — `GET /admin/order_custom_fields/count`.
  Future<ApiResponse> countOrderCustomFields({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countOrderCustomFields(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one field —
  /// `GET /admin/order_custom_fields/{order_custom_field_id}`.
  Future<ApiResponse> getOrderCustomField(
    Object orderCustomFieldId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getOrderCustomField(_client, orderCustomFieldId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Check a timeslot against an order limit —
  /// `POST /admin/order_custom_fields/{order_custom_field_id}/validate_timeslot`.
  Future<ApiResponse> validateOrderCustomFieldTimeslot(
          Object orderCustomFieldId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _validateOrderCustomFieldTimeslot(_client, orderCustomFieldId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the fields — `GET /admin/order_custom_fields`. `limit` caps at 20; `sort`
/// takes `id`, `label`, `name`, `type`, `orderNo`, `isActive`, `created` or `updated`.
Future<ApiResponse> listOrderCustomFields(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderCustomFieldUrls.orderCustomFields,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCustomFieldPage.fromMap);

/// How many fields the store holds — `GET /admin/order_custom_fields/count`.
/// `.map` is `{"count": N}`; `filterBy` narrows it as it narrows the listing.
Future<ApiResponse> countOrderCustomFields(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderCustomFieldUrls.orderCustomFieldsCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Retrieve one field, with nine fields its listing row leaves out; `field_metadata`
/// adds the schema beside it. `GET /admin/order_custom_fields/{order_custom_field_id}`
Future<ApiResponse> getOrderCustomField(
  WebCommanderClient client,
  Object orderCustomFieldId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(OrderCustomFieldUrls.orderCustomField,
        pathParams: {'order_custom_field_id': orderCustomFieldId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: OrderCustomField.fromMap);

/// Check a timeslot against an order limit; `201 {"valid", "message"}`, nothing stored.
/// `POST /admin/order_custom_fields/{order_custom_field_id}/validate_timeslot`
Future<ApiResponse> validateOrderCustomFieldTimeslot(
        WebCommanderClient client, Object orderCustomFieldId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(
        OrderCustomFieldUrls.orderCustomFieldValidateTimeslot,
        pathParams: {'order_custom_field_id': orderCustomFieldId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listOrderCustomFields = listOrderCustomFields;
final _countOrderCustomFields = countOrderCustomFields;
final _getOrderCustomField = getOrderCustomField;
final _validateOrderCustomFieldTimeslot = validateOrderCustomFieldTimeslot;
