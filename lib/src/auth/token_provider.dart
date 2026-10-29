import 'dart:math';

import '../client/api_response.dart';
import '../config/sdk_config.dart';
import '../errors.dart';
import '../http/transport.dart';
import '../redaction.dart';
import 'token_store.dart';

/// Fetches, caches and renews the access token.
class TokenProvider {
  /// Build a provider; [tokenPath] overrides the default endpoint path.
  TokenProvider(this._config, this._transport, this._tokenStore,
      {String? tokenPath, void Function(String message)? onCacheDegraded})
      : _tokenPath = tokenPath ?? buildTokenPath(_config.apiVersion),
        _onCacheDegraded = onCacheDegraded;

  static const String _refreshGrantType = 'refresh_token';

  final SdkConfig _config;
  final Transport _transport;
  final TokenStore _tokenStore;
  final String _tokenPath;
  final void Function(String message)? _onCacheDegraded;

  /// Report that a token was obtained but could not be cached.
  void _reportCacheDegradation(SdkError refused) => _onCacheDegraded?.call(
      'the access token was obtained but not cached: ${refused.message}. Every '
      'call will buy a fresh token until the cache works again');

  /// The absolute token endpoint URL.
  String get tokenUrl => _config.baseUrl + _tokenPath;

  /// A usable access token, fetching one only if needed. A token store that
  /// cannot be read fails this call; one that cannot be written does not.
  Future<String> getAccessToken() async {
    final record = TokenRecord.fromMap(await _tokenStore.readTokenRecord());
    if (record != null && !record.needsRefresh()) return record.accessToken;
    return _renew(null, anyCachedTokenWillDo: true);
  }

  /// Replace a token the API has just rejected; a different cached token means
  /// another worker already renewed, and that one is returned instead.
  Future<String> refreshAccessToken(String? staleAccessToken) =>
      _renew(staleAccessToken, anyCachedTokenWillDo: false);

  Future<String> _renew(String? staleAccessToken,
      {required bool anyCachedTokenWillDo}) async {
    final scope = await _tokenStore.acquireTokenRefreshLock();
    try {
      final record = TokenRecord.fromMap(await scope.readTokenRecord());
      if (record != null && !record.needsRefresh()) {
        if (anyCachedTokenWillDo ||
            (staleAccessToken != null &&
                record.accessToken != staleAccessToken)) {
          return record.accessToken;
        }
      }

      TokenRecord? renewed;
      final refreshToken = record?.refreshToken;
      if (refreshToken != null) {
        renewed = await _requestTokenWithRefreshGrant(refreshToken);
      }
      renewed ??= await _requestTokenWithCredentials();

      try {
        await scope.writeTokenRecord(renewed.toMap());
      } on SdkError catch (refused) {
        if (_isCallerFault(refused)) rethrow;
        _reportCacheDegradation(refused);
      }
      return renewed.accessToken;
    } finally {
      await scope.release();
    }
  }

  Future<TokenRecord> _requestTokenWithCredentials() async {
    final response = await _transport.sendHttpRequest(
      TransportRequest('POST', tokenUrl,
          jsonBody: _credentialsPayload(),
          headers: _tokenHeaders(),
          endpointTemplate: tokenPathTemplate),
    );
    if (!response.succeeded) {
      final messages = response.getErrorMessages();
      // Counts what the endpoint said, never quotes it: it echoes credential material.
      final error = SdkAuthError(
        'token request failed with ${response.statusCode} '
        '(${messages.length} message(s) from the endpoint)',
        statusCode: response.statusCode,
        errorType: response.errorType,
        rawResponse: Redaction.redactValue(response.map),
        responseHeaders: Redaction.redactMapping(response.headers),
        requestInfo: response.requestInfo,
      );
      for (final message in messages) {
        error.addError(message);
      }
      throw error;
    }
    return _buildTokenRecord(response, null);
  }

  /// The cheap grant; an expected failure falls back to full credentials.
  Future<TokenRecord?> _requestTokenWithRefreshGrant(
      String refreshToken) async {
    final payload = <String, Object?>{
      'grant_type': _refreshGrantType,
      'refresh_token': refreshToken,
      'redirect_uri': _config.auth.redirectUri,
      'client_id': _config.auth.clientId,
      'client_secret': _config.auth.clientSecret,
    };
    try {
      final response = await _transport.sendHttpRequest(
        TransportRequest('POST', tokenUrl,
            jsonBody: payload,
            headers: _tokenHeaders(),
            endpointTemplate: tokenPathTemplate),
      );
      return response.succeeded
          ? _buildTokenRecord(response, refreshToken)
          : null;
    } on SdkError catch (error) {
      if (_isCallerFault(error)) rethrow;
      return null;
    }
  }

  static bool _isCallerFault(SdkError error) =>
      error is SdkUsageError || error is SdkConfigError;

  Map<String, Object?> _credentialsPayload() => <String, Object?>{
        'grant_type': _config.auth.grantType,
        'auth_string': _config.auth.authString,
        'redirect_uri': _config.auth.redirectUri,
        'client_id': _config.auth.clientId,
        'client_secret': _config.auth.clientSecret,
      };

