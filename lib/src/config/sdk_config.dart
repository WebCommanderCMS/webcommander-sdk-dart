import 'dart:convert';

import '../errors.dart';
import '../http/header_grammar.dart';
import '../http/retry_policy.dart';
import '../redaction.dart';
import 'auth_config.dart';
import 'environment_web.dart' if (dart.library.io) 'environment_io.dart';
import 'file_probe_web.dart' if (dart.library.io) 'file_probe_io.dart';

/// The version the SDK reports, and the User-Agent built from it.
class Sdk {
  Sdk._();

  /// The SDK version, reported by [defaultUserAgent] and `sdkVersion`.
  // Keep in step with `version:` in pubspec.yaml.
  static const String version = '4.0.0';

  /// The default User-Agent sent with every request.
  static const String defaultUserAgent = 'webcommander/$version';
}

/// Immutable SDK behaviour: timeouts, retries, TLS, logging, printing.
/// Credentials live on [AuthConfig]. Validated at construction, all at once.
final class SdkConfig {
  /// Construct and validate; every problem is reported in one exception.
  SdkConfig(
    this.auth, {
    String apiVersion = defaultApiVersion,
    this.timeoutSeconds = defaultTimeoutSeconds,
    this.connectTimeoutSeconds = defaultConnectTimeoutSeconds,
    this.maxRetries = defaultMaxRetries,
    Set<int>? retryableHttpCodes,
    Set<int>? unsafeRetryableHttpCodes,
    this.retryBackoffSeconds = defaultRetryBackoffSeconds,
    this.retryBackoffMaxSeconds = defaultRetryBackoffMaxSeconds,
    this.verifySsl = true,
    String? caBundle,
    String? proxyUrl,
    this.poolMaxsize = defaultPoolMaxsize,
    this.maxResponseBytes = defaultMaxResponseBytes,
    this.maxRequestBytes = defaultMaxRequestBytes,
    this.maxRequestSourceBytes = defaultMaxRequestSourceBytes,
    this.maxMultipartOverheadBytes = defaultMaxMultipartOverheadBytes,
    this.maxTokenCacheBytes = defaultMaxTokenCacheBytes,
    this.maxCaBundleBytes = defaultMaxCaBundleBytes,
    Map<String, String>? defaultHeaders,
    this.raiseOnError = false,
    String? userAgent,
    String? logLevel = defaultLogLevel,
    this.logBodies = false,
    String? logFile,
    this.printApiInfo = false,
    this.printRequestPayload = false,
    this.printResponseBody = false,
    this.printHeaders = false,
    this.printCurl = false,
    this.printOnlyOnError = false,
    String? printFormat = printFormatPretty,
    this.printColor = false,
    this.printMaxChars = 0,
    String? responseFormat,
  })  : responseFormat = _resolveResponseFormat(responseFormat),
        caBundle = _blankToNull(caBundle),
        proxyUrl = _normaliseProxyUrlField(proxyUrl),
        apiVersion = _normaliseApiVersion(apiVersion),
        retryableHttpCodes = Set<int>.unmodifiable(
            retryableHttpCodes ?? RetryPolicy.defaultRetryableHttpCodes),
        unsafeRetryableHttpCodes = Set<int>.unmodifiable(
            unsafeRetryableHttpCodes ??
                RetryPolicy.defaultUnsafeRetryableHttpCodes),
        defaultHeaders = Map<String, String>.unmodifiable(
            defaultHeaders ?? const <String, String>{}),
        userAgent = userAgent ?? Sdk.defaultUserAgent,
        logLevel = logLevel?.trim().toUpperCase(),
        logFile = _blankToNull(logFile),
        printFormat = printFormat?.trim().toLowerCase() {
    _validate();
  }

  /// Default API version segment.
  static const String defaultApiVersion = 'v4';

  /// Default overall request timeout, in seconds.
  static const double defaultTimeoutSeconds = 30.0;

  /// Default connection-establishment timeout, in seconds.
  static const double defaultConnectTimeoutSeconds = 10.0;

  /// Total attempts including the first, so 1 disables retrying.
  static const int defaultMaxRetries = 1;

  /// Default base backoff before the first retry.
  static const double defaultRetryBackoffSeconds = 0.5;

  /// Default ceiling on any single backoff.
  static const double defaultRetryBackoffMaxSeconds = 20.0;

  /// Default for [poolMaxsize], which is validated but not applied.
  static const int defaultPoolMaxsize = 10;

  /// Default ceiling on how much of one response body is buffered: 64 MiB.
  static const int defaultMaxResponseBytes = 64 << 20;

  /// Default ceiling on the final wire body of one request: 64 MiB.
  static const int defaultMaxRequestBytes = 64 << 20;

  /// Default ceiling on the source material one request is built from: 64 MiB.
  static const int defaultMaxRequestSourceBytes = 64 << 20;

  /// Default ceiling on a multipart body's metadata and framing alone: 1 MiB.
  static const int defaultMaxMultipartOverheadBytes = 1 << 20;

  /// Default ceiling on the token cache file the SDK reads: 1 MiB.
  static const int defaultMaxTokenCacheBytes = 1 << 20;

