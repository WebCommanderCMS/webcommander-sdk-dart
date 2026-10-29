/// File-system probes on web: no file system, so each answer leaves its config
/// check inert rather than wrong.
library;

/// Always `true` on web: a missing file cannot be proven, so nothing is refused.
bool pathIsFile(String path) => true;

/// Always `false` on web: a directory cannot be proven, so nothing is refused.
bool pathIsDirectory(String path) => false;

/// Always `null` on web: there is no file to measure.
int? fileSizeOrNull(String path) => null;
