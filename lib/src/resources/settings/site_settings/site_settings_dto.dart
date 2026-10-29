/// Typed views over the site settings bodies.
library;

import '../../../client/dto.dart';

/// A country or a state as a read sends it.
class Region extends Dto {
  const Region({this.id, this.code, this.name});

  static Region? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Region(
      id: readInteger(source['id']),
      code: readText(source['code']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? code;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'name': name,
      };
}

/// The `auto_suggest.addresses` block — whether addresses are suggested as they
/// are typed and whether the chosen one is then validated.
class AutoSuggestAddresses extends Dto {
  const AutoSuggestAddresses({this.enabled, this.validate});

  static AutoSuggestAddresses? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AutoSuggestAddresses(
      enabled: readFlag(source['enabled']),
      validate: readFlag(source['validate']),
    );
  }

  final bool? enabled;

  final bool? validate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'validate': validate,
      };
}

/// The `auto_suggest` block — address and suburb suggestions.
class AutoSuggest extends Dto {
  const AutoSuggest({this.addresses, this.suburbsCities});

  static AutoSuggest? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AutoSuggest(
      addresses: AutoSuggestAddresses.fromMap(source['addresses']),
      suburbsCities: readFlag(source['suburbs_cities']),
    );
  }

  final AutoSuggestAddresses? addresses;

  final bool? suburbsCities;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'addresses': addresses,
        'suburbs_cities': suburbsCities,
      };
}

/// The `captcha` block — the challenge shown on store forms, and the provider
/// keys behind it.
class Captcha extends Dto {
  const Captcha({
    this.enabled,
    this.useOwn,
    this.version,
    this.type,
    this.publicKey,
    this.privateKey,
    this.publicKeyV3,
    this.privateKeyV3,
    this.publicKeyTurnstile,
    this.privateKeyTurnstile,
    this.minimumScore,
  });

  static Captcha? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Captcha(
      enabled: readFlag(source['enabled']),
      useOwn: readFlag(source['use_own']),
      version: readText(source['version']),
      type: readText(source['type']),
      publicKey: readText(source['public_key']),
      privateKey: readText(source['private_key']),
      publicKeyV3: readText(source['public_key_v3']),
      privateKeyV3: readText(source['private_key_v3']),
      publicKeyTurnstile: readText(source['public_key_turnstile']),
      privateKeyTurnstile: readText(source['private_key_turnstile']),
      minimumScore: readDecimal(source['minimum_score']),
    );
  }

  final bool? enabled;

  final bool? useOwn;

  final String? version;

  /// `type` — a field of the body, not a `field_metadata` entry's `type` key.
  final String? type;

  final String? publicKey;

  /// `private_key` — marked `secret: true`, read back as `***`, and hidden by
  /// this SDK's own redaction.
  final String? privateKey;

  final String? publicKeyV3;

  /// `private_key_v3` — the same masking and the same redaction as [privateKey].
  final String? privateKeyV3;

  /// `public_key_turnstile` — sent by the store and described by no metadata entry.
  final String? publicKeyTurnstile;

  /// `private_key_turnstile` — described by nothing either, and redacted here.
  final String? privateKeyTurnstile;

  /// `minimum_score` — typed against the body, which sends a number, rather
  /// than against `field_metadata`, which calls it a string.
  final double? minimumScore;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'use_own': useOwn,
        'version': version,
        'type': type,
        'public_key': publicKey,
        'private_key': privateKey,
        'public_key_v3': publicKeyV3,
        'private_key_v3': privateKeyV3,
        'public_key_turnstile': publicKeyTurnstile,
        'private_key_turnstile': privateKeyTurnstile,
        'minimum_score': minimumScore,
      };
}

/// The `administration` section — units, precision, default region, error pages
/// and the CAPTCHA block.
class Administration extends Dto {
  const Administration({
    this.page404,
    this.page403,
    this.defaultState,
    this.defaultCountry,
    this.maxPrecision,
    this.unitLength,
    this.unitWeight,
    this.ecommerceEnabled,
    this.captcha,
    this.autoSuggest,
  });