  /// Default ceiling on the CA bundle file: 4 MiB.
  static const int defaultMaxCaBundleBytes = 4 << 20;

  /// Default log level.
  static const String defaultLogLevel = 'WARNING';

  /// Pretty (multi-line) console print format.
  static const String printFormatPretty = 'pretty';

  /// Compact (single-line) console print format.
  static const String printFormatCompact = 'compact';

  /// `ApiResponse.data` is the decoded body; the built-in default.
  static const String responseFormatMap = 'map';

  /// `ApiResponse.data` is the server's own body text.
  static const String responseFormatJson = 'json';

  /// `ApiResponse.data` is the typed view the endpoint produces.
  static const String responseFormatDto = 'dto';

  /// The three values [responseFormat] accepts, in the order messages name them.
  static const List<String> responseFormats = <String>[
    responseFormatMap,
    responseFormatJson,
    responseFormatDto,
  ];

  /// The environment variable read for [responseFormat]; lowest priority.
  static const String responseFormatEnvironmentVariable = 'WC_RESPONSE_FORMAT';

  static const Set<String> _validLogLevels = <String>{
    'DEBUG',
    'INFO',
    'WARNING',
    'ERROR',
    'CRITICAL'
  };
  static const Set<String> _validPrintFormats = <String>{
    printFormatPretty,
    printFormatCompact
  };
  static final RegExp _apiVersionPattern =
      RegExp(r'^v?[1-9][0-9]*$', caseSensitive: false);
  static const int _maxHttpCodes =
      RetryPolicy.maxStatusCode - RetryPolicy.minStatusCode + 1;

  /// The credentials and instance this config talks to.
  final AuthConfig auth;

  /// The API version segment, e.g. `v4`.
  final String apiVersion;

  /// Ceiling on one attempt, in seconds; each retry starts a fresh one.
  final double timeoutSeconds;

  /// Ceiling on connection setup, a phase inside [timeoutSeconds]; inert on web.
  final double connectTimeoutSeconds;

  /// Total attempts including the first.
  final int maxRetries;

  /// Statuses worth another attempt for `GET`, `HEAD`, `OPTIONS` or `TRACE`.
  final Set<int> retryableHttpCodes;

  /// Statuses worth another attempt for a state-changing method.
  final Set<int> unsafeRetryableHttpCodes;

  /// Base backoff before the first retry.
  final double retryBackoffSeconds;

  /// Ceiling on any single backoff.
  final double retryBackoffMaxSeconds;

  /// Whether TLS certificates are verified (native only).
  final bool verifySsl;

  /// Path to a custom CA bundle, or `null` (native only); blank reads as unset.
  final String? caBundle;

  /// Proxy URL, or `null`.
  final String? proxyUrl;

  /// Validated (it must be at least 1) but not applied on any platform:
  /// `dart:io` exposes no pool-size setting, so idle connections are pooled on
  /// its own terms.
  final int poolMaxsize;

  /// Ceiling on how much of one response body the transport buffers, in bytes.
  final int maxResponseBytes;

  /// Ceiling on the final wire body of one request, in bytes, framing included.
  final int maxRequestBytes;

  /// Ceiling on the source material one request is built from, in bytes.
  final int maxRequestSourceBytes;

  /// Ceiling on a multipart body's metadata and framing alone, in bytes.
  final int maxMultipartOverheadBytes;

  /// Ceiling on the token cache file this SDK will read, in bytes.
  final int maxTokenCacheBytes;

  /// Ceiling on the CA bundle file, in bytes.
  final int maxCaBundleBytes;

  /// Extra headers sent on every request.
  final Map<String, String> defaultHeaders;

  /// Whether a failed response throws rather than returning the error body.
  final bool raiseOnError;

  /// The User-Agent header value.
  final String userAgent;

  /// The SDK's own log level.
  final String? logLevel;

  /// Whether request and response bodies are logged.
  final bool logBodies;

  /// Also append log records to this path (native only), or `null`.
  final String? logFile;

  /// Print the resolved API call info.
  final bool printApiInfo;

  /// Print the request payload.
  final bool printRequestPayload;

  /// Print the response body.
  final bool printResponseBody;

  /// Print request/response headers.
  final bool printHeaders;

  /// Print an equivalent curl command.
  final bool printCurl;

  /// Print only when a call fails.
  final bool printOnlyOnError;

  /// The console print format.
  final String? printFormat;

  /// Whether console printing is coloured.
  final bool printColor;

  /// Truncate printed values to this many characters; 0 = unlimited.
  final int printMaxChars;

  /// Which form `ApiResponse.data` takes, one of [responseFormats].
  final String responseFormat;

  /// Where the instance lives, from the credentials — see [AuthConfig.baseUrl].
  String get baseUrl => auth.baseUrl;

  /// The instance's logical name, from the credentials.
  String get clientName => auth.clientName;

