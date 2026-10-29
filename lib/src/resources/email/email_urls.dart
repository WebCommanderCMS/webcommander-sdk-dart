/// Email path templates; the client fills `{api_version}`.
class EmailUrls {
  EmailUrls._();

  /// Send one email. `POST` only; `GET`, `HEAD`, `PUT`, `PATCH` and `DELETE`
  /// are `405`.
  static const String emailSend = '/api/{api_version}/admin/email/send';

  /// Names the plugin that owns the template `identifier`; a `plugin_uuid`
  /// body field is ignored.
  static const String pluginUuidHeader = 'plugin_uuid';
}
