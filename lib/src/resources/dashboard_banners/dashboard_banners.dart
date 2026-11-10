import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'dashboard_banners_dto.dart';
import 'dashboard_banners_urls.dart';

/// Dashboard banner endpoints, bound to one client.
class DashboardBanners {
  /// Bind the resource to a client; normally reached via `client.dashboardBanners`.
  DashboardBanners(this._client);

  final WebCommanderClient _client;

  /// List every banner, active or not — `GET /admin/dashboard/banners`.
  Future<ApiResponse> listDashboardBanners(
          {bool? raiseOnError, String? responseFormat}) =>
      _listDashboardBanners(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a banner — `POST /admin/dashboard/banners`.
  Future<ApiResponse> createDashboardBanner(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createDashboardBanner(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one banner by its `key` — `GET
  /// /admin/dashboard/banners/{banner_key}`.
  Future<ApiResponse> getDashboardBanner(String bannerKey,
          {bool? raiseOnError, String? responseFormat}) =>
      _getDashboardBanner(_client, bannerKey,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH /admin/dashboard/banners/{banner_key}`.
  Future<ApiResponse> patchDashboardBanner(String bannerKey, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchDashboardBanner(_client, bannerKey, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one banner — `DELETE /admin/dashboard/banners/{banner_key}`.
  Future<ApiResponse> deleteDashboardBanner(String bannerKey,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteDashboardBanner(_client, bannerKey,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read what the Dashboard shows besides the figures — `GET
  /// /admin/dashboard/content_info`.
  Future<ApiResponse> getDashboardContentInfo(
          {bool? raiseOnError, String? responseFormat}) =>
      _getDashboardContentInfo(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List every banner, active or not — `GET /admin/dashboard/banners`,
/// `{"banners": [...]}` in position order, positions counting from 1 without a
/// gap.
Future<ApiResponse> listDashboardBanners(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardBannerUrls.banners,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardBannerListing.fromMap);

/// Create a banner — `POST /admin/dashboard/banners`, answered `201` with the
/// banner bare and no `Location`. The body is bare; every failing field is listed
/// in one `400`, a `key` already used is `400` `duplicate`, an unknown field is
/// `400`. It joins the Dashboard feed at once while `active`.
Future<ApiResponse> createDashboardBanner(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(DashboardBannerUrls.banners,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardBanner.fromMap);

/// Retrieve one banner by its `key` — `GET
/// /admin/dashboard/banners/{banner_key}`, the banner bare, hidden ones included.
/// An unknown key is `404`.
Future<ApiResponse> getDashboardBanner(
        WebCommanderClient client, String bannerKey,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardBannerUrls.banner,
        pathParams: {'banner_key': bannerKey},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardBanner.fromMap);

/// Change only the fields sent — `PATCH /admin/dashboard/banners/{banner_key}`,
/// answered `200` with the banner. An empty body, a blank `title`, a `key` and an
/// unknown field are `400`; an unknown banner is `404`. `learn_more` and `try_it`
/// are replaced whole, and `try_it` `null` removes the second button.
/// `updated_at` is not moved.
Future<ApiResponse> patchDashboardBanner(
        WebCommanderClient client, String bannerKey, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(DashboardBannerUrls.banner,
        pathParams: {'banner_key': bannerKey},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardBanner.fromMap);

/// Delete one banner — `DELETE /admin/dashboard/banners/{banner_key}`, `204` with
/// no body. The banners after it move up, so the positions stay without a gap; an
/// unknown key is `404`.
Future<ApiResponse> deleteDashboardBanner(
        WebCommanderClient client, String bannerKey,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(DashboardBannerUrls.banner,
        pathParams: {'banner_key': bannerKey},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Read what the Dashboard shows besides the figures — `GET
/// /admin/dashboard/content_info`: the active banners under `banners`, the
/// support card under `contact`, `online_store` and `member_label`. A hidden
/// banner is not listed.
Future<ApiResponse> getDashboardContentInfo(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(DashboardBannerUrls.contentInfo,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DashboardContentInfo.fromMap);

final _listDashboardBanners = listDashboardBanners;
final _createDashboardBanner = createDashboardBanner;
final _getDashboardBanner = getDashboardBanner;
final _patchDashboardBanner = patchDashboardBanner;
final _deleteDashboardBanner = deleteDashboardBanner;
final _getDashboardContentInfo = getDashboardContentInfo;