  /// Every field in declaration order, secrets redacted.
  @override
  String toString() => 'SdkConfig(auth=$auth'
      ", apiVersion='${_shown('apiVersion', apiVersion)}'"
      ', timeoutSeconds=$timeoutSeconds'
      ', connectTimeoutSeconds=$connectTimeoutSeconds'
      ', maxRetries=$maxRetries'
      ', retryableHttpCodes=${_sortedCodes(retryableHttpCodes)}'
      ', unsafeRetryableHttpCodes=${_sortedCodes(unsafeRetryableHttpCodes)}'
      ', retryBackoffSeconds=$retryBackoffSeconds'
      ', retryBackoffMaxSeconds=$retryBackoffMaxSeconds'
      ', verifySsl=$verifySsl'
      ', caBundle=${_configuredOrNull(caBundle)}'
      ', proxyUrl=${_quoteOrNull('proxyUrl', proxyUrl)}'
      ', poolMaxsize=$poolMaxsize'
      ', maxResponseBytes=$maxResponseBytes'
      ', maxRequestBytes=$maxRequestBytes'
      ', maxRequestSourceBytes=$maxRequestSourceBytes'
      ', maxMultipartOverheadBytes=$maxMultipartOverheadBytes'
      ', maxTokenCacheBytes=$maxTokenCacheBytes'
      ', maxCaBundleBytes=$maxCaBundleBytes'
      ', defaultHeaders=${Redaction.redactMapping(defaultHeaders)}'
      ', raiseOnError=$raiseOnError'
      ", userAgent='${_shown('userAgent', userAgent)}'"
      ", logLevel='${_shown('logLevel', logLevel)}'"
      ', logBodies=$logBodies'
      ', logFile=${_configuredOrNull(logFile)}'
      ', printApiInfo=$printApiInfo'
      ', printRequestPayload=$printRequestPayload'
      ', printResponseBody=$printResponseBody'
      ', printHeaders=$printHeaders'
      ', printCurl=$printCurl'
      ', printOnlyOnError=$printOnlyOnError'
      ", printFormat='${_shown('printFormat', printFormat)}'"
      ', printColor=$printColor'
      ', printMaxChars=$printMaxChars'
      ", responseFormat='${_shown('responseFormat', responseFormat)}')";

  static String _shown(String name, Object? value) =>
      '${Redaction.redactForDisplay(name, value)}';

  static String _quoteOrNull(String name, String? value) =>
      value == null ? 'null' : "'${_shown(name, value)}'";

  static String _configuredOrNull(String? value) =>
      value == null ? 'null' : "'<configured>'";

  static List<int> _sortedCodes(Set<int> codes) => codes.toList()..sort();

  /// Derive a new config, changing some fields; re-validated, and this instance is untouched.
  SdkConfig withOverrides({
    AuthConfig? auth,
    String? apiVersion,
    double? timeoutSeconds,
    double? connectTimeoutSeconds,
    int? maxRetries,
    Set<int>? retryableHttpCodes,
    Set<int>? unsafeRetryableHttpCodes,
    double? retryBackoffSeconds,
    double? retryBackoffMaxSeconds,
    bool? verifySsl,
    Object? caBundle = noOverride,
    Object? proxyUrl = noOverride,
    int? poolMaxsize,
    int? maxResponseBytes,
    int? maxRequestBytes,
    int? maxRequestSourceBytes,
    int? maxMultipartOverheadBytes,
    int? maxTokenCacheBytes,
    int? maxCaBundleBytes,
    Map<String, String>? defaultHeaders,
    bool? raiseOnError,
    String? userAgent,
    String? logLevel,
    bool? logBodies,
    Object? logFile = noOverride,
    bool? printApiInfo,
    bool? printRequestPayload,
    bool? printResponseBody,
    bool? printHeaders,
    bool? printCurl,
    bool? printOnlyOnError,
    String? printFormat,
    bool? printColor,
    int? printMaxChars,
    String? responseFormat,
  }) =>
      SdkConfig(
        auth ?? this.auth,
        apiVersion: apiVersion ?? this.apiVersion,
        timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
        connectTimeoutSeconds:
            connectTimeoutSeconds ?? this.connectTimeoutSeconds,
        maxRetries: maxRetries ?? this.maxRetries,
        retryableHttpCodes: retryableHttpCodes ?? this.retryableHttpCodes,
        unsafeRetryableHttpCodes:
            unsafeRetryableHttpCodes ?? this.unsafeRetryableHttpCodes,
        retryBackoffSeconds: retryBackoffSeconds ?? this.retryBackoffSeconds,
        retryBackoffMaxSeconds:
            retryBackoffMaxSeconds ?? this.retryBackoffMaxSeconds,
        verifySsl: verifySsl ?? this.verifySsl,
        caBundle: identical(caBundle, noOverride)
            ? this.caBundle
            : _nullableText('caBundle', caBundle),
        proxyUrl: identical(proxyUrl, noOverride)
            ? this.proxyUrl
            : _nullableText('proxyUrl', proxyUrl),
        poolMaxsize: poolMaxsize ?? this.poolMaxsize,
        maxResponseBytes: maxResponseBytes ?? this.maxResponseBytes,
        maxRequestBytes: maxRequestBytes ?? this.maxRequestBytes,
        maxRequestSourceBytes:
            maxRequestSourceBytes ?? this.maxRequestSourceBytes,
        maxMultipartOverheadBytes:
            maxMultipartOverheadBytes ?? this.maxMultipartOverheadBytes,
        maxTokenCacheBytes: maxTokenCacheBytes ?? this.maxTokenCacheBytes,
        maxCaBundleBytes: maxCaBundleBytes ?? this.maxCaBundleBytes,
        defaultHeaders: defaultHeaders ?? this.defaultHeaders,
        raiseOnError: raiseOnError ?? this.raiseOnError,
        userAgent: userAgent ?? this.userAgent,
        logLevel: logLevel ?? this.logLevel,
        logBodies: logBodies ?? this.logBodies,
        logFile: identical(logFile, noOverride)
            ? this.logFile
            : _nullableText('logFile', logFile),
        printApiInfo: printApiInfo ?? this.printApiInfo,
        printRequestPayload: printRequestPayload ?? this.printRequestPayload,
        printResponseBody: printResponseBody ?? this.printResponseBody,
        printHeaders: printHeaders ?? this.printHeaders,
        printCurl: printCurl ?? this.printCurl,
        printOnlyOnError: printOnlyOnError ?? this.printOnlyOnError,
        printFormat: printFormat ?? this.printFormat,
        printColor: printColor ?? this.printColor,
        printMaxChars: printMaxChars ?? this.printMaxChars,
        responseFormat: responseFormat ?? this.responseFormat,
      );

