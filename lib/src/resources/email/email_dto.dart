/// Typed views over the email send bodies.
library;

import '../../client/dto.dart';

/// The send body, bare and camelCase as the store takes it; `html_content` and
/// other unknown keys are ignored. `recipients`, `cc` and `bcc` hold at most 100
/// addresses together. Send `htmlContent` or a plugin template's `identifier`,
/// not both.
class EmailInput extends Dto {
  const EmailInput({
    this.recipients,
    this.cc,
    this.bcc,
    this.subject,
    this.htmlContent,
    this.contentType,
    this.identifier,
    this.data,
  });

  final List<String?>? recipients;

  final List<String?>? cc;

  final List<String?>? bcc;

  final String? subject;

  final String? htmlContent;

  /// `contentType` — `html`, `text` or `text/html`.
  final String? contentType;

  final String? identifier;

  /// `data` — the template's variables, an object of any shape.
  final Object? data;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'recipients': recipients,
        'cc': cc,
        'bcc': bcc,
        'subject': subject,
        'htmlContent': htmlContent,
        'contentType': contentType,
        'identifier': identifier,
        'data': data,
      };
}

/// One address the store could not send to, and why, such as `send_failed`.
class EmailRejection extends Dto {
  const EmailRejection({this.email, this.reason});

  /// Reads one entry of `rejected`.
  static EmailRejection? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return EmailRejection(
      email: readText(source['email']),
      reason: readText(source['reason']),
    );
  }

  final String? email;

  final String? reason;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'email': email,
        'reason': reason,
      };
}

/// The send's verdict: each list holds the addresses trimmed, a repeat in any
/// case once.
class EmailSendResult extends Dto {
  const EmailSendResult({
    this.status,
    this.accepted,
    this.rejected,
    this.cc,
    this.bcc,
  });

  /// Reads a send body.
  static EmailSendResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return EmailSendResult(
      status: readText(source['status']),
      accepted: readList<String>(source['accepted'], readText),
      rejected:
          readList<EmailRejection>(source['rejected'], EmailRejection.fromMap),
      cc: readList<String>(source['cc'], readText),
      bcc: readList<String>(source['bcc'], readText),
    );
  }

  final String? status;

  final List<String?>? accepted;

  final List<EmailRejection?>? rejected;

  final List<String?>? cc;

  final List<String?>? bcc;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'accepted': accepted,
        'rejected': rejected,
        'cc': cc,
        'bcc': bcc,
      };
}
