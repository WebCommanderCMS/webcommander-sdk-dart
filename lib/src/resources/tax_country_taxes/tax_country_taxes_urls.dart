/// Country tax path templates; the client fills `{api_version}`.
class TaxCountryTaxUrls {
  TaxCountryTaxUrls._();

  /// List and create country taxes.
  static const String taxCountryTaxes =
      '/api/{api_version}/admin/tax/country-taxes';

  /// One country tax by id.
  static const String taxCountryTax =
      '/api/{api_version}/admin/tax/country-taxes/{country_tax_id}';

  /// The page size when `limit` is not sent; a sent one is honoured up to 100.
  static const int pageSize = 20;

  /// Files a new country tax under this transaction number.
  static const String transactionNoHeader = 'X-Transaction-No';
}
