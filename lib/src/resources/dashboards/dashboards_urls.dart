/// Dashboard layout path templates; the client fills `{api_version}`.
class DashboardUrls {
  DashboardUrls._();

  /// The listing and the create.
  static const String dashboards = '/api/{api_version}/admin/dashboards';

  /// One layout, by its `id`.
  static const String dashboard =
      '/api/{api_version}/admin/dashboards/{dashboard_id}';
}
