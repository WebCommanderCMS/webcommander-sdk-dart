/// Shipping settings path templates; the client fills `{api_version}`.
class ShippingSettingsUrls {
  ShippingSettingsUrls._();

  static const String shippingSettings =
      '/api/{api_version}/admin/settings/shipping_settings';
}
