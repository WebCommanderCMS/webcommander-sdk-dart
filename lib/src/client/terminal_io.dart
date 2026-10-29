import 'dart:io';

/// Whether ANSI colour should be emitted at all, before the caller's `printColor` is consulted.
bool stdoutSupportsColour() {
  final noColor = Platform.environment['NO_COLOR'];
  if (noColor != null && noColor.isNotEmpty) return false;
  if (Platform.environment['TERM'] == 'dumb') return false;
  return stdout.hasTerminal;
}

/// Write one warning line to stderr, never stdout: stdout is the data stream
/// the rendered exchanges own.
void writeWarning(String message) {
  try {
    stderr.writeln(message);
  } on Object {
    // The log record already carries it.
  }
}

/// Whether the console's encoding can represent [text], probed by round trip
/// because `SystemEncoding` substitutes rather than throws.
bool stdoutCanEncode(String text) {
  final encoding = stdout.encoding;
  return encoding.decode(encoding.encode(text)) == text;
}
