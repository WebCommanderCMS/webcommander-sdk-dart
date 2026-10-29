/// Terminal capability probes on web: there is no terminal, so colour escapes
/// would land in a browser console as literal `[2m` noise.
library;

/// Always `false` on web: there is no terminal to colour.
bool stdoutSupportsColour() => false;

/// Web has no stderr; the browser console is the only channel.
void writeWarning(String message) {
  // ignore: avoid_print
  print(message);
}

/// Always `true` on web: a browser console is UTF-8.
bool stdoutCanEncode(String text) => true;
