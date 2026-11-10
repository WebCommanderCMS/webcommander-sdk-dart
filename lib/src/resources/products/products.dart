import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import '../../errors.dart';
import 'products_dto.dart';
import 'products_urls.dart';

/// Product endpoints, bound to one client.
class Products {
  /// Bind the resource to a client; normally reached via `client.products`.
  Products(this._client);

  final WebCommanderClient _client;

  /// List the products — `GET /admin/products`.
  Future<ApiResponse> listProducts({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listProducts(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a product — `POST /admin/products`.
  Future<ApiResponse> createProduct(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createProduct(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one product — `GET /admin/products/{product_id}`.
  Future<ApiResponse> getProduct(
    Object productId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getProduct(_client, productId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Update one product — `PUT /admin/products/{product_id}`.
  Future<ApiResponse> updateProduct(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateProduct(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Merge into one product — `PATCH /admin/products/{product_id}`.
  Future<ApiResponse> patchProduct(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProduct(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move a product to the trash — `DELETE /admin/products/{product_id}`.
  Future<ApiResponse> deleteProduct(Object productId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteProduct(_client, productId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add reviews to a product —
  /// `POST /admin/products/{product_id}/reviews`.
  Future<ApiResponse> importProductReviews(Object productId, Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _importProductReviews(_client, productId, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// One product's stock at each location —
  /// `GET /admin/products/{product_id}/stock`.
  Future<ApiResponse> getProductStock(Object productId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getProductStock(_client, productId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Set the product's stock — `PUT /admin/products/{product_id}/stock`.
  Future<ApiResponse> updateProductStock(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateProductStock(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Unassign one location from the product —
  /// `DELETE /admin/products/{product_id}/stock/locations/{inventory_location_id}`.
  Future<ApiResponse> deleteProductStockLocation(
          Object productId, Object inventoryLocationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteProductStockLocation(_client, productId, inventoryLocationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Count the products — `GET /admin/products/count`.
  Future<ApiResponse> countProducts(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _countProducts(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether a SKU is free — `GET /admin/products/check-sku`.
  Future<ApiResponse> checkProductSku(String sku,
          {Object? excludeProductId,
          bool? raiseOnError,
          String? responseFormat}) =>
      _checkProductSku(_client, sku,
          excludeProductId: excludeProductId,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// List a special selection of products —
  /// `GET /admin/products/special`.
  Future<ApiResponse> listSpecialProducts(Map<String, Object?> queryParams,
          {bool? raiseOnError, String? responseFormat}) =>
      _listSpecialProducts(_client, queryParams,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move several products to the trash —
  /// `POST /admin/products/bulk-delete`.
  Future<ApiResponse> bulkDeleteProducts(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _bulkDeleteProducts(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List a product's reviews —
  /// `GET /admin/products/{product_id}/reviews`.
  Future<ApiResponse> listProductReviews(Object productId,
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _listProductReviews(_client, productId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Read one review —
  /// `GET /admin/products/{product_id}/reviews/{review_id}`.
  Future<ApiResponse> getProductReview(Object productId, Object reviewId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getProductReview(_client, productId, reviewId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change one review —
  /// `PATCH /admin/products/{product_id}/reviews/{review_id}`.
  Future<ApiResponse> patchProductReview(
          Object productId, Object reviewId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductReview(_client, productId, reviewId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one review —
  /// `DELETE /admin/products/{product_id}/reviews/{review_id}`.
  Future<ApiResponse> deleteProductReview(Object productId, Object reviewId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteProductReview(_client, productId, reviewId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Set a product's stock figure —
  /// `POST /admin/products/{product_id}/inventories`.
  Future<ApiResponse> createProductInventory(Object productId, Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createProductInventory(_client, productId, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Store images on a product — `POST /admin/products/{product_id}/image`.
  Future<ApiResponse> createProductImage(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createProductImage(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Store one file on a product — `POST /admin/products/{product_id}/media`,
  /// answered `201` with a `Location` header and the file just stored as one
  /// flat row, not under `product`: `id`, `filename`, `position`, `primary`,
  /// `alt_text`, `url` and `thumbnail_url`. A bare JSON body of `type`,
  /// `filename` and `content` (base64 or a `data:` URI). Only `type` `images` is
  /// accepted; `videos` and `specification_file` are `400 not_supported`.
  /// `position` (1-based) is accepted.
  Future<ApiResponse> createProductMedia(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createProductMedia(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one image from a product —
  /// `DELETE /admin/products/{product_id}/media/images/{image_id}`.
  Future<ApiResponse> deleteProductMediaImage(Object productId, Object imageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteProductMediaImage(_client, productId, imageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Set the order of a product's images —
  /// `PUT /admin/products/{product_id}/media/order`.
  Future<ApiResponse> updateProductMediaOrder(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateProductMediaOrder(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move one image to a position —
  /// `PATCH /admin/products/{product_id}/media/images/{image_id}`.
  Future<ApiResponse> patchProductMediaImage(
          Object productId, Object imageId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductMediaImage(_client, productId, imageId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read a product's SEO settings —
  /// `GET /admin/products/{product_id}/seo`.
  Future<ApiResponse> getProductSeo(Object productId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getProductSeo(_client, productId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change a product's stock — `PATCH /admin/products/{product_id}/stock`.
  Future<ApiResponse> patchProductStock(Object productId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductStock(_client, productId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List a product's stock history —
  /// `GET /admin/products/{product_id}/stock/adjustments`.
  Future<ApiResponse> listProductStockAdjustments(Object productId,
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _listProductStockAdjustments(_client, productId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// List the products, the most recently updated first —
/// `GET /admin/products`. Each row is the full record [getProduct] answers, and
/// a trashed product is not listed. `limit` is 1 to 100 (default 20, above 100
/// is `400`), with `offset` or a 1-based `page`. `search_text` matches `name`
/// or `sku`; `name`, `sku`, `ids` (repeat the name for more; a comma list is
/// `500`), `parent` (a category id), `product_type`, `stock` (`in`, `out` or
/// `low`), `is_available`, `is_inventory_enabled`, `created_by`, `price_from`,
/// `price_to`, `created_from`, `created_to`, `updated_from` and `updated_to`
/// narrow it. `sort` takes `name`, `isAvailable`, `sku`, `parent`, `basePrice`,
/// `isInventoryEnabled`, `createdBy`, `created`, `updated` or `id`, with `dir`;
/// `field_metadata` adds a schema. Any other name is `400`.
Future<ApiResponse> listProducts(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductUrls.products,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductListPage.fromMap);

/// Create a product — `POST /admin/products`, answered `201`. A bare record:
/// `name` and `base_price` are required, and a `sku` must be free; the store
/// makes one when it is left out. [transactionNo] is sent as
/// `X-Transaction-No`.
Future<ApiResponse> createProduct(WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.products,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ProductUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Product.fromMap);

/// Retrieve one product — `GET /admin/products/{product_id}`. `field_metadata`
/// `true` adds a field schema beside `product`; any other name is `400`.
Future<ApiResponse> getProduct(
  WebCommanderClient client,
  Object productId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductUrls.product,
        pathParams: {'product_id': productId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Product.fromMap);

/// Update one product — `PUT /admin/products/{product_id}`. A bare record merged
/// at every level; it must carry `name`, `sku`, `base_price`, `product_type`,
/// `available`, `is_on_sale`, `available_on_date_range`,
/// `available_on_weekdays`, `available_for` and `selected_customers` (`400
/// required` otherwise), and fields left out keep their values.
/// `{"product": {...}}` is `400`.
Future<ApiResponse> updateProduct(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ProductUrls.product,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Product.fromMap);

/// Merge into one product — `PATCH /admin/products/{product_id}`, the same
/// bare record the `PUT` takes; a product in the trash is `409`.
Future<ApiResponse> patchProduct(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductUrls.product,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Product.fromMap);

/// Move a product to the trash — `DELETE /admin/products/{product_id}`; `204`.
/// It still reads back, `status` `trashed`, and a second delete is `404`.
Future<ApiResponse> deleteProduct(WebCommanderClient client, Object productId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ProductUrls.product,
        pathParams: {'product_id': productId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Add reviews to a product; `201` with every review it holds. The body is
/// `{"product": {"reviews": [...]}}`; [transactionNo] is sent as
/// `X-Transaction-No`. `POST /admin/products/{product_id}/reviews`
Future<ApiResponse> importProductReviews(
        WebCommanderClient client, Object productId, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.productReviews,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ProductUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductReviews.fromMap);

/// One product's stock at each location —
/// `GET /admin/products/{product_id}/stock`.
Future<ApiResponse> getProductStock(WebCommanderClient client, Object productId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ProductUrls.productStock,
        pathParams: {'product_id': productId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductStock.fromMap);

/// Set the product's stock — `PUT /admin/products/{product_id}/stock`.
/// `locations` replaces the whole set: a location left out is unassigned, so
/// send every row that is to stay.
Future<ApiResponse> updateProductStock(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ProductUrls.productStock,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductStock.fromMap);

/// Unassign one location from the product; `204`. The location must hold `0`
/// units and not be the product's default, or it is `409`.
/// `DELETE /admin/products/{product_id}/stock/locations/{inventory_location_id}`
Future<ApiResponse> deleteProductStockLocation(
        WebCommanderClient client, Object productId, Object inventoryLocationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ProductUrls.productStockLocation,
        pathParams: {
          'product_id': productId,
          'inventory_location_id': inventoryLocationId,
        },
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Count the products — `GET /admin/products/count`; `{"total": n, "count": n}`.
/// It takes the list's filters (`search_text`, `name`, `sku`, `ids`, `parent`,
/// `product_type`, `stock`, `is_available`, `is_inventory_enabled`,
/// `created_by`, `price_from`, `price_to` and the four date bounds) and refuses
/// its paging and sorting, and `status`, as `400 unknown_parameter`. A trashed
/// product is not counted.
Future<ApiResponse> countProducts(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductUrls.productsCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductCount.fromMap);

/// Ask whether a SKU is free — `GET /admin/products/check-sku`. The match
/// ignores case and sees a SKU held by a trashed product or by a variant;
/// [excludeProductId] is the `id` of a product that may hold it, as when that
/// product is being edited. Any other query name, and `SKU` in capitals, is
/// `400 unknown_parameter`.
Future<ApiResponse> checkProductSku(WebCommanderClient client, String sku,
    {Object? excludeProductId, bool? raiseOnError, String? responseFormat}) {
  if (sku.isEmpty) {
    throw SdkUsageError('sku is required');
  }
  return client.sendGetRequest(ProductUrls.productsCheckSku,
      queryParams: {'sku': sku, 'exclude_product_id': excludeProductId},
      raiseOnError: raiseOnError,
      responseFormat: responseFormat,
      dtoDecoder: ProductSkuCheck.fromMap);
}

/// List a special selection of products — `GET /admin/products/special`.
/// `type` is required: `onSale`, `featured`, `new`, `topSelling`, `lastBought`
/// or `lastViewed`. `max` (1 to 100, default 10) and `offset` page it. The last
/// two are per customer and need `customerId` (the `customer_id` or
/// `internal_id` of a customer) or `customer_email`; `customer_id` is not read,
/// and an unknown customer is `400 unknown_reference`. A name it does not know
/// is ignored.
Future<ApiResponse> listSpecialProducts(
        WebCommanderClient client, Map<String, Object?> queryParams,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ProductUrls.productsSpecial,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductSpecialPage.fromMap);

/// Move several products to the trash — `POST /admin/products/bulk-delete`,
/// answered `200` even when an id failed. The body is `{"ids": [...]}` (the
/// collection sends `product_ids`, which the store answers `400 required` for
/// `ids`); an empty list is `400`. Each id that is not a product is counted in
/// `failed` and listed in `errors`.
Future<ApiResponse> bulkDeleteProducts(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.productsBulkDelete,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductsBulkDeleteResult.fromMap);

/// List a product's reviews — `GET /admin/products/{product_id}/reviews`;
/// `{"reviews": [...]}` with no paging block. `status`, `limit` and `offset`
/// are in the collection and this store ignores them, as it does any other
/// name.
Future<ApiResponse> listProductReviews(
  WebCommanderClient client,
  Object productId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductUrls.productReviews,
        pathParams: {'product_id': productId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductReviewList.fromMap);

/// Read one review under `review` —
/// `GET /admin/products/{product_id}/reviews/{review_id}`. `review_id` is a
/// review's `id`; an unknown one is `404`.
Future<ApiResponse> getProductReview(
        WebCommanderClient client, Object productId, Object reviewId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ProductUrls.productReview,
        pathParams: {'product_id': productId, 'review_id': reviewId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductReview.fromMap);

/// Change one review —
/// `PATCH /admin/products/{product_id}/reviews/{review_id}`, a bare body
/// answered `200` with the review under `review`. `status` is `pending` (what
/// an imported review without one reads) or `approved`; `rejected`, which the
/// collection uses, is `400 invalid_enum`. `rating` and `comment` change too.
Future<ApiResponse> patchProductReview(WebCommanderClient client,
        Object productId, Object reviewId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductUrls.productReview,
        pathParams: {'product_id': productId, 'review_id': reviewId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductReview.fromMap);

/// Delete one review for good; `204`, and a second delete is `404`.
/// `DELETE /admin/products/{product_id}/reviews/{review_id}`
Future<ApiResponse> deleteProductReview(
        WebCommanderClient client, Object productId, Object reviewId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ProductUrls.productReview,
        pathParams: {'product_id': productId, 'review_id': reviewId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Set a product's stock figure —
/// `POST /admin/products/{product_id}/inventories`, answered `201`. The body is
/// `{"product": {"product_pricing_and_stock": {"track_inventory": true,
/// "available_stock": n}}}`; `low_level_stock` sets the low level. It records a
/// history row and a variant keeps its own figure. [transactionNo] is sent as
/// `X-Transaction-No` and stored as the product's `transaction_no` when it has
/// none; the answer echoes the value from before the write.
Future<ApiResponse> createProductInventory(
        WebCommanderClient client, Object productId, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.productInventories,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ProductUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductInventoryResult.fromMap);

/// Store images on a product — `POST /admin/products/{product_id}/image`,
/// answered `201` with the files just stored. The body is JSON,
/// `{"product": {"image_and_video": {"images": [{"filename": ..., "base64":
/// ...}]}}}`; a multipart body is `415`.
Future<ApiResponse> createProductImage(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.productImage,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductMediaUploaded.fromMap);

/// Store one file on a product — `POST /admin/products/{product_id}/media`,
/// answered `201` with the file just stored as a flat record (`id`, `filename`,
/// `position`, `primary`, `alt_text`, `url`, `thumbnail_url`). A bare JSON body of `type`,
/// `filename` and `content` (base64 or a `data:` URI). Only `type` `images` is
/// accepted; `videos` and `specification_file` are `400 not_supported`, and
/// `position` is `400 unknown_field`.
Future<ApiResponse> createProductMedia(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ProductUrls.productMedia,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductMediaBlockImage.fromMap);

/// Delete one image from a product; `204`, and a second delete is `404`.
/// `image_id` is an image's `id` on the product.
/// `DELETE /admin/products/{product_id}/media/images/{image_id}`
Future<ApiResponse> deleteProductMediaImage(
        WebCommanderClient client, Object productId, Object imageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ProductUrls.productMediaImage,
        pathParams: {'product_id': productId, 'image_id': imageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Set the order of a product's images; the first becomes `primary`. A bare
/// `{"type": "images", "ids": [...]}` naming every image once, answered with
/// `images` in the new order.
/// `PUT /admin/products/{product_id}/media/order`
Future<ApiResponse> updateProductMediaOrder(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ProductUrls.productMediaOrder,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductMediaOrder.fromMap);

/// Move one image to a 1-based `position`; a bare `{"position": n}` is the only
/// body, and the image is answered as one flat row. `image_id` is an image's
/// `id` on the product.
/// `PATCH /admin/products/{product_id}/media/images/{image_id}`
Future<ApiResponse> patchProductMediaImage(WebCommanderClient client,
        Object productId, Object imageId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductUrls.productMediaImage,
        pathParams: {'product_id': productId, 'image_id': imageId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductMediaBlockImage.fromMap);

/// A product's SEO, analytics, custom code, social and AI visibility settings
/// under `seo`. `GET /admin/products/{product_id}/seo`
Future<ApiResponse> getProductSeo(WebCommanderClient client, Object productId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ProductUrls.productSeo,
        pathParams: {'product_id': productId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductSeo.fromMap);

/// Change a product's stock; a bare body of `tracking`, `locations`, `note` and
/// `transaction_no`, at least one of them. Answered with the `stock` now and
/// the `adjustment` it recorded, `null` when the figure did not change.
/// `PATCH /admin/products/{product_id}/stock`
Future<ApiResponse> patchProductStock(
        WebCommanderClient client, Object productId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductUrls.productStock,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductStockPatchResult.fromMap);

/// A product's stock history, newest first, paged by `limit` and `offset`.
/// `GET /admin/products/{product_id}/stock/adjustments`
Future<ApiResponse> listProductStockAdjustments(
  WebCommanderClient client,
  Object productId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductUrls.productStockAdjustments,
        pathParams: {'product_id': productId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductStockAdjustmentPage.fromMap);

final _updateProductMediaOrder = updateProductMediaOrder;
final _patchProductMediaImage = patchProductMediaImage;
final _getProductSeo = getProductSeo;
final _patchProductStock = patchProductStock;
final _listProductStockAdjustments = listProductStockAdjustments;
final _countProducts = countProducts;
final _checkProductSku = checkProductSku;
final _listSpecialProducts = listSpecialProducts;
final _bulkDeleteProducts = bulkDeleteProducts;
final _listProductReviews = listProductReviews;
final _getProductReview = getProductReview;
final _patchProductReview = patchProductReview;
final _deleteProductReview = deleteProductReview;
final _createProductInventory = createProductInventory;
final _createProductImage = createProductImage;
final _createProductMedia = createProductMedia;
final _deleteProductMediaImage = deleteProductMediaImage;

final _listProducts = listProducts;
final _createProduct = createProduct;
final _getProduct = getProduct;
final _updateProduct = updateProduct;
final _patchProduct = patchProduct;
final _deleteProduct = deleteProduct;
final _importProductReviews = importProductReviews;
final _getProductStock = getProductStock;
final _updateProductStock = updateProductStock;
final _deleteProductStockLocation = deleteProductStockLocation;
