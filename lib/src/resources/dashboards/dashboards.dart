import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'dashboards_dto.dart';
import 'dashboards_urls.dart';

/// Dashboard layout endpoints, bound to one client.
class Dashboards {
  /// Bind the resource to a client; normally reached via `client.dashboards`.
  Dashboards(this._client);

  final WebCommanderClient _client;

  /// List the admin's layouts — `GET /admin/dashboards`.
  Future<ApiResponse> listDashboards(
          {bool? raiseOnError, String? responseFormat}) =>
      _listDashboards(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a layout — `POST /admin/dashboards`.
  Future<ApiResponse> createDashboard(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createDashboard(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one layout by its `id` — `GET /admin/dashboards/{dashboard_id}`.
  Future<ApiResponse> getDashboard(Object dashboardId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getDashboard(_client, dashboardId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH /admin/dashboards/{dashboard_id}`.
  Future<ApiResponse> patchDashboard(Object dashboardId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchDashboard(_client, dashboardId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one layout — `DELETE /admin/dashboards/{dashboard_id}`.
  Future<ApiResponse> deleteDashboard(Object dashboardId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteDashboard(_client, dashboardId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the admin's layouts — `GET /admin/dashboards`, `{"dashboards": [...]}`
/// with no paging. Each row is `id`, `name`, `default` and the two timestamps,
/// and exactly one row is the default.
Future<ApiResponse> listDashboards(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardUrls.dashboards,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardListing.fromMap);

/// Create a layout — `POST /admin/dashboards`, answered `201` with the whole
/// layout, bare and with no `Location`. The body is bare and needs `name`, unique
/// among the admin's layouts (`409` `name_taken`); an empty body is `400`. It
/// starts as a copy of the layout named in `copy_from` or of the default one,
/// then the sections and `kpis` sent are applied. Unknown fields are ignored.
Future<ApiResponse> createDashboard(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(DashboardUrls.dashboards,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Dashboard.fromMap);

/// Retrieve one layout by its `id` — `GET /admin/dashboards/{dashboard_id}`, the
/// layout bare. An unknown id is `404` `not_found` on `dashboard_id`.
Future<ApiResponse> getDashboard(WebCommanderClient client, Object dashboardId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardUrls.dashboard,
        pathParams: {'dashboard_id': dashboardId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Dashboard.fromMap);

/// Change only the fields sent — `PATCH /admin/dashboards/{dashboard_id}`,
/// answered `200` with the whole layout. An empty body is `400`; unknown fields
/// are ignored. A blank `name` or one over 60 characters is `400`, a section key
/// the layout does not have is `400`, a standard section with a `position` is
/// `400` and hiding `contact` is `400`. `default` `true` moves the store's
/// default layout to this one.
Future<ApiResponse> patchDashboard(
        WebCommanderClient client, Object dashboardId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(DashboardUrls.dashboard,
        pathParams: {'dashboard_id': dashboardId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Dashboard.fromMap);

/// Delete one layout — `DELETE /admin/dashboards/{dashboard_id}`, `204` with no
/// body; the layout then reads `404`.
Future<ApiResponse> deleteDashboard(
        WebCommanderClient client, Object dashboardId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(DashboardUrls.dashboard,
        pathParams: {'dashboard_id': dashboardId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listDashboards = listDashboards;
final _createDashboard = createDashboard;
final _getDashboard = getDashboard;
final _patchDashboard = patchDashboard;
final _deleteDashboard = deleteDashboard;
