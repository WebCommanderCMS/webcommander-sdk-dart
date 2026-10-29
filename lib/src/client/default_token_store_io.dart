import '../auth/file_token_store.dart';
import '../auth/token_store.dart';
import '../config/sdk_config.dart';

/// Build the default token store on a native platform: a file cache keyed by the credential
/// fingerprint, or the memory store when the config carries no cache path.
TokenStore buildDefaultTokenStore(SdkConfig config) {
  final auth = config.auth;
  final path = auth.tokenCachePath;
  if (path == null) return MemoryTokenStore();
  return FileTokenStore(
      path,
      buildCredentialsNamespace(auth.baseUrl, auth.clientId, auth.clientSecret,
          auth.authString, auth.grantType),
      FileTokenStore.defaultLockWaitSeconds,
      config.maxTokenCacheBytes);
}
