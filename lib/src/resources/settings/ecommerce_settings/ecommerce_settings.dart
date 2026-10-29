import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'ecommerce_settings_dto.dart';
import 'ecommerce_settings_urls.dart';

/// Ecommerce settings endpoints, bound to one client.
class EcommerceSettingsResource {
  EcommerceSettingsResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getEcommerceSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getEcommerceSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchEcommerceSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchEcommerceSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headEcommerceSettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headEcommerceSettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getEcommerceSettingsSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getEcommerceSettingsSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchEcommerceSettingsSection(
          String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchEcommerceSettingsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/ecommerce_settings`.
Future<ApiResponse> getEcommerceSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(EcommerceSettingsUrls.ecommerceSettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: EcommerceSettings.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/ecommerce_settings`.
Future<ApiResponse> patchEcommerceSettings(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(EcommerceSettingsUrls.ecommerceSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: EcommerceSettings.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/ecommerce_settings`.
Future<ApiResponse> headEcommerceSettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', EcommerceSettingsUrls.ecommerceSettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/ecommerce_settings/{section}`.
Future<ApiResponse> getEcommerceSettingsSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(EcommerceSettingsUrls.ecommerceSettingsSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: EcommerceSettings.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/ecommerce_settings/{section}`.
Future<ApiResponse> patchEcommerceSettingsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(EcommerceSettingsUrls.ecommerceSettingsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: EcommerceSettings.fromMap);

final _getEcommerceSettings = getEcommerceSettings;
final _patchEcommerceSettings = patchEcommerceSettings;
final _headEcommerceSettings = headEcommerceSettings;
final _getEcommerceSettingsSection = getEcommerceSettingsSection;
final _patchEcommerceSettingsSection = patchEcommerceSettingsSection;