  static Administration? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'administration');
    if (source == null) return null;
    return Administration(
      page404: readText(source['page_404']),
      page403: readText(source['page_403']),
      defaultState: Region.fromMap(source['default_state']),
      defaultCountry: Region.fromMap(source['default_country']),
      maxPrecision: readInteger(source['max_precision']),
      unitLength: readText(source['unit_length']),
      unitWeight: readText(source['unit_weight']),
      ecommerceEnabled: readFlag(source['ecommerce_enabled']),
      captcha: Captcha.fromMap(source['captcha']),
      autoSuggest: AutoSuggest.fromMap(source['auto_suggest']),
    );
  }

  /// `page_404` — a page slug; one that names no page is `400 invalid_page`.
  final String? page404;

  /// `page_403` — a page slug, checked as [page404] is.
  final String? page403;

  final Region? defaultState;

  final Region? defaultCountry;

  final int? maxPrecision;

  final String? unitLength;

  final String? unitWeight;

  final bool? ecommerceEnabled;

  final Captcha? captcha;

  final AutoSuggest? autoSuggest;

  @override
  String? get envelopeKey => 'administration';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page_404': page404,
        'page_403': page403,
        'default_state': defaultState,
        'default_country': defaultCountry,
        'max_precision': maxPrecision,
        'unit_length': unitLength,
        'unit_weight': unitWeight,
        'ecommerce_enabled': ecommerceEnabled,
        'captcha': captcha,
        'auto_suggest': autoSuggest,
      };
}

/// The `brand_kit.colors` block — six roles, each a hex colour.
class BrandColors extends Dto {
  const BrandColors({
    this.primary,
    this.secondary,
    this.accent,
    this.background,
    this.surface,
    this.text,
  });

  static BrandColors? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BrandColors(
      primary: readText(source['primary']),
      secondary: readText(source['secondary']),
      accent: readText(source['accent']),
      background: readText(source['background']),
      surface: readText(source['surface']),
      text: readText(source['text']),
    );
  }

  final String? primary;

  final String? secondary;

  final String? accent;

  final String? background;

  final String? surface;

  final String? text;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'primary': primary,
        'secondary': secondary,
        'accent': accent,
        'background': background,
        'surface': surface,
        'text': text,
      };
}

/// The `brand_kit` section — the site-wide palette.
class BrandKit extends Dto {
  const BrandKit({this.enabled, this.paletteName, this.colors});

  static BrandKit? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'brand_kit');
    if (source == null) return null;
    return BrandKit(
      enabled: readFlag(source['enabled']),
      paletteName: readText(source['palette_name']),
      colors: BrandColors.fromMap(source['colors']),
    );
  }

  final bool? enabled;

  final String? paletteName;

  final BrandColors? colors;

  @override
  String? get envelopeKey => 'brand_kit';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'palette_name': paletteName,
        'colors': colors,
      };
}

/// The three fields every `date_time` audience block carries — how a date and a
/// time are rendered for it and in which zone.
class DateTimeFormat extends Dto {
  const DateTimeFormat({this.dateFormat, this.timeFormat, this.timeZone});

  static DateTimeFormat? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DateTimeFormat(
      dateFormat: readText(source['date_format']),
      timeFormat: readText(source['time_format']),
      timeZone: readText(source['time_zone']),
    );
  }

  final String? dateFormat;

  final String? timeFormat;

  final String? timeZone;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'date_format': dateFormat,
        'time_format': timeFormat,
        'time_zone': timeZone,
      };
}

/// The `date_time.admin` block — the admin area's own formats, and the only one
/// of the three that carries [firstDayOfWeek].
class AdminDateTime extends DateTimeFormat {
  const AdminDateTime({
    super.dateFormat,
    super.timeFormat,
    super.timeZone,
    this.firstDayOfWeek,
  });

  static AdminDateTime? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AdminDateTime(
      dateFormat: readText(source['date_format']),
      timeFormat: readText(source['time_format']),
      timeZone: readText(source['time_zone']),
      firstDayOfWeek: readText(source['first_day_of_week']),
    );
  }

  final String? firstDayOfWeek;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'first_day_of_week': firstDayOfWeek,
      };
}

