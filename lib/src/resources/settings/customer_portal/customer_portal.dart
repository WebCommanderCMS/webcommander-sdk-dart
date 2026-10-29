import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'customer_portal_dto.dart';
import 'customer_portal_urls.dart';

/// Customer portal settings endpoints, bound to one client.
class CustomerPortalSettings {
  CustomerPortalSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getCustomerPortal({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerPortal(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCustomerPortal(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCustomerPortal(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headCustomerPortal(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCustomerPortal(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCustomerPortalSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerPortalSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCustomerPortalSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCustomerPortalSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/customer_portal`.
Future<ApiResponse> getCustomerPortal(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerPortalUrls.customerPortal,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerPortal.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/customer_portal`.
Future<ApiResponse> patchCustomerPortal(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CustomerPortalUrls.customerPortal,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerPortal.fromMap);

/// Ask whether the area is reachable — `HEAD /admin/settings/customer_portal`.
Future<ApiResponse> headCustomerPortal(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CustomerPortalUrls.customerPortal,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/customer_portal/{section}`.
Future<ApiResponse> getCustomerPortalSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerPortalUrls.customerPortalSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerPortal.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/customer_portal/{section}`.
Future<ApiResponse> patchCustomerPortalSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CustomerPortalUrls.customerPortalSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomerPortal.fromMap);

final _getCustomerPortal = getCustomerPortal;
final _patchCustomerPortal = patchCustomerPortal;
final _headCustomerPortal = headCustomerPortal;
final _getCustomerPortalSection = getCustomerPortalSection;
final _patchCustomerPortalSection = patchCustomerPortalSection;
