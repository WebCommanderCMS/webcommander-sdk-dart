import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'discount_profiles_dto.dart';
import 'discount_profiles_urls.dart';

/// Discount profile endpoints, bound to one client.
class DiscountProfiles {
  /// Bind the resource to a client; normally reached via
  /// `client.discountProfiles`.
  DiscountProfiles(this._client);

  final WebCommanderClient _client;

  /// List the profiles — `GET /admin/discount_profiles`.
  Future<ApiResponse> listDiscountProfiles({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listDiscountProfiles(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Create a profile — `POST /admin/discount_profiles`.
  Future<ApiResponse> createDiscountProfile(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createDiscountProfile(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one profile —
  /// `GET /admin/discount_profiles/{discount_profile_id}`.
  Future<ApiResponse> getDiscountProfile(
    Object discountProfileId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getDiscountProfile(_client, discountProfileId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Replace one profile —
  /// `PUT /admin/discount_profiles/{discount_profile_id}`.
  Future<ApiResponse> updateDiscountProfile(
          Object discountProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateDiscountProfile(_client, discountProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete a profile —
  /// `DELETE /admin/discount_profiles/{discount_profile_id}`.
  Future<ApiResponse> deleteDiscountProfile(Object discountProfileId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteDiscountProfile(_client, discountProfileId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Generate coupon codes on one profile —
  /// `POST /admin/discount_profiles/{discount_profile_id}/create-coupons`.
  Future<ApiResponse> createDiscountProfileCoupons(
          Object discountProfileId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createDiscountProfileCoupons(_client, discountProfileId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Give a generated code to a customer —
  /// `POST /admin/discount_coupons/assign-customer`.
  Future<ApiResponse> assignDiscountCouponCustomer(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _assignDiscountCouponCustomer(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the profiles, newest `id` first — `GET /admin/discount_profiles`.
/// `limit` caps at 20, and a name outside [DiscountProfileUrls.queryParams] is
/// ignored, not refused.
Future<ApiResponse> listDiscountProfiles(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(DiscountProfileUrls.discountProfiles,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DiscountProfilePage.fromMap);

/// Create a profile — `POST /admin/discount_profiles`, answered `201`. The body
/// is a bare record: `name`, `discount_details_type` and the block it names.
Future<ApiResponse> createDiscountProfile(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(DiscountProfileUrls.discountProfiles,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DiscountProfile.fromMap);

/// Retrieve one profile; `field_metadata` adds the schema beside it.
/// `GET /admin/discount_profiles/{discount_profile_id}`
Future<ApiResponse> getDiscountProfile(
  WebCommanderClient client,
  Object discountProfileId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(DiscountProfileUrls.discountProfile,
        pathParams: {'discount_profile_id': discountProfileId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DiscountProfile.fromMap);

/// Replace one profile: a flag, date or limit the body omits is reset.
/// `PUT /admin/discount_profiles/{discount_profile_id}`
Future<ApiResponse> updateDiscountProfile(
        WebCommanderClient client, Object discountProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(DiscountProfileUrls.discountProfile,
        pathParams: {'discount_profile_id': discountProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DiscountProfile.fromMap);

/// Delete one profile and its coupons; `204`, no body.
/// `DELETE /admin/discount_profiles/{discount_profile_id}`
Future<ApiResponse> deleteDiscountProfile(
        WebCommanderClient client, Object discountProfileId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(DiscountProfileUrls.discountProfile,
        pathParams: {'discount_profile_id': discountProfileId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Generate codes on a profile that has `is_apply_coupon_code`, from
/// `{"requested_codes": n}`; answered `201`.
/// `POST /admin/discount_profiles/{discount_profile_id}/create-coupons`
Future<ApiResponse> createDiscountProfileCoupons(
        WebCommanderClient client, Object discountProfileId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(DiscountProfileUrls.discountProfileCreateCoupons,
        pathParams: {'discount_profile_id': discountProfileId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: DiscountProfileCoupons.fromMap);

/// Give a generated code to a customer — `POST
/// /admin/discount_coupons/assign-customer`, `201`. The body is `{"code",
/// "email"}`; the answer is a verdict, so `.dto` is `null`.
Future<ApiResponse> assignDiscountCouponCustomer(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(DiscountProfileUrls.discountCouponsAssignCustomer,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listDiscountProfiles = listDiscountProfiles;
final _createDiscountProfile = createDiscountProfile;
final _getDiscountProfile = getDiscountProfile;
final _updateDiscountProfile = updateDiscountProfile;
final _deleteDiscountProfile = deleteDiscountProfile;
final _createDiscountProfileCoupons = createDiscountProfileCoupons;
final _assignDiscountCouponCustomer = assignDiscountCouponCustomer;