/// The `date_time.email` and `date_time.user` blocks — the same three formats
/// and a [separate] flag beside them.
class SeparableDateTime extends DateTimeFormat {
  const SeparableDateTime({
    super.dateFormat,
    super.timeFormat,
    super.timeZone,
    this.separate,
  });

  static SeparableDateTime? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SeparableDateTime(
      dateFormat: readText(source['date_format']),
      timeFormat: readText(source['time_format']),
      timeZone: readText(source['time_zone']),
      separate: readFlag(source['separate']),
    );
  }

  /// `separate` — a read key no metadata entry describes, the write-side name
  /// for it sitting at the section's top level instead.
  final bool? separate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'separate': separate,
      };
}

/// The `date_time` section — formats and zones for the admin area, for emails
/// and for the storefront.
class SiteSettingsDateTime extends Dto {
  const SiteSettingsDateTime({
    this.admin,
    this.hideTimeZone,
    this.email,
    this.user,
  });

  static SiteSettingsDateTime? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'date_time');
    if (source == null) return null;
    return SiteSettingsDateTime(
      admin: AdminDateTime.fromMap(source['admin']),
      hideTimeZone: readFlag(source['hide_time_zone']),
      email: SeparableDateTime.fromMap(source['email']),
      user: SeparableDateTime.fromMap(source['user']),
    );
  }

  final AdminDateTime? admin;

  final bool? hideTimeZone;

  final SeparableDateTime? email;

  final SeparableDateTime? user;

  @override
  String? get envelopeKey => 'date_time';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'admin': admin,
        'hide_time_zone': hideTimeZone,
        'email': email,
        'user': user,
      };
}

/// The `maintenance` block — whether the storefront is closed and what it says
/// while it is.
class Maintenance extends Dto {
  const Maintenance({this.enabled, this.message});

  static Maintenance? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Maintenance(
      enabled: readFlag(source['enabled']),
      message: readText(source['message']),
    );
  }

  final bool? enabled;

  final String? message;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'message': message,
      };
}

/// The `security_code` block — the site lock.
class SecurityCode extends Dto {
  const SecurityCode({this.enabled, this.code, this.numberOnly});

  static SecurityCode? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SecurityCode(
      enabled: readFlag(source['enabled']),
      code: readText(source['code']),
      numberOnly: readFlag(source['number_only']),
    );
  }

  final bool? enabled;

  /// `code` — marked `secret: true`; a set one reads back as `***`.
  final String? code;

  final bool? numberOnly;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'code': code,
        'number_only': numberOnly,
      };
}

/// The `ssl.key_file` block — what the store holds for the private key.
class SslKeyFile extends Dto {
  const SslKeyFile({this.uploaded, this.fileName});

  static SslKeyFile? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SslKeyFile(
      uploaded: readFlag(source['uploaded']),
      fileName: readText(source['file_name']),
    );
  }

  final bool? uploaded;

  final String? fileName;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'uploaded': uploaded,
        'file_name': fileName,
      };
}

/// The `ssl.certificate_file` block — the same two fields as [SslKeyFile] and
/// the certificate's own subject and expiry beside them.
class SslCertificateFile extends SslKeyFile {
  const SslCertificateFile({
    super.uploaded,
    super.fileName,
    this.subject,
    this.expiresAt,
  });

  static SslCertificateFile? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SslCertificateFile(
      uploaded: readFlag(source['uploaded']),
      fileName: readText(source['file_name']),
      subject: readText(source['subject']),
      expiresAt: readText(source['expires_at']),
    );
  }

  final String? subject;

  final String? expiresAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'subject': subject,
        'expires_at': expiresAt,
      };
}

/// The `ssl` block — what is stored for the certificate and its key.
class Ssl extends Dto {
  const Ssl({this.keyFile, this.certificateFile});

  static Ssl? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Ssl(
      keyFile: SslKeyFile.fromMap(source['key_file']),
      certificateFile: SslCertificateFile.fromMap(source['certificate_file']),
    );
  }

  final SslKeyFile? keyFile;

  final SslCertificateFile? certificateFile;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key_file': keyFile,
        'certificate_file': certificateFile,
      };
}

