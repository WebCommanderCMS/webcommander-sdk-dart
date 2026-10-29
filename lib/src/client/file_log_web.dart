import '../config/sdk_config.dart';
import '../errors.dart';

/// The web build of the file-log sink: no file system, so a configured
/// `logFile` is refused at construction rather than silently dropped.
class FileLogSink {
  FileLogSink._();

  /// Always `null` (no file), or an [SdkConfigError] when a `logFile` is
  /// configured on a platform that cannot write one.
  static FileLogSink? attach(SdkConfig config) {
    if (config.logFile == null) return null;
    throw SdkConfigError(
        'logFile: there is no file system on web - leave logFile unset and '
        'route records with the onLog hook instead');
  }

  /// Never reached on web ([attach] never returns an instance).
  void write(String line) {}

  /// Never reached on web ([attach] never returns an instance).
  void release() {}
}
