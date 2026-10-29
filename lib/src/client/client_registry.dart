import '../config/auth_config.dart';
import '../config/sdk_config.dart';
import '../errors.dart';
import 'web_commander_client.dart';

/// Several instances open at once: one cached client per registered credentials
/// block, built on first use. Call [close] to close every client it built.
class ClientRegistry {
  /// Register one or more credentials blocks (each an [SdkConfig] or [AuthConfig]).
  ClientRegistry(List<Object> credentials) {
    if (credentials.isEmpty) {
      throw SdkUsageError(
          'ClientRegistry needs at least one credentials block');
    }
    for (final block in credentials) {
      _blocks.add(_asConfig(block));
    }
    _indexDeclaredNames();
  }

  final List<SdkConfig> _blocks = <SdkConfig>[];
  final Map<String, int> _names = <String, int>{};
  final List<String> _labels = <String>[];
  final Map<int, WebCommanderClient> _clients = <int, WebCommanderClient>{};
  final Set<int> _supplied = <int>{};

  static SdkConfig _asConfig(Object block) {
    if (block is SdkConfig) return block;
    if (block is AuthConfig) return SdkConfig(block);
    throw SdkUsageError(
        'credentials entries must be SdkConfig or AuthConfig, got ${block.runtimeType}');
  }

  void _indexDeclaredNames() {
    for (var i = 0; i < _blocks.length; i++) {
      final name = _blocks[i].auth.clientName;
      final earlier = _names[name];
      if (earlier != null) {
        throw SdkUsageError(
            "two instances share clientName '$name' (positions $earlier and "
            '$i); names must be unique so one can be told from the other');
      }
      _names[name] = i;
      _labels.add(name);
    }
  }

  /// Turn an instance selector into a position: `null` = first, an int, or a name.
  int resolveIndex([Object? name]) {
    if (name == null) return 0;
    if (name is int) {
      final size = _blocks.length;
      if (name >= -size && name < size) {
        return name % size;
      }
      throw SdkUsageError(
          'no instance at index $name; $size registered (0-${size - 1})');
    }
    if (name is String) {
      final index = _names[name];
      if (index != null) return index;
      throw SdkUsageError(
          "unknown instance '$name'; registered: ${_labels.join(', ')}");
    }
    throw SdkUsageError('name must be null, an index or a clientName');
  }

  /// A client for one instance, built and cached on first use.
  WebCommanderClient getClient([Object? name]) {
    final index = resolveIndex(name);
    return _clients.putIfAbsent(
        index, () => WebCommanderClient(_blocks[index]));
  }

  /// Register a pre-built client under a name; its lifetime stays the caller's.
  void addClient(String name, WebCommanderClient client) {
    if (name.trim().isEmpty) {
      throw SdkUsageError('addClient needs a non-blank name');
    }
    if (_names.containsKey(name)) {
      throw SdkUsageError("instance '$name' is already registered");
    }
    _blocks.add(client.config);
    final index = _blocks.length - 1;
    _names[name] = index;
    _labels.add(name);
    _clients[index] = client;
    _supplied.add(index);
  }

  /// Close every client this registry built — a supplied one is skipped, every
  /// close is attempted even when one fails, and all are dropped either way.
  void close() {
    final failures = <String>[];
    Object? first;
    for (final entry in _clients.entries.toList()) {
      if (_supplied.contains(entry.key)) continue;
      try {
        entry.value.close();
      } on Object catch (failure) {
        failures.add('${_labels[entry.key]}: $failure');
        first ??= failure;
      }
    }
    _clients.removeWhere((index, _) => !_supplied.contains(index));
    if (first != null) {
      throw SdkError(
          '${failures.length} client(s) failed to close (${failures.join('; ')}); '
          'all were attempted and dropped');
    }
  }

  static List<SdkConfig> _registered = const <SdkConfig>[];

  /// Register every instance this isolate can talk to; the first is the default.
  static void registerInstances(List<Object> credentials) {
    final validated = ClientRegistry(credentials);
    _registered = List<SdkConfig>.of(validated._blocks);
  }

  /// The instances registered by [registerInstances], first entry the default.
  static List<SdkConfig> getRegisteredInstances() {
    final snapshot = _registered;
    if (snapshot.isEmpty) {
      throw SdkUsageError(
          'no instances registered - call ClientRegistry.registerInstances(...) first');
    }
    return List<SdkConfig>.of(snapshot);
  }

  /// One label per registered instance, default first.
  static List<String> listInstanceNames() => List<String>.unmodifiable(
      getRegisteredInstances().map((config) => config.auth.clientName));
}

/// Register every instance this isolate can talk to; the first is the default.
void registerInstances(List<Object> credentials) =>
    ClientRegistry.registerInstances(credentials);

/// The instances registered by [registerInstances], first entry the default.
List<SdkConfig> getRegisteredInstances() =>
    ClientRegistry.getRegisteredInstances();

/// One label per registered instance, default first.
List<String> listInstanceNames() => ClientRegistry.listInstanceNames();