/// The `domain_settings` section — the store's address, its aliases, the site
/// lock, the maintenance switch and the stored certificate.
class DomainSettings extends Dto {
  const DomainSettings({
    this.websiteAddress,
    this.maintenance,
    this.securityCode,
    this.httpsEnabled,
    this.aliases,
    this.ssl,
  });

  static DomainSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'domain_settings');
    if (source == null) return null;
    return DomainSettings(
      websiteAddress: readText(source['website_address']),
      maintenance: Maintenance.fromMap(source['maintenance']),
      securityCode: SecurityCode.fromMap(source['security_code']),
      httpsEnabled: readFlag(source['https_enabled']),
      aliases: readList(source['aliases'], readText),
      ssl: Ssl.fromMap(source['ssl']),
    );
  }

  final String? websiteAddress;

  final Maintenance? maintenance;

  final SecurityCode? securityCode;

  final bool? httpsEnabled;

  /// `aliases` — marked `read_only`, and refused as the only field of a body.
  final List<String?>? aliases;

  final Ssl? ssl;

  @override
  String? get envelopeKey => 'domain_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'website_address': websiteAddress,
        'maintenance': maintenance,
        'security_code': securityCode,
        'https_enabled': httpsEnabled,
        'aliases': aliases,
        'ssl': ssl,
      };
}

/// One entry of `available` — a provider the store can send through.
class EmailProvider extends Dto {
  const EmailProvider({this.key, this.label, this.type, this.connectUrl});

  static EmailProvider? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return EmailProvider(
      key: readText(source['key']),
      label: readText(source['label']),
      type: readText(source['type']),
      connectUrl: readText(source['connect_url']),
    );
  }

  final String? key;

  final String? label;

  final String? type;

  final String? connectUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'label': label,
        'type': type,
        'connect_url': connectUrl,
      };
}

/// A `reply` block — whether replies go somewhere other than the sender
/// address, and where.
class ReplyTo extends Dto {
  const ReplyTo({this.different, this.toName, this.toEmail});

  static ReplyTo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReplyTo(
      different: readFlag(source['different']),
      toName: readText(source['to_name']),
      toEmail: readText(source['to_email']),
    );
  }

  final bool? different;

  final String? toName;

  final String? toEmail;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'different': different,
        'to_name': toName,
        'to_email': toEmail,
      };
}

/// One entry of `default.domains` — one of the platform's own sending domains
/// and the sender identity this store uses on it.
class DefaultDomain extends Dto {
  const DefaultDomain({
    this.domain,
    this.configure,
    this.senderName,
    this.emailPrefix,
    this.reply,
  });

  static DefaultDomain? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DefaultDomain(
      domain: readText(source['domain']),
      configure: readFlag(source['configure']),
      senderName: readText(source['sender_name']),
      emailPrefix: readText(source['email_prefix']),
      reply: ReplyTo.fromMap(source['reply']),
    );
  }

  final String? domain;

  final bool? configure;

  final String? senderName;

  final String? emailPrefix;

  final ReplyTo? reply;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'domain': domain,
        'configure': configure,
        'sender_name': senderName,
        'email_prefix': emailPrefix,
        'reply': reply,
      };
}

/// The `default` block — the platform's own sending domains.
class DefaultEmail extends Dto {
  const DefaultEmail({this.domains});

  static DefaultEmail? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DefaultEmail(
      domains: readList(source['domains'], DefaultDomain.fromMap),
    );
  }

  final List<DefaultDomain?>? domains;

  @override
  Map<String, Object?> get fields => <String, Object?>{'domains': domains};
}

/// The `gmail` and `office365` blocks — one read-only `connect_url` each.
class OauthProvider extends Dto {
  const OauthProvider({this.connectUrl});

  static OauthProvider? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OauthProvider(connectUrl: readText(source['connect_url']));
  }

  final String? connectUrl;

  @override
  Map<String, Object?> get fields =>
      <String, Object?>{'connect_url': connectUrl};
}

