/// Search settings path templates; the client fills `{api_version}`.
class SearchSettingsUrls {
  SearchSettingsUrls._();

  static const String searchSettings =
      '/api/{api_version}/admin/settings/search_settings';

  static const String searchSettingsSection =
      '/api/{api_version}/admin/settings/search_settings/{section}';

  /// The read-only sub-resource beside the sections.
  static const String searchSettingsReindexStatus =
      '/api/{api_version}/admin/settings/search_settings/reindex_status';
}
