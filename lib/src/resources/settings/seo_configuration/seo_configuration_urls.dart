/// SEO configuration settings path templates; the client fills `{api_version}`.
class SeoConfigurationUrls {
  SeoConfigurationUrls._();

  static const String seoConfiguration =
      '/api/{api_version}/admin/settings/seo_configuration';

  static const String seoConfigurationSection =
      '/api/{api_version}/admin/settings/seo_configuration/{section}';

  static const String seoConfigurationDocumentRoot =
      '/api/{api_version}/admin/settings/seo_configuration/document_root';

  static const String seoConfigurationDocumentRootFile =
      '/api/{api_version}/admin/settings/seo_configuration/document_root/{config_key}';

  static const String seoConfigurationRedirects =
      '/api/{api_version}/admin/settings/seo_configuration/redirects';

  static const String seoConfigurationRedirect =
      '/api/{api_version}/admin/settings/seo_configuration/redirects/{redirect_id}';
}
