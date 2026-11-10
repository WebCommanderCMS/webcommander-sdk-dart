import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_settings_dto.dart';
import 'tax_settings_urls.dart';

/// Tax settings endpoints, bound to one client.
class TaxSettingsResource {
  /// Bind the resource to a client; normally reached via `client.taxSettings`.
  TaxSettingsResource(this._client);

  final WebCommanderClient _client;

  /// Read the tax settings — `GET /admin/settings/tax`.
  Future<ApiResponse> getTaxSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getTaxSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Write the tax settings — `PUT /admin/settings/tax`.
  Future<ApiResponse> putTaxSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putTaxSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Write one field or several — `PATCH /admin/settings/tax`.
  Future<ApiResponse> patchTaxSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchTaxSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether the tax settings are reachable — `HEAD /admin/settings/tax`.
  Future<ApiResponse> headTaxSettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxSettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the tax settings — `GET /admin/settings/tax`.
Future<ApiResponse> getTaxSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxSettingsUrls.taxSettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxSettings.fromMap);

/// Write the tax settings — `PUT /admin/settings/tax`; a merge, wrapped in
/// `tax_settings`.
Future<ApiResponse> putTaxSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxSettingsUrls.taxSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxSettings.fromMap);

/// Write one field or several — `PATCH /admin/settings/tax`, wrapped in
/// `tax_settings`.
Future<ApiResponse> patchTaxSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(TaxSettingsUrls.taxSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxSettings.fromMap);

/// Ask whether the tax settings are reachable — `HEAD /admin/settings/tax`; no
/// body.
Future<ApiResponse> headTaxSettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxSettingsUrls.taxSettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _getTaxSettings = getTaxSettings;
final _putTaxSettings = putTaxSettings;
final _patchTaxSettings = patchTaxSettings;
final _headTaxSettings = headTaxSettings;