/// The `sendgrid` block — the SendGrid sender identity and the key behind it.
class SendGrid extends Dto {
  const SendGrid({
    this.apiKey,
    this.senderName,
    this.senderEmail,
    this.reply,
  });

  static SendGrid? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SendGrid(
      apiKey: readText(source['api_key']),
      senderName: readText(source['sender_name']),
      senderEmail: readText(source['sender_email']),
      reply: ReplyTo.fromMap(source['reply']),
    );
  }

  /// `api_key` — marked `secret: true`, read back as `***`, and hidden by this
  /// SDK's own redaction.
  final String? apiKey;

  final String? senderName;

  final String? senderEmail;

  final ReplyTo? reply;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'api_key': apiKey,
        'sender_name': senderName,
        'sender_email': senderEmail,
        'reply': reply,
      };
}

/// The `smtp.authentication` block — whether the server is logged in to and
/// with what.
class SmtpAuthentication extends Dto {
  const SmtpAuthentication({this.enabled, this.username, this.password});

  static SmtpAuthentication? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SmtpAuthentication(
      enabled: readFlag(source['enabled']),
      username: readText(source['username']),
      password: readText(source['password']),
    );
  }

  final bool? enabled;

  final String? username;

  /// `password` — marked `secret: true`, read back as `***`, and redacted here.
  final String? password;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'username': username,
        'password': password,
      };
}

/// The `smtp` block — the server the store sends through and who it sends as.
class Smtp extends Dto {
  const Smtp({
    this.senderName,
    this.senderEmail,
    this.host,
    this.port,
    this.encryption,
    this.authentication,
  });

  static Smtp? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Smtp(
      senderName: readText(source['sender_name']),
      senderEmail: readText(source['sender_email']),
      host: readText(source['host']),
      port: readInteger(source['port']),
      encryption: readText(source['encryption']),
      authentication: SmtpAuthentication.fromMap(source['authentication']),
    );
  }

  /// `sender_name` — plain text, never masked.
  final String? senderName;

  final String? senderEmail;

  final String? host;

  final int? port;

  final String? encryption;

  final SmtpAuthentication? authentication;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sender_name': senderName,
        'sender_email': senderEmail,
        'host': host,
        'port': port,
        'encryption': encryption,
        'authentication': authentication,
      };
}

/// The `email_settings` section — which provider sends the store's mail and the
/// credentials of each.
class EmailSettings extends Dto {
  const EmailSettings({
    this.serviceProvider,
    this.available,
    this.smtp,
    this.sendgrid,
    this.gmail,
    this.office365,
    this.defaultEmail,
  });

  static EmailSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'email_settings');
    if (source == null) return null;
    return EmailSettings(
      serviceProvider: readText(source['service_provider']),
      available: readList(source['available'], EmailProvider.fromMap),
      smtp: Smtp.fromMap(source['smtp']),
      sendgrid: SendGrid.fromMap(source['sendgrid']),
      gmail: OauthProvider.fromMap(source['gmail']),
      office365: OauthProvider.fromMap(source['office365']),
      defaultEmail: DefaultEmail.fromMap(source['default']),
    );
  }

  final String? serviceProvider;

  /// `available` — marked `read_only`; the providers this store may send through.
  final List<EmailProvider?>? available;

  final Smtp? smtp;

  final SendGrid? sendgrid;

  final OauthProvider? gmail;

  final OauthProvider? office365;

  /// `default` on the wire, renamed because `default` is a Dart keyword.
  final DefaultEmail? defaultEmail;

  @override
  String? get envelopeKey => 'email_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'service_provider': serviceProvider,
        'available': available,
        'smtp': smtp,
        'sendgrid': sendgrid,
        'gmail': gmail,
        'office365': office365,
        'default': defaultEmail,
      };
}

/// The `image` record of either media section — what the store holds and where
/// it serves it.
class MediaImage extends Dto {
  const MediaImage({
    this.fileName,
    this.url,
    this.contentType,
    this.sizeBytes,
    this.width,
    this.height,
  });

