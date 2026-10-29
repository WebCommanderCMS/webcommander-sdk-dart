import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'blogs_dto.dart';
import 'blogs_urls.dart';

/// Blog and blog comment endpoints, bound to one client.
class Blogs {
  /// Bind the resource to a client; normally reached via `client.blogs`.
  Blogs(this._client);

  final WebCommanderClient _client;

  /// List the blogs, latest `date` first — `GET /admin/blogs`.
  Future<ApiResponse> listBlogs({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listBlogs(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// How many blogs are live — `GET /admin/blogs/count`.
  Future<ApiResponse> countBlogs({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countBlogs(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a blog — `POST /admin/blogs`.
  Future<ApiResponse> createBlog(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createBlog(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one blog — `GET /admin/blogs/{blog_id}`.
  Future<ApiResponse> getBlog(
    Object blogId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getBlog(_client, blogId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Replace one blog — `PUT /admin/blogs/{blog_id}`.
  Future<ApiResponse> updateBlog(Object blogId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateBlog(_client, blogId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH /admin/blogs/{blog_id}`.
  Future<ApiResponse> patchBlog(Object blogId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchBlog(_client, blogId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Move one blog to the trash — `DELETE /admin/blogs/{blog_id}`.
  Future<ApiResponse> deleteBlog(Object blogId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteBlog(_client, blogId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Every comment on one blog — `GET /admin/blogs/{blog_id}/comments`.
  Future<ApiResponse> listBlogComments(Object blogId,
          {bool? raiseOnError, String? responseFormat}) =>
      _listBlogComments(_client, blogId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add a comment — `POST /admin/blogs/{blog_id}/comments`.
  Future<ApiResponse> createBlogComment(Object blogId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createBlogComment(_client, blogId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one comment —
  /// `GET /admin/blogs/{blog_id}/comments/{blog_comment_id}`.
  Future<ApiResponse> getBlogComment(Object blogId, Object blogCommentId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getBlogComment(_client, blogId, blogCommentId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Approve one comment —
  /// `POST /admin/blogs/{blog_id}/comments/{blog_comment_id}/approve`.
  Future<ApiResponse> approveBlogComment(Object blogId, Object blogCommentId,
          {bool? raiseOnError, String? responseFormat}) =>
      _approveBlogComment(_client, blogId, blogCommentId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Mark one comment as spam —
  /// `POST /admin/blogs/{blog_id}/comments/{blog_comment_id}/mark-spam`.
  Future<ApiResponse> markBlogCommentSpam(Object blogId, Object blogCommentId,
          {bool? raiseOnError, String? responseFormat}) =>
      _markBlogCommentSpam(_client, blogId, blogCommentId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the blogs, latest `date` first — `GET /admin/blogs`. `limit` is capped
/// at 20, and an unknown name is `400`.
Future<ApiResponse> listBlogs(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(BlogUrls.blogs,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogPage.fromMap);

/// How many blogs are live — `GET /admin/blogs/count`; narrowed by the
/// listing's filters and not by its paging.
Future<ApiResponse> countBlogs(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(BlogUrls.blogsCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCount.fromMap);

/// Create a blog — `POST /admin/blogs`, answered `201`. `title` is required,
/// unique among live and trashed blogs alike.
Future<ApiResponse> createBlog(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(BlogUrls.blogs,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Blog.fromMap);

/// Retrieve one blog — `GET /admin/blogs/{blog_id}`; a trashed blog is `404`.
Future<ApiResponse> getBlog(
  WebCommanderClient client,
  Object blogId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(BlogUrls.blog,
        pathParams: {'blog_id': blogId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Blog.fromMap);

/// Replace one blog — `PUT /admin/blogs/{blog_id}`. `title` and `visibility`
/// are required; every other field left out is reset, except the image and `url`.
Future<ApiResponse> updateBlog(
        WebCommanderClient client, Object blogId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(BlogUrls.blog,
        pathParams: {'blog_id': blogId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Blog.fromMap);

/// Change only the fields sent — `PATCH /admin/blogs/{blog_id}`; the answer
/// carries `group_meta` beside the row.
Future<ApiResponse> patchBlog(
        WebCommanderClient client, Object blogId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(BlogUrls.blog,
        pathParams: {'blog_id': blogId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Blog.fromMap);

/// Move one blog to the trash — `DELETE /admin/blogs/{blog_id}`; `204`. Its
/// title stays taken, and its comments stay readable.
Future<ApiResponse> deleteBlog(WebCommanderClient client, Object blogId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(BlogUrls.blog,
        pathParams: {'blog_id': blogId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Every comment on one blog, oldest first and unpaged —
/// `GET /admin/blogs/{blog_id}/comments`.
Future<ApiResponse> listBlogComments(WebCommanderClient client, Object blogId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(BlogUrls.blogComments,
        pathParams: {'blog_id': blogId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCommentList.fromMap);

/// Add a comment, `pending` — `POST /admin/blogs/{blog_id}/comments`, answered
/// `201`. Without the `{"blog": {"comment": {...}}}` wrappers it is `404`.
Future<ApiResponse> createBlogComment(
        WebCommanderClient client, Object blogId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(BlogUrls.blogComments,
        pathParams: {'blog_id': blogId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCommentEnvelope.fromMap);

/// Retrieve one comment; the top-level `id` is the blog's —
/// `GET /admin/blogs/{blog_id}/comments/{blog_comment_id}`.
Future<ApiResponse> getBlogComment(
        WebCommanderClient client, Object blogId, Object blogCommentId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(BlogUrls.blogComment,
        pathParams: {'blog_id': blogId, 'blog_comment_id': blogCommentId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCommentEnvelope.fromMap);

/// Approve one comment; answers `201` and leaves `spam` as it was —
/// `POST /admin/blogs/{blog_id}/comments/{blog_comment_id}/approve`.
Future<ApiResponse> approveBlogComment(
        WebCommanderClient client, Object blogId, Object blogCommentId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(BlogUrls.blogCommentApprove,
        pathParams: {'blog_id': blogId, 'blog_comment_id': blogCommentId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCommentEnvelope.fromMap);

/// Mark one comment as spam, setting `status` and `spam`; answers `201` —
/// `POST /admin/blogs/{blog_id}/comments/{blog_comment_id}/mark-spam`.
Future<ApiResponse> markBlogCommentSpam(
        WebCommanderClient client, Object blogId, Object blogCommentId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(BlogUrls.blogCommentMarkSpam,
        pathParams: {'blog_id': blogId, 'blog_comment_id': blogCommentId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: BlogCommentEnvelope.fromMap);

final _listBlogs = listBlogs;
final _countBlogs = countBlogs;
final _createBlog = createBlog;
final _getBlog = getBlog;
final _updateBlog = updateBlog;
final _patchBlog = patchBlog;
final _deleteBlog = deleteBlog;
final _listBlogComments = listBlogComments;
final _createBlogComment = createBlogComment;
final _getBlogComment = getBlogComment;
final _approveBlogComment = approveBlogComment;
final _markBlogCommentSpam = markBlogCommentSpam;
