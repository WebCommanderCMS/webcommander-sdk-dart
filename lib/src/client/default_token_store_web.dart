import '../auth/token_store.dart';
import '../config/sdk_config.dart';

/// Build the default token store on web: memory only, since a browser has no
/// file cache.
TokenStore buildDefaultTokenStore(SdkConfig config) => MemoryTokenStore();
