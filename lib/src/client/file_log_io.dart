import 'dart:io';

import '../config/sdk_config.dart';
import '../errors.dart';

/// One reference-counted append handle per log file in this isolate, released
/// once the last user detaches.
class FileLogSink {
  FileLogSink._(this._path, this._file);

  /// Open handles keyed by absolute path, so a relative `logFile` still matches.
  static final Map<String, FileLogSink> _open = <String, FileLogSink>{};

  final String _path;
  final RandomAccessFile _file;
  int _users = 1;

  /// A handle for [SdkConfig.logFile], or `null` when none is configured.
  static FileLogSink? attach(SdkConfig config) {
    final logFile = config.logFile;
    if (logFile == null) return null;
    final target = File(logFile).absolute.path;
    final existing = _open[target];
    if (existing != null) {
      existing._users += 1;
      return existing;
    }
    final RandomAccessFile file;
    try {
      file = File(target).openSync(mode: FileMode.append);
    } on Object catch (error) {
      throw SdkConfigError("logFile '$logFile' cannot be opened: $error",
          cause: error);
    }
    final handle = FileLogSink._(target, file);
    _open[target] = handle;
    return handle;
  }

  /// Append one record.
  void write(String line) {
    try {
      _file.writeStringSync('$line\n');
    } on Object {
      // Diagnostics must not take the request down.
    }
  }

  /// Release this client's claim; the last user closes the descriptor.
  void release() {
    _users -= 1;
    if (_users > 0) return;
    _open.remove(_path);
    try {
      _file.closeSync();
    } on Object {
      // Already closed.
    }
  }
}
