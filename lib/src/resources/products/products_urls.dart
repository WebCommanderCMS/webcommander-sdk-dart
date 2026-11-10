/// Product path templates; the client fills `{api_version}`.
class ProductUrls {
  ProductUrls._();

  /// List or create the products; `HEAD` here is `404`.
  static const String products = '/api/{api_version}/admin/products';

  /// The count of the products; `GET` only.
  static const String productsCount = '/api/{api_version}/admin/products/count';

  /// Whether a SKU is free; `GET` only.
  static const String productsCheckSku =
      '/api/{api_version}/admin/products/check-sku';

  /// A special selection of products; `GET` only.
  static const String productsSpecial =
      '/api/{api_version}/admin/products/special';

  /// Move several products to the trash. `POST` only.
  static const String productsBulkDelete =
      '/api/{api_version}/admin/products/bulk-delete';

  /// One product by id.
  static const String product =
      '/api/{api_version}/admin/products/{product_id}';

  /// One product's reviews: `GET` lists them, `POST` adds them.
  static const String productReviews =
      '/api/{api_version}/admin/products/{product_id}/reviews';

  /// One review of a product.
  static const String productReview =
      '/api/{api_version}/admin/products/{product_id}/reviews/{review_id}';

  /// Images stored on a product from a JSON body. `POST` only.
  static const String productImage =
      '/api/{api_version}/admin/products/{product_id}/image';

  /// One file stored on a product. `POST` only.
  static const String productMedia =
      '/api/{api_version}/admin/products/{product_id}/media';

  /// One image of a product. `DELETE` only.
  static const String productMediaImage =
      '/api/{api_version}/admin/products/{product_id}/media/images/{image_id}';

  /// A product's stock figure, set by a top-up. `POST` only.
  static const String productInventories =
      '/api/{api_version}/admin/products/{product_id}/inventories';

  /// One product's stock at each location.
  static const String productStock =
      '/api/{api_version}/admin/products/{product_id}/stock';

  /// One location's assignment to the product. `DELETE` only.
  static const String productStockLocation =
      '/api/{api_version}/admin/products/{product_id}/stock/locations/{inventory_location_id}';

  /// A product's stock history. `GET` only.
  static const String productStockAdjustments =
      '/api/{api_version}/admin/products/{product_id}/stock/adjustments';

  /// A product's SEO settings. `GET` only.
  static const String productSeo =
      '/api/{api_version}/admin/products/{product_id}/seo';

  /// The order of a product's images. `PUT` only.
  static const String productMediaOrder =
      '/api/{api_version}/admin/products/{product_id}/media/order';

  /// The header that tags a create with a transaction number; it wins over a
  /// body `transaction_no` it disagrees with.
  static const String transactionNoHeader = 'X-Transaction-No';
}
