import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'category_page_dto.dart';
import 'category_page_urls.dart';

/// Category page settings endpoints, bound to one client.
class CategoryPageSettings {
  CategoryPageSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getCategoryPage({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCategoryPage(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCategoryPage(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCategoryPage(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headCategoryPage(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCategoryPage(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCategoryPageSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCategoryPageSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchCategoryPageSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchCategoryPageSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/page_settings/category_page`.
Future<ApiResponse> getCategoryPage(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CategoryPageUrls.categoryPage,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryPage.fromMap);

/// Write fields in one section or both —
/// `PATCH /admin/settings/page_settings/category_page`.
Future<ApiResponse> patchCategoryPage(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CategoryPageUrls.categoryPage,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryPage.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/page_settings/category_page`.
Future<ApiResponse> headCategoryPage(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CategoryPageUrls.categoryPage,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section —
/// `GET /admin/settings/page_settings/category_page/{section}`.
Future<ApiResponse> getCategoryPageSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CategoryPageUrls.categoryPageSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryPage.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/page_settings/category_page/{section}`.
Future<ApiResponse> patchCategoryPageSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(CategoryPageUrls.categoryPageSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CategoryPage.fromMap);

final _getCategoryPage = getCategoryPage;
final _patchCategoryPage = patchCategoryPage;
final _headCategoryPage = headCategoryPage;
final _getCategoryPageSection = getCategoryPageSection;
final _patchCategoryPageSection = patchCategoryPageSection;
