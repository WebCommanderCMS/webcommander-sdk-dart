/// Dashboard banner path templates; the client fills `{api_version}`.
class DashboardBannerUrls {
  DashboardBannerUrls._();

  /// The listing and the create.
  static const String banners = '/api/{api_version}/admin/dashboard/banners';

  /// One banner, by its `key`.
  static const String banner =
      '/api/{api_version}/admin/dashboard/banners/{banner_key}';

  /// The Dashboard's feed: the active banners and the support card.
  static const String contentInfo =
      '/api/{api_version}/admin/dashboard/content_info';
}
