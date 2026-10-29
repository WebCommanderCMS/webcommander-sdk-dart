import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'countries_dto.dart';
import 'countries_urls.dart';

/// Country endpoints, bound to one client.
class Countries {
  /// Bind the resource to a client; normally reached via `client.countries`.
  Countries(this._client);

  final WebCommanderClient _client;

  /// List the countries — `GET /admin/countries`.
  Future<ApiResponse> listCountries({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCountries(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/countries`.
  Future<ApiResponse> headCountries(
          {bool? raiseOnError, String? responseFormat}) =>
      _headCountries(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one country — `GET /admin/countries/{country_id}`.
  Future<ApiResponse> getCountry(Object countryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCountry(_client, countryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one country is there — `HEAD /admin/countries/{country_id}`.
  Future<ApiResponse> headCountry(Object countryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headCountry(_client, countryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List one country's states —
  /// `GET /admin/countries/{country_id}/states`.
  Future<ApiResponse> listCountryStates(
    Object countryId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listCountryStates(_client, countryId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether one country's states are reachable —
  /// `HEAD /admin/countries/{country_id}/states`.
  Future<ApiResponse> headCountryStates(Object countryId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headCountryStates(_client, countryId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one state of one country —
  /// `GET /admin/countries/{country_id}/states/{state_id}`.
  Future<ApiResponse> getCountryState(Object countryId, Object stateId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCountryState(_client, countryId, stateId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one state of one country is there —
  /// `HEAD /admin/countries/{country_id}/states/{state_id}`.
  Future<ApiResponse> headCountryState(Object countryId, Object stateId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headCountryState(_client, countryId, stateId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List the countries — `GET /admin/countries`, `id` ascending. `limit` is 1 to
/// 100 or `all`; `code`, `name` and `id` match exactly, `search` a substring of
/// `name` or `code`; `sort` takes `id`, `name` or `code` with `order`.
Future<ApiResponse> listCountries(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CountryUrls.countries,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/countries`; no body,
/// and the `ETag` the listing's first page carries.
Future<ApiResponse> headCountries(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CountryUrls.countries,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Retrieve one country — `GET /admin/countries/{country_id}`. The slot takes
/// the numeric `id`, the ISO `code` or the `name`, in any case.
Future<ApiResponse> getCountry(WebCommanderClient client, Object countryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CountryUrls.country,
        pathParams: {'country_id': countryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Country.fromMap);

/// Ask whether one country is there — `HEAD /admin/countries/{country_id}`; no
/// body, and the `ETag` its read carries.
Future<ApiResponse> headCountry(WebCommanderClient client, Object countryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CountryUrls.country,
        pathParams: {'country_id': countryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// List one country's states, beside the short parent country —
/// `GET /admin/countries/{country_id}/states`; the query names of [listCountries].
Future<ApiResponse> listCountryStates(
  WebCommanderClient client,
  Object countryId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CountryUrls.countryStates,
        pathParams: {'country_id': countryId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryStatePage.fromMap);

/// Ask whether one country's states are reachable —
/// `HEAD /admin/countries/{country_id}/states`; no body, and the `ETag` the
/// state listing's first page carries.
Future<ApiResponse> headCountryStates(
        WebCommanderClient client, Object countryId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CountryUrls.countryStates,
        pathParams: {'country_id': countryId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Retrieve one state of one country; `stateId` takes the state's `id`, `code`
/// or `name`, in any case. `GET /admin/countries/{country_id}/states/{state_id}`
Future<ApiResponse> getCountryState(
        WebCommanderClient client, Object countryId, Object stateId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CountryUrls.countryState,
        pathParams: {'country_id': countryId, 'state_id': stateId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: CountryState.fromMap);

/// Ask whether one state of one country is there —
/// `HEAD /admin/countries/{country_id}/states/{state_id}`; no body, and the
/// `ETag` its read carries.
Future<ApiResponse> headCountryState(
        WebCommanderClient client, Object countryId, Object stateId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', CountryUrls.countryState,
        pathParams: {'country_id': countryId, 'state_id': stateId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listCountries = listCountries;
final _headCountries = headCountries;
final _getCountry = getCountry;
final _headCountry = headCountry;
final _listCountryStates = listCountryStates;
final _headCountryStates = headCountryStates;
final _getCountryState = getCountryState;
final _headCountryState = headCountryState;
