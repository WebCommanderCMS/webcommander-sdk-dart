import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'search_settings_dto.dart';
import 'search_settings_urls.dart';

/// Search settings endpoints, bound to one client.
class SearchSettingsResource {
  SearchSettingsResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getSearchSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSearchSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> putSearchSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putSearchSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSearchSettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSearchSettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSearchSettingsSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchSettingsSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSearchSettingsSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchSettingsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> putSearchSettingsSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putSearchSettingsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSearchSettingsReindexStatus({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchSettingsReindexStatus(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> headSearchSettingsReindexStatus(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSearchSettingsReindexStatus(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/search_settings`.
Future<ApiResponse> getSearchSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SearchSettingsUrls.searchSettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/search_settings`.
Future<ApiResponse> patchSearchSettings(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SearchSettingsUrls.searchSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Replace the whole area — `PUT /admin/settings/search_settings`.
Future<ApiResponse> putSearchSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(SearchSettingsUrls.searchSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Ask whether the area is reachable — `HEAD /admin/settings/search_settings`.
Future<ApiResponse> headSearchSettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', SearchSettingsUrls.searchSettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/search_settings/{section}`.
Future<ApiResponse> getSearchSettingsSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SearchSettingsUrls.searchSettingsSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/search_settings/{section}`.
Future<ApiResponse> patchSearchSettingsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SearchSettingsUrls.searchSettingsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Replace one section — `PUT /admin/settings/search_settings/{section}`.
Future<ApiResponse> putSearchSettingsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(SearchSettingsUrls.searchSettingsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchSettings.fromMap);

/// Read where the reindex stands —
/// `GET /admin/settings/search_settings/reindex_status`.
Future<ApiResponse> getSearchSettingsReindexStatus(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SearchSettingsUrls.searchSettingsReindexStatus,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ReindexStatus.fromMap);

/// Ask whether the reindex status is reachable; no body and no `ETag` —
/// `HEAD /admin/settings/search_settings/reindex_status`.
Future<ApiResponse> headSearchSettingsReindexStatus(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest(
        'HEAD', SearchSettingsUrls.searchSettingsReindexStatus,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _getSearchSettings = getSearchSettings;
final _patchSearchSettings = patchSearchSettings;
final _putSearchSettings = putSearchSettings;
final _headSearchSettings = headSearchSettings;
final _getSearchSettingsSection = getSearchSettingsSection;
final _patchSearchSettingsSection = patchSearchSettingsSection;
final _putSearchSettingsSection = putSearchSettingsSection;
final _getSearchSettingsReindexStatus = getSearchSettingsReindexStatus;
final _headSearchSettingsReindexStatus = headSearchSettingsReindexStatus;
