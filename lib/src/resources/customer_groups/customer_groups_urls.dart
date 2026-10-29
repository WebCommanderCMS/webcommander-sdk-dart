/// Customer group path templates; the client fills `{api_version}`.
class CustomerGroupUrls {
  CustomerGroupUrls._();

  /// List and create.
  static const String customerGroups =
      '/api/{api_version}/admin/customer_groups';

  /// How many groups the listing's filters match.
  static const String customerGroupsCount =
      '/api/{api_version}/admin/customer_groups/count';

  /// Add one customer to one group. `POST` only.
  static const String customerGroupsAssign =
      '/api/{api_version}/admin/customer_groups/assign';

  /// One group by id.
  static const String customerGroup =
      '/api/{api_version}/admin/customer_groups/{customer_group_id}';

  /// A group's member list. `PATCH` only; a `GET` here is `405`.
  static const String customerGroupCustomers =
      '/api/{api_version}/admin/customer_groups/{customer_group_id}/customers';

  /// One member, by its `customer_id`.
  static const String customerGroupCustomer =
      '/api/{api_version}/admin/customer_groups/{customer_group_id}/customers/{customer_id}';
}