  /// Return one block: `null` takes the first, an `int` is a position (negative
  /// counts from the end), a `String` matches exactly one entry's `clientName`.
  static Object selectCredentials(List<Object> credentials,
      [Object? instance]) {
    if (credentials.isEmpty) {
      throw SdkUsageError('no credentials were supplied');
    }
    if (instance == null) return credentials.first;
    if (instance is int) {
      final size = credentials.length;
      if (instance >= -size && instance < size) {
        return credentials[instance % size];
      }
      throw SdkUsageError(
          'no credentials at index $instance; $size supplied (0-${size - 1})');
    }
    if (instance is String) {
      final matched = <int>[];
      for (var i = 0; i < credentials.length; i++) {
        if (readClientName(credentials[i]) == instance) matched.add(i);
      }
      if (matched.length == 1) return credentials[matched.first];
      if (matched.length > 1) {
        throw SdkUsageError(
            "instance '$instance' is defined more than once, at index "
            "${matched.join(' and ')}; clientName has to identify one entry");
      }
      final available = <String>[];
      for (var i = 0; i < credentials.length; i++) {
        available.add(readClientName(credentials[i]) ?? '<index $i>');
      }
      throw SdkUsageError(
          "unknown instance '$instance'; available: ${available.join(', ')}");
    }
    throw SdkUsageError('instance must be null, an index or a clientName');
  }

  /// Build a config from one entry of a list of credential blocks, chosen by [instance].
  static SdkConfig fromCredentials(
    List<Object> credentials, {
    Object? instance,
    AuthConfig? auth,
    String? apiVersion,
    double? timeoutSeconds,
    double? connectTimeoutSeconds,
    int? maxRetries,
    Set<int>? retryableHttpCodes,
    Set<int>? unsafeRetryableHttpCodes,
    double? retryBackoffSeconds,
    double? retryBackoffMaxSeconds,
    bool? verifySsl,
    Object? caBundle = noOverride,
    Object? proxyUrl = noOverride,
    int? poolMaxsize,
    int? maxResponseBytes,
    int? maxRequestBytes,
    int? maxRequestSourceBytes,
    int? maxMultipartOverheadBytes,
    int? maxTokenCacheBytes,
    int? maxCaBundleBytes,
    Map<String, String>? defaultHeaders,
    bool? raiseOnError,
    String? userAgent,
    String? logLevel,
    bool? logBodies,
    Object? logFile = noOverride,
    bool? printApiInfo,
    bool? printRequestPayload,
    bool? printResponseBody,
    bool? printHeaders,
    bool? printCurl,
    bool? printOnlyOnError,
    String? printFormat,
    bool? printColor,
    int? printMaxChars,
    String? responseFormat,
  }) {
    final chosen = selectCredentials(credentials, instance);
    final SdkConfig base;
    if (chosen is SdkConfig) {
      base = chosen;
    } else if (chosen is AuthConfig) {
      base = SdkConfig(chosen);
    } else if (chosen is Map) {
      base = _fromMapping(chosen, instance);
    } else {
      throw SdkConfigError(
          'credentials[${instance ?? 0}]: expected an SdkConfig, an AuthConfig '
          'or a mapping of config fields, got ${chosen.runtimeType}');
    }

    return base.withOverrides(
      auth: auth,
      apiVersion: apiVersion,
      timeoutSeconds: timeoutSeconds,
      connectTimeoutSeconds: connectTimeoutSeconds,
      maxRetries: maxRetries,
      retryableHttpCodes: retryableHttpCodes,
      unsafeRetryableHttpCodes: unsafeRetryableHttpCodes,
      retryBackoffSeconds: retryBackoffSeconds,
      retryBackoffMaxSeconds: retryBackoffMaxSeconds,
      verifySsl: verifySsl,
      caBundle: caBundle,
      proxyUrl: proxyUrl,
      poolMaxsize: poolMaxsize,
      maxResponseBytes: maxResponseBytes,
      maxRequestBytes: maxRequestBytes,
      maxRequestSourceBytes: maxRequestSourceBytes,
      maxMultipartOverheadBytes: maxMultipartOverheadBytes,
      maxTokenCacheBytes: maxTokenCacheBytes,
      maxCaBundleBytes: maxCaBundleBytes,
      defaultHeaders: defaultHeaders,
      raiseOnError: raiseOnError,
      userAgent: userAgent,
      logLevel: logLevel,
      logBodies: logBodies,
      logFile: logFile,
      printApiInfo: printApiInfo,
      printRequestPayload: printRequestPayload,
      printResponseBody: printResponseBody,
      printHeaders: printHeaders,
      printCurl: printCurl,
      printOnlyOnError: printOnlyOnError,
      printFormat: printFormat,
      printColor: printColor,
      printMaxChars: printMaxChars,
      responseFormat: responseFormat,
    );
  }

