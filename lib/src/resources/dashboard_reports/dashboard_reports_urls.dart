/// Dashboard report path templates; the client fills `{api_version}`.
class DashboardReportUrls {
  DashboardReportUrls._();

  /// The quick report.
  static const String quick =
      '/api/{api_version}/admin/dashboard/reports/quick';

  /// The sales report.
  static const String sales =
      '/api/{api_version}/admin/dashboard/reports/sales';

  /// The summary.
  static const String summary =
      '/api/{api_version}/admin/dashboard/reports/summary';
}
