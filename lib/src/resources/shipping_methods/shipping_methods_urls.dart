/// Shipping method path templates; the client fills `{api_version}`.
class ShippingMethodUrls {
  ShippingMethodUrls._();

  /// List and create.
  static const String shippingMethods =
      '/api/{api_version}/admin/shipping_methods';

  /// How many rows the collection holds.
  static const String shippingMethodsCount =
      '/api/{api_version}/admin/shipping_methods/count';

  /// One method by id.
  static const String shippingMethod =
      '/api/{api_version}/admin/shipping_methods/{shipping_method_id}';

  /// Hand one method the `is_default` flag. `PUT` only, and it takes no body.
  static const String shippingMethodDefault =
      '/api/{api_version}/admin/shipping_methods/{shipping_method_id}/default';
}
