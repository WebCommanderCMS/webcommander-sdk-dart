/// Blog category path templates; the client fills `{api_version}`.
class BlogCategoryUrls {
  BlogCategoryUrls._();

  /// List and create.
  static const String blogCategories =
      '/api/{api_version}/admin/blog_categories';

  /// One category by id.
  static const String blogCategory =
      '/api/{api_version}/admin/blog_categories/{blog_category_id}';
}
