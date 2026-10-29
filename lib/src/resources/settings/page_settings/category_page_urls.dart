/// Category page settings path templates; the client fills `{api_version}`.
class CategoryPageUrls {
  CategoryPageUrls._();

  static const String categoryPage =
      '/api/{api_version}/admin/settings/page_settings/category_page';

  static const String categoryPageSection =
      '/api/{api_version}/admin/settings/page_settings/category_page/{section}';
}
