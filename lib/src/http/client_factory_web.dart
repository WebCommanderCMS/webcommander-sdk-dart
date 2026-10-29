import 'package:http/http.dart' as http;

import '../config/sdk_config.dart';

/// Build the default HTTP client on web: the browser client.
http.Client createDefaultClient(SdkConfig config) => http.Client();

/// False on web: connection reuse belongs to the browser, and there is no pool the SDK can reach.
const bool canDiscardPooledConnections = false;

/// Always `false` on web: there is no `HttpClient.connectionTimeout` to expire.
bool isConnectTimeout(Object error) => false;

/// Always `false` on web, where every transport failure is one opaque
/// `ClientException`.
bool isConnectionEstablishmentFailure(Object error) => false;
