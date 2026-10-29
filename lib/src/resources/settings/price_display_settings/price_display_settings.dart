import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'price_display_settings_dto.dart';
import 'price_display_settings_urls.dart';

/// Price display settings endpoints, bound to one client.
class PriceDisplaySettingsResource {
  PriceDisplaySettingsResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getPriceDisplaySettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getPriceDisplaySettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchPriceDisplaySettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchPriceDisplaySettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headPriceDisplaySettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headPriceDisplaySettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getPriceDisplaySettingsSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getPriceDisplaySettingsSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchPriceDisplaySettingsSection(
          String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchPriceDisplaySettingsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/price_display_settings`.
Future<ApiResponse> getPriceDisplaySettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PriceDisplaySettingsUrls.priceDisplaySettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PriceDisplaySettings.fromMap);

/// Write fields in one section or both —
/// `PATCH /admin/settings/price_display_settings`.
Future<ApiResponse> patchPriceDisplaySettings(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(PriceDisplaySettingsUrls.priceDisplaySettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PriceDisplaySettings.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/price_display_settings`.
Future<ApiResponse> headPriceDisplaySettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PriceDisplaySettingsUrls.priceDisplaySettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/price_display_settings/{section}`.
Future<ApiResponse> getPriceDisplaySettingsSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PriceDisplaySettingsUrls.priceDisplaySettingsSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PriceDisplaySettings.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/price_display_settings/{section}`.
Future<ApiResponse> patchPriceDisplaySettingsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(
        PriceDisplaySettingsUrls.priceDisplaySettingsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PriceDisplaySettings.fromMap);

final _getPriceDisplaySettings = getPriceDisplaySettings;
final _patchPriceDisplaySettings = patchPriceDisplaySettings;
final _headPriceDisplaySettings = headPriceDisplaySettings;
final _getPriceDisplaySettingsSection = getPriceDisplaySettingsSection;
final _patchPriceDisplaySettingsSection = patchPriceDisplaySettingsSection;
