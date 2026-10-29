import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../config/sdk_config.dart';
import '../errors.dart';
import 'token_store.dart';

/// Token storage in a JSON file, shared between processes through an OS lock on
/// a sidecar file. Native only; use one isolate per cache path.
class FileTokenStore extends ScopedTokenStore {
  /// Open a store over a file path, keyed by a namespace (typically a
  /// fingerprint).
  FileTokenStore(String filePath,
      [String? namespace,
      double lockWaitSeconds = defaultLockWaitSeconds,
      int maxCacheBytes = defaultMaxCacheBytes])
      : _path = filePath,
        _lockPath = '$filePath.lock',
        _lockWaitMillis = _validatedLockWaitMillis(lockWaitSeconds),
        _maxCacheBytes = _validatedMaxCacheBytes(maxCacheBytes),
        _namespace = (namespace == null || namespace.isEmpty)
            ? _defaultNamespace
            : namespace {
    final parent = File(_path).parent;
    if (!parent.existsSync()) {
      try {
        parent.createSync(recursive: true);
      } on FileSystemException catch (error) {
        throw SdkConfigError(
            'tokenCachePath: the directory the configured cache path lives in '
            'could not be created (${error.runtimeType}); name a path whose '
            'parent exists, or keep the token in memory. The path is on '
            'getErrorMessages()',
            cause: error)
          ..addError('tokenCachePath: $_path');
      }
    }
  }

  static const String _defaultNamespace = 'default';

  /// How long an acquisition waits for another process by default — five minutes.
  static const double defaultLockWaitSeconds = 300;

  /// The longest wait this store accepts — one day.
  static const double maxLockWaitSeconds = 24 * 60 * 60;

  /// The default ceiling on the cache file this store reads — 1 MiB.
  static const int defaultMaxCacheBytes = SdkConfig.defaultMaxTokenCacheBytes;

  static const int _lockPollMillis = 50;
  static const int _replaceRetryAttempts = 5;
  static const int _replaceRetryInitialMillis = 10;

  // Per isolate: a POSIX lock is per process, so a second descriptor would re-grant it.
  static final Map<String, _SharedFileLock> _locksByPath =
      <String, _SharedFileLock>{};

  final String _path;
  final String _lockPath;
  final int _lockWaitMillis;
  final int _maxCacheBytes;
  final String _namespace;

  _SharedFileLock get _shared => _locksByPath.putIfAbsent(
      _canonicalLockKey(_lockPath), _SharedFileLock.new);

  // Refused before round(), which throws on NaN, infinity or a huge value.
  static int _validatedLockWaitMillis(double lockWaitSeconds) {
    if (lockWaitSeconds.isNaN ||
        lockWaitSeconds.isInfinite ||
        lockWaitSeconds < 0 ||
        lockWaitSeconds > maxLockWaitSeconds) {
      throw SdkConfigError(
          'lockWaitSeconds: expected a finite number of seconds from 0 to '
          '$maxLockWaitSeconds (0 gives up on the first poll), got '
          '$lockWaitSeconds');
    }
    return (lockWaitSeconds * 1000).round();
  }

  static int _validatedMaxCacheBytes(int maxCacheBytes) {
    if (maxCacheBytes < 1) {
      throw SdkConfigError('maxCacheBytes: must be at least 1 byte, got '
          '$maxCacheBytes');
    }
    return maxCacheBytes;
  }

  static String _canonicalLockKey(String lockPath) {
    final absolute = File(lockPath).absolute.path;
    return Platform.isWindows ? absolute.toLowerCase() : absolute;
  }

  /// The conventional per-user cache path for this platform, falling back to
  /// the system temp directory when the environment names no home.
  static String buildDefaultTokenCachePath(String filename) {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final separator = Platform.pathSeparator;
    String? root;
    if (Platform.isWindows) {
      root = Platform.environment['LOCALAPPDATA'] ?? home;
    } else if (Platform.isMacOS) {
      root = home == null ? null : '$home${separator}Library${separator}Caches';
    } else {
      root = Platform.environment['XDG_CACHE_HOME'] ??
          (home == null ? null : '$home$separator.cache');
    }
    if (root == null || !Directory(root).isAbsolute) {
      // A relative root would put a refresh token wherever the program started.
      root = Directory.systemTemp.path;
    }
    final directory = Directory('$root${separator}webcommander');
    try {
      directory.createSync(recursive: true);
    } on FileSystemException catch (error) {
      throw SdkConfigError(
          'the default token cache directory could not be created '
          '(${error.runtimeType}); pass a path, or keep the token in memory. The '
          "path is on getErrorMessages() and the platform's own reason on this "
          "error's cause",
          cause: error)
        ..addError('tokenCachePath: ${directory.path}');
    }
    _restrictToOwner(directory.path, isDirectory: true);
    return '${directory.path}$separator$filename';
  }

  // Best effort: dart:io has no chmod, and mobile platforms cannot run Process.
  static void _restrictToOwner(String path, {required bool isDirectory}) {
    if (Platform.isWindows) return;
    try {
      Process.runSync('chmod', <String>[isDirectory ? '700' : '600', path]);
    } on Object catch (_) {}
  }

