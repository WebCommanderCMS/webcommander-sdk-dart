/// Price display settings path templates; the client fills `{api_version}`.
class PriceDisplaySettingsUrls {
  PriceDisplaySettingsUrls._();

  static const String priceDisplaySettings =
      '/api/{api_version}/admin/settings/price_display_settings';

  static const String priceDisplaySettingsSection =
      '/api/{api_version}/admin/settings/price_display_settings/{section}';
}
