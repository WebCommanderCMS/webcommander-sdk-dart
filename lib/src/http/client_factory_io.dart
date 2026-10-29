import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../config/file_probe_io.dart';
import '../config/sdk_config.dart';
import '../errors.dart';

/// Build the default native HTTP client: an [IOClient] over `dart:io`, honouring
/// the connect timeout, TLS verification, a CA bundle and a proxy.
http.Client createDefaultClient(SdkConfig config) {
  SecurityContext? context;
  final caBundle = config.caBundle;
  if (caBundle != null) {
    // Checked again: the file can be replaced after the config was validated.
    final size = fileSizeOrNull(caBundle);
    if (size != null && size > config.maxCaBundleBytes) {
      throw SdkUsageError(
          'caBundle: the configured trust store is $size bytes, '
          'over the ${config.maxCaBundleBytes}-byte maxCaBundleBytes ceiling; '
          'raise maxCaBundleBytes to accept it. The path is on '
          'getErrorMessages()')
        ..addError('caBundle: $caBundle');
    }
    try {
      // withTrustedRoots: false, so the named bundle replaces the trust store.
      context = SecurityContext(withTrustedRoots: false)
        ..setTrustedCertificates(caBundle);
    } on Object catch (error) {
      throw SdkUsageError('caBundle could not be loaded (${error.runtimeType})',
          cause: error)
        ..addError('caBundle: $caBundle');
    }
  }

  final inner = HttpClient(context: context)
    ..connectionTimeout =
        Duration(milliseconds: (config.connectTimeoutSeconds * 1000).round());

  if (!config.verifySsl) {
    inner.badCertificateCallback = (certificate, host, port) => true;
  }

  final proxyUrl = config.proxyUrl;
  if (proxyUrl != null) {
    final proxy = SdkConfig.normaliseProxyUrl(proxyUrl)!;
    final port = proxy.hasPort ? proxy.port : 80;
    inner.findProxy = (uri) => 'PROXY ${proxy.host}:$port';
    if (proxy.userInfo.isNotEmpty) {
      final colon = proxy.userInfo.indexOf(':');
      final user = colon < 0
          ? Uri.decodeComponent(proxy.userInfo)
          : Uri.decodeComponent(proxy.userInfo.substring(0, colon));
      final password = colon < 0
          ? ''
          : Uri.decodeComponent(proxy.userInfo.substring(colon + 1));
      inner.authenticateProxy = (host, proxyPort, scheme, realm) async {
        // Only Basic is answered: Digest or NTLM would be offered the password unasked.
        if (scheme.toLowerCase() != 'basic') return false;
        inner.addProxyCredentials(host, proxyPort, realm ?? '',
            HttpClientBasicCredentials(user, password));
        return true;
      };
    }
  }

  return IOClient(inner);
}

/// True on a native platform: a client this factory built keeps its own
/// `dart:io` connection pool, and closing it drops every pooled connection.
const bool canDiscardPooledConnections = true;

/// Whether an error is `dart:io`'s connect timeout, a plain [SocketException]
/// matched by its fixed message.
bool isConnectTimeout(Object error) =>
    error is SocketException &&
    error.message.startsWith('HTTP connection timed out');

/// Whether an error is a failure to establish the connection, given that the
/// caller has already established nothing was written.
bool isConnectionEstablishmentFailure(Object error) =>
    error is SocketException || error is TlsException;
