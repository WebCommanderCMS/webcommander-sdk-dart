import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'shipping_rules_dto.dart';
import 'shipping_rules_urls.dart';

/// Shipping rule endpoints, bound to one client.
class ShippingRules {
  /// Bind the resource to a client; normally reached via `client.shippingRules`.
  ShippingRules(this._client);

  final WebCommanderClient _client;

  /// List the rules, newest first — `GET /admin/shipping_rules`.
  Future<ApiResponse> listShippingRules(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _listShippingRules(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/shipping_rules`.
  Future<ApiResponse> headShippingRules(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRules(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// How many rules match — `GET /admin/shipping_rules/count`.
  Future<ApiResponse> countShippingRules(
          {Map<String, Object?>? queryParams,
          bool? raiseOnError,
          String? responseFormat}) =>
      _countShippingRules(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the count is reachable — `HEAD /admin/shipping_rules/count`.
  Future<ApiResponse> headShippingRulesCount(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRulesCount(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a rule — `POST /admin/shipping_rules`.
  Future<ApiResponse> createShippingRule(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createShippingRule(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Retrieve one rule by its `id` — `GET
  /// /admin/shipping_rules/{shipping_rule_id}`.
  Future<ApiResponse> getShippingRule(Object shippingRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getShippingRule(_client, shippingRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether a rule exists — `HEAD
  /// /admin/shipping_rules/{shipping_rule_id}`.
  Future<ApiResponse> headShippingRule(Object shippingRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headShippingRule(_client, shippingRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one rule — `PUT /admin/shipping_rules/{shipping_rule_id}`.
  Future<ApiResponse> updateShippingRule(Object shippingRuleId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateShippingRule(_client, shippingRuleId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Change only the fields sent — `PATCH
  /// /admin/shipping_rules/{shipping_rule_id}`.
  Future<ApiResponse> patchShippingRule(Object shippingRuleId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShippingRule(_client, shippingRuleId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one rule — `DELETE /admin/shipping_rules/{shipping_rule_id}`.
  Future<ApiResponse> deleteShippingRule(Object shippingRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteShippingRule(_client, shippingRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the rules, newest first — `GET /admin/shipping_rules`. `search` (part
/// of the name), `shipping_class_id`, `zone_id`, `method` (the method of the
/// rule's rate) and `handling_cost` (`with_handling` or `without_handling`)
/// filter, each rule listed once; `sort` is `id`, `name`, `description`,
/// `created_at`, `updated_at` or `transaction_no` with `order` `asc` or `desc`;
/// `limit` is 1 to 100 and defaults to 20, `offset` pages. An unknown value or
/// an id that names no record is `400`.
Future<ApiResponse> listShippingRules(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingRuleUrls.shippingRules,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRuleListing.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/shipping_rules`; no
/// body.
Future<ApiResponse> headShippingRules(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRuleUrls.shippingRules,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// How many rules match — `GET /admin/shipping_rules/count`, a bare `{"total":
/// N}`. The listing's filters narrow it.
Future<ApiResponse> countShippingRules(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(ShippingRuleUrls.shippingRulesCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRuleCount.fromMap);

/// Ask whether the count is reachable — `HEAD /admin/shipping_rules/count`; no
/// body.
Future<ApiResponse> headShippingRulesCount(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRuleUrls.shippingRulesCount,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a rule — `POST /admin/shipping_rules`, answered `201` with a
/// `Location`. The body is wrapped in `shipping_rule` and needs `name`, unique
/// without regard to case (`409`). A class, a rate and every zone must exist,
/// `zones` without a repeat; a `profile_id` adds the rule to that profile. An
/// unknown field, an `id` or an unwrapped body is `400`. [transactionNo] is
/// sent as `X-Transaction-No`.
Future<ApiResponse> createShippingRule(
        WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(ShippingRuleUrls.shippingRules,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {ShippingRuleUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRule.fromMap);

/// Retrieve one rule by its `id` — `GET
/// /admin/shipping_rules/{shipping_rule_id}`, the row under `shipping_rule`. An
/// id that is not plain digits, or unknown, is `404`.
Future<ApiResponse> getShippingRule(
        WebCommanderClient client, Object shippingRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(ShippingRuleUrls.shippingRule,
        pathParams: {'shipping_rule_id': shippingRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRule.fromMap);

/// Ask whether a rule exists — `HEAD /admin/shipping_rules/{shipping_rule_id}`;
/// 200 with no body, 404 for an unknown id.
Future<ApiResponse> headShippingRule(
        WebCommanderClient client, Object shippingRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShippingRuleUrls.shippingRule,
        pathParams: {'shipping_rule_id': shippingRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one rule — `PUT /admin/shipping_rules/{shipping_rule_id}`. `name`,
/// `description`, `shipping_class`, `shipping_rate` and `zones` are all
/// required; the first three may be `null` and `zones` `[]`. The rate and the
/// zones themselves stay.
Future<ApiResponse> updateShippingRule(
        WebCommanderClient client, Object shippingRuleId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(ShippingRuleUrls.shippingRule,
        pathParams: {'shipping_rule_id': shippingRuleId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRule.fromMap);

/// Change only the fields sent — `PATCH
/// /admin/shipping_rules/{shipping_rule_id}`. `zones` is the full list, so `[]`
/// takes every zone off; `shipping_rate` and `shipping_class` `null` take the
/// rate or the class off. The records themselves stay.
Future<ApiResponse> patchShippingRule(
        WebCommanderClient client, Object shippingRuleId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShippingRuleUrls.shippingRule,
        pathParams: {'shipping_rule_id': shippingRuleId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShippingRule.fromMap);

/// Delete one rule — `DELETE /admin/shipping_rules/{shipping_rule_id}`, `204`.
/// Its rate and zones stay. A rule on a profile is `409` until it is taken off.
Future<ApiResponse> deleteShippingRule(
        WebCommanderClient client, Object shippingRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(ShippingRuleUrls.shippingRule,
        pathParams: {'shipping_rule_id': shippingRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listShippingRules = listShippingRules;
final _headShippingRules = headShippingRules;
final _countShippingRules = countShippingRules;
final _headShippingRulesCount = headShippingRulesCount;
final _createShippingRule = createShippingRule;
final _getShippingRule = getShippingRule;
final _headShippingRule = headShippingRule;
final _updateShippingRule = updateShippingRule;
final _patchShippingRule = patchShippingRule;
final _deleteShippingRule = deleteShippingRule;
