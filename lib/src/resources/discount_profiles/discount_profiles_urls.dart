/// Discount profile path templates; the client fills `{api_version}`.
class DiscountProfileUrls {
  DiscountProfileUrls._();

  /// List and create.
  static const String discountProfiles =
      '/api/{api_version}/admin/discount_profiles';

  /// One profile by id. `PATCH` here is `405`.
  static const String discountProfile =
      '/api/{api_version}/admin/discount_profiles/{discount_profile_id}';

  /// Generate coupon codes on one profile. `POST` only.
  static const String discountProfileCreateCoupons =
      '/api/{api_version}/admin/discount_profiles/{discount_profile_id}/create-coupons';

  /// Give one generated code to a customer. `POST` only, and no listing beside it.
  static const String discountCouponsAssignCustomer =
      '/api/{api_version}/admin/discount_coupons/assign-customer';

  /// The names the listing reads; any other name is ignored rather than refused.
  static const List<String> queryParams = <String>[
    'limit',
    'offset',
    'page',
    'sort',
    'dir',
    'type',
    'name',
    'field_metadata',
  ];
}
