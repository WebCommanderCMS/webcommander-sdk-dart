import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'shipping_profiles_dto.dart';
import 'shipping_profiles_urls.dart';

/// Shipping profile endpoints, bound to one client.
class ShippingProfiles {
  /// Bind the resource to a client; normally reached via `client.shippingProfiles`.
  ShippingProfiles(this._client);

  final WebCommanderClient _client;

  /// List the profiles, newest first — `GET /admin/shipping_profiles`.
  Future<ApiResponse> listShippingProfiles(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _listShippingProfiles(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/shipping_profiles`.
  Future<ApiResponse> headShippingProfiles(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingProfiles(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many profiles match — `GET /admin/shipping_profiles/count`.
  Future<ApiResponse> countShippingProfiles(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _countShippingProfiles(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable — `HEAD
  /// /admin/shipping_profiles/count`.
  Future<ApiResponse> headShippingProfilesCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingProfilesCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a profile — `POST /admin/shipping_profiles`.
  Future<ApiResponse> createShippingProfile(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createShippingProfile(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a profile with its rules and their rates in one call — `POST
  /// /admin/shipping_profiles/wizard`.
  Future<ApiResponse> createShippingProfileWizard(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createShippingProfileWizard(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one profile by its `id` — `GET
  /// /admin/shipping_profiles/{shipping_profile_id}`.
  Future<ApiResponse> getShippingProfile(Object shippingProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getShippingProfile(_client, shippingProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether a profile exists — `HEAD
  /// /admin/shipping_profiles/{shipping_profile_id}`.
  Future<ApiResponse> headShippingProfile(Object shippingProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingProfile(_client, shippingProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one profile — `PUT
  /// /admin/shipping_profiles/{shipping_profile_id}`.
  Future<ApiResponse> updateShippingProfile(
          Object shippingProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateShippingProfile(_client, shippingProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH
  /// /admin/shipping_profiles/{shipping_profile_id}`.
  Future<ApiResponse> patchShippingProfile(
          Object shippingProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShippingProfile(_client, shippingProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one profile — `DELETE
  /// /admin/shipping_profiles/{shipping_profile_id}`.
  Future<ApiResponse> deleteShippingProfile(Object shippingProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteShippingProfile(_client, shippingProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the profiles, newest first — `GET /admin/shipping_profiles`. `search`
/// (part of the name) and `default` (`true` or `false`) filter; `sort` is `id`,
/// `name`, `description`, `rule_preference`, `created_at`, `updated_at` or
/// `transaction_no` with `order` `asc` or `desc`; `limit` is 1 to 100 and
/// defaults to 20, `offset` pages. An unknown value is `400`; an unknown name
/// is ignored.
Future<ApiResponse> listShippingProfiles(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingProfileUrls.shippingProfiles,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfileListing.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/shipping_profiles`;
/// no body.
Future<ApiResponse> headShippingProfiles(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingProfileUrls.shippingProfiles,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many profiles match — `GET /admin/shipping_profiles/count`, a bare
/// `{"total": N}`. `search` and `default` narrow it.
Future<ApiResponse> countShippingProfiles(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingProfileUrls.shippingProfilesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfileCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/shipping_profiles/count`;
/// no body.
Future<ApiResponse> headShippingProfilesCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingProfileUrls.shippingProfilesCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a profile — `POST /admin/shipping_profiles`, answered `201` with a
/// `Location`. The body is wrapped in `shipping_profile` and needs `name`,
/// unique without regard to case (`409`); `rule_preference` defaults to
/// `product_assigned_rule`. An unknown field, an `id` or an unwrapped body is
/// `400`. [transactionNo] is sent as `X-Transaction-No`.
Future<ApiResponse> createShippingProfile(
        WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingProfileUrls.shippingProfiles,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ShippingProfileUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfile.fromMap);

/// Create a profile with its rules and their rates in one call — `POST
/// /admin/shipping_profiles/wizard`. A new profile name is `201`; a name that
/// exists adds the rules to that profile and is `200`. Every rule's rate, class
/// and zone is checked first, and one bad value saves nothing. A zone given as
/// `{"name": ...}` is created.
Future<ApiResponse> createShippingProfileWizard(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingProfileUrls.shippingProfilesWizard,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfile.fromMap);

/// Retrieve one profile by its `id` — `GET
/// /admin/shipping_profiles/{shipping_profile_id}`, the row under
/// `shipping_profile`. An id that is not plain digits, or unknown, is `404`.
Future<ApiResponse> getShippingProfile(
        WebCommanderClient client, Object shippingProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ShippingProfileUrls.shippingProfile,
        pathParams: {'shipping_profile_id': shippingProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfile.fromMap);

/// Ask whether a profile exists — `HEAD
/// /admin/shipping_profiles/{shipping_profile_id}`; 200 with no body, 404 for
/// an unknown id.
Future<ApiResponse> headShippingProfile(
        WebCommanderClient client, Object shippingProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingProfileUrls.shippingProfile,
        pathParams: {'shipping_profile_id': shippingProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one profile — `PUT /admin/shipping_profiles/{shipping_profile_id}`.
/// `name`, `description`, `rule_preference` and `shipping_rules` are all
/// required (`description` may be `null`); the rules not listed are taken off
/// the profile and kept.
Future<ApiResponse> updateShippingProfile(
        WebCommanderClient client, Object shippingProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingProfileUrls.shippingProfile,
        pathParams: {'shipping_profile_id': shippingProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfile.fromMap);

/// Change only the fields sent — `PATCH
/// /admin/shipping_profiles/{shipping_profile_id}`. `shipping_rules` is the
/// full list, so `[]` takes every rule off. `default` true moves the store
/// default to this profile; the default cannot be switched off directly
/// (`409`).
Future<ApiResponse> patchShippingProfile(
        WebCommanderClient client, Object shippingProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShippingProfileUrls.shippingProfile,
        pathParams: {'shipping_profile_id': shippingProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingProfile.fromMap);

/// Delete one profile — `DELETE
/// /admin/shipping_profiles/{shipping_profile_id}`, `204`. Its rules and zones
/// stay. The store default is `409` until another profile holds the flag.
Future<ApiResponse> deleteShippingProfile(
        WebCommanderClient client, Object shippingProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ShippingProfileUrls.shippingProfile,
        pathParams: {'shipping_profile_id': shippingProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listShippingProfiles = listShippingProfiles;
final _headShippingProfiles = headShippingProfiles;
final _countShippingProfiles = countShippingProfiles;
final _headShippingProfilesCount = headShippingProfilesCount;
final _createShippingProfile = createShippingProfile;
final _createShippingProfileWizard = createShippingProfileWizard;
final _getShippingProfile = getShippingProfile;
final _headShippingProfile = headShippingProfile;
final _updateShippingProfile = updateShippingProfile;
final _patchShippingProfile = patchShippingProfile;
final _deleteShippingProfile = deleteShippingProfile;
