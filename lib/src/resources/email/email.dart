import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'email_dto.dart';
import 'email_urls.dart';

/// Email endpoints, bound to one client.
class Email {
  /// Bind the resource to a client; normally reached via `client.email`.
  Email(this._client);

  final WebCommanderClient _client;

  /// Send an email — `POST /admin/email/send`.
  Future<ApiResponse> sendEmail(Object payload,
          {String? pluginUuid, bool? raiseOnError, String? responseFormat}) =>
      _sendEmail(_client, payload,
          pluginUuid: pluginUuid,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// Send an email — `POST /admin/email/send`, answered `200` once every message
/// is sent. A bare body: `recipients` and `subject`, with `htmlContent` or a
/// template `identifier` and its `data`. [pluginUuid] is sent as the header a
/// template send needs and switches the call to plugin auth, so an admin token
/// is `401`. Past 500 addresses a day per sender the store answers `429` until
/// 00:00 UTC; a body over 1048576 bytes is `413`. A send the mail server fails
/// is `502`, `status` `failed`, each address in `rejected`.
Future<ApiResponse> sendEmail(WebCommanderClient client, Object payload,
        {String? pluginUuid, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(EmailUrls.emailSend,
        jsonBody: payload,
        headers: pluginUuid == null
            ? null
            : {EmailUrls.pluginUuidHeader: pluginUuid},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: EmailSendResult.fromMap);

final _sendEmail = sendEmail;
