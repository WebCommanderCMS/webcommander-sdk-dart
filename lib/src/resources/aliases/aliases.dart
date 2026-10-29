import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'aliases_dto.dart';
import 'aliases_urls.dart';

/// Domain alias endpoints, bound to one client.
class Aliases {
  /// Bind the resource to a client; normally reached via `client.aliases`.
  Aliases(this._client);

  final WebCommanderClient _client;

  /// List the aliases — `GET /admin/aliases`.
  Future<ApiResponse> listAliases({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listAliases(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection answers — `HEAD /admin/aliases`.
  Future<ApiResponse> headAliases(
          {bool? raiseOnError, String? responseFormat}) =>
      _headAliases(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create an alias — `POST /admin/aliases`.
  Future<ApiResponse> createAlias(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createAlias(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one alias — `DELETE /admin/aliases/{alias_id}`.
  Future<ApiResponse> deleteAlias(Object aliasId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteAlias(_client, aliasId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the aliases — `GET /admin/aliases`.
Future<ApiResponse> listAliases(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(AliasUrls.aliases,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: AliasPage.fromMap);

/// Ask whether the collection answers — `HEAD /admin/aliases`; `200`, no body.
Future<ApiResponse> headAliases(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', AliasUrls.aliases,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create an alias — `POST /admin/aliases`.
Future<ApiResponse> createAlias(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(AliasUrls.aliases,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Alias.fromMap);

/// Delete one alias — `DELETE /admin/aliases/{alias_id}`.
Future<ApiResponse> deleteAlias(WebCommanderClient client, Object aliasId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(AliasUrls.alias,
        pathParams: {'alias_id': aliasId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listAliases = listAliases;
final _headAliases = headAliases;
final _createAlias = createAlias;
final _deleteAlias = deleteAlias;
