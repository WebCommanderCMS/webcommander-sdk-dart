/// Shipping rule path templates; the client fills `{api_version}`.
class ShippingRuleUrls {
  ShippingRuleUrls._();

  /// List and create.
  static const String shippingRules = '/api/{api_version}/admin/shipping_rules';

  /// How many rows the listing's filters match.
  static const String shippingRulesCount =
      '/api/{api_version}/admin/shipping_rules/count';

  /// One record by id.
  static const String shippingRule =
      '/api/{api_version}/admin/shipping_rules/{shipping_rule_id}';

  /// Files a new record under this transaction number; a
  /// differing `transaction_no` beside the wrapper is `400 header_body_mismatch`;
  /// one inside is not compared.
  static const String transactionNoHeader = 'X-Transaction-No';
}
