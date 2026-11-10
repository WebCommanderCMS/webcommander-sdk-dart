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

  /// Files a new record under this transaction number; it wins over a
  /// `transaction_no` in the body.
  static const String transactionNoHeader = 'X-Transaction-No';
}
