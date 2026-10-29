import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import '../../../errors.dart';
import '../../customers/admin_customers_dto.dart';
import 'seo_configuration_dto.dart';
import 'seo_configuration_urls.dart';

/// SEO configuration settings endpoints, bound to one client.
class SeoConfigurationSettings {
  SeoConfigurationSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getSeoConfiguration({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSeoConfiguration(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSeoConfiguration(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSeoConfiguration(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> putSeoConfiguration(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putSeoConfiguration(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSeoConfiguration(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSeoConfiguration(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSeoConfigurationSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSeoConfigurationSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchSeoConfigurationSection(
          String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSeoConfigurationSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> putSeoConfigurationSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _putSeoConfigurationSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSeoConfigurationDocumentRoot({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSeoConfigurationDocumentRoot(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> headSeoConfigurationDocumentRoot(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSeoConfigurationDocumentRoot(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> uploadSeoConfigurationDocumentRoot(
          Map<String, Object?> files,
          {bool? raiseOnError,
          String? responseFormat}) =>
      _uploadSeoConfigurationDocumentRoot(_client, files,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> deleteSeoConfigurationDocumentRootFile(String configKey,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteSeoConfigurationDocumentRootFile(_client, configKey,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSeoConfigurationRedirects({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getSeoConfigurationRedirects(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> headSeoConfigurationRedirects(
          {bool? raiseOnError, String? responseFormat}) =>
      _headSeoConfigurationRedirects(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> createSeoConfigurationRedirect(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createSeoConfigurationRedirect(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getSeoConfigurationRedirect(Object redirectId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getSeoConfigurationRedirect(_client, redirectId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headSeoConfigurationRedirect(Object redirectId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headSeoConfigurationRedirect(_client, redirectId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> patchSeoConfigurationRedirect(
          Object redirectId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchSeoConfigurationRedirect(_client, redirectId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> deleteSeoConfigurationRedirect(Object redirectId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteSeoConfigurationRedirect(_client, redirectId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/seo_configuration`.
Future<ApiResponse> getSeoConfiguration(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SeoConfigurationUrls.seoConfiguration,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// Write fields in one section or several —
/// `PATCH /admin/settings/seo_configuration`.
Future<ApiResponse> patchSeoConfiguration(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SeoConfigurationUrls.seoConfiguration,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// Replace the sections a body names — `PUT /admin/settings/seo_configuration`,
/// with a [patchSeoConfiguration] body.
Future<ApiResponse> putSeoConfiguration(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(SeoConfigurationUrls.seoConfiguration,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/seo_configuration`.
Future<ApiResponse> headSeoConfiguration(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', SeoConfigurationUrls.seoConfiguration,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/seo_configuration/{section}`.
Future<ApiResponse> getSeoConfigurationSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SeoConfigurationUrls.seoConfigurationSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/seo_configuration/{section}`.
Future<ApiResponse> patchSeoConfigurationSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SeoConfigurationUrls.seoConfigurationSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// Replace one section — `PUT /admin/settings/seo_configuration/{section}`,
/// wrapped in the section's own key as the `PATCH` is.
Future<ApiResponse> putSeoConfigurationSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(SeoConfigurationUrls.seoConfigurationSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: SeoConfiguration.fromMap);

/// List the files served from the document root —
/// `GET /admin/settings/seo_configuration/document_root`.
Future<ApiResponse> getSeoConfigurationDocumentRoot(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SeoConfigurationUrls.seoConfigurationDocumentRoot,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Page.of(DocumentRootFile.fromMap));

/// Ask whether the document root listing is reachable; no body and no `ETag` —
/// `HEAD /admin/settings/seo_configuration/document_root`.
Future<ApiResponse> headSeoConfigurationDocumentRoot(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest(
        'HEAD', SeoConfigurationUrls.seoConfigurationDocumentRoot,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Add a file to the document root, as a part named `file` —
/// `POST /admin/settings/seo_configuration/document_root`.
Future<ApiResponse> uploadSeoConfigurationDocumentRoot(
    WebCommanderClient client, Map<String, Object?> files,
    {bool? raiseOnError, String? responseFormat}) {
  _requireFiles(files);
  return client.sendPostRequest(
      SeoConfigurationUrls.seoConfigurationDocumentRoot,
      files: files,
      raiseOnError: raiseOnError,
      responseFormat: responseFormat,
      dtoDecoder: DocumentRootFile.fromMap);
}

/// Stop serving one file —
/// `DELETE /admin/settings/seo_configuration/document_root/{config_key}`.
Future<ApiResponse> deleteSeoConfigurationDocumentRootFile(
        WebCommanderClient client, String configKey,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(
        SeoConfigurationUrls.seoConfigurationDocumentRootFile,
        pathParams: {'config_key': configKey},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// List the redirects — `GET /admin/settings/seo_configuration/redirects`.
Future<ApiResponse> getSeoConfigurationRedirects(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(SeoConfigurationUrls.seoConfigurationRedirects,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Page.of(Redirect.fromMap));

/// Ask whether the redirects listing is reachable; no body and no `ETag` —
/// `HEAD /admin/settings/seo_configuration/redirects`.
Future<ApiResponse> headSeoConfigurationRedirects(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest(
        'HEAD', SeoConfigurationUrls.seoConfigurationRedirects,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Add a redirect — `POST /admin/settings/seo_configuration/redirects`.
Future<ApiResponse> createSeoConfigurationRedirect(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(SeoConfigurationUrls.seoConfigurationRedirects,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Redirect.fromMap);

/// Read one redirect —
/// `GET /admin/settings/seo_configuration/redirects/{redirect_id}`.
Future<ApiResponse> getSeoConfigurationRedirect(
        WebCommanderClient client, Object redirectId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(SeoConfigurationUrls.seoConfigurationRedirect,
        pathParams: {'redirect_id': redirectId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Redirect.fromMap);

/// Ask whether one redirect is there; no body, no `ETag`, and `404` for an
/// unknown id — `HEAD /admin/settings/seo_configuration/redirects/{redirect_id}`.
Future<ApiResponse> headSeoConfigurationRedirect(
        WebCommanderClient client, Object redirectId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', SeoConfigurationUrls.seoConfigurationRedirect,
        pathParams: {'redirect_id': redirectId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Change one redirect —
/// `PATCH /admin/settings/seo_configuration/redirects/{redirect_id}`.
Future<ApiResponse> patchSeoConfigurationRedirect(
        WebCommanderClient client, Object redirectId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(SeoConfigurationUrls.seoConfigurationRedirect,
        pathParams: {'redirect_id': redirectId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Redirect.fromMap);

/// Remove one redirect —
/// `DELETE /admin/settings/seo_configuration/redirects/{redirect_id}`.
Future<ApiResponse> deleteSeoConfigurationRedirect(
        WebCommanderClient client, Object redirectId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(SeoConfigurationUrls.seoConfigurationRedirect,
        pathParams: {'redirect_id': redirectId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _getSeoConfiguration = getSeoConfiguration;
final _patchSeoConfiguration = patchSeoConfiguration;
final _putSeoConfiguration = putSeoConfiguration;
final _headSeoConfiguration = headSeoConfiguration;
final _getSeoConfigurationSection = getSeoConfigurationSection;
final _patchSeoConfigurationSection = patchSeoConfigurationSection;
final _putSeoConfigurationSection = putSeoConfigurationSection;
final _getSeoConfigurationDocumentRoot = getSeoConfigurationDocumentRoot;
final _headSeoConfigurationDocumentRoot = headSeoConfigurationDocumentRoot;
final _uploadSeoConfigurationDocumentRoot = uploadSeoConfigurationDocumentRoot;
final _deleteSeoConfigurationDocumentRootFile =
    deleteSeoConfigurationDocumentRootFile;
final _getSeoConfigurationRedirects = getSeoConfigurationRedirects;
final _headSeoConfigurationRedirects = headSeoConfigurationRedirects;
final _createSeoConfigurationRedirect = createSeoConfigurationRedirect;
final _getSeoConfigurationRedirect = getSeoConfigurationRedirect;
final _headSeoConfigurationRedirect = headSeoConfigurationRedirect;
final _patchSeoConfigurationRedirect = patchSeoConfigurationRedirect;
final _deleteSeoConfigurationRedirect = deleteSeoConfigurationRedirect;

void _requireFiles(Map<String, Object?> files) {
  if (files.isEmpty) {
    throw SdkUsageError(
        'files is required and must carry the upload: the API reads the part '
        "named 'file', whose value is [filename, contents]. An empty mapping "
        'sends no multipart body at all, which the store answers 400 '
        "invalid_request with field 'file', code 'required'");
  }
}
