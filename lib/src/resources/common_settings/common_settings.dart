import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'common_settings_dto.dart';
import 'common_settings_urls.dart';

/// Common settings endpoints, bound to one client.
class CommonSettingsResource {
  /// Bind the resource to a client; normally reached via
  /// `client.commonSettings`.
  CommonSettingsResource(this._client);

  final WebCommanderClient _client;

  /// Read the store's settings by group — `GET /settings`.
  Future<ApiResponse> getSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the settings are reachable — `HEAD /settings`.
  Future<ApiResponse> headSettings({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _headSettings(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Save settings — `PUT /settings`.
  Future<ApiResponse> updateSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Save settings — `POST /settings`.
  Future<ApiResponse> saveSettings(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _saveSettings(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Read the customer registration form — `GET /create-customer-fields`.
  Future<ApiResponse> getCreateCustomerFields(
          {bool? raiseOnError, String? responseFormat}) =>
      _getCreateCustomerFields(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether the registration form is there —
  /// `HEAD /create-customer-fields`.
  Future<ApiResponse> headCreateCustomerFields(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCreateCustomerFields(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the store's settings — `GET /settings`, `settings` mapping each group
/// to `{"config_key", "value"}` maps. `type` names one group, an unknown one
/// `404`; `config_key` one key, with or without `type`. A comma list of keys
/// matches nothing and answers `{"settings": {}}`. Secrets read `***`. Other
/// names, paging included, are `400`. Without `type` the answer is every group,
/// about 2 MB, and can take 30 seconds or more.
Future<ApiResponse> getSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CommonSettingsUrls.settings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CommonSettings.fromMap);

/// Ask whether the settings are reachable — `HEAD /settings`; no body. It runs
/// the read's query, so pass a `type`: an unknown one is `404`.
Future<ApiResponse> headSettings(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendApiRequest('HEAD', CommonSettingsUrls.settings,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Save settings — `PUT /settings` with `{"settings": {group: ...}}`; `200` and
/// every group of the store. Only the keys sent change, and one bad entry
/// refuses the whole request with `400`. A write was measured at 5 to 53
/// seconds, past the default 30 of `timeoutSeconds` at the slow end: build the
/// client with a longer one.
Future<ApiResponse> updateSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CommonSettingsUrls.settings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CommonSettings.fromMap);

/// Save settings — `POST /settings`, the `PUT`'s body, behaviour and timing,
/// answered `201`. A `POST` is not resent after a timeout, so read the keys
/// back before retrying.
Future<ApiResponse> saveSettings(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CommonSettingsUrls.settings,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CommonSettings.fromMap);

/// Read the customer registration form — `GET /create-customer-fields`, the
/// active `fields` in order and every field's `fields_configs`. Any query name
/// is `400`.
Future<ApiResponse> getCreateCustomerFields(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CommonSettingsUrls.createCustomerFields,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerFields.fromMap);

/// Ask whether the registration form is there — `HEAD /create-customer-fields`;
/// no body.
Future<ApiResponse> headCreateCustomerFields(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CommonSettingsUrls.createCustomerFields,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _getSettings = getSettings;
final _headSettings = headSettings;
final _updateSettings = updateSettings;
final _saveSettings = saveSettings;
final _getCreateCustomerFields = getCreateCustomerFields;
final _headCreateCustomerFields = headCreateCustomerFields;
