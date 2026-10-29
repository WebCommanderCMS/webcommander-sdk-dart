/// Shipping class path templates; the client fills `{api_version}`.
class ShippingClassUrls {
  ShippingClassUrls._();

  static const String shippingClasses =
      '/api/{api_version}/admin/shipping_classes';

  static const String shippingClassesCount =
      '/api/{api_version}/admin/shipping_classes/count';

  static const String shippingClass =
      '/api/{api_version}/admin/shipping_classes/{shipping_class_id}';

  static const String shippingClassDefault =
      '/api/{api_version}/admin/shipping_classes/{shipping_class_id}/default';
}
