import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_profiles_dto.dart';
import 'tax_profiles_urls.dart';

/// Tax profile endpoints, bound to one client.
class TaxProfiles {
  /// Bind the resource to a client; normally reached via `client.taxProfiles`.
  TaxProfiles(this._client);

  final WebCommanderClient _client;

  /// List the tax profiles — `GET /admin/tax_profiles`.
  Future<ApiResponse> listTaxProfiles({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxProfiles(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/tax_profiles`.
  Future<ApiResponse> headTaxProfiles(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxProfiles(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a tax profile — `POST /admin/tax_profiles`.
  Future<ApiResponse> createTaxProfile(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createTaxProfile(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one tax profile — `GET /admin/tax_profiles/{tax_profile_id}`.
  Future<ApiResponse> getTaxProfile(Object taxProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxProfile(_client, taxProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one tax profile is there —
  /// `HEAD /admin/tax_profiles/{tax_profile_id}`.
  Future<ApiResponse> headTaxProfile(Object taxProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxProfile(_client, taxProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one tax profile — `PUT /admin/tax_profiles/{tax_profile_id}`.
  Future<ApiResponse> updateTaxProfile(Object taxProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxProfile(_client, taxProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one tax profile — `DELETE /admin/tax_profiles/{tax_profile_id}`.
  Future<ApiResponse> deleteTaxProfile(Object taxProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxProfile(_client, taxProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the tax profiles — `GET /admin/tax_profiles`.
Future<ApiResponse> listTaxProfiles(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxProfileUrls.taxProfiles,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxProfilePage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/tax_profiles`.
Future<ApiResponse> headTaxProfiles(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxProfileUrls.taxProfiles,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a tax profile — `POST /admin/tax_profiles`.
Future<ApiResponse> createTaxProfile(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxProfileUrls.taxProfiles,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxProfile.fromMap);

/// Retrieve one tax profile — `GET /admin/tax_profiles/{tax_profile_id}`.
Future<ApiResponse> getTaxProfile(
        WebCommanderClient client, Object taxProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxProfileUrls.taxProfile,
        pathParams: {'tax_profile_id': taxProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxProfile.fromMap);

/// Ask whether one tax profile is there —
/// `HEAD /admin/tax_profiles/{tax_profile_id}`.
Future<ApiResponse> headTaxProfile(
        WebCommanderClient client, Object taxProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxProfileUrls.taxProfile,
        pathParams: {'tax_profile_id': taxProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Update one tax profile — `PUT /admin/tax_profiles/{tax_profile_id}`.
Future<ApiResponse> updateTaxProfile(
        WebCommanderClient client, Object taxProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxProfileUrls.taxProfile,
        pathParams: {'tax_profile_id': taxProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxProfile.fromMap);

/// Delete one tax profile — `DELETE /admin/tax_profiles/{tax_profile_id}`.
Future<ApiResponse> deleteTaxProfile(
        WebCommanderClient client, Object taxProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxProfileUrls.taxProfile,
        pathParams: {'tax_profile_id': taxProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxProfiles = listTaxProfiles;
final _headTaxProfiles = headTaxProfiles;
final _createTaxProfile = createTaxProfile;
final _getTaxProfile = getTaxProfile;
final _headTaxProfile = headTaxProfile;
final _updateTaxProfile = updateTaxProfile;
final _deleteTaxProfile = deleteTaxProfile;
