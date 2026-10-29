/// Product listing path templates; the client fills `{api_version}`.
class ProductListingUrls {
  ProductListingUrls._();

  static const String productListing =
      '/api/{api_version}/admin/settings/product_listing';
}
