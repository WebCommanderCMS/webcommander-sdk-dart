/// Product page settings path templates; the client fills `{api_version}`.
class ProductPageUrls {
  ProductPageUrls._();

  static const String productPage =
      '/api/{api_version}/admin/settings/page_settings/product_page';

  static const String productPageSection =
      '/api/{api_version}/admin/settings/page_settings/product_page/{section}';
}
