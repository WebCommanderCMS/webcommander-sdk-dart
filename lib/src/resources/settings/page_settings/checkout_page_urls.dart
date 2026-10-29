/// Checkout page settings path templates; the client fills `{api_version}`.
class CheckoutPageUrls {
  CheckoutPageUrls._();

  static const String checkoutPage =
      '/api/{api_version}/admin/settings/page_settings/checkout_page';

  static const String checkoutPageSection =
      '/api/{api_version}/admin/settings/page_settings/checkout_page/{section}';
}
