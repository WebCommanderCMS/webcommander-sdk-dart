import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'cities_dto.dart';
import 'cities_urls.dart';

/// City endpoints, bound to one client.
class Cities {
  /// Bind the resource to a client; normally reached via `client.cities`.
  Cities(this._client);

  final WebCommanderClient _client;

  /// List the cities, by state, post code and name unless `sort` says
  /// otherwise — `GET /app/cities`.
  Future<ApiResponse> listCities({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCities(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the listing is reachable — `HEAD /app/cities`.
  Future<ApiResponse> headCities(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCities(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the cities, by state, post code and name unless `sort` says otherwise
/// — `GET /app/cities`. `limit` is the page size, 1 to 100 and 100 when absent;
/// `offset` the start. `country` takes a country id or two-letter code, `state`
/// a state id or, beside `country`, a state code; `post_code` matches exactly
/// and `search` a substring of `name` in any case. `sort` is `state`, `name` or
/// `post_code`, `order` `asc` or `desc`.
Future<ApiResponse> listCities(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CityUrls.cities,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CityPage.fromMap);

/// Ask whether the listing is reachable — `HEAD /app/cities`; the listing's
/// headers, its `ETag` among them, and no body.
Future<ApiResponse> headCities(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CityUrls.cities,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _listCities = listCities;
final _headCities = headCities;
