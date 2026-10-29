/// Tax zone path templates; the client fills `{api_version}`.
class TaxZoneUrls {
  TaxZoneUrls._();

  /// List and create tax zones.
  static const String taxZones = '/api/{api_version}/admin/tax_zones';

  /// One tax zone by id.
  static const String taxZone =
      '/api/{api_version}/admin/tax_zones/{tax_zone_id}';

  /// The page size when `limit` is not sent, and the ceiling on one that is.
  static const int pageSize = 20;
}
