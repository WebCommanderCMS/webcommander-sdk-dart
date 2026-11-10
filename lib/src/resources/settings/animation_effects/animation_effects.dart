import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import '../../../errors.dart';
import 'animation_effects_dto.dart';
import 'animation_effects_urls.dart';

/// Animation effects settings endpoints, bound to one client.
class AnimationEffectsSettings {
  AnimationEffectsSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getAnimationEffects({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getAnimationEffects(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchAnimationEffects(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchAnimationEffects(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headAnimationEffects(
          {bool? raiseOnError, String? responseFormat}) =>
      _headAnimationEffects(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getAnimationEffectsSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getAnimationEffectsSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchAnimationEffectsSection(
          String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchAnimationEffectsSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Upload the custom preloader image —
  /// `POST /admin/settings/animation_effects/custom_loader`.
  Future<ApiResponse> uploadAnimationEffectsCustomLoader(
          Map<String, Object?> files,
          {bool? raiseOnError,
          String? responseFormat}) =>
      _uploadAnimationEffectsCustomLoader(_client, files,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Remove the custom preloader image —
  /// `DELETE /admin/settings/animation_effects/custom_loader`.
  Future<ApiResponse> deleteAnimationEffectsCustomLoader(
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteAnimationEffectsCustomLoader(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/animation_effects`.
Future<ApiResponse> getAnimationEffects(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(AnimationEffectsUrls.animationEffects,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AnimationEffects.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/animation_effects`.
Future<ApiResponse> patchAnimationEffects(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(AnimationEffectsUrls.animationEffects,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AnimationEffects.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/animation_effects`.
Future<ApiResponse> headAnimationEffects(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', AnimationEffectsUrls.animationEffects,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section — `GET /admin/settings/animation_effects/{section}`.
Future<ApiResponse> getAnimationEffectsSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(AnimationEffectsUrls.animationEffectsSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AnimationEffects.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/animation_effects/{section}`.
Future<ApiResponse> patchAnimationEffectsSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(AnimationEffectsUrls.animationEffectsSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AnimationEffects.fromMap);

/// Upload the custom preloader image, as a part named `file` (svg, png, jpg,
/// jpeg or gif; the value is `[filename, contents, contentType]`). `201`, and
/// the loader reads `enabled: true`.
/// `POST /admin/settings/animation_effects/custom_loader`
Future<ApiResponse> uploadAnimationEffectsCustomLoader(
    WebCommanderClient client, Map<String, Object?> files,
    {bool? raiseOnError, String? responseFormat}) {
  if (files.isEmpty) {
    throw SdkUsageError(
        'files is required and must carry the upload: the API reads the part '
        "named 'file', whose value is [filename, contents]");
  }
  return client.sendPostRequest(
      AnimationEffectsUrls.animationEffectsCustomLoader,
      files: files,
      raiseOnError: raiseOnError,
      responseFormat: responseFormat,
      dtoDecoder: CustomLoaderSection.fromMap);
}

/// Remove the custom preloader image; `204`, also when there is none.
/// `DELETE /admin/settings/animation_effects/custom_loader`
Future<ApiResponse> deleteAnimationEffectsCustomLoader(
        WebCommanderClient client,
        {bool? raiseOnError,
        String? responseFormat}) =>
    client.sendDeleteRequest(AnimationEffectsUrls.animationEffectsCustomLoader,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _uploadAnimationEffectsCustomLoader = uploadAnimationEffectsCustomLoader;
final _deleteAnimationEffectsCustomLoader = deleteAnimationEffectsCustomLoader;
final _getAnimationEffects = getAnimationEffects;
final _patchAnimationEffects = patchAnimationEffects;
final _headAnimationEffects = headAnimationEffects;
final _getAnimationEffectsSection = getAnimationEffectsSection;
final _patchAnimationEffectsSection = patchAnimationEffectsSection;