  @override
  Future<Map<String, Object?>?> readTokenRecord() async {
    final release = await _shared.gate.acquire();
    try {
      return _readNamespaceRecord();
    } finally {
      release();
    }
  }

  @override
  Future<TokenRefreshScope> acquireTokenRefreshLock() async {
    final shared = _shared;
    final release = await shared.gate.acquire();
    try {
      shared.handle = await _takeFileLock();
    } on Object {
      release();
      rethrow;
    }
    shared.hold(release);
    return _FileScope(this, shared);
  }

  Future<RandomAccessFile> _takeFileLock() async {
    final waited = Stopwatch()..start();
    var recreatedParent = false;
    while (true) {
      final RandomAccessFile handle;
      try {
        // append, not write: write would truncate a file another process has locked.
        handle = await File(_lockPath).open(mode: FileMode.append);
      } on PathNotFoundException catch (error) {
        if (recreatedParent) throw _unopenableSidecar(error);
        recreatedParent = true;
        final reason = _remakeParentDirectory();
        if (reason == null) continue;
        throw SdkError('the token lock directory could not be recreated',
            cause: error)
          ..addError('lockSidecar: $_lockPath')
          ..addError('osReason: $reason');
      } on FileSystemException catch (error) {
        throw _unopenableSidecar(error);
      }
      try {
        // A fixed byte range: the lock must not depend on file length.
        await handle.lock(FileLock.exclusive, 0, 1);
        return handle;
      } on FileSystemException catch (error) {
        await _closeQuietly(handle);
        if (waited.elapsedMilliseconds >= _lockWaitMillis) {
          throw SdkError(
              'another process has held the token cache lock for longer than '
              '${_lockWaitMillis ~/ 1000}s; refusing to read or write the cache '
              'without it, since two processes refreshing at once overwrite one '
              'another. The sidecar path is on getErrorMessages()',
              cause: error)
            ..addError('lockSidecar: $_lockPath');
        }
        await Future<void>.delayed(
            const Duration(milliseconds: _lockPollMillis));
      }
    }
  }

  SdkError _unopenableSidecar(FileSystemException error) => SdkError(
      'the token cache lock sidecar could not be opened, so the cache cannot be '
      'locked; name a tokenCachePath this process can write, or keep the token '
      "in memory with tokenCachePath: null. The path and the operating system's "
      'own reason are on getErrorMessages()',
      cause: error)
    ..addError('lockSidecar: $_lockPath')
    ..addError('osReason: ${_osReason(error)}');

  static String _osReason(FileSystemException error) =>
      error.osError?.message ?? error.message;

  String? _remakeParentDirectory() {
    try {
      File(_path).parent.createSync(recursive: true);
      return null;
    } on FileSystemException catch (error) {
      return _osReason(error);
    }
  }

  // Closes the descriptor: POSIX drops every lock on a file when any descriptor closes.
  Future<void> _leave(_SharedFileLock shared) async {
    if (!shared.leave()) return;
    final handle = shared.handle;
    shared.handle = null;
    if (handle != null) {
      try {
        await handle.unlock(0, 1);
      } on FileSystemException catch (_) {}
      await _closeQuietly(handle);
    }
    // Released last, so no later acquisition overlaps giving up the OS lock.
    shared.openGate();
  }

  static Future<void> _closeQuietly(RandomAccessFile handle) async {
    try {
      await handle.close();
    } on FileSystemException catch (_) {}
  }

  Map<String, Object?>? _readNamespaceRecord() {
    final reading = _readCache();
    _refuseUnknownCache(reading);
    final entry = reading.records[_namespace];
    if (entry is Map) return Map<String, Object?>.from(entry);
    return null;
  }

  void _refuseUnknownCache(_CacheReading reading) {
    if (reading.state != _CacheState.corrupt &&
        reading.state != _CacheState.unreadable) {
      return;
    }
    throw SdkError(
        'the token cache is ${reading.state.description}: clear the token or '
        'use tokenCachePath: null',
        cause: reading.cause)
      ..addError('tokenCachePath: $_path');
  }

  Future<void> _writeNamespaceRecord(Map<String, Object?> record) async {
    final reading = _readCache();
    _refuseUnknownCache(reading);
    final stored = reading.records;
    stored[_namespace] = Map<String, Object?>.from(record);
    await _writeAllNamespaces(stored);
  }

  Future<void> _clearNamespaceRecord() async {
    final reading = _readCache();
    if (reading.state == _CacheState.corrupt ||
        reading.state == _CacheState.unreadable) {
      _deleteTokenFile();
      return;
    }
    final stored = reading.records;
    if (stored.remove(_namespace) == null) return;
    if (stored.isNotEmpty) {
      await _writeAllNamespaces(stored);
    } else {
      _deleteTokenFile();
    }
  }

