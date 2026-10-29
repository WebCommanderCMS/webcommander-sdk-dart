/// Ecommerce settings path templates; the client fills `{api_version}`.
class EcommerceSettingsUrls {
  EcommerceSettingsUrls._();

  static const String ecommerceSettings =
      '/api/{api_version}/admin/settings/ecommerce_settings';

  static const String ecommerceSettingsSection =
      '/api/{api_version}/admin/settings/ecommerce_settings/{section}';
}
