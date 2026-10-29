import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'product_page_dto.dart';
import 'product_page_urls.dart';

/// Product page settings endpoints, bound to one client.
class ProductPageSettings {
  ProductPageSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getProductPage({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getProductPage(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchProductPage(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductPage(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headProductPage(
          {bool? raiseOnError, String? responseFormat}) =>
      _headProductPage(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getProductPageSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getProductPageSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchProductPageSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductPageSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/page_settings/product_page`.
Future<ApiResponse> getProductPage(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductPageUrls.productPage,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPage.fromMap);

/// Write fields in one section or several —
/// `PATCH /admin/settings/page_settings/product_page`.
Future<ApiResponse> patchProductPage(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductPageUrls.productPage,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPage.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/page_settings/product_page`.
Future<ApiResponse> headProductPage(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ProductPageUrls.productPage,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section —
/// `GET /admin/settings/page_settings/product_page/{section}`.
Future<ApiResponse> getProductPageSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductPageUrls.productPageSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPage.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/page_settings/product_page/{section}`.
Future<ApiResponse> patchProductPageSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductPageUrls.productPageSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPage.fromMap);

final _getProductPage = getProductPage;
final _patchProductPage = patchProductPage;
final _headProductPage = headProductPage;
final _getProductPageSection = getProductPageSection;
final _patchProductPageSection = patchProductPageSection;
