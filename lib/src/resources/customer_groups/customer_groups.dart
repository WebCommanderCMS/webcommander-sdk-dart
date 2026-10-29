import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'customer_groups_dto.dart';
import 'customer_groups_urls.dart';

/// Customer group endpoints, bound to one client.
class CustomerGroups {
  /// Bind the resource to a client; normally reached via
  /// `client.customerGroups`.
  CustomerGroups(this._client);

  final WebCommanderClient _client;

  /// List the groups, by `name` — `GET /admin/customer_groups`.
  Future<ApiResponse> listCustomerGroups({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCustomerGroups(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// How many groups match — `GET /admin/customer_groups/count`.
  Future<ApiResponse> countCustomerGroups({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countCustomerGroups(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a group — `POST /admin/customer_groups`.
  Future<ApiResponse> createCustomerGroup(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createCustomerGroup(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one group —
  /// `GET /admin/customer_groups/{customer_group_id}`.
  Future<ApiResponse> getCustomerGroup(
    Object customerGroupId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerGroup(_client, customerGroupId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Change only the fields sent —
  /// `PATCH /admin/customer_groups/{customer_group_id}`.
  Future<ApiResponse> patchCustomerGroup(Object customerGroupId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCustomerGroup(_client, customerGroupId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one group —
  /// `DELETE /admin/customer_groups/{customer_group_id}`.
  Future<ApiResponse> deleteCustomerGroup(Object customerGroupId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCustomerGroup(_client, customerGroupId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace the member list —
  /// `PATCH /admin/customer_groups/{customer_group_id}/customers`.
  Future<ApiResponse> updateCustomerGroupCustomers(
          Object customerGroupId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCustomerGroupCustomers(_client, customerGroupId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read one member —
  /// `GET /admin/customer_groups/{customer_group_id}/customers/{customer_id}`.
  Future<ApiResponse> getCustomerGroupCustomer(
          Object customerGroupId, Object customerId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCustomerGroupCustomer(_client, customerGroupId, customerId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add one customer to one group — `POST /admin/customer_groups/assign`.
  Future<ApiResponse> assignCustomerGroup(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _assignCustomerGroup(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the groups, by `name` — `GET /admin/customer_groups`. `limit` 1 to 100,
/// default 20; `search_text` or `name` match a name, `status` takes `A` or `I`.
Future<ApiResponse> listCustomerGroups(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerGroupUrls.customerGroups,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupPage.fromMap);

/// How many groups match — `GET /admin/customer_groups/count`; `{"total": N}`,
/// narrowed by the listing's filters and not by its paging.
Future<ApiResponse> countCustomerGroups(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerGroupUrls.customerGroupsCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupCount.fromMap);

/// Create a group — `POST /admin/customer_groups`, answered `201`. The body is
/// `{"customer_group": {...}}` with `name` required, unique in any letter case.
Future<ApiResponse> createCustomerGroup(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerGroupUrls.customerGroups,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupRecord.fromMap);

/// Retrieve one group with `customer_count` and its `customers` —
/// `GET /admin/customer_groups/{customer_group_id}`; `field_metadata` adds the schema.
Future<ApiResponse> getCustomerGroup(
  WebCommanderClient client,
  Object customerGroupId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerGroupUrls.customerGroup,
        pathParams: {'customer_group_id': customerGroupId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupRecord.fromMap);

/// Change only the fields sent, nested ones included, in the `customer_group`
/// wrapper — `PATCH /admin/customer_groups/{customer_group_id}`; `PUT` is `405`.
Future<ApiResponse> patchCustomerGroup(
        WebCommanderClient client, Object customerGroupId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CustomerGroupUrls.customerGroup,
        pathParams: {'customer_group_id': customerGroupId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupRecord.fromMap);

/// Delete one group and its memberships —
/// `DELETE /admin/customer_groups/{customer_group_id}`; `204`, the members stay.
Future<ApiResponse> deleteCustomerGroup(
        WebCommanderClient client, Object customerGroupId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CustomerGroupUrls.customerGroup,
        pathParams: {'customer_group_id': customerGroupId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace the member list with `{"customers": [customer_id, ...]}`; `[]`
/// empties it. `PATCH /admin/customer_groups/{customer_group_id}/customers`
Future<ApiResponse> updateCustomerGroupCustomers(
        WebCommanderClient client, Object customerGroupId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CustomerGroupUrls.customerGroupCustomers,
        pathParams: {'customer_group_id': customerGroupId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupRecord.fromMap);

/// Read one member by its `customer_id`; a customer outside the group is `404`.
/// `GET /admin/customer_groups/{customer_group_id}/customers/{customer_id}`
Future<ApiResponse> getCustomerGroupCustomer(
        WebCommanderClient client, Object customerGroupId, Object customerId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CustomerGroupUrls.customerGroupCustomer,
        pathParams: {
          'customer_group_id': customerGroupId,
          'customer_id': customerId,
        },
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupMember.fromMap);

/// Add one customer to one group, keeping the other members —
/// `POST /admin/customer_groups/assign`; `201`, `added` `false` for a member.
Future<ApiResponse> assignCustomerGroup(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerGroupUrls.customerGroupsAssign,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerGroupAssignment.fromMap);

final _listCustomerGroups = listCustomerGroups;
final _countCustomerGroups = countCustomerGroups;
final _createCustomerGroup = createCustomerGroup;
final _getCustomerGroup = getCustomerGroup;
final _patchCustomerGroup = patchCustomerGroup;
final _deleteCustomerGroup = deleteCustomerGroup;
final _updateCustomerGroupCustomers = updateCustomerGroupCustomers;
final _getCustomerGroupCustomer = getCustomerGroupCustomer;
final _assignCustomerGroup = assignCustomerGroup;