  static MediaImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return MediaImage(
      fileName: readText(source['file_name']),
      url: readText(source['url']),
      contentType: readText(source['content_type']),
      sizeBytes: readInteger(source['size_bytes']),
      width: readInteger(source['width']),
      height: readInteger(source['height']),
    );
  }

  final String? fileName;

  final String? url;

  final String? contentType;

  final int? sizeBytes;

  final int? width;

  final int? height;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'file_name': fileName,
        'url': url,
        'content_type': contentType,
        'size_bytes': sizeBytes,
        'width': width,
        'height': height,
      };
}

/// The `favicon` section — `kind: "media"`.
class Favicon extends Dto {
  const Favicon({this.enabled, this.image});

  static Favicon? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'favicon');
    if (source == null) return null;
    return Favicon(
      enabled: readFlag(source['enabled']),
      image: MediaImage.fromMap(source['image']),
    );
  }

  /// `enabled` — marked `read_only`, derived from whether an image is set, so
  /// it is no safe route into writing a media section.
  final bool? enabled;

  final MediaImage? image;

  @override
  String? get envelopeKey => 'favicon';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'image': image,
      };
}

/// The `store_logo.variants` block — the logos for dark backgrounds and the
/// sticky header.
class StoreLogoVariants extends Dto {
  const StoreLogoVariants({this.darkBackground, this.stickyHeader});

  static StoreLogoVariants? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return StoreLogoVariants(
      darkBackground: readAny(source['dark_background']),
      stickyHeader: readAny(source['sticky_header']),
    );
  }

  // Both read null while the main logo is used; a set variant's shape has not been measured.
  final Object? darkBackground;

  final Object? stickyHeader;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'dark_background': darkBackground,
        'sticky_header': stickyHeader,
      };
}

/// The `store_logo` section — `kind: "media"`, read rather than written.
class StoreLogo extends Dto {
  const StoreLogo({this.image, this.variants});

  static StoreLogo? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'store_logo');
    if (source == null) return null;
    return StoreLogo(
      image: MediaImage.fromMap(source['image']),
      variants: StoreLogoVariants.fromMap(source['variants']),
    );
  }

  final MediaImage? image;

  final StoreLogoVariants? variants;

  @override
  String? get envelopeKey => 'store_logo';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'image': image,
        'variants': variants,
      };
}

/// The `store_details.address` block — where the business is.
class StoreAddress extends Dto {
  const StoreAddress({
    this.addressLine1,
    this.addressLine2,
    this.state,
    this.country,
    this.postCode,
    this.city,
  });

  static StoreAddress? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return StoreAddress(
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      state: Region.fromMap(source['state']),
      country: Region.fromMap(source['country']),
      postCode: readText(source['post_code']),
      city: readText(source['city']),
    );
  }

  final String? addressLine1;

  final String? addressLine2;

  final Region? state;

  final Region? country;

  final String? postCode;

  final String? city;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'state': state,
        'country': country,
        'post_code': postCode,
        'city': city,
      };
}

/// The `store_details.contact` block — the three numbers the store publishes.
class StoreContact extends Dto {
  const StoreContact({this.phone, this.mobile, this.fax});

  static StoreContact? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return StoreContact(
      phone: readText(source['phone']),
      mobile: readText(source['mobile']),
      fax: readText(source['fax']),
    );
  }

  final String? phone;

  final String? mobile;

  final String? fax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'phone': phone,
        'mobile': mobile,
        'fax': fax,
      };
}

/// The `store_details` section — `kind: "resource"`, every field writable.
class StoreDetails extends Dto {
  const StoreDetails({
    this.companyName,
    this.email,
    this.address,
    this.contact,
    this.abn,
  });

