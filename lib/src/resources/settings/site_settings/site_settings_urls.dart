/// Site settings path templates; the client fills `{api_version}`.
class SiteSettingsUrls {
  SiteSettingsUrls._();

  static const String siteSettings =
      '/api/{api_version}/admin/settings/site_settings';

  static const String siteSettingsSection =
      '/api/{api_version}/admin/settings/site_settings/{section}';
}
