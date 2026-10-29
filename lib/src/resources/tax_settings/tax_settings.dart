import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_settings_dto.dart';
import 'tax_settings_urls.dart';

/// Tax settings endpoints, bound to one client; there is no `HEAD` here.
class TaxSettingsResource {
  /// Bind the resource to a client; normally reached via `client.taxSettings`.
  TaxSettingsResource(this._client);

  final WebCommanderClient _client;

  /// Read the tax settings — `GET /admin/tax/settings`.
  Future<ApiResponse> getTaxSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getTaxSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Write the tax settings — `PUT /admin/tax/settings`.
  Future<ApiResponse> putTaxSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putTaxSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the tax settings — `GET /admin/tax/settings`.
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

/// Write the tax settings — `PUT /admin/tax/settings`.
Future<ApiResponse> putTaxSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxSettingsUrls.taxSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxSettings.fromMap);

final _getTaxSettings = getTaxSettings;
final _putTaxSettings = putTaxSettings;
