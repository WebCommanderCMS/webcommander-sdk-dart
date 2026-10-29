import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import '../../customers/admin_customers_dto.dart';
import 'search_result_page_dto.dart';
import 'search_result_page_urls.dart';

/// Search result page settings endpoints, bound to one client.
class SearchResultPageSettings {
  SearchResultPageSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getSearchResultPage({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchResultPage(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSearchResultPage(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchResultPage(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSearchResultPage(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSearchResultPage(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSearchResultPageSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchResultPageSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSearchResultPageSection(
          String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchResultPageSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSearchResultPageProductPromotions({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSearchResultPageProductPromotions(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> headSearchResultPageProductPromotions(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSearchResultPageProductPromotions(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> createSearchResultPageProductPromotion(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createSearchResultPageProductPromotion(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSearchResultPageProductPromotion(Object promotionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getSearchResultPageProductPromotion(_client, promotionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSearchResultPageProductPromotion(Object promotionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headSearchResultPageProductPromotion(_client, promotionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> patchSearchResultPageProductPromotion(
          Object promotionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchResultPageProductPromotion(_client, promotionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> patchSearchResultPageProductPromotionActive(
          Object promotionId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSearchResultPageProductPromotionActive(
          _client, promotionId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> deleteSearchResultPageProductPromotion(Object promotionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteSearchResultPageProductPromotion(_client, promotionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area —
/// `GET /admin/settings/page_settings/search_result_page`.
Future<ApiResponse> getSearchResultPage(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SearchResultPageUrls.searchResultPage,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchResultPage.fromMap);

/// Write fields in the writable section —
/// `PATCH /admin/settings/page_settings/search_result_page`.
Future<ApiResponse> patchSearchResultPage(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SearchResultPageUrls.searchResultPage,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchResultPage.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/page_settings/search_result_page`.
Future<ApiResponse> headSearchResultPage(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', SearchResultPageUrls.searchResultPage,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section —
/// `GET /admin/settings/page_settings/search_result_page/{section}`.
Future<ApiResponse> getSearchResultPageSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SearchResultPageUrls.searchResultPageSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchResultPage.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/page_settings/search_result_page/{section}`.
Future<ApiResponse> patchSearchResultPageSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SearchResultPageUrls.searchResultPageSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SearchResultPage.fromMap);

/// List the promotions —
/// `GET /admin/settings/page_settings/search_result_page/product_promotion`.
Future<ApiResponse> getSearchResultPageProductPromotions(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(
        SearchResultPageUrls.searchResultPageProductPromotions,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Page.of(ProductPromotion.fromMap));

/// Ask whether the promotions collection is reachable; no body and no `ETag` —
/// `HEAD /admin/settings/page_settings/search_result_page/product_promotion`.
Future<ApiResponse> headSearchResultPageProductPromotions(
        WebCommanderClient client,
        {bool? raiseOnError,
        String? responseFormat}) =>
    client.sendApiRequest(
        'HEAD', SearchResultPageUrls.searchResultPageProductPromotions,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Add a promotion —
/// `POST /admin/settings/page_settings/search_result_page/product_promotion`.
Future<ApiResponse> createSearchResultPageProductPromotion(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(
        SearchResultPageUrls.searchResultPageProductPromotions,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPromotion.fromMap);

/// Read one promotion —
/// `GET /admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}`.
Future<ApiResponse> getSearchResultPageProductPromotion(
        WebCommanderClient client, Object promotionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(SearchResultPageUrls.searchResultPageProductPromotion,
        pathParams: {'promotion_id': promotionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPromotion.fromMap);

/// Ask whether one promotion is there; no body, an `ETag`, and `404` for an
/// unknown id —
/// `HEAD /admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}`.
Future<ApiResponse> headSearchResultPageProductPromotion(
        WebCommanderClient client, Object promotionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest(
        'HEAD', SearchResultPageUrls.searchResultPageProductPromotion,
        pathParams: {'promotion_id': promotionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Change one promotion —
/// `PATCH /admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}`.
Future<ApiResponse> patchSearchResultPageProductPromotion(
        WebCommanderClient client, Object promotionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(
        SearchResultPageUrls.searchResultPageProductPromotion,
        pathParams: {'promotion_id': promotionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPromotion.fromMap);

/// Turn one promotion on or off —
/// `PATCH /admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}/active`.
Future<ApiResponse> patchSearchResultPageProductPromotionActive(
        WebCommanderClient client, Object promotionId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(
        SearchResultPageUrls.searchResultPageProductPromotionActive,
        pathParams: {'promotion_id': promotionId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductPromotion.fromMap);

/// Remove one promotion —
/// `DELETE /admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}`.
Future<ApiResponse> deleteSearchResultPageProductPromotion(
        WebCommanderClient client, Object promotionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(
        SearchResultPageUrls.searchResultPageProductPromotion,
        pathParams: {'promotion_id': promotionId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _getSearchResultPage = getSearchResultPage;
final _patchSearchResultPage = patchSearchResultPage;
final _headSearchResultPage = headSearchResultPage;
final _getSearchResultPageSection = getSearchResultPageSection;
final _patchSearchResultPageSection = patchSearchResultPageSection;
final _getSearchResultPageProductPromotions =
    getSearchResultPageProductPromotions;
final _headSearchResultPageProductPromotions =
    headSearchResultPageProductPromotions;
final _createSearchResultPageProductPromotion =
    createSearchResultPageProductPromotion;
final _getSearchResultPageProductPromotion =
    getSearchResultPageProductPromotion;
final _headSearchResultPageProductPromotion =
    headSearchResultPageProductPromotion;
final _patchSearchResultPageProductPromotion =
    patchSearchResultPageProductPromotion;
final _patchSearchResultPageProductPromotionActive =
    patchSearchResultPageProductPromotionActive;
final _deleteSearchResultPageProductPromotion =
    deleteSearchResultPageProductPromotion;
