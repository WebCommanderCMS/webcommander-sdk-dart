import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'blog_categories_dto.dart';
import 'blog_categories_urls.dart';

/// Blog category endpoints, bound to one client.
class BlogCategories {
  /// Bind the resource to a client; normally reached via `client.blogCategories`.
  BlogCategories(this._client);

  final WebCommanderClient _client;

  /// List the categories, ordered by `name` — `GET /admin/blog_categories`.
  Future<ApiResponse> listBlogCategories({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listBlogCategories(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a category — `POST /admin/blog_categories`.
  Future<ApiResponse> createBlogCategory(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createBlogCategory(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one category —
  /// `GET /admin/blog_categories/{blog_category_id}`.
  Future<ApiResponse> getBlogCategory(Object blogCategoryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getBlogCategory(_client, blogCategoryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update a category —
  /// `PUT /admin/blog_categories/{blog_category_id}`.
  Future<ApiResponse> updateBlogCategory(Object blogCategoryId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateBlogCategory(_client, blogCategoryId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a category —
  /// `DELETE /admin/blog_categories/{blog_category_id}`.
  Future<ApiResponse> deleteBlogCategory(Object blogCategoryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteBlogCategory(_client, blogCategoryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the categories, ordered by `name` — `GET /admin/blog_categories`.
/// `limit` (capped at 20), `offset`, `page`, `sort`, `dir`, `field_metadata`.
Future<ApiResponse> listBlogCategories(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(BlogCategoryUrls.blogCategories,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCategoryPage.fromMap);

/// Create a category — `POST /admin/blog_categories`, `201`. Wrapped in
/// `blog_category`; a `url` another row holds is stored with `-1` appended.
Future<ApiResponse> createBlogCategory(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(BlogCategoryUrls.blogCategories,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCategory.fromMap);

/// Retrieve one category —
/// `GET /admin/blog_categories/{blog_category_id}`.
Future<ApiResponse> getBlogCategory(
        WebCommanderClient client, Object blogCategoryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(BlogCategoryUrls.blogCategory,
        pathParams: {'blog_category_id': blogCategoryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCategory.fromMap);

/// Update a category — `PUT /admin/blog_categories/{blog_category_id}`; an
/// omitted `description` is blanked, `url` and `image` kept.
Future<ApiResponse> updateBlogCategory(
        WebCommanderClient client, Object blogCategoryId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(BlogCategoryUrls.blogCategory,
        pathParams: {'blog_category_id': blogCategoryId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCategory.fromMap);

/// Delete a category — `DELETE /admin/blog_categories/{blog_category_id}`;
/// `204`, and the blogs linked to it are kept.
Future<ApiResponse> deleteBlogCategory(
        WebCommanderClient client, Object blogCategoryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(BlogCategoryUrls.blogCategory,
        pathParams: {'blog_category_id': blogCategoryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listBlogCategories = listBlogCategories;
final _createBlogCategory = createBlogCategory;
final _getBlogCategory = getBlogCategory;
final _updateBlogCategory = updateBlogCategory;
final _deleteBlogCategory = deleteBlogCategory;
