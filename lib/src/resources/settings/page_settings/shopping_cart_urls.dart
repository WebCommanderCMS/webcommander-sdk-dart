/// Shopping cart settings path templates; the client fills `{api_version}`.
class ShoppingCartUrls {
  ShoppingCartUrls._();

  static const String shoppingCart =
      '/api/{api_version}/admin/settings/page_settings/shopping_cart';

  static const String shoppingCartSection =
      '/api/{api_version}/admin/settings/page_settings/shopping_cart/{section}';
}
