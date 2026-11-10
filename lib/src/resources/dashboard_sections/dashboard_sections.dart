import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'dashboard_sections_dto.dart';
import 'dashboard_sections_urls.dart';

/// Dashboard section endpoints, bound to one client. The Dashboard shows five
/// tabs; a tab is a path value.
class DashboardSections {
  /// Bind the resource to a client; normally reached via `client.dashboardSections`.
  DashboardSections(this._client);

  final WebCommanderClient _client;

  /// Read one tab — `GET /admin/dashboard/sections/{section}`.
  Future<ApiResponse> getDashboardSection(String section,
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _getDashboardSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// Read one tab — `GET /admin/dashboard/sections/{section}`, [section] being one
/// of `DashboardSectionUrls.sections` (`ecommerce`, `content`, `bookings`,
/// `courses`, `blog`); the answer is bare, `section` echoing it, with `period`
/// and that tab's own fields. Any other value is `404` `not_found` on `key`.
/// `duration` or `start_date` with `end_date` choose the period, as in the
/// reports.
Future<ApiResponse> getDashboardSection(
        WebCommanderClient client, String section,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(DashboardSectionUrls.section,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardSectionReport.fromMap);

final _getDashboardSection = getDashboardSection;
