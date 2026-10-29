/// Custom tax profile path templates; the client fills `{api_version}`.
class TaxCustomProfileUrls {
  TaxCustomProfileUrls._();

  /// List and create custom tax profiles.
  static const String taxCustomProfiles =
      '/api/{api_version}/admin/tax/custom-profiles';

  /// One custom tax profile by id.
  static const String taxCustomProfile =
      '/api/{api_version}/admin/tax/custom-profiles/{custom_profile_id}';

  /// The page size when `limit` is not sent; a sent one is honoured up to 100.
  static const int pageSize = 20;

  /// Files a new custom profile under this transaction number.
  static const String transactionNoHeader = 'X-Transaction-No';
}
