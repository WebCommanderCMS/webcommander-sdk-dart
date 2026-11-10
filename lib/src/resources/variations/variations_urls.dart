/// Variation type and product variant path templates; the client fills
/// `{api_version}`.
class VariationUrls {
  VariationUrls._();

  /// List and create the store's variation types.
  static const String variations = '/api/{api_version}/admin/variations';

  /// One variation type by id.
  static const String variation =
      '/api/{api_version}/admin/variations/{variation_id}';

  /// One option of a variation type. `DELETE` only.
  static const String variationOption =
      '/api/{api_version}/admin/variations/{variation_id}/options/{variation_option_id}';

  /// One product's variants: `GET` reads them, `POST` imports them, `DELETE` removes them all; no `HEAD`.
  static const String productVariations =
      '/api/{api_version}/admin/products/{product_id}/variations';

  /// One variant of a product: `GET` reads it, `PATCH` changes it, `DELETE` removes it.
  static const String productVariation =
      '/api/{api_version}/admin/products/{product_id}/variations/{variation_id}';

  /// Several variants of one product written at once. `PATCH` only.
  static const String productVariationsBulk =
      '/api/{api_version}/admin/products/{product_id}/variations/bulk';

  /// The header that tags an import with a transaction number; it wins over a
  /// body `transaction_no` it disagrees with.
  static const String transactionNoHeader = 'X-Transaction-No';
}
