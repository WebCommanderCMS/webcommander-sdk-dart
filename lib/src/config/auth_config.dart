import '../auth/file_token_store_web.dart'
    if (dart.library.io) '../auth/file_token_store.dart';
import '../errors.dart';
import '../redaction.dart';
import 'file_probe_web.dart' if (dart.library.io) 'file_probe_io.dart';
import 'sdk_config.dart';

/// The credentials and instance to talk to, and where the token is kept;
/// behaviour lives on `SdkConfig`.
final class AuthConfig {
  /// Construct and validate; every problem is reported in one exception.
  AuthConfig({
    required String baseUrl,
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.authString,
    required this.clientName,
    this.grantType = defaultGrantType,
    Object? tokenCachePath = useDefaultTokenCache,
  }) : baseUrl = _normaliseBaseUrl(baseUrl) {
    // Validated first: resolving creates the cache directory, which a bad config must not leave.
    _validate(tokenCachePath);
    this.tokenCachePath = _resolveTokenCachePath(tokenCachePath);
  }

  /// The only grant type WebCommander's token endpoint accepts.
  static const String defaultGrantType = 'client_credentials';

  /// Where the instance lives: `scheme://host[:port]` with trailing slashes
  /// stripped, plus an optional base path each request path is appended to.
  final String baseUrl;

  /// The OAuth client id.
  final String clientId;

  /// The OAuth client secret; redacted by [toString].
  final String clientSecret;

  /// The registered redirect URI.
  final String redirectUri;

  /// The base64 admin credential; redacted by [toString].
  final String authString;

  /// Logical name distinguishing this instance, and how it is selected by name.
  final String clientName;

  /// The OAuth grant type.
  final String grantType;

  /// The resolved token cache file: the platform's per-user file, the caller's
  /// own path, or `null` when the token is kept in memory.
  late final String? tokenCachePath;

  /// Every field, in declaration order, secrets replaced and URLs reduced to their origin.
  @override
  String toString() => "AuthConfig(baseUrl='${_origin(baseUrl)}'"
      ", clientId='${_shown('clientId', clientId)}'"
      ", clientSecret='${Redaction.redacted}'"
      ", redirectUri='${_origin(redirectUri)}'"
      ", authString='${Redaction.redacted}'"
      ", clientName='${_shown('clientName', clientName)}'"
      ", grantType='${_shown('grantType', grantType)}'"
      ", tokenCachePath=${tokenCachePath == null ? 'null' : "'<configured>'"})";

  static String _shown(String name, String value) =>
      '${Redaction.redactForDisplay(name, value)}';

  static String _origin(String url) {
    final parsed = Uri.tryParse(url);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      return '<unparsable>';
    }
    final port = parsed.hasPort ? ':${parsed.port}' : '';
    return '${parsed.scheme.toLowerCase()}://${parsed.host.toLowerCase()}$port';
  }

  /// Derive new credentials, changing some fields; re-validated, and this
  /// instance is untouched.
  AuthConfig withOverrides({
    String? baseUrl,
    String? clientId,
    String? clientSecret,
    String? redirectUri,
    String? authString,
    String? clientName,
    String? grantType,
    Object? tokenCachePath = SdkConfig.noOverride,
  }) =>
      AuthConfig(
        baseUrl: baseUrl ?? this.baseUrl,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
        redirectUri: redirectUri ?? this.redirectUri,
        authString: authString ?? this.authString,
        clientName: clientName ?? this.clientName,
        grantType: grantType ?? this.grantType,
        tokenCachePath: identical(tokenCachePath, SdkConfig.noOverride)
            ? this.tokenCachePath
            : tokenCachePath,
      );

  /// The credentials that must be present, in declaration order.
  static const List<String> requiredFields = <String>[
    'baseUrl',
    'clientId',
    'clientSecret',
    'redirectUri',
    'authString',
  ];

  void _validate(Object? requested) {
    final problems = <String>[];

    final supplied = <String, String>{
      'baseUrl': baseUrl,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'redirectUri': redirectUri,
      'authString': authString,
    };
    final missing =
        requiredFields.where((name) => _isBlank(supplied[name]!)).toList();
    if (missing.isNotEmpty) {
      problems.add('missing required values: ${missing.join(', ')}');
    }
    if (!_isBlank(baseUrl)) problems.addAll(_baseUrlProblems(baseUrl));
    if (_isBlank(clientName)) problems.add('clientName: must not be blank');
    if (_isBlank(grantType)) problems.add('grantType: must not be blank');

    if (requested is! String &&
        requested != null &&
        !identical(requested, useDefaultTokenCache)) {
      problems.add('tokenCachePath: expected a path, null, or '
          'useDefaultTokenCache, got ${requested.runtimeType}');
    } else if (requested is String && requested.trim().isEmpty) {
      problems.add('tokenCachePath: must not be blank - pass null to keep the '
          'token in memory, or a path to cache it');
    } else if (requested is String && pathIsDirectory(requested)) {
      problems.add('tokenCachePath: the configured path is an existing '
          'directory, so nothing could be written to it - name the file to '
          'write, or pass null to keep the token in memory');
    }

    if (problems.isNotEmpty) {
      final label = clientName.trim().isEmpty ? '<unnamed>' : clientName.trim();
      throw SdkConfigError('instance $label: ${problems.join('; ')}');
    }
  }

  static String _normaliseBaseUrl(String raw) {
    var trimmed = raw.trim();
    while (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  static List<String> _baseUrlProblems(String baseUrl) {
    final problems = <String>[];
    final parsed = Uri.tryParse(baseUrl);
    // hasScheme, not isAbsolute, which is false for any URI with a fragment.
    if (parsed == null || !parsed.hasScheme) {
      problems.add('baseUrl: not a URL');
      return problems;
    }
    final scheme = parsed.scheme.toLowerCase();
    if ((scheme != 'http' && scheme != 'https') || parsed.host.isEmpty) {
      problems.add('baseUrl: must start with http:// or https:// and include a '
          'host; this one names scheme "$scheme"'
          '${parsed.host.isEmpty ? ' and no host' : ''}');
      return problems;
    }
    if (parsed.userInfo.isNotEmpty) {
      problems.add(
          'baseUrl: host ${parsed.host} carries embedded credentials, which would '
          'replace the bearer token; strip the userinfo');
    }
    if (parsed.hasQuery || baseUrl.contains('#')) {
      final carries = parsed.hasQuery
          ? (baseUrl.contains('#')
              ? 'a query string and a fragment'
              : 'a query string')
          : 'a fragment';
      problems.add(
          'baseUrl: must be a scheme, host and optional base path, and the one '
          'configured for host ${parsed.host} carries $carries');
    }
    return problems;
  }

  static bool _isBlank(String value) => value.trim().isEmpty;

  static String? _resolveTokenCachePath(Object? requested) {
    if (!identical(requested, useDefaultTokenCache)) {
      return requested as String?;
    }
    try {
      return buildDefaultTokenCachePath();
    } on UnsupportedError {
      return null;
    }
  }
}

/// Sentinel: resolve the platform's per-user cache path — the default for
/// [AuthConfig.tokenCachePath].
const Object useDefaultTokenCache = _UseDefaultTokenCache();

class _UseDefaultTokenCache {
  const _UseDefaultTokenCache();

  @override
  String toString() => '<platform default>';
}
