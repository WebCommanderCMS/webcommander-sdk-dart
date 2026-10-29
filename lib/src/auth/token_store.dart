import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../errors.dart';

/// The cache filename the file store writes under the platform's per-user cache directory.
const String defaultTokenCacheFilename = 'wc_dart_token.json';

/// Fingerprint a set of credentials into a 16-character hex namespace, for
/// keying a token file shared between instances.
String buildCredentialsNamespace(String? baseUrl, String? clientId,
    [String? clientSecret = '',
    String? authString = '',
    String? grantType = '']) {
  final material = StringBuffer();
  for (final value in <String?>[
    'v3',
    baseUrl,
    clientId,
    clientSecret,
    authString,
    grantType
  ]) {
    final text = value ?? '';
    material
      ..write(text.runes.length)
      ..write(':')
      ..write(text);
  }
  return sha256
      .convert(utf8.encode(material.toString()))
      .toString()
      .substring(0, 16);
}

/// The token-store operations that run under an already-held refresh lock; call
/// [release] in a `finally`. A released or stale scope throws [SdkUsageError].
abstract class TokenRefreshScope {
  /// The stored token, read under the held lock — `null` when absent, and
  /// `SdkError` when the store cannot tell absent from unreadable.
  Future<Map<String, Object?>?> readTokenRecord();

  /// Persist a token under the held lock.
  Future<void> writeTokenRecord(Map<String, Object?> record);

  /// Discard the stored token under the held lock.
  Future<void> clearTokenRecord();

  /// Enter the same lock again from inside this held scope; the lock is given up
  /// on the last release, whichever scope that is.
  Future<TokenRefreshScope> enterNested();

  /// Release this scope. The lock itself goes on the final release.
  Future<void> release();
}

/// Where an access token lives between calls: persistence plus refresh
/// coordination.
abstract class TokenStore {
  /// The stored token, or `null` when there is none.
  Future<Map<String, Object?>?> readTokenRecord();

  /// Persist a token, replacing whatever was there; takes and releases the lock.
  Future<void> writeTokenRecord(Map<String, Object?> record);

  /// Discard the stored token, a no-op when there is none; takes and releases the lock.
  Future<void> clearTokenRecord();

  /// Hold the refresh lock for the lifetime of the returned scope, working
  /// through the scope rather than the standalone methods while it is held.
  Future<TokenRefreshScope> acquireTokenRefreshLock();
}

/// The standalone write and clear, each run through a refresh scope of its own.
abstract class ScopedTokenStore implements TokenStore {
  @override
  Future<void> writeTokenRecord(Map<String, Object?> record) async {
    final scope = await acquireTokenRefreshLock();
    try {
      await scope.writeTokenRecord(record);
    } finally {
      await scope.release();
    }
  }

  @override
  Future<void> clearTokenRecord() async {
    final scope = await acquireTokenRefreshLock();
    try {
      await scope.clearTokenRecord();
    } finally {
      await scope.release();
    }
  }
}

/// One refresh lock's gate and bookkeeping, shared by every scope handed out
/// under it.
class LockState {
  final AsyncLock gate = AsyncLock();

  /// Outstanding scopes; the lock is given up on the transition to zero.
  int depth = 0;

  /// Which holding of the lock is current.
  int generation = 0;

  void Function()? releaseGate;

  /// Record a fresh holding of the gate behind [release].
  void hold(void Function() release) {
    depth = 1;
    generation++;
    releaseGate = release;
  }

  /// Hand the gate on; true when this was the last outstanding scope.
  bool leave() {
    if (depth > 1) {
      depth--;
      return false;
    }
    depth = 0;
    return true;
  }

  void openGate() {
    final release = releaseGate;
    releaseGate = null;
    release?.call();
  }
}

/// A [TokenRefreshScope] over a [LockState], refusing work once released or
/// stale.
abstract class LockScope implements TokenRefreshScope {
  LockScope(this.lock) : _generation = lock.generation;

  final LockState lock;
  final int _generation;
  bool _released = false;

  /// Throw [SdkUsageError] unless this scope still owns the lock.
  void requireLive(String operation) {
    if (_released) {
      throw SdkUsageError(
          '$operation was called on a released token refresh scope');
    }
    if (lock.generation != _generation || lock.depth == 0) {
      throw SdkUsageError('$operation was called on a stale token refresh '
          'scope: the lock has since been given up and taken again');
    }
  }

  /// A further scope under the same holding.
  LockScope nestedScope();

  /// Give up this scope's share of the lock.
  Future<void> leave();

  @override
  Future<TokenRefreshScope> enterNested() async {
    requireLive('enterNested()');
    lock.depth++;
    return nestedScope();
  }

  @override
  Future<void> release() async {
    if (_released) return;
    _released = true;
    if (lock.generation != _generation) return;
    await leave();
  }
}

/// In-process token storage, isolated per instance: two clients with their own
/// stores never share a token.
class MemoryTokenStore extends ScopedTokenStore {
  final LockState _lock = LockState();
  Map<String, Object?>? _record;

  @override
  Future<Map<String, Object?>?> readTokenRecord() async {
    final release = await _lock.gate.acquire();
    try {
      return _readCore();
    } finally {
      release();
    }
  }

  @override
  Future<TokenRefreshScope> acquireTokenRefreshLock() async {
    _lock.hold(await _lock.gate.acquire());
    return _MemoryScope(this);
  }

  Map<String, Object?>? _readCore() =>
      _record == null ? null : Map<String, Object?>.of(_record!);
}

class _MemoryScope extends LockScope {
  _MemoryScope(this._store) : super(_store._lock);

  final MemoryTokenStore _store;

  @override
  Future<Map<String, Object?>?> readTokenRecord() async {
    requireLive('readTokenRecord()');
    return _store._readCore();
  }

  @override
  Future<void> writeTokenRecord(Map<String, Object?> record) async {
    requireLive('writeTokenRecord()');
    _store._record = Map<String, Object?>.of(record);
  }

  @override
  Future<void> clearTokenRecord() async {
    requireLive('clearTokenRecord()');
    _store._record = null;
  }

  @override
  LockScope nestedScope() => _MemoryScope(_store);

  @override
  Future<void> leave() async {
    if (lock.leave()) lock.openGate();
  }
}

/// A minimal async mutex: a chain of futures so acquirers run one at a time.
class AsyncLock {
  Future<void> _tail = Future<void>.value();

  /// Acquire the lock; returns a release callback.
  Future<void Function()> acquire() async {
    final done = Completer<void>();
    final previous = _tail;
    _tail = done.future;
    await previous;
    return done.complete;
  }
}
