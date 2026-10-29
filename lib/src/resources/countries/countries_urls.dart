/// Country path templates; the client fills `{api_version}`.
class CountryUrls {
  CountryUrls._();

  /// The listing. `POST` here is `405`: no country is created through this API.
  static const String countries = '/api/{api_version}/admin/countries';

  /// One country by id, code or name. `PUT` and `PATCH` here are `405`.
  static const String country =
      '/api/{api_version}/admin/countries/{country_id}';

  static const String countryStates =
      '/api/{api_version}/admin/countries/{country_id}/states';

  /// One state of one country, by id, code or name.
  static const String countryState =
      '/api/{api_version}/admin/countries/{country_id}/states/{state_id}';
}
