import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
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
