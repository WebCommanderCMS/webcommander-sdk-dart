/// Dashboard KPI path templates; the client fills `{api_version}`.
class DashboardKpiUrls {
  DashboardKpiUrls._();

  /// Every metric a tile can show.
  static const String kpiOptions =
      '/api/{api_version}/admin/dashboard/kpi_options';

  /// The tiles in use; read and replaced here.
  static const String kpiSelection =
      '/api/{api_version}/admin/dashboard/kpi_selection';
}
