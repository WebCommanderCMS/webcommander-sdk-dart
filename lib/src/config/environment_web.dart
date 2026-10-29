/// The environment read on web: a browser has no process environment.
library;

/// Always `null` on web: there is no process environment to read.
String? readEnvironmentVariable(String name) => null;
