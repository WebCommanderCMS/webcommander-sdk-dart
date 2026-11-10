import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'dashboard_kpis_dto.dart';
import 'dashboard_kpis_urls.dart';

/// Dashboard KPI endpoints, bound to one client.
class DashboardKpis {
  /// Bind the resource to a client; normally reached via `client.dashboardKpis`.
  DashboardKpis(this._client);

  final WebCommanderClient _client;

  /// List the metrics a tile can show — `GET /admin/dashboard/kpi_options`.
  Future<ApiResponse> getDashboardKpiOptions(
          {bool? raiseOnError, String? responseFormat}) =>
      _getDashboardKpiOptions(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read the tiles in use with their figures — `GET
  /// /admin/dashboard/kpi_selection`.
  Future<ApiResponse> getDashboardKpiSelection(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _getDashboardKpiSelection(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Save the tiles — `PUT /admin/dashboard/kpi_selection`.
  Future<ApiResponse> updateDashboardKpiSelection(Object payload,
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _updateDashboardKpiSelection(_client, payload,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// List the metrics a tile can show — `GET /admin/dashboard/kpi_options`,
/// grouped, with `min` 2 and `max` 5 tiles and the keys now in use under
/// `selected`. It reads the same tiles as `kpi_selection`.
Future<ApiResponse> getDashboardKpiOptions(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardKpiUrls.kpiOptions,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: KpiOptions.fromMap);

/// Read the tiles in use with their figures — `GET
/// /admin/dashboard/kpi_selection`, the tiles of the default layout under
/// `selected` in position order. `duration` (`last_30_days` when left out) or
/// `start_date` with `end_date` (`YYYY-MM-DD`, sent together) choose the period;
/// a bad value is `400`.
Future<ApiResponse> getDashboardKpiSelection(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(DashboardKpiUrls.kpiSelection,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: KpiSelection.fromMap);

/// Save the tiles — `PUT /admin/dashboard/kpi_selection` with `{"metrics":
/// [...]}`, answered `200` like the read. The list replaces the default layout's
/// tiles, which is store-wide state, and is read back at once by that layout and
/// by `kpi_options`. Fewer than 2 or more than 5, a repeat, an unknown key, a
/// missing `metrics` and a non-list are `400`. `duration` or the dates in
/// [queryParams] set the period of the figures in the answer.
Future<ApiResponse> updateDashboardKpiSelection(
        WebCommanderClient client, Object payload,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendPutRequest(DashboardKpiUrls.kpiSelection,
        jsonBody: payload,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: KpiSelection.fromMap);

final _getDashboardKpiOptions = getDashboardKpiOptions;
final _getDashboardKpiSelection = getDashboardKpiSelection;
final _updateDashboardKpiSelection = updateDashboardKpiSelection;
