import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'dashboard_reports_dto.dart';
import 'dashboard_reports_urls.dart';

/// Dashboard report endpoints, bound to one client. Every report takes the same
/// period query: `duration` (`today`, `yesterday`, `last_24_hours`,
/// `last_7_days`, `last_30_days`, `this_month`, `last_month`, `last_3_months`,
/// `last_6_months`, `last_12_months`, `last_24_months`, `last_36_months`,
/// `last_48_months`, `last_60_months` or `custom`; `last_30_days` when left out)
/// or `start_date` with `end_date` (`YYYY-MM-DD`, sent together, not reversed and
/// not in the future). A bad value, a repeated `duration` and a lone date are
/// `400` with every bad field listed; a name the report does not know is ignored.
class DashboardReports {
  /// Bind the resource to a client; normally reached via `client.dashboardReports`.
  DashboardReports(this._client);

  final WebCommanderClient _client;

  /// Read the quick report — `GET /admin/dashboard/reports/quick`.
  Future<ApiResponse> getDashboardReportQuick(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _getDashboardReportQuick(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the quick report is reachable — `HEAD
  /// /admin/dashboard/reports/quick`.
  Future<ApiResponse> headDashboardReportQuick(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _headDashboardReportQuick(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Read the sales report — `GET /admin/dashboard/reports/sales`.
  Future<ApiResponse> getDashboardReportSales(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _getDashboardReportSales(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the sales report is reachable — `HEAD
  /// /admin/dashboard/reports/sales`.
  Future<ApiResponse> headDashboardReportSales(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _headDashboardReportSales(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Read the summary — `GET /admin/dashboard/reports/summary`.
  Future<ApiResponse> getDashboardReportSummary(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _getDashboardReportSummary(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the summary is reachable — `HEAD
  /// /admin/dashboard/reports/summary`.
  Future<ApiResponse> headDashboardReportSummary(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _headDashboardReportSummary(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// Read the quick report — `GET /admin/dashboard/reports/quick`: `period`,
/// `kpis`, grouped totals, the most viewed pages under `view_report` and
/// `trends`. `kpis` is a comma list of metric keys (an unknown one is `400`) that
/// narrows `kpis` to those, in that order; `entity_name` is `page` (the default)
/// or `product` and picks what `view_report` ranks.
Future<ApiResponse> getDashboardReportQuick(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(DashboardReportUrls.quick,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: QuickReport.fromMap);

/// Ask whether the quick report is reachable — `HEAD
/// /admin/dashboard/reports/quick`; the status of the read, with no body. It runs
/// the read's query, so a bad value is `400`.
Future<ApiResponse> headDashboardReportQuick(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendApiRequest('HEAD', DashboardReportUrls.quick,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Read the sales report — `GET /admin/dashboard/reports/sales`: `rows` by day or
/// month and `totals`. `breakdown` (`true` or `false`) adds orders, shipping,
/// tax, discount, refunds and the top product to each row and total; `sort` is
/// `date` (the default) or `sales` and `order` is `asc` (the default) or `desc`;
/// any other value is `400`.
Future<ApiResponse> getDashboardReportSales(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(DashboardReportUrls.sales,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SalesReport.fromMap);

/// Ask whether the sales report is reachable — `HEAD
/// /admin/dashboard/reports/sales`; the status of the read, with no body. It runs
/// the read's query, so a bad value is `400`.
Future<ApiResponse> headDashboardReportSales(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendApiRequest('HEAD', DashboardReportUrls.sales,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Read the summary — `GET /admin/dashboard/reports/summary`: the quick report
/// without `kpis`, orders by month, sales rows, the most visited and best selling
/// products and the order updates, in one answer. `compare_previous` (`true` or
/// `false`) is checked as a boolean; any other value is `400`.
Future<ApiResponse> getDashboardReportSummary(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(DashboardReportUrls.summary,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SummaryReport.fromMap);

/// Ask whether the summary is reachable — `HEAD
/// /admin/dashboard/reports/summary`; the status of the read, with no body. It
/// runs the read's query, so a bad value is `400`.
Future<ApiResponse> headDashboardReportSummary(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendApiRequest('HEAD', DashboardReportUrls.summary,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _getDashboardReportQuick = getDashboardReportQuick;
final _headDashboardReportQuick = headDashboardReportQuick;
final _getDashboardReportSales = getDashboardReportSales;
final _headDashboardReportSales = headDashboardReportSales;
final _getDashboardReportSummary = getDashboardReportSummary;
final _headDashboardReportSummary = headDashboardReportSummary;