  /// Sentinel telling an omitted nullable setting from one passed as `null`.
  static const Object noOverride = Object();

  // Keep in step with AuthConfig's required constructor fields.
  static const List<String> _mappingRequiredFields = <String>[
    'base_url',
    'client_id',
    'client_secret',
    'redirect_uri',
    'auth_string',
    'client_name',
  ];

  static const Set<String> _authFieldNames = <String>{
    ..._mappingRequiredFields,
    'grant_type',
    'token_cache_path',
  };

  static const Set<String> _settingNames = <String>{
    'api_version',
    'timeout_seconds',
    'connect_timeout_seconds',
    'max_retries',
    'retryable_http_codes',
    'unsafe_retryable_http_codes',
    'retry_backoff_seconds',
    'retry_backoff_max_seconds',
    'verify_ssl',
    'ca_bundle',
    'proxy_url',
    'pool_maxsize',
    'max_response_bytes',
    'max_request_bytes',
    'max_request_source_bytes',
    'max_multipart_overhead_bytes',
    'max_token_cache_bytes',
    'max_ca_bundle_bytes',
    'default_headers',
    'raise_on_error',
    'user_agent',
    'log_level',
    'log_bodies',
    'log_file',
    'print_api_info',
    'print_request_payload',
    'print_response_body',
    'print_headers',
    'print_curl',
    'print_only_on_error',
    'print_format',
    'print_color',
    'print_max_chars',
    'response_format',
  };

