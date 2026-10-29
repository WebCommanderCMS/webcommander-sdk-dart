/// Tax profile path templates; the client fills `{api_version}`.
class TaxProfileUrls {
  TaxProfileUrls._();

  /// List and create tax profiles.
  static const String taxProfiles = '/api/{api_version}/admin/tax_profiles';

  /// One tax profile by id.
  static const String taxProfile =
      '/api/{api_version}/admin/tax_profiles/{tax_profile_id}';

  /// The page size when `limit` is not sent, and the ceiling on one that is.
  static const int pageSize = 20;
}
