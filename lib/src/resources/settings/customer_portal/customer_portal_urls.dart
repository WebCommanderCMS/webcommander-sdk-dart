/// Customer portal path templates; the client fills `{api_version}`.
class CustomerPortalUrls {
  CustomerPortalUrls._();

  static const String customerPortal =
      '/api/{api_version}/admin/settings/customer_portal';

  static const String customerPortalSection =
      '/api/{api_version}/admin/settings/customer_portal/{section}';
}
