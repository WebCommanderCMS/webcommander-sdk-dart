/// Common settings path templates; the client fills `{api_version}`.
class CommonSettingsUrls {
  CommonSettingsUrls._();

  /// Not under `/admin`: the store-wide settings, read by group and written as
  /// `config_key` and `value` pairs.
  static const String settings = '/api/{api_version}/settings';

  /// Not under `/admin`: the customer registration form those settings shape.
  static const String createCustomerFields =
      '/api/{api_version}/create-customer-fields';
}
