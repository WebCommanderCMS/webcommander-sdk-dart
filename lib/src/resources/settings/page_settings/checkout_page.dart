import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'checkout_page_dto.dart';
import 'checkout_page_urls.dart';

/// Checkout page settings endpoints, bound to one client.
class CheckoutPageSettings {
  CheckoutPageSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getCheckoutPage({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCheckoutPage(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCheckoutPage(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCheckoutPage(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headCheckoutPage(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCheckoutPage(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCheckoutPageSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCheckoutPageSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCheckoutPageSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCheckoutPageSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/page_settings/checkout_page`.
Future<ApiResponse> getCheckoutPage(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CheckoutPageUrls.checkoutPage,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CheckoutPage.fromMap);

/// Write fields in one section or several —
/// `PATCH /admin/settings/page_settings/checkout_page`.
Future<ApiResponse> patchCheckoutPage(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CheckoutPageUrls.checkoutPage,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CheckoutPage.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/page_settings/checkout_page`.
Future<ApiResponse> headCheckoutPage(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CheckoutPageUrls.checkoutPage,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section —
/// `GET /admin/settings/page_settings/checkout_page/{section}`.
Future<ApiResponse> getCheckoutPageSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CheckoutPageUrls.checkoutPageSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CheckoutPage.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/page_settings/checkout_page/{section}`.
Future<ApiResponse> patchCheckoutPageSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CheckoutPageUrls.checkoutPageSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CheckoutPage.fromMap);

final _getCheckoutPage = getCheckoutPage;
final _patchCheckoutPage = patchCheckoutPage;
final _headCheckoutPage = headCheckoutPage;
final _getCheckoutPageSection = getCheckoutPageSection;
final _patchCheckoutPageSection = patchCheckoutPageSection;
