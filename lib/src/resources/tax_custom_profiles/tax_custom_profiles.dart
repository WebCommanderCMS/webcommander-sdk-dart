import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_custom_profiles_dto.dart';
import 'tax_custom_profiles_urls.dart';

/// Custom tax profile endpoints, bound to one client; no path here serves `HEAD`.
class TaxCustomProfiles {
  /// Bind the resource to a client; normally reached via `client.taxCustomProfiles`.
  TaxCustomProfiles(this._client);

  final WebCommanderClient _client;

  /// List the custom profiles — `GET /admin/tax/custom-profiles`.
  Future<ApiResponse> listTaxCustomProfiles({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxCustomProfiles(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a custom profile — `POST /admin/tax/custom-profiles`.
  Future<ApiResponse> createTaxCustomProfile(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createTaxCustomProfile(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one custom profile —
  /// `GET /admin/tax/custom-profiles/{custom_profile_id}`.
  Future<ApiResponse> getTaxCustomProfile(Object customProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxCustomProfile(_client, customProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one custom profile —
  /// `PUT /admin/tax/custom-profiles/{custom_profile_id}`.
  Future<ApiResponse> updateTaxCustomProfile(
          Object customProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxCustomProfile(_client, customProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one custom profile —
  /// `DELETE /admin/tax/custom-profiles/{custom_profile_id}`.
  Future<ApiResponse> deleteTaxCustomProfile(Object customProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxCustomProfile(_client, customProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the custom profiles — `GET /admin/tax/custom-profiles`, newest first.
/// `limit` is 1 to 100 with the cap echoed, `offset` or `page` move the window,
/// `sort` takes `id` or `name`.
Future<ApiResponse> listTaxCustomProfiles(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxCustomProfileUrls.taxCustomProfiles,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomProfilePage.fromMap);

/// Create a custom profile — `POST /admin/tax/custom-profiles`, answered `201`.
/// The body is wrapped in `custom_profile` and needs `name`. [transactionNo] is
/// sent as `X-Transaction-No` and files the profile under that number.
Future<ApiResponse> createTaxCustomProfile(
        WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxCustomProfileUrls.taxCustomProfiles,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {TaxCustomProfileUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomProfile.fromMap);

/// Retrieve one custom profile —
/// `GET /admin/tax/custom-profiles/{custom_profile_id}`; with an `ETag`, and
/// only this form carries `rules`.
Future<ApiResponse> getTaxCustomProfile(
        WebCommanderClient client, Object customProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxCustomProfileUrls.taxCustomProfile,
        pathParams: {'custom_profile_id': customProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomProfile.fromMap);

/// Replace one custom profile —
/// `PUT /admin/tax/custom-profiles/{custom_profile_id}`. An omitted `name` is
/// kept; an omitted `description` or `tax_code` comes back `null`.
Future<ApiResponse> updateTaxCustomProfile(
        WebCommanderClient client, Object customProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxCustomProfileUrls.taxCustomProfile,
        pathParams: {'custom_profile_id': customProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CustomProfile.fromMap);

/// Delete one custom profile —
/// `DELETE /admin/tax/custom-profiles/{custom_profile_id}`; `204`, no body.
Future<ApiResponse> deleteTaxCustomProfile(
        WebCommanderClient client, Object customProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxCustomProfileUrls.taxCustomProfile,
        pathParams: {'custom_profile_id': customProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxCustomProfiles = listTaxCustomProfiles;
final _createTaxCustomProfile = createTaxCustomProfile;
final _getTaxCustomProfile = getTaxCustomProfile;
final _updateTaxCustomProfile = updateTaxCustomProfile;
final _deleteTaxCustomProfile = deleteTaxCustomProfile;
