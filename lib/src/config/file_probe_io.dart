import 'dart:io';

/// Whether a path names an existing regular file.
bool pathIsFile(String path) {
  try {
    return FileSystemEntity.isFileSync(path);
  } on FileSystemException {
    return false;
  }
}

/// Whether a path names an existing directory.
bool pathIsDirectory(String path) {
  try {
    return FileSystemEntity.isDirectorySync(path);
  } on FileSystemException {
    return false;
  }
}

/// The size of the file at [path] in bytes, read from the directory entry, or
/// `null` when the file is not there or the platform refused the question.
int? fileSizeOrNull(String path) {
  try {
    return File(path).lengthSync();
  } on FileSystemException {
    return null;
  }
}
