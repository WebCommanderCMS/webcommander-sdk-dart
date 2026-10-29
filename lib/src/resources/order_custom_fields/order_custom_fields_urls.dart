/// Order custom field path templates; the client fills `{api_version}`.
class OrderCustomFieldUrls {
  OrderCustomFieldUrls._();

  /// The listing. `POST` here is `405`: no field is created through this API.
  static const String orderCustomFields =
      '/api/{api_version}/admin/order_custom_fields';

  static const String orderCustomFieldsCount =
      '/api/{api_version}/admin/order_custom_fields/count';

  /// One field by id. `PUT`, `PATCH` and `DELETE` here are `405`.
  static const String orderCustomField =
      '/api/{api_version}/admin/order_custom_fields/{order_custom_field_id}';

  /// The timeslot check on one field. `POST` only, and it stores nothing.
  static const String orderCustomFieldValidateTimeslot =
      '/api/{api_version}/admin/order_custom_fields/{order_custom_field_id}/validate_timeslot';
}
