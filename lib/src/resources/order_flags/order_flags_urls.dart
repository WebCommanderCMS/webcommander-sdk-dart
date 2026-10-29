/// Order flag path templates; the client fills `{api_version}`.
class OrderFlagUrls {
  OrderFlagUrls._();

  /// List and create.
  static const String orderFlags = '/api/{api_version}/admin/order_flags';

  /// One flag by id.
  static const String orderFlag =
      '/api/{api_version}/admin/order_flags/{order_flag_id}';
}
