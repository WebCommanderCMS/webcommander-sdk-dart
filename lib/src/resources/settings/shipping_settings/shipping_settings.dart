import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'shipping_settings_dto.dart';
import 'shipping_settings_urls.dart';

/// Shipping settings endpoints, bound to one client.
class ShippingSettingsResource {
  ShippingSettingsResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getShippingSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getShippingSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchShippingSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShippingSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headShippingSettings(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingSettings(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/shipping_settings`.
Future<ApiResponse> getShippingSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShippingSettingsUrls.shippingSettings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingSettings.fromMap);

/// Write one field or several — `PATCH /admin/settings/shipping_settings`.
Future<ApiResponse> patchShippingSettings(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShippingSettingsUrls.shippingSettings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingSettings.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/shipping_settings`.
Future<ApiResponse> headShippingSettings(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingSettingsUrls.shippingSettings,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _getShippingSettings = getShippingSettings;
final _patchShippingSettings = patchShippingSettings;
final _headShippingSettings = headShippingSettings;
