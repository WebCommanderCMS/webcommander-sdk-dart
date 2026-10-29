import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'categories_dto.dart';
import 'categories_urls.dart';

/// Category endpoints, bound to one client.
class Categories {
  /// Bind the resource to a client; normally reached via `client.categories`.
  Categories(this._client);

  final WebCommanderClient _client;

  /// List the categories — `GET /admin/categories`.
  Future<ApiResponse> listCategories({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCategories(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Count the categories — `GET /admin/categories/count`.
  Future<ApiResponse> countCategories({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countCategories(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether a name is free — `GET /admin/categories/check-name`.
  Future<ApiResponse> checkCategoryName(String name,
          {bool? raiseOnError, String? responseFormat}) =>
      _checkCategoryName(_client, name,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a category — `POST /admin/categories`.
  Future<ApiResponse> createCategory(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createCategory(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one category — `GET /admin/categories/{category_id}`.
  Future<ApiResponse> getCategory(
    Object categoryId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCategory(_client, categoryId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Replace one category — `PUT /admin/categories/{category_id}`.
  Future<ApiResponse> updateCategory(Object categoryId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCategory(_client, categoryId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Merge fields into one category — `PATCH /admin/categories/{category_id}`.
  Future<ApiResponse> patchCategory(Object categoryId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCategory(_client, categoryId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move one category to the trash —
  /// `DELETE /admin/categories/{category_id}`.
  Future<ApiResponse> deleteCategory(Object categoryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCategory(_client, categoryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read one section —
  /// `GET /admin/categories/{category_id}/{section}`.
  Future<ApiResponse> getCategorySection(Object categoryId, String section,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCategorySection(_client, categoryId, section,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Merge fields into one section —
  /// `PATCH /admin/categories/{category_id}/{section}`.
  Future<ApiResponse> patchCategorySection(
          Object categoryId, String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCategorySection(_client, categoryId, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the categories, newest update first — `GET /admin/categories`; `limit`
/// caps at 20. `name`, `searchText` and `parent` filter, `sort` and `dir` order.
Future<ApiResponse> listCategories(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CategoryUrls.categories,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryListPage.fromMap);

/// Count the categories — `GET /admin/categories/count`; the listing's `name`,
/// `searchText` and `parent` narrow it, and trashed rows are not counted.
Future<ApiResponse> countCategories(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CategoryUrls.categoriesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryCount.fromMap);

/// Ask whether a name is free — `GET /admin/categories/check-name`; read
/// `available` off `.map`. Exact, case-insensitive, every level and the trash.
Future<ApiResponse> checkCategoryName(WebCommanderClient client, String name,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CategoryUrls.categoriesCheckName,
        queryParams: {'name': name},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Create a category — `POST /admin/categories`, `201`. The body is wrapped in
/// `category` and needs `general.name`; a top-level row's name is `409`.
/// [transactionNo] is sent as `X-Transaction-No` and files the category under
/// that number.
Future<ApiResponse> createCategory(WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CategoryUrls.categories,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {CategoryUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

/// Retrieve one category — `GET /admin/categories/{category_id}`; a trashed one
/// still reads `200` with `in_trash: true`. `field_metadata` adds the schema.
Future<ApiResponse> getCategory(
  WebCommanderClient client,
  Object categoryId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CategoryUrls.category,
        pathParams: {'category_id': categoryId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

/// Replace one category — `PUT /admin/categories/{category_id}`. Omitted fields
/// reset except `name`, `sku`, `url`, images and five `tax_shipping` fields.
Future<ApiResponse> updateCategory(
        WebCommanderClient client, Object categoryId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CategoryUrls.category,
        pathParams: {'category_id': categoryId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

/// Merge fields into one category — `PATCH /admin/categories/{category_id}`,
/// across as many sections as the body names; what it omits keeps its value.
Future<ApiResponse> patchCategory(
        WebCommanderClient client, Object categoryId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CategoryUrls.category,
        pathParams: {'category_id': categoryId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

/// Move one category to the trash — `DELETE /admin/categories/{category_id}`;
/// `204`. It leaves the listing and the count, and still reads `200`.
Future<ApiResponse> deleteCategory(WebCommanderClient client, Object categoryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CategoryUrls.category,
        pathParams: {'category_id': categoryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Read one section — `GET /admin/categories/{category_id}/{section}`; the
/// answer is `{"category": {<section>: {...}}}`. See `CategoryUrls.sections`.
Future<ApiResponse> getCategorySection(
        WebCommanderClient client, Object categoryId, String section,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CategoryUrls.categorySection,
        pathParams: {'category_id': categoryId, 'section': section},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

/// Merge into one section — `PATCH /admin/categories/{category_id}/{section}`;
/// the body is `{"category": {<section>: {...}}}`, any other section ignored.
Future<ApiResponse> patchCategorySection(WebCommanderClient client,
        Object categoryId, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CategoryUrls.categorySection,
        pathParams: {'category_id': categoryId, 'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Category.fromMap);

final _listCategories = listCategories;
final _countCategories = countCategories;
final _checkCategoryName = checkCategoryName;
final _createCategory = createCategory;
final _getCategory = getCategory;
final _updateCategory = updateCategory;
final _patchCategory = patchCategory;
final _deleteCategory = deleteCategory;
final _getCategorySection = getCategorySection;
final _patchCategorySection = patchCategorySection;