  Map<String, String> _tokenHeaders() => <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': _config.userAgent,
      };

  static TokenRecord _buildTokenRecord(
      ApiResponse response, String? previousRefreshToken) {
    final body = response.map;
    final token =
        body is Map ? TokenRecord.normaliseToken(body['access_token']) : null;
    if (body is! Map || token == null) {
      throw SdkAuthError(
        'token response did not contain an access_token',
        statusCode: response.statusCode,
        errorType: response.errorType,
        rawResponse: Redaction.redactValue(body),
        requestInfo: response.requestInfo,
      );
    }
    final lifetimeSeconds = _readLifetimeSeconds(body['expires_in']);
    return TokenRecord(
      token,
      // RFC 6749 §6: no refresh token in the answer means keep the one held.
      TokenRecord.normaliseToken(body['refresh_token']) ?? previousRefreshToken,
      _nowSeconds() + lifetimeSeconds,
      min(TokenRecord.expirySkewSeconds, lifetimeSeconds / 2),
    );
  }

  /// NaN, infinity, non-positive and unparseable lifetimes all take the default.
  static double _readLifetimeSeconds(Object? expiresIn) {
    var lifetimeSeconds = TokenRecord.defaultTokenTtlSeconds;
    if (expiresIn is num) {
      lifetimeSeconds = expiresIn.toDouble();
    } else if (expiresIn is String) {
      lifetimeSeconds =
          double.tryParse(expiresIn) ?? TokenRecord.defaultTokenTtlSeconds;
    }
    if (lifetimeSeconds.isNaN ||
        lifetimeSeconds.isInfinite ||
        lifetimeSeconds <= 0) {
      lifetimeSeconds = TokenRecord.defaultTokenTtlSeconds;
    }
    return min(lifetimeSeconds, TokenRecord.maxTokenTtlSeconds);
  }
}

/// The token endpoint path with `{api_version}` still in it — the template
/// [buildTokenPath] substitutes into.
const String tokenPathTemplate = '/api/{api_version}/oauth2/token';

/// The token endpoint path for an API version.
String buildTokenPath(String apiVersion) =>
    tokenPathTemplate.replaceAll('{api_version}', apiVersion);

/// An access token and when it stops being usable. Renaming a key in [toMap]
/// orphans every cache file already on disk.
class TokenRecord {
  /// Construct a record; [fromMap] rebuilds one from a stored mapping.
  TokenRecord(String accessToken, String? refreshToken, this.expiresAt,
      this.skewSeconds)
      : accessToken = accessToken.trim(),
        refreshToken = normaliseToken(refreshToken);

  /// Assumed lifetime when the token endpoint gives none.
  static const double defaultTokenTtlSeconds = 3600;

  /// How early a token is treated as expired, by default.
  static const double expirySkewSeconds = 60;

  /// The furthest ahead a cached expiry is believed — one day; a stamp beyond
  /// it means refresh rather than believe.
  static const double maxTokenTtlSeconds = 24 * 60 * 60;

  /// The one reading of a token, wherever it came from: trimmed, and `null`
  /// when nothing is left of it.
  static String? normaliseToken(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// The bearer token.
  final String accessToken;

  /// The refresh token — non-blank, or `null`.
  final String? refreshToken;

  /// Epoch seconds when the token expires.
  final double expiresAt;

  /// How early to treat it as expired — carried per record.
  final double skewSeconds;

  /// Whether the token should be treated as expired — early, on purpose, so a
  /// token with seconds left does not fail in flight.
  bool needsRefresh() {
    final now = _nowSeconds();
    if (expiresAt - now > maxTokenTtlSeconds) return true;
    return now >= expiresAt - skewSeconds;
  }

  /// The plain mapping a token store persists.
  Map<String, Object?> toMap() => <String, Object?>{
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at': expiresAt,
        'skew_seconds': skewSeconds,
      };

  /// Rebuild from a stored mapping, or `null` when absent or malformed, which
  /// costs one extra authentication rather than an exception.
  static TokenRecord? fromMap(Map<String, Object?>? record) {
    if (record == null) return null;
    final accessToken = normaliseToken(record['access_token']);
    final expiresAt = _finiteNumber(record['expires_at']);
    if (accessToken == null || expiresAt == null) return null;
    var skew = _finiteNumber(record['skew_seconds']);
    if (skew == null || skew < 0) skew = expirySkewSeconds;
    skew = min(skew, maxTokenTtlSeconds);
    return TokenRecord(
        accessToken, normaliseToken(record['refresh_token']), expiresAt, skew);
  }

  /// Both tokens redacted, and the expiry as a **duration** rather than the
  /// absolute stamp.
  @override
  String toString() => "TokenRecord(accessToken='${Redaction.redacted}'"
      ", refreshToken='${refreshToken == null ? 'null' : Redaction.redacted}'"
      ', expiresIn=${_renderRemaining()})';

  String _renderRemaining() {
    final remaining = expiresAt - _nowSeconds();
    if (remaining.isNaN || remaining.isInfinite) return 'unusable';
    return remaining <= 0 ? 'expired' : '${remaining.floor()}s';
  }

  static double? _finiteNumber(Object? value) {
    if (value is! num) return null;
    final seconds = value.toDouble();
    return seconds.isNaN || seconds.isInfinite ? null : seconds;
  }
}

double _nowSeconds() => DateTime.now().millisecondsSinceEpoch / 1000.0;
