/// Shipping rate path templates; the client fills `{api_version}`.
class ShippingRateUrls {
  ShippingRateUrls._();

  /// List and create.
  static const String shippingRates = '/api/{api_version}/admin/shipping_rates';

  /// How many rows the listing's filters match.
  static const String shippingRatesCount =
      '/api/{api_version}/admin/shipping_rates/count';

  /// One record by id.
  static const String shippingRate =
      '/api/{api_version}/admin/shipping_rates/{shipping_rate_id}';

  /// Files a new record under this transaction number; it wins over a
  /// `transaction_no` in the body.
  static const String transactionNoHeader = 'X-Transaction-No';
}