  static SdkConfig _fromMapping(Map<Object?, Object?> block, Object? instance) {
    final selector = instance is String ? "'$instance'" : '${instance ?? 0}';
    final where = 'credentials[$selector]';
    final remaining = <String, Object?>{};
    for (final entry in block.entries) {
      final key = entry.key;
      if (key is! String) {
        throw SdkConfigError(
            '$where: a config field name must be text, got ${key.runtimeType}');
      }
      remaining[key] = entry.value;
    }

    final carriesAuth = remaining.containsKey('auth');
    final suppliedAuth = remaining.remove('auth');
    final authValues = <String, Object?>{};
    for (final name in remaining.keys.toList()) {
      if (_authFieldNames.contains(name)) {
        authValues[name] = remaining.remove(name);
      }
    }

    if (carriesAuth && authValues.isNotEmpty) {
      final named = authValues.keys.toList()..sort();
      throw SdkConfigError(
          'auth: an AuthConfig was supplied alongside the credential field(s) '
          "${named.join(', ')}; pass one or the other");
    }

    final problems = <String>[];

    AuthConfig? resolvedAuth;
    var baseUrl = '';
    var clientId = '';
    var clientSecret = '';
    var redirectUri = '';
    var authString = '';
    var clientName = '';
    var grantType = AuthConfig.defaultGrantType;
    Object? tokenCachePath = useDefaultTokenCache;
    if (carriesAuth) {
      if (suppliedAuth is! AuthConfig) {
        throw SdkConfigError('$where: auth must be an AuthConfig, got '
            '${suppliedAuth.runtimeType}');
      }
      resolvedAuth = suppliedAuth;
    } else {
      final absent = _mappingRequiredFields
          .where((name) => !authValues.containsKey(name))
          .toList();
      if (absent.isNotEmpty) {
        throw SdkConfigError(
            "credentials: missing required field(s): ${absent.join(', ')}");
      }
      baseUrl = _requiredText(authValues, 'base_url', problems);
      clientId = _requiredText(authValues, 'client_id', problems);
      clientSecret = _requiredText(authValues, 'client_secret', problems);
      redirectUri = _requiredText(authValues, 'redirect_uri', problems);
      authString = _requiredText(authValues, 'auth_string', problems);
      clientName = _requiredText(authValues, 'client_name', problems);
      if (authValues.containsKey('grant_type')) {
        grantType = _requiredText(authValues, 'grant_type', problems);
      }
      if (authValues.containsKey('token_cache_path')) {
        tokenCachePath = _textOrNull(authValues, 'token_cache_path', problems);
      }
    }

    final unknown = remaining.keys
        .where((name) => !_settingNames.contains(name))
        .toList()
      ..sort();
    if (unknown.isNotEmpty) {
      final known = _settingNames.toList()..sort();
      throw SdkConfigError('$where: unknown config field(s): '
          "${unknown.join(', ')}; known: ${known.join(', ')}");
    }

    final apiVersion = _textOrNull(remaining, 'api_version', problems);
    final timeoutSeconds =
        _number(remaining, 'timeout_seconds', problems)?.toDouble();
    final connectTimeoutSeconds =
        _number(remaining, 'connect_timeout_seconds', problems)?.toDouble();
    final maxRetries = _number(remaining, 'max_retries', problems)?.toInt();
    final retryableHttpCodes =
        _codes(remaining, 'retryable_http_codes', problems);
    final unsafeRetryableHttpCodes =
        _codes(remaining, 'unsafe_retryable_http_codes', problems);
    final retryBackoffSeconds =
        _number(remaining, 'retry_backoff_seconds', problems)?.toDouble();
    final retryBackoffMaxSeconds =
        _number(remaining, 'retry_backoff_max_seconds', problems)?.toDouble();
    final verifySsl = _boolean(remaining, 'verify_ssl', problems);
    final Object? caBundle = remaining.containsKey('ca_bundle')
        ? _textOrNull(remaining, 'ca_bundle', problems)
        : noOverride;
    final Object? proxyUrl = remaining.containsKey('proxy_url')
        ? _textOrNull(remaining, 'proxy_url', problems)
        : noOverride;
    final poolMaxsize = _number(remaining, 'pool_maxsize', problems)?.toInt();
    final maxResponseBytes =
        _number(remaining, 'max_response_bytes', problems)?.toInt();
    final maxRequestBytes =
        _number(remaining, 'max_request_bytes', problems)?.toInt();
    final maxRequestSourceBytes =
        _number(remaining, 'max_request_source_bytes', problems)?.toInt();
    final maxMultipartOverheadBytes =
        _number(remaining, 'max_multipart_overhead_bytes', problems)?.toInt();
    final maxTokenCacheBytes =
        _number(remaining, 'max_token_cache_bytes', problems)?.toInt();
    final maxCaBundleBytes =
        _number(remaining, 'max_ca_bundle_bytes', problems)?.toInt();
    final defaultHeaders = _headerMap(remaining, 'default_headers', problems);
    final raiseOnError = _boolean(remaining, 'raise_on_error', problems);
    final userAgent = _textOrNull(remaining, 'user_agent', problems);
    final logLevel = _textOrNull(remaining, 'log_level', problems);
    final logBodies = _boolean(remaining, 'log_bodies', problems);
    final Object? logFile = remaining.containsKey('log_file')
        ? _textOrNull(remaining, 'log_file', problems)
        : noOverride;
    final printApiInfo = _boolean(remaining, 'print_api_info', problems);
    final printRequestPayload =
        _boolean(remaining, 'print_request_payload', problems);
    final printResponseBody =
        _boolean(remaining, 'print_response_body', problems);
    final printHeaders = _boolean(remaining, 'print_headers', problems);
    final printCurl = _boolean(remaining, 'print_curl', problems);
    final printOnlyOnError =
        _boolean(remaining, 'print_only_on_error', problems);
    final printFormat = _textOrNull(remaining, 'print_format', problems);
    final printColor = _boolean(remaining, 'print_color', problems);
    final printMaxChars =
        _number(remaining, 'print_max_chars', problems)?.toInt();
    final responseFormat = _textOrNull(remaining, 'response_format', problems);

    if (problems.isNotEmpty) {
      throw SdkConfigError('$where: ${problems.join('; ')}');
    }

    resolvedAuth ??= AuthConfig(
      baseUrl: baseUrl,
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
      authString: authString,
      clientName: clientName,
      grantType: grantType,
      tokenCachePath: tokenCachePath,
    );

    return SdkConfig(resolvedAuth).withOverrides(
      apiVersion: apiVersion,
      timeoutSeconds: timeoutSeconds,
      connectTimeoutSeconds: connectTimeoutSeconds,
      maxRetries: maxRetries,
      retryableHttpCodes: retryableHttpCodes,
      unsafeRetryableHttpCodes: unsafeRetryableHttpCodes,
      retryBackoffSeconds: retryBackoffSeconds,
      retryBackoffMaxSeconds: retryBackoffMaxSeconds,
      verifySsl: verifySsl,
      caBundle: caBundle,
      proxyUrl: proxyUrl,
      poolMaxsize: poolMaxsize,
      maxResponseBytes: maxResponseBytes,
      maxRequestBytes: maxRequestBytes,
      maxRequestSourceBytes: maxRequestSourceBytes,
      maxMultipartOverheadBytes: maxMultipartOverheadBytes,
      maxTokenCacheBytes: maxTokenCacheBytes,
      maxCaBundleBytes: maxCaBundleBytes,
      defaultHeaders: defaultHeaders,
      raiseOnError: raiseOnError,
      userAgent: userAgent,
      logLevel: logLevel,
      logBodies: logBodies,
      logFile: logFile,
      printApiInfo: printApiInfo,
      printRequestPayload: printRequestPayload,
      printResponseBody: printResponseBody,
      printHeaders: printHeaders,
      printCurl: printCurl,
      printOnlyOnError: printOnlyOnError,
      printFormat: printFormat,
      printColor: printColor,
      printMaxChars: printMaxChars,
      responseFormat: responseFormat,
    );
  }

