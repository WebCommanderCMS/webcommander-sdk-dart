import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'site_settings_dto.dart';
import 'site_settings_urls.dart';

/// Site settings endpoints, bound to one client.
class SiteSettingsResource {
  SiteSettingsResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getSiteSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSiteSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSiteSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSiteSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSiteSettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSiteSettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSiteSettingsSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSiteSettingsSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSiteSettingsSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSiteSettingsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/site_settings`.
Future<ApiResponse> getSiteSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SiteSettingsUrls.siteSettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SiteSettings.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/site_settings`.
Future<ApiResponse> patchSiteSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SiteSettingsUrls.siteSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SiteSettings.fromMap);

/// Ask whether the area is reachable — `HEAD /admin/settings/site_settings`.
Future<ApiResponse> headSiteSettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', SiteSettingsUrls.siteSettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/site_settings/{section}`.
Future<ApiResponse> getSiteSettingsSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SiteSettingsUrls.siteSettingsSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SiteSettings.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/site_settings/{section}`.
Future<ApiResponse> patchSiteSettingsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SiteSettingsUrls.siteSettingsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SiteSettings.fromMap);

final _getSiteSettings = getSiteSettings;
final _patchSiteSettings = patchSiteSettings;
final _headSiteSettings = headSiteSettings;
final _getSiteSettingsSection = getSiteSettingsSection;
final _patchSiteSettingsSection = patchSiteSettingsSection;
