/// Tax rule path templates; the client fills `{api_version}`.
class TaxRuleUrls {
  TaxRuleUrls._();

  /// List and create tax rules.
  static const String taxRules = '/api/{api_version}/admin/tax_rules';

  /// One tax rule by id.
  static const String taxRule =
      '/api/{api_version}/admin/tax_rules/{tax_rule_id}';

  /// The page size when `limit` is not sent; a larger `limit` is held to 100.
  static const int pageSize = 20;
}
