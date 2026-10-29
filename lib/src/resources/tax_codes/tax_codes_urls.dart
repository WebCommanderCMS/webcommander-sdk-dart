/// Tax code path templates; the client fills `{api_version}`.
class TaxCodeUrls {
  TaxCodeUrls._();

  /// List and create tax codes.
  static const String taxCodes = '/api/{api_version}/admin/tax_codes';

  /// One tax code by id.
  static const String taxCode =
      '/api/{api_version}/admin/tax_codes/{tax_code_id}';

  /// The page size when `limit` is not sent; a larger `limit` is held to 100.
  static const int pageSize = 20;
}
