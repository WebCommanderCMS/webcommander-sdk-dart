import '../config/sdk_config.dart';
import 'token_store.dart';

/// Web placeholder for [FileTokenStore]: there is no file system in the
/// browser, so this throws; use [MemoryTokenStore] instead.
class FileTokenStore implements TokenStore {
  /// Always throws on web — there is no file cache.
  FileTokenStore(String filePath,
      [String? namespace,
      double lockWaitSeconds = defaultLockWaitSeconds,
      int maxCacheBytes = defaultMaxCacheBytes]) {
    throw UnsupportedError(
        'FileTokenStore is not available on this platform (no dart:io); use MemoryTokenStore '
        'or supply your own TokenStore.');
  }

  /// How long an acquisition waits for another process by default — five minutes.
  static const double defaultLockWaitSeconds = 300;

  /// The longest wait this store accepts — one day.
  static const double maxLockWaitSeconds = 24 * 60 * 60;

  /// The default ceiling on the cache file this store reads — 1 MiB.
  static const int defaultMaxCacheBytes = SdkConfig.defaultMaxTokenCacheBytes;

  /// Always throws on web.
  static String buildDefaultTokenCachePath(String filename) =>
      throw UnsupportedError(
          'A default file token cache is not available on this platform (no dart:io).');

  @override
  Future<Map<String, Object?>?> readTokenRecord() =>
      throw UnsupportedError('web: no file cache');

  @override
  Future<void> writeTokenRecord(Map<String, Object?> record) =>
      throw UnsupportedError('web: no file cache');

  @override
  Future<void> clearTokenRecord() =>
      throw UnsupportedError('web: no file cache');

  @override
  Future<TokenRefreshScope> acquireTokenRefreshLock() =>
      throw UnsupportedError('web: no file cache');
}

/// Always throws on web — there is no file cache to name a path in.
String buildDefaultTokenCachePath(
        [String filename = defaultTokenCacheFilename]) =>
    FileTokenStore.buildDefaultTokenCachePath(filename);