  static String _requiredText(
      Map<String, Object?> values, String name, List<String> problems) {
    final value = values[name];
    if (value is String) return value;
    problems.add('$name: must be text, got ${value.runtimeType}');
    return '';
  }

  // Only the type is reported, never the value: it can carry a secret.
  static String? _textOrNull(
      Map<String, Object?> values, String name, List<String> problems) {
    final value = values[name];
    if (value == null) return null;
    if (value is String) return value;
    problems.add('$name: expected text, got ${value.runtimeType}');
    return null;
  }

  static bool? _boolean(
      Map<String, Object?> values, String name, List<String> problems) {
    final value = values[name];
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      problems.add("$name: expected true or false, got '$value'");
    } else {
      problems.add('$name: expected true or false, got ${value.runtimeType}');
    }
    return null;
  }

  static num? _number(
      Map<String, Object?> values, String name, List<String> problems) {
    final value = values[name];
    if (value == null) return null;
    if (value is num) return value;
    problems.add('$name: expected a number, got ${value.runtimeType}');
    return null;
  }

  static Set<int>? _codes(
      Map<String, Object?> values, String name, List<String> problems) {
    final value = values[name];
    if (value == null) return null;
    if (value is Iterable) {
      final codes = <int>{};
      for (final item in value) {
        if (item is num) {
          codes.add(item.toInt());
        } else {
          problems.add(
              '$name: expected HTTP status codes, got a ${item.runtimeType}');
          return null;
        }
      }
      return codes;
    }
    problems.add(
        '$name: expected a list of HTTP status codes, got ${value.runtimeType}');
    return null;
  }

  static Map<String, String>? _headerMap(
      Map<String, Object?> values, String name, List<String> problems) {
    Object? value = values[name];
    if (value == null) return null;
    if (value is String) {
      try {
        value = jsonDecode(value);
      } on FormatException {
        problems.add('$name: a text value must be the JSON of an object of '
            'header names to values. The value is not shown: it may carry a '
            'credential');
        return null;
      }
    }
    if (value is! Map) {
      problems.add('$name: expected a map of header names to values, '
          'got ${value.runtimeType}');
      return null;
    }
    final headers = <String, String>{};
    var flat = true;
    value.forEach((key, item) {
      if (item is Map || item is List) {
        problems.add("$name: the value for '$key' must be a flat scalar "
            'value, got ${item.runtimeType}');
        flat = false;
      } else {
        headers['$key'] = item?.toString() ?? '';
      }
    });
    return flat ? headers : null;
  }

  static String? _nullableText(String name, Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    throw SdkConfigError(
        '$name: expected text or null, got ${value.runtimeType}');
  }

  /// Normalise a proxy URL: a missing scheme defaults to `http://`.
  static Uri? normaliseProxyUrl(String value) {
    var text = value.trim();
    if (!text.contains('://')) text = 'http://$text';
    final parsed = Uri.tryParse(text);
    if (parsed == null || parsed.host.isEmpty) return null;
    final scheme = parsed.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;
    return parsed;
  }

  static String? _normaliseProxyUrlField(String? value) {
    final trimmed = _blankToNull(value);
    if (trimmed == null) return null;
    return normaliseProxyUrl(trimmed)?.toString() ?? trimmed;
  }

  static String _resolveResponseFormat(String? supplied) {
    if (supplied != null) return supplied.trim().toLowerCase();
    final fromEnvironment =
        readEnvironmentVariable(responseFormatEnvironmentVariable);
    if (fromEnvironment == null) return responseFormatMap;
    final named = fromEnvironment.trim();
    if (named.isEmpty) return responseFormatMap;
    return named.toLowerCase();
  }

  void _validate() {
    final problems = <String>[];
    final withheld = <String>[];

    if (!_apiVersionPattern.hasMatch(apiVersion)) {
      problems.add(
          "apiVersion: expected something like 'v4' or '4', got '$apiVersion'");
    }
    if (maxRetries < 1) {
      problems.add(
          'maxRetries: must be at least 1 (1 disables retry), got $maxRetries');
    }
    if (!_finitePositive(timeoutSeconds)) {
      problems.add('timeoutSeconds: must be a finite number > 0');
    }
    if (!_finitePositive(connectTimeoutSeconds)) {
      problems.add('connectTimeoutSeconds: must be a finite number > 0');
    }
    if (retryBackoffSeconds.isNaN ||
        retryBackoffSeconds.isInfinite ||
        retryBackoffSeconds < 0) {
      problems.add('retryBackoffSeconds: must be a finite number >= 0');
    }
    if (retryBackoffMaxSeconds.isNaN ||
        retryBackoffMaxSeconds.isInfinite ||
        retryBackoffMaxSeconds < retryBackoffSeconds) {
      problems.add(
          'retryBackoffMaxSeconds: must be finite and >= retryBackoffSeconds');
    }
    if (poolMaxsize < 1) problems.add('poolMaxsize: must be at least 1');
    _validateCeiling(problems, 'maxResponseBytes', maxResponseBytes);
    _validateCeiling(problems, 'maxRequestBytes', maxRequestBytes);
    _validateCeiling(problems, 'maxRequestSourceBytes', maxRequestSourceBytes);
    _validateCeiling(
        problems, 'maxMultipartOverheadBytes', maxMultipartOverheadBytes);
    _validateCeiling(problems, 'maxTokenCacheBytes', maxTokenCacheBytes);
    _validateCeiling(problems, 'maxCaBundleBytes', maxCaBundleBytes);
    _validateCodes(problems, 'retryableHttpCodes', retryableHttpCodes);
    _validateCodes(
        problems, 'unsafeRetryableHttpCodes', unsafeRetryableHttpCodes);
    if (logLevel == null || !_validLogLevels.contains(logLevel)) {
      // Printed in `_validLogLevels`'s severity order; do not sort it.
      problems.add('logLevel: expected one of ${_validLogLevels.join(', ')}, '
          "got '$logLevel'");
    }
    if (printFormat == null || !_validPrintFormats.contains(printFormat)) {
      problems.add(
          'printFormat: expected one of $printFormatPretty, $printFormatCompact, '
          "got '$printFormat'");
    }
    if (printMaxChars < 0) {
      problems.add('printMaxChars: must be >= 0 (0 = unlimited)');
    }
    if (!responseFormats.contains(responseFormat)) {
      problems.add(
          'responseFormat: expected one of ${responseFormats.join(', ')}, '
          "got '$responseFormat'. It is set in code, or in "
          '$responseFormatEnvironmentVariable, and nothing falls back silently');
    }
    if (userAgent.trim().isEmpty) problems.add('userAgent: must not be blank');
    if (proxyUrl != null) {
      final parsed = normaliseProxyUrl(proxyUrl!);
      if (parsed == null) {
        problems.add(
            'proxyUrl: must be an http(s) URL naming a host - the value is not '
            'shown, it may carry a password');
      } else if (parsed.scheme.toLowerCase() == 'https') {
        problems.add('proxyUrl: https proxies are not supported');
      }
    }
    if (caBundle != null) {
      if (!verifySsl) {
        problems.add(
            'caBundle and verifySsl=false are contradictory: one supplies a trust store, '
            'the other disables verification');
      }
      if (!pathIsFile(caBundle!)) {
        problems.add('caBundle: no such file (the configured path is on '
            'getErrorMessages())');
        withheld.add('caBundle: $caBundle');
      } else {
        final size = fileSizeOrNull(caBundle!);
        if (size != null && size > maxCaBundleBytes) {
          problems.add('caBundle: the configured trust store is $size bytes, '
              'over the $maxCaBundleBytes-byte maxCaBundleBytes ceiling; raise '
              'maxCaBundleBytes to accept it (the path is on '
              'getErrorMessages())');
          withheld.add('caBundle: $caBundle');
        }
      }
    }
    problems.addAll(_headerProblems(defaultHeaders));

    if (problems.isNotEmpty) {
      final refusal = SdkConfigError(problems.join('; '));
      for (final detail in withheld) {
        refusal.addError(detail);
      }
      throw refusal;
    }
  }

  static void _validateCeiling(
      List<String> problems, String name, int ceiling) {
    if (ceiling < 1) {
      problems.add('$name: must be at least 1 byte, got $ceiling');
    }
  }

  static void _validateCodes(
      List<String> problems, String name, Set<int> codes) {
    if (codes.length > _maxHttpCodes) {
      problems.add(
          '$name: at most $_maxHttpCodes status codes, got more than that');
      return;
    }
    for (final code in codes) {
      if (code < RetryPolicy.minStatusCode ||
          code > RetryPolicy.maxStatusCode) {
        problems.add('$name: $code is not an HTTP status code');
      }
    }
  }

  static List<String> _headerProblems(Map<String, String> headers) {
    final problems = <String>[];
    headers.forEach((name, value) {
      if (sendableHeaderName(name) && sendableHeaderValue(value)) return;
      problems.add(
          'defaultHeaders: ${jsonEncode(name)} cannot be sent as a header');
    });
    return problems;
  }

  static String? _blankToNull(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _normaliseApiVersion(String raw) {
    var value = raw.trim().toLowerCase();
    if (value.isNotEmpty && !value.startsWith('v')) value = 'v$value';
    return value;
  }

  static bool _finitePositive(double value) =>
      !value.isNaN && !value.isInfinite && value > 0;
}

/// The logical name a credentials block carries, or `null` when it names none.
String? readClientName(Object block) {
  if (block is SdkConfig) return block.auth.clientName;
  if (block is AuthConfig) return block.clientName;
  if (block is Map) {
    final value = block['client_name'];
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }
  return null;
}

/// The SDK version this package reports; the same value as [Sdk.version].
const String sdkVersion = Sdk.version;

/// Choose one credentials block, as [SdkConfig.selectCredentials] does.
Object selectCredentials(List<Object> credentials, [Object? instance]) =>
    SdkConfig.selectCredentials(credentials, instance);
