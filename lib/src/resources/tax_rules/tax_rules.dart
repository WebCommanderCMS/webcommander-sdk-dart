import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'tax_rules_dto.dart';
import 'tax_rules_urls.dart';

/// Tax rule endpoints, bound to one client.
class TaxRules {
  /// Bind the resource to a client; normally reached via `client.taxRules`.
  TaxRules(this._client);

  final WebCommanderClient _client;

  /// List the tax rules — `GET /admin/tax_rules`.
  Future<ApiResponse> listTaxRules({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTaxRules(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/tax_rules`.
  Future<ApiResponse> headTaxRules(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxRules(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a tax rule — `POST /admin/tax_rules`.
  Future<ApiResponse> createTaxRule(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createTaxRule(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one tax rule — `GET /admin/tax_rules/{tax_rule_id}`.
  Future<ApiResponse> getTaxRule(Object taxRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTaxRule(_client, taxRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one tax rule is there — `HEAD /admin/tax_rules/{tax_rule_id}`.
  Future<ApiResponse> headTaxRule(Object taxRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headTaxRule(_client, taxRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Update one tax rule — `PUT /admin/tax_rules/{tax_rule_id}`.
  Future<ApiResponse> updateTaxRule(Object taxRuleId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateTaxRule(_client, taxRuleId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one tax rule — `DELETE /admin/tax_rules/{tax_rule_id}`.
  Future<ApiResponse> deleteTaxRule(Object taxRuleId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTaxRule(_client, taxRuleId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the tax rules — `GET /admin/tax_rules`. `limit` is capped at 100.
Future<ApiResponse> listTaxRules(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TaxRuleUrls.taxRules,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxRulePage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/tax_rules`.
Future<ApiResponse> headTaxRules(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxRuleUrls.taxRules,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a tax rule — `POST /admin/tax_rules`.
Future<ApiResponse> createTaxRule(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TaxRuleUrls.taxRules,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxRule.fromMap);

/// Retrieve one tax rule — `GET /admin/tax_rules/{tax_rule_id}`.
Future<ApiResponse> getTaxRule(WebCommanderClient client, Object taxRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TaxRuleUrls.taxRule,
        pathParams: {'tax_rule_id': taxRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxRule.fromMap);

/// Ask whether one tax rule is there — `HEAD /admin/tax_rules/{tax_rule_id}`.
Future<ApiResponse> headTaxRule(WebCommanderClient client, Object taxRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TaxRuleUrls.taxRule,
        pathParams: {'tax_rule_id': taxRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Update one tax rule — `PUT /admin/tax_rules/{tax_rule_id}`.
Future<ApiResponse> updateTaxRule(
        WebCommanderClient client, Object taxRuleId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(TaxRuleUrls.taxRule,
        pathParams: {'tax_rule_id': taxRuleId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TaxRule.fromMap);

/// Delete one tax rule — `DELETE /admin/tax_rules/{tax_rule_id}`.
Future<ApiResponse> deleteTaxRule(WebCommanderClient client, Object taxRuleId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TaxRuleUrls.taxRule,
        pathParams: {'tax_rule_id': taxRuleId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTaxRules = listTaxRules;
final _headTaxRules = headTaxRules;
final _createTaxRule = createTaxRule;
final _getTaxRule = getTaxRule;
final _headTaxRule = headTaxRule;
final _updateTaxRule = updateTaxRule;
final _deleteTaxRule = deleteTaxRule;
