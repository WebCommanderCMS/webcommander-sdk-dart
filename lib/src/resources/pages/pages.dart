import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'pages_dto.dart';
import 'pages_urls.dart';

/// Page endpoints, bound to one client.
class Pages {
  /// Bind the resource to a client; normally reached via `client.pages`.
  Pages(this._client);

  final WebCommanderClient _client;

  /// List the pages outside the trash — `GET /admin/pages`.
  Future<ApiResponse> listPages({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listPages(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/pages`.
  Future<ApiResponse> headPages({bool? raiseOnError, String? responseFormat}) =>
      _headPages(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many pages match — `GET /admin/pages/count`.
  Future<ApiResponse> countPages({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _countPages(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable — `HEAD /admin/pages/count`.
  Future<ApiResponse> headPagesCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headPagesCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a page — `POST /admin/pages`.
  Future<ApiResponse> createPage(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createPage(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one page — `GET /admin/pages/{page_id}`.
  Future<ApiResponse> getPage(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getPage(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one page is there — `HEAD /admin/pages/{page_id}`.
  Future<ApiResponse> headPage(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headPage(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one page — `PUT /admin/pages/{page_id}`.
  Future<ApiResponse> updatePage(Object pageId, Object payload,
          {String? ifMatch, bool? raiseOnError, String? responseFormat}) =>
      _updatePage(_client, pageId, payload,
          ifMatch: ifMatch,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH /admin/pages/{page_id}`.
  Future<ApiResponse> patchPage(Object pageId, Object payload,
          {String? ifMatch, bool? raiseOnError, String? responseFormat}) =>
      _patchPage(_client, pageId, payload,
          ifMatch: ifMatch,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Move a page to the trash — `DELETE /admin/pages/{page_id}`.
  Future<ApiResponse> deletePage(
    Object pageId, {
    Map<String, Object?>? queryParams,
    String? ifMatch,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _deletePage(_client, pageId,
          queryParams: queryParams,
          ifMatch: ifMatch,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Move a page to a new URL — `PUT /admin/pages/{page_id}/url`.
  Future<ApiResponse> updatePageUrl(Object pageId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updatePageUrl(_client, pageId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Make a page the store's landing page —
  /// `PATCH /admin/pages/{page_id}/landing`.
  Future<ApiResponse> setLandingPage(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _setLandingPage(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Whether a delete would pass —
  /// `GET /admin/pages/{page_id}/delete-blockers`.
  Future<ApiResponse> getPageDeleteBlockers(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getPageDeleteBlockers(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether the delete check is reachable —
  /// `HEAD /admin/pages/{page_id}/delete-blockers`.
  Future<ApiResponse> headPageDeleteBlockers(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headPageDeleteBlockers(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Copy a page — `POST /admin/pages/{page_id}/duplicate`.
  Future<ApiResponse> duplicatePage(Object pageId,
          {bool? raiseOnError, String? responseFormat}) =>
      _duplicatePage(_client, pageId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the pages outside the trash, newest change first —
/// `GET /admin/pages`. `search`, `active`, `has_layout`, `visibility`,
/// `created_from`/`created_to`, `updated_from`/`updated_to` (`YYYY-MM-DD`),
/// `author`, `store` and `not_in_store` filter; `sort` and `order` order;
/// `limit` is 1 to 100 or `all`. Unknown names are `400`.
Future<ApiResponse> listPages(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PageUrls.pages,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageListing.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/pages`; no body.
Future<ApiResponse> headPages(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PageUrls.pages,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many pages match — `GET /admin/pages/count`, a bare `{"total": N}`.
/// The listing's filters narrow it; `sort`, `order`, `limit` and `offset` are
/// ignored.
Future<ApiResponse> countPages(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(PageUrls.pagesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/pages/count`; no body.
Future<ApiResponse> headPagesCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PageUrls.pagesCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a page — `POST /admin/pages` with `{"page": {...}}`, answered `201`.
/// `name` and `visibility` are required; the URL is made from the name.
Future<ApiResponse> createPage(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(PageUrls.pages,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Retrieve one page, with an `ETag`; a page in the trash still reads,
/// `in_trash` true. `GET /admin/pages/{page_id}`
Future<ApiResponse> getPage(WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(PageUrls.page,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Ask whether one page is there; no body, the `ETag` its `GET` carries.
/// `HEAD /admin/pages/{page_id}`
Future<ApiResponse> headPage(WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PageUrls.page,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one page — `PUT /admin/pages/{page_id}`. `name`, `title`,
/// `subtitle`, `url`, `layout`, `visibility`, `body_class`, `active`,
/// `disable_tracking` and `password_protection` are required, a partial body
/// is `400`; `subtitle`, `layout` and `body_class` take `null`. [ifMatch] is
/// sent as `If-Match`: a stale `ETag` is `412`, checked before the body.
Future<ApiResponse> updatePage(
        WebCommanderClient client, Object pageId, Object payload,
        {String? ifMatch, bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(PageUrls.page,
        pathParams: {'page_id': pageId},
        jsonBody: payload,
        headers: ifMatch == null ? null : {PageUrls.ifMatchHeader: ifMatch},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Change only the fields sent — `PATCH /admin/pages/{page_id}`; an empty
/// `page` is `400` and a page in the trash `409`. [ifMatch] is sent as
/// `If-Match`.
Future<ApiResponse> patchPage(
        WebCommanderClient client, Object pageId, Object payload,
        {String? ifMatch, bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(PageUrls.page,
        pathParams: {'page_id': pageId},
        jsonBody: payload,
        headers: ifMatch == null ? null : {PageUrls.ifMatchHeader: ifMatch},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Move a page to the trash — `DELETE /admin/pages/{page_id}`; `204`. `force`
/// `true` purges it, from the trash or live; a second plain delete is `400`.
/// The landing page is `409`. [ifMatch] is sent as `If-Match`.
Future<ApiResponse> deletePage(
  WebCommanderClient client,
  Object pageId, {
  Map<String, Object?>? queryParams,
  String? ifMatch,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendDeleteRequest(PageUrls.page,
        pathParams: {'page_id': pageId},
        queryParams: queryParams,
        headers: ifMatch == null ? null : {PageUrls.ifMatchHeader: ifMatch},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Move a page to a new URL — `PUT /admin/pages/{page_id}/url` with a bare
/// `{"url": ...}`; answers the page. A URL another page holds is `409`.
Future<ApiResponse> updatePageUrl(
        WebCommanderClient client, Object pageId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(PageUrls.pageUrl,
        pathParams: {'page_id': pageId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Make a page the store's landing page; takes no body. The previous landing
/// page stops being it. `PATCH /admin/pages/{page_id}/landing`
Future<ApiResponse> setLandingPage(WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(PageUrls.pageLanding,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

/// Whether a delete would pass and what blocks it, such as `landing_page`.
/// `GET /admin/pages/{page_id}/delete-blockers`
Future<ApiResponse> getPageDeleteBlockers(
        WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(PageUrls.pageDeleteBlockers,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageDeleteBlockers.fromMap);

/// Ask whether the delete check is reachable; no body.
/// `HEAD /admin/pages/{page_id}/delete-blockers`
Future<ApiResponse> headPageDeleteBlockers(
        WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', PageUrls.pageDeleteBlockers,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Copy a page — `POST /admin/pages/{page_id}/duplicate`, answered `201`; a
/// body field is `400`. The copy is `"<name> - Copy"` at `<url>-copy`, then
/// `- Copy 1` at `-copy-1`.
Future<ApiResponse> duplicatePage(WebCommanderClient client, Object pageId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(PageUrls.pageDuplicate,
        pathParams: {'page_id': pageId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: PageRecord.fromMap);

final _listPages = listPages;
final _headPages = headPages;
final _countPages = countPages;
final _headPagesCount = headPagesCount;
final _createPage = createPage;
final _getPage = getPage;
final _headPage = headPage;
final _updatePage = updatePage;
final _patchPage = patchPage;
final _deletePage = deletePage;
final _updatePageUrl = updatePageUrl;
final _setLandingPage = setLandingPage;
final _getPageDeleteBlockers = getPageDeleteBlockers;
final _headPageDeleteBlockers = headPageDeleteBlockers;
final _duplicatePage = duplicatePage;