  static StoreDetails? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'store_details');
    if (source == null) return null;
    return StoreDetails(
      companyName: readText(source['company_name']),
      email: readText(source['email']),
      address: StoreAddress.fromMap(source['address']),
      contact: StoreContact.fromMap(source['contact']),
      abn: readText(source['abn']),
    );
  }

  final String? companyName;

  final String? email;

  final StoreAddress? address;

  final StoreContact? contact;

  /// `abn` — eleven digits, optionally spaced.
  final String? abn;

  @override
  String? get envelopeKey => 'store_details';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'company_name': companyName,
        'email': email,
        'address': address,
        'contact': contact,
        'abn': abn,
      };
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class SiteSettingsSectionMeta extends Dto {
  const SiteSettingsSectionMeta({this.kind, this.writable, this.href});

  static SiteSettingsSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SiteSettingsSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"`, `"media"` or `"resource"`.
  final String? kind;

  /// `writable` — `true` on all eight entries here.
  final bool? writable;

  /// `href` — the section's own path on this resource, for all eight entries.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [SiteSettingsSectionMeta] per section the area
/// declares.
class SiteSettingsGroupMeta extends Dto {
  const SiteSettingsGroupMeta({
    this.storeLogo,
    this.brandKit,
    this.favicon,
    this.storeDetails,
    this.dateTime,
    this.administration,
    this.domainSettings,
    this.emailSettings,
  });

  static SiteSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SiteSettingsGroupMeta(
      storeLogo: SiteSettingsSectionMeta.fromMap(source['store_logo']),
      brandKit: SiteSettingsSectionMeta.fromMap(source['brand_kit']),
      favicon: SiteSettingsSectionMeta.fromMap(source['favicon']),
      storeDetails: SiteSettingsSectionMeta.fromMap(source['store_details']),
      dateTime: SiteSettingsSectionMeta.fromMap(source['date_time']),
      administration: SiteSettingsSectionMeta.fromMap(source['administration']),
      domainSettings:
          SiteSettingsSectionMeta.fromMap(source['domain_settings']),
      emailSettings: SiteSettingsSectionMeta.fromMap(source['email_settings']),
    );
  }

  final SiteSettingsSectionMeta? storeLogo;

  final SiteSettingsSectionMeta? brandKit;

  final SiteSettingsSectionMeta? favicon;

  final SiteSettingsSectionMeta? storeDetails;

  final SiteSettingsSectionMeta? dateTime;

  final SiteSettingsSectionMeta? administration;

  final SiteSettingsSectionMeta? domainSettings;

  final SiteSettingsSectionMeta? emailSettings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'store_logo': storeLogo,
        'brand_kit': brandKit,
        'favicon': favicon,
        'store_details': storeDetails,
        'date_time': dateTime,
        'administration': administration,
        'domain_settings': domainSettings,
        'email_settings': emailSettings,
      };
}

/// The site settings, as the facade or one section sends them.
class SiteSettings extends Dto {
  const SiteSettings({
    this.storeLogo,
    this.brandKit,
    this.favicon,
    this.storeDetails,
    this.dateTime,
    this.administration,
    this.domainSettings,
    this.emailSettings,
    this.groupMeta,
    this.fieldMetadata,
  });

  static SiteSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'site_settings');
    if (source == null) return null;
    return SiteSettings(
      storeLogo: StoreLogo.fromMap(source['store_logo']),
      brandKit: BrandKit.fromMap(source['brand_kit']),
      favicon: Favicon.fromMap(source['favicon']),
      storeDetails: StoreDetails.fromMap(source['store_details']),
      dateTime: SiteSettingsDateTime.fromMap(source['date_time']),
      administration: Administration.fromMap(source['administration']),
      domainSettings: DomainSettings.fromMap(source['domain_settings']),
      emailSettings: EmailSettings.fromMap(source['email_settings']),
      groupMeta: SiteSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `store_logo` — `kind: "media"`: read, never written.
  final StoreLogo? storeLogo;

  final BrandKit? brandKit;

  /// `favicon` — `kind: "media"`: read, never written.
  final Favicon? favicon;

  final StoreDetails? storeDetails;

  final SiteSettingsDateTime? dateTime;

  final Administration? administration;

  final DomainSettings? domainSettings;

  final EmailSettings? emailSettings;

  /// `group_meta` — on the facade's answer only.
  final SiteSettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'site_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'store_logo': storeLogo,
        'brand_kit': brandKit,
        'favicon': favicon,
        'store_details': storeDetails,
        'date_time': dateTime,
        'administration': administration,
        'domain_settings': domainSettings,
        'email_settings': emailSettings,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