  void _deleteTokenFile() {
    try {
      File(_path).deleteSync();
    } on PathNotFoundException catch (_) {
    } on FileSystemException catch (error) {
      throw SdkError(
          'the token cache file could not be deleted: a reusable token may still '
          'be on disk, so treat this as a failed logout rather than a completed '
          "one. The path and the operating system's own reason are on "
          'getErrorMessages()',
          cause: error)
        ..addError('tokenCachePath: $_path')
        ..addError('osReason: ${_osReason(error)}');
    }
  }

  // typeSync, not File.existsSync, which hides a directory at the cache path.
  _CacheReading _readCache() {
    final String content;
    try {
      final type = FileSystemEntity.typeSync(_path);
      if (type == FileSystemEntityType.notFound) {
        return const _CacheReading(_CacheState.absent);
      }
      if (type != FileSystemEntityType.file) {
        // typeSync follows links; anything but a file must never be written over.
        return const _CacheReading(_CacheState.unreadable);
      }
      final bytes = _readUpToCeiling();
      if (bytes == null) {
        return _CacheReading(_CacheState.unreadable,
            cause: SdkError(
                'the token cache is larger than the $_maxCacheBytes-byte ceiling '
                'this store reads; raise maxCacheBytes to accept it, or remove '
                'the file. The path is on getErrorMessages()')
              ..addError('tokenCachePath: $_path'));
      }
      content = utf8.decode(bytes, allowMalformed: true);
    } on FileSystemException catch (error) {
      return _CacheReading(_CacheState.unreadable, cause: error);
    }
    if (content.trim().isEmpty) return const _CacheReading(_CacheState.empty);
    final Object? parsed;
    try {
      parsed = jsonDecode(content);
    } on FormatException catch (error) {
      return _CacheReading(_CacheState.corrupt, cause: error);
    }
    if (parsed is! Map) return const _CacheReading(_CacheState.corrupt);
    return _CacheReading(_CacheState.records,
        records: Map<String, Object?>.from(parsed));
  }

  // Reads at most ceiling + 1 bytes, as the file can grow after a length check.
  Uint8List? _readUpToCeiling() {
    final handle = File(_path).openSync();
    try {
      final read = handle.readSync(_maxCacheBytes + 1);
      return read.length > _maxCacheBytes ? null : read;
    } finally {
      try {
        handle.closeSync();
      } on FileSystemException catch (_) {}
    }
  }

  Future<void> _writeAllNamespaces(Map<String, Object?> stored) async {
    File(_path).parent.createSync(recursive: true);
    final temporary =
        File('$_path.${DateTime.now().microsecondsSinceEpoch}.tmp');
    try {
      // Narrowed to 0600 while empty, so the secret is never world-readable.
      temporary.createSync();
      _restrictToOwner(temporary.path, isDirectory: false);
      temporary.writeAsStringSync(jsonEncode(stored));
      await _replaceTokenFile(temporary);
      _restrictToOwner(_path, isDirectory: false);
    } on Object {
      _tryDelete(temporary.path);
      rethrow;
    }
  }

  Future<void> _replaceTokenFile(File temporary) async {
    var wait = _replaceRetryInitialMillis;
    for (var attempt = 0;; attempt++) {
      try {
        // No delete-first: renameSync replaces the target; the retry covers a Windows reader.
        temporary.renameSync(_path);
        return;
      } on FileSystemException {
        if (!Platform.isWindows || attempt == _replaceRetryAttempts - 1) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: wait));
        wait *= 2;
      }
    }
  }

  static void _tryDelete(String path) {
    try {
      File(path).deleteSync();
    } on FileSystemException catch (_) {}
  }
}

class _SharedFileLock extends LockState {
  RandomAccessFile? handle;
}

enum _CacheState {
  absent('not there'),
  empty('empty'),
  records('readable'),
  corrupt('present but not a JSON object'),
  unreadable('present but could not be read');

  const _CacheState(this.description);

  final String description;
}

class _CacheReading {
  const _CacheReading(this.state, {Map<String, Object?>? records, this.cause})
      : _records = records;

  final _CacheState state;

  final Map<String, Object?>? _records;

  final Object? cause;

  Map<String, Object?> get records => _records == null
      ? <String, Object?>{}
      : Map<String, Object?>.of(_records);
}

class _FileScope extends LockScope {
  _FileScope(this._store, this._shared) : super(_shared);

  final FileTokenStore _store;
  final _SharedFileLock _shared;

  @override
  Future<Map<String, Object?>?> readTokenRecord() async {
    requireLive('readTokenRecord()');
    return _store._readNamespaceRecord();
  }

  @override
  Future<void> writeTokenRecord(Map<String, Object?> record) {
    requireLive('writeTokenRecord()');
    return _store._writeNamespaceRecord(record);
  }

  @override
  Future<void> clearTokenRecord() {
    requireLive('clearTokenRecord()');
    return _store._clearNamespaceRecord();
  }

  @override
  LockScope nestedScope() => _FileScope(_store, _shared);

  @override
  Future<void> leave() => _store._leave(_shared);
}

/// The conventional per-user cache path for this platform, under [filename].
String buildDefaultTokenCachePath(
        [String filename = defaultTokenCacheFilename]) =>
    FileTokenStore.buildDefaultTokenCachePath(filename);
