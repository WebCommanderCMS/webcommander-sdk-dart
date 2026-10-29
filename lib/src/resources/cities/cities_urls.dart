/// City path templates; the client fills `{api_version}`.
class CityUrls {
  CityUrls._();

  /// Under `/app`, not `/admin`: the storefront address lookup. A write here is
  /// `405`, and `/app/cities/{city_id}` is `404`.
  static const String cities = '/api/{api_version}/app/cities';
}
