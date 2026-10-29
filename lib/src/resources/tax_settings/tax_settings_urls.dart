/// Tax settings path template; the client fills `{api_version}`.
class TaxSettingsUrls {
  TaxSettingsUrls._();

  /// The settings facade — read and write.
  static const String taxSettings = '/api/{api_version}/admin/tax/settings';
}
