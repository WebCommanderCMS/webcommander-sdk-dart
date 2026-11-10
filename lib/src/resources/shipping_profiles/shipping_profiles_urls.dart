/// Shipping profile path templates; the client fills `{api_version}`.
class ShippingProfileUrls {
  ShippingProfileUrls._();

  /// List and create.
  static const String shippingProfiles =
      '/api/{api_version}/admin/shipping_profiles';

  /// How many rows the listing's filters match.
  static const String shippingProfilesCount =
      '/api/{api_version}/admin/shipping_profiles/count';

  /// Create a profile with its rules and their rates in one call. `POST` only.
  static const String shippingProfilesWizard =
      '/api/{api_version}/admin/shipping_profiles/wizard';

  /// One record by id.
  static const String shippingProfile =
      '/api/{api_version}/admin/shipping_profiles/{shipping_profile_id}';

  /// Files a new record under this transaction number; it wins over a
  /// `transaction_no` in the body.
  static const String transactionNoHeader = 'X-Transaction-No';
}
