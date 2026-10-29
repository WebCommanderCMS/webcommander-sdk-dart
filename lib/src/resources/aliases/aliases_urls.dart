/// Domain alias path templates; the client fills `{api_version}`.
class AliasUrls {
  AliasUrls._();

  static const String aliases = '/api/{api_version}/admin/aliases';

  /// One alias by id; it serves `DELETE` alone.
  static const String alias = '/api/{api_version}/admin/aliases/{alias_id}';
}
