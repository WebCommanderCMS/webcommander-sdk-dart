/// Blog and blog comment path templates; the client fills `{api_version}`.
class BlogUrls {
  BlogUrls._();

  /// List and create.
  static const String blogs = '/api/{api_version}/admin/blogs';

  /// How many live blogs the listing's filters match.
  static const String blogsCount = '/api/{api_version}/admin/blogs/count';

  /// One blog by id.
  static const String blog = '/api/{api_version}/admin/blogs/{blog_id}';

  /// A blog's comments, and where a comment is added.
  static const String blogComments =
      '/api/{api_version}/admin/blogs/{blog_id}/comments';

  /// One comment; `GET` only.
  static const String blogComment =
      '/api/{api_version}/admin/blogs/{blog_id}/comments/{blog_comment_id}';

  /// Approve one comment. `POST` only, and it takes no body.
  static const String blogCommentApprove =
      '/api/{api_version}/admin/blogs/{blog_id}/comments/{blog_comment_id}/approve';

  /// Mark one comment as spam. `POST` only, and it takes no body.
  static const String blogCommentMarkSpam =
      '/api/{api_version}/admin/blogs/{blog_id}/comments/{blog_comment_id}/mark-spam';
}
