import 'dart:io';

/// One environment variable's value, or `null` when it is not set.
String? readEnvironmentVariable(String name) => Platform.environment[name];
