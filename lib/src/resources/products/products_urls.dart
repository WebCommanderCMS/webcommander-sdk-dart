/// Product path templates; the client fills `{api_version}`.
class ProductUrls {
  ProductUrls._();

  /// List or create the products; `HEAD` here is `404`.
  static const String products = '/api/{api_version}/admin/products';

  /// One product by id.
  static const String product =
      '/api/{api_version}/admin/products/{product_id}';

  /// One product's reviews. `POST` only.
  static const String productReviews =
      '/api/{api_version}/admin/products/{product_id}/reviews';

  /// One product's stock at each location.
  static const String productStock =
      '/api/{api_version}/admin/products/{product_id}/stock';

  /// One location's assignment to the product. `DELETE` only.
  static const String productStockLocation =
      '/api/{api_version}/admin/products/{product_id}/stock/locations/{inventory_location_id}';

  /// The header that tags a create with a transaction number; it wins over a
  /// body `transaction_no` it disagrees with.
  static const String transactionNoHeader = 'X-Transaction-No';
}
