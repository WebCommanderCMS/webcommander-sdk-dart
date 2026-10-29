import 'dart:convert';

import '../auth/token_provider.dart';
import '../auth/token_store.dart';
import '../config/auth_config.dart';
import '../config/sdk_config.dart';
import '../errors.dart';
import '../http/query_params.dart';
import '../http/retry_policy.dart';
import '../http/transport.dart';
import '../http/url_builder.dart';
import '../redaction.dart';
import '../resources/aliases/aliases.dart';
import '../resources/blog_categories/blog_categories.dart';
import '../resources/blogs/blogs.dart';
import '../resources/carts/carts.dart';
import '../resources/categories/categories.dart';
import '../resources/cities/cities.dart';
import '../resources/common_settings/common_settings.dart';
import '../resources/countries/countries.dart';
import '../resources/currencies/currencies.dart';
import '../resources/customer_groups/customer_groups.dart';
import '../resources/customers/admin_customers.dart';
import '../resources/discount_profiles/discount_profiles.dart';
import '../resources/email/email.dart';
import '../resources/inventory_locations/inventory_locations.dart';
import '../resources/order_custom_fields/order_custom_fields.dart';
import '../resources/order_flags/order_flags.dart';
import '../resources/orders/orders.dart';
import '../resources/pages/pages.dart';
import '../resources/payment_gateways/payment_gateways.dart';
import '../resources/products/products.dart';
import '../resources/settings/animation_effects/animation_effects.dart';
import '../resources/settings/customer_portal/customer_portal.dart';
import '../resources/settings/ecommerce_settings/ecommerce_settings.dart';
import '../resources/settings/page_settings/category_page.dart';
import '../resources/settings/page_settings/checkout_page.dart';
import '../resources/settings/page_settings/product_page.dart';
import '../resources/settings/page_settings/search_result_page.dart';
import '../resources/settings/page_settings/shopping_cart.dart';
import '../resources/settings/price_display_settings/price_display_settings.dart';
import '../resources/settings/product_listing/product_listing.dart';
import '../resources/settings/search_settings/search_settings.dart';
import '../resources/settings/seo_configuration/seo_configuration.dart';
import '../resources/settings/shipping_settings/shipping_settings.dart';
import '../resources/settings/site_settings/site_settings.dart';
import '../resources/shipping_classes/shipping_classes.dart';
import '../resources/shipping_methods/shipping_methods.dart';
import '../resources/tax_codes/tax_codes.dart';
import '../resources/tax_country_taxes/tax_country_taxes.dart';
import '../resources/tax_custom_profiles/tax_custom_profiles.dart';
import '../resources/tax_profiles/tax_profiles.dart';
import '../resources/tax_rules/tax_rules.dart';
import '../resources/tax_settings/tax_settings.dart';
import '../resources/tax_zones/tax_zones.dart';
import '../resources/transactions/transactions.dart';
import '../resources/trash/trash.dart';
import '../resources/variations/variations.dart';
import 'api_response.dart';
import 'client_registry.dart';
import 'console.dart';
import 'default_token_store_web.dart'
    if (dart.library.io) 'default_token_store_io.dart';
import 'dto.dart';
import 'file_log_web.dart' if (dart.library.io) 'file_log_io.dart';
import 'resource_binding.dart';
import 'terminal_web.dart' if (dart.library.io) 'terminal_io.dart';

/// The prefix of every logger name, e.g. `webcommander.default`.
const String loggerName = 'webcommander';

/// Flatten a `clientName` into one logger-name segment.
String _loggerSafe(String clientName) =>
    Uri.encodeComponent(clientName).replaceAll('.', '%2E');

/// Authenticated access to one WebCommander store: config in, [ApiResponse] out.
/// Call [close] when done; a request after that is refused before any I/O.
class WebCommanderClient {
  /// Build a client over one store's configuration; the optional collaborators are
  /// injection points, and an injected [transport] stays open after [close].
  WebCommanderClient(
    this._config, {
    TokenStore? tokenStore,
    Transport? transport,
    RetryPolicy? retryPolicy,
    TokenProvider? tokenProvider,
    void Function(String message)? onLog,
    void Function(InsecureTransportWarning warning)? onWarning,
  })  : _onLog = onLog,
        _onWarning = onWarning {
    _logSink = FileLogSink.attach(_config);
    try {
      _warnAboutInsecureTransport();
      _ownsTransport = transport == null;
      _transport = transport ??
          Transport(_config,
              retryPolicy: retryPolicy, onProgress: _reportProgress);
      final store = tokenStore ?? buildDefaultTokenStore(_config);
      _tokenProvider = tokenProvider ??
          TokenProvider(_config, _transport, store,
              onCacheDegraded: (String message) => _log('WARNING', message));
    } on Object {
      _detachLogFile();
      rethrow;
    }
  }

  static const String _apiVersionParam = 'api_version';
  static const String _tokenFailureError = 'unauthorized';
  static const Set<String> _tokenFailureMessages = <String>{
    'invalid_access_token',
    'invalid_request'
  };

  final SdkConfig _config;
  final void Function(String message)? _onLog;
  final void Function(InsecureTransportWarning warning)? _onWarning;
  late final Transport _transport;

  /// Whether this client built its own transport, and so may close one.
  late final bool _ownsTransport;
  late final TokenProvider _tokenProvider;
  FileLogSink? _logSink;

  /// Latched by [close] and never cleared — a closed client is not reopened.
  bool _closed = false;

  /// How many accepted calls have not finished.
  int _inFlight = 0;

  /// Whether [close] ran with calls in flight, so owned resources await release.
  bool _releasePending = false;

  /// The configuration this client was built with.
  SdkConfig get config => _config;

  /// The logical name of this instance.
  String get name => _config.clientName;

  AdminCustomers? _adminCustomers;

  /// The admin customer endpoints, bound to this client.
  AdminCustomers get adminCustomers => _adminCustomers ??= AdminCustomers(this);

  SeoConfigurationSettings? _seoConfiguration;

  /// The SEO configuration settings endpoints, bound to this client.
  SeoConfigurationSettings get seoConfiguration =>
      _seoConfiguration ??= SeoConfigurationSettings(this);

  SearchResultPageSettings? _searchResultPage;

  /// The search result page settings endpoints, bound to this client.
  SearchResultPageSettings get searchResultPage =>
      _searchResultPage ??= SearchResultPageSettings(this);

  CategoryPageSettings? _categoryPage;

  /// The category page settings endpoints, bound to this client.
  CategoryPageSettings get categoryPage =>
      _categoryPage ??= CategoryPageSettings(this);

  ShoppingCartSettings? _shoppingCart;

  /// The shopping cart settings endpoints, bound to this client.
  ShoppingCartSettings get shoppingCart =>
      _shoppingCart ??= ShoppingCartSettings(this);

  ProductPageSettings? _productPage;

  /// The product page settings endpoints, bound to this client.
  ProductPageSettings get productPage =>
      _productPage ??= ProductPageSettings(this);

  CheckoutPageSettings? _checkoutPage;

  /// The checkout page settings endpoints, bound to this client.
  CheckoutPageSettings get checkoutPage =>
      _checkoutPage ??= CheckoutPageSettings(this);

  PriceDisplaySettingsResource? _priceDisplaySettings;

  /// The price display settings endpoints, bound to this client.
  PriceDisplaySettingsResource get priceDisplaySettings =>
      _priceDisplaySettings ??= PriceDisplaySettingsResource(this);

  AnimationEffectsSettings? _animationEffects;

  /// The animation effects settings endpoints, bound to this client.
  AnimationEffectsSettings get animationEffects =>
      _animationEffects ??= AnimationEffectsSettings(this);

  ProductListingResource? _productListing;

  /// The product listing settings endpoints, bound to this client.
  ProductListingResource get productListing =>
      _productListing ??= ProductListingResource(this);

  CustomerPortalSettings? _customerPortal;

  /// The customer portal settings endpoints, bound to this client.
  CustomerPortalSettings get customerPortal =>
      _customerPortal ??= CustomerPortalSettings(this);

  SiteSettingsResource? _siteSettings;

  /// The site settings endpoints, bound to this client.
  SiteSettingsResource get siteSettings =>
      _siteSettings ??= SiteSettingsResource(this);

  ShippingSettingsResource? _shippingSettings;

  /// The shipping settings endpoints, bound to this client.
  ShippingSettingsResource get shippingSettings =>
      _shippingSettings ??= ShippingSettingsResource(this);

  SearchSettingsResource? _searchSettings;

  /// The search settings endpoints, bound to this client.
  SearchSettingsResource get searchSettings =>
      _searchSettings ??= SearchSettingsResource(this);

  EcommerceSettingsResource? _ecommerceSettings;

  /// The ecommerce settings endpoints, bound to this client.
  EcommerceSettingsResource get ecommerceSettings =>
      _ecommerceSettings ??= EcommerceSettingsResource(this);

  OrderFlags? _orderFlags;

  /// The order flag endpoints, bound to this client.
  OrderFlags get orderFlags => _orderFlags ??= OrderFlags(this);

  InventoryLocations? _inventoryLocations;

  /// The inventory location endpoints, bound to this client.
  InventoryLocations get inventoryLocations =>
      _inventoryLocations ??= InventoryLocations(this);

  ShippingMethods? _shippingMethods;

  /// The shipping method endpoints, bound to this client.
  ShippingMethods get shippingMethods =>
      _shippingMethods ??= ShippingMethods(this);

  ShippingClasses? _shippingClasses;

  /// The shipping class endpoints, bound to this client.
  ShippingClasses get shippingClasses =>
      _shippingClasses ??= ShippingClasses(this);

  Aliases? _aliases;

  /// The domain alias endpoints, bound to this client.
  Aliases get aliases => _aliases ??= Aliases(this);

  Countries? _countries;

  /// The country endpoints, bound to this client.
  Countries get countries => _countries ??= Countries(this);

  Orders? _orders;

  /// The order endpoints, bound to this client.
  Orders get orders => _orders ??= Orders(this);

  Carts? _carts;

  /// The cart endpoints, bound to this client.
  Carts get carts => _carts ??= Carts(this);

  DiscountProfiles? _discountProfiles;

  /// The discount profile endpoints, bound to this client.
  DiscountProfiles get discountProfiles =>
      _discountProfiles ??= DiscountProfiles(this);

  Categories? _categories;

  /// The category endpoints, bound to this client.
  Categories get categories => _categories ??= Categories(this);

  BlogCategories? _blogCategories;

  /// The blog category endpoints, bound to this client.
  BlogCategories get blogCategories => _blogCategories ??= BlogCategories(this);

  OrderCustomFields? _orderCustomFields;

  /// The order custom field endpoints, bound to this client.
  OrderCustomFields get orderCustomFields =>
      _orderCustomFields ??= OrderCustomFields(this);

  TaxCodes? _taxCodes;

  /// The tax code endpoints, bound to this client.
  TaxCodes get taxCodes => _taxCodes ??= TaxCodes(this);

  TaxProfiles? _taxProfiles;

  /// The tax profile endpoints, bound to this client.
  TaxProfiles get taxProfiles => _taxProfiles ??= TaxProfiles(this);

  TaxRules? _taxRules;

  /// The tax rule endpoints, bound to this client.
  TaxRules get taxRules => _taxRules ??= TaxRules(this);

  TaxZones? _taxZones;

  /// The tax zone endpoints, bound to this client.
  TaxZones get taxZones => _taxZones ??= TaxZones(this);

  TaxSettingsResource? _taxSettings;

  /// The tax settings endpoints, bound to this client.
  TaxSettingsResource get taxSettings =>
      _taxSettings ??= TaxSettingsResource(this);

  TaxCountryTaxes? _taxCountryTaxes;

  /// The country tax endpoints, bound to this client.
  TaxCountryTaxes get taxCountryTaxes =>
      _taxCountryTaxes ??= TaxCountryTaxes(this);

  TaxCustomProfiles? _taxCustomProfiles;

  /// The custom tax profile endpoints, bound to this client.
  TaxCustomProfiles get taxCustomProfiles =>
      _taxCustomProfiles ??= TaxCustomProfiles(this);

  Blogs? _blogs;

  /// The blog and blog comment endpoints, bound to this client.
  Blogs get blogs => _blogs ??= Blogs(this);

  Products? _products;

  /// The product row and stock endpoints, bound to this client.
  Products get products => _products ??= Products(this);

  Currencies? _currencies;

  /// The currency endpoints, bound to this client.
  Currencies get currencies => _currencies ??= Currencies(this);

  CustomerGroups? _customerGroups;

  /// The customer group endpoints, bound to this client.
  CustomerGroups get customerGroups => _customerGroups ??= CustomerGroups(this);

  VariationsResource? _variations;

  /// The variation type and product variant endpoints, bound to this client.
  VariationsResource get variations => _variations ??= VariationsResource(this);

  Cities? _cities;

  /// The city lookup endpoints under `/app`, bound to this client.
  Cities get cities => _cities ??= Cities(this);

  Transactions? _transactions;

  /// The transaction-number endpoints, bound to this client.
  Transactions get transactions => _transactions ??= Transactions(this);

  PaymentGateways? _paymentGateways;

  /// The payment gateway endpoints, bound to this client.
  PaymentGateways get paymentGateways =>
      _paymentGateways ??= PaymentGateways(this);

  Trash? _trash;

  /// The trash endpoints, bound to this client.
  Trash get trash => _trash ??= Trash(this);

  Email? _email;

  /// The email endpoints, bound to this client.
  Email get email => _email ??= Email(this);

  CommonSettingsResource? _commonSettings;

  /// The store-wide settings endpoints outside `/admin`, bound to this client.
  CommonSettingsResource get commonSettings =>
      _commonSettings ??= CommonSettingsResource(this);

  Pages? _pages;

  /// The page endpoints, bound to this client.
  Pages get pages => _pages ??= Pages(this);

  /// Every resource reachable as a property on this client, sorted.
  List<String> listResourceNames() => registeredResourceNames();

  /// One resource by a name [listResourceNames] reports, or an
  /// [SdkAttributeError] naming what is available.
  Object resourceByName(String name) => BoundResource(name, this).value;

  /// Send one request and return the response; [jsonBody] takes a map, a list, a
  /// raw JSON `String` sent byte for byte, or a payload DTO.
  Future<ApiResponse> sendApiRequest(
    String httpMethod,
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) async {
    _refuseWhenClosed(httpMethod);
    _inFlight++;
    try {
      _validatePath(path);
      final payload = _resolvePayload(jsonBody);
      _validatePayload(jsonBody: payload, formData: formData, files: files);
      final format = _resolveResponseFormat(responseFormat);
      validateRequestHeaders(headers);

      final resolvedPath = UrlBuilder.substitutePathParams(
          path, _seedApiVersion(path, pathParams));
      final url = UrlBuilder.buildUrl(_config.baseUrl, resolvedPath);
      final normalisedParams = QueryParams.build(queryParams);
      _rejectDuplicatedQueryParams(url, normalisedParams);

      // Snapshotted before the first await: every attempt sends the validated bytes.
      final canonical = TransportRequest(
        httpMethod,
        url,
        queryParams: normalisedParams,
        jsonBody: payload,
        formData: formData,
        files: files,
        responseFormat: format,
        dtoDecoder: dtoDecoder,
        endpointTemplate: deriveEndpointTemplate(path),
        requestInfoBody: Redaction.redactValue(
            Console.summarisePayload(payload ?? formData, files)),
        maxRequestBytes: _config.maxRequestBytes,
        maxRequestSourceBytes: _config.maxRequestSourceBytes,
        maxMultipartOverheadBytes: _config.maxMultipartOverheadBytes,
      );
      final callerHeaders =
          headers == null ? null : Map<String, String>.unmodifiable(headers);
      final reportedBody = canonical.jsonBody ?? canonical.formData;

      final accessToken =
          authenticated ? await _tokenProvider.getAccessToken() : null;

      var response = await _sendOnce(canonical, accessToken, callerHeaders,
          reportedBody: reportedBody);

      if (authenticated && _meansExpiredToken(response, canonical.httpMethod)) {
        _reportExchange(response, reportedBody,
            files: canonical.files,
            formData: canonical.formData,
            warning: true);
        final fresh = await _tokenProvider.refreshAccessToken(accessToken);
        response = await _sendOnce(canonical, fresh, callerHeaders,
            reportedBody: reportedBody);
      }
      _reportExchange(response, reportedBody,
          files: canonical.files, formData: canonical.formData, warning: false);

      final shouldRaise = raiseOnError ?? _config.raiseOnError;
      return shouldRaise ? response.raiseForStatus() : response;
    } finally {
      _inFlight--;
      _releaseOwnedResourcesWhenDrained();
    }
  }

  /// Send a GET request through [sendApiRequest].
  Future<ApiResponse> sendGetRequest(
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) =>
      sendApiRequest('GET', path,
          pathParams: pathParams,
          queryParams: queryParams,
          jsonBody: jsonBody,
          formData: formData,
          files: files,
          headers: headers,
          authenticated: authenticated,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat,
          dtoDecoder: dtoDecoder);

  /// Send a POST request through [sendApiRequest].
  Future<ApiResponse> sendPostRequest(
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) =>
      sendApiRequest('POST', path,
          pathParams: pathParams,
          queryParams: queryParams,
          jsonBody: jsonBody,
          formData: formData,
          files: files,
          headers: headers,
          authenticated: authenticated,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat,
          dtoDecoder: dtoDecoder);

  /// Send a PUT request through [sendApiRequest].
  Future<ApiResponse> sendPutRequest(
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) =>
      sendApiRequest('PUT', path,
          pathParams: pathParams,
          queryParams: queryParams,
          jsonBody: jsonBody,
          formData: formData,
          files: files,
          headers: headers,
          authenticated: authenticated,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat,
          dtoDecoder: dtoDecoder);

  /// Send a PATCH request through [sendApiRequest].
  Future<ApiResponse> sendPatchRequest(
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) =>
      sendApiRequest('PATCH', path,
          pathParams: pathParams,
          queryParams: queryParams,
          jsonBody: jsonBody,
          formData: formData,
          files: files,
          headers: headers,
          authenticated: authenticated,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat,
          dtoDecoder: dtoDecoder);

  /// Send a DELETE request through [sendApiRequest].
  Future<ApiResponse> sendDeleteRequest(
    String path, {
    Map<String, Object?>? pathParams,
    Map<String, Object?>? queryParams,
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
    Map<String, String>? headers,
    bool authenticated = true,
    bool? raiseOnError,
    String? responseFormat,
    DtoDecoder? dtoDecoder,
  }) =>
      sendApiRequest('DELETE', path,
          pathParams: pathParams,
          queryParams: queryParams,
          jsonBody: jsonBody,
          formData: formData,
          files: files,
          headers: headers,
          authenticated: authenticated,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat,
          dtoDecoder: dtoDecoder);

  /// Release pooled connections and the `logFile` handle, and refuse later requests.
  void close() {
    // Latched first, so a throwing transport close still leaves the client refusing.
    _closed = true;
    if (_inFlight > 0) {
      _releasePending = true;
      return;
    }
    _releaseOwnedResources();
  }

  /// Release what this client owns once the last accepted call has returned.
  void _releaseOwnedResourcesWhenDrained() {
    if (!_releasePending || _inFlight > 0) return;
    _releasePending = false;
    _releaseOwnedResources();
  }

  void _releaseOwnedResources() {
    try {
      if (_ownsTransport) _transport.close();
    } finally {
      _detachLogFile();
    }
  }

  /// Release pooled connections and the `logFile` handle. An alias for [close].
  void closeClient() => close();

  /// Refuse a request on a closed client with an [SdkUsageError], before any I/O.
  void _refuseWhenClosed(String httpMethod) {
    if (!_closed) return;
    throw SdkUsageError(
        "client '${_config.clientName}' is closed: close() released its HTTP "
        'client, so this $httpMethod cannot be sent. A closed client is not '
        'reopened - build a new one.');
  }

  /// Send the canonical request once, under the headers this attempt's token produces.
  Future<ApiResponse> _sendOnce(
    TransportRequest canonical,
    String? accessToken,
    Map<String, String>? callerHeaders, {
    required Object? reportedBody,
  }) async {
    final headers = _buildRequestHeaders(callerHeaders, accessToken);
    try {
      return await _transport.sendHttpRequest(canonical.withHeaders(headers,
          requestInfoHeaders: Redaction.redactMapping(headers)));
    } on SdkError catch (error) {
      final info = error.requestInfo;
      if (info is RequestInfo) {
        _reportFailure(info, reportedBody,
            files: canonical.files, formData: canonical.formData);
      }
      rethrow;
    }
  }

  /// Merge headers case-insensitively; the SDK's `Authorization` cannot be overridden.
  Map<String, String> _buildRequestHeaders(
      Map<String, String>? callerHeaders, String? accessToken) {
    final canonical = <String, String>{};
    final byLowerName = <String, String>{};

    _putHeader(canonical, byLowerName, 'Accept', 'application/json');
    _putHeader(canonical, byLowerName, 'User-Agent', _config.userAgent);
    _config.defaultHeaders.forEach(
        (name, value) => _putHeader(canonical, byLowerName, name, value));
    callerHeaders?.forEach(
        (name, value) => _putHeader(canonical, byLowerName, name, value));
    if (accessToken != null) {
      byLowerName.remove('authorization');
      _putHeader(
          canonical, byLowerName, 'Authorization', 'Bearer $accessToken');
    }
    final merged = <String, String>{};
    byLowerName.forEach((lower, value) => merged[canonical[lower]!] = value);
    return merged;
  }

  static const Map<String, String> _sdkHeaderSpellings = <String, String>{
    'authorization': 'Authorization',
    'accept': 'Accept',
    'user-agent': 'User-Agent',
  };

  static void _putHeader(Map<String, String> canonical,
      Map<String, String> byLowerName, String name, String value) {
    final lower = name.toLowerCase();
    canonical[lower] = _sdkHeaderSpellings[lower] ?? canonical[lower] ?? name;
    byLowerName[lower] = value;
  }

  Map<String, Object?> _seedApiVersion(
      String path, Map<String, Object?>? pathParams) {
    final resolved = pathParams == null
        ? <String, Object?>{}
        : Map<String, Object?>.of(pathParams);
    if (UrlBuilder.findPathParamNames(path).contains(_apiVersionParam) &&
        !resolved.containsKey(_apiVersionParam)) {
      resolved[_apiVersionParam] = _config.apiVersion;
    }
    return resolved;
  }

  static void _validatePath(String path) {
    if (path.trim().isEmpty) {
      throw SdkUsageError('path must name an endpoint');
    }
  }

  /// A payload DTO's map, or the body unchanged.
  static Object? _resolvePayload(Object? jsonBody) =>
      jsonBody is Dto ? jsonBody.toMap() : jsonBody;

  /// The form this call's response takes: the parameter if given, else the config's.
  String _resolveResponseFormat(String? responseFormat) {
    if (responseFormat == null) return _config.responseFormat;
    final named = responseFormat.trim().toLowerCase();
    if (SdkConfig.responseFormats.contains(named)) return named;
    throw SdkUsageError('responseFormat: expected one of '
        "${SdkConfig.responseFormats.join(', ')}, got '$responseFormat'");
  }

  static void _validatePayload({
    Object? jsonBody,
    Map<String, Object?>? formData,
    Map<String, Object?>? files,
  }) {
    if (jsonBody != null && formData != null) {
      throw SdkUsageError(
          'pass jsonBody or formData, not both - they are different content '
          'types and only one can be sent');
    }
    if (jsonBody != null && files != null) {
      throw SdkUsageError(
          'pass jsonBody or files, not both - a multipart body replaces the '
          'JSON one, so the JSON would be discarded unsent');
    }

    if (jsonBody == null) return;
    if (jsonBody is String) {
      final Object? decoded;
      try {
        decoded = jsonDecode(jsonBody);
      } on FormatException catch (error) {
        throw SdkUsageError('jsonBody: not valid JSON: ${error.message}',
            cause: error);
      }
      if (decoded is! Map && decoded is! List) {
        throw SdkUsageError(
            'jsonBody: a JSON string must hold an object or an array, got '
            '${decoded.runtimeType}');
      }
      return;
    }
    if (jsonBody is! Map && jsonBody is! List) {
      throw SdkUsageError(
          'jsonBody must be a JSON string, a map, a list or a payload DTO, got '
          '${jsonBody.runtimeType}');
    }
    try {
      jsonEncode(jsonBody);
    } on JsonUnsupportedObjectError catch (error) {
      throw SdkUsageError(
          'jsonBody is not JSON-serialisable: holds a '
          '${error.unsupportedObject.runtimeType}',
          cause: error);
    }
  }

  static void _rejectDuplicatedQueryParams(
      String url, Map<String, Object?> queryParams) {
    final mark = url.indexOf('?');
    if (queryParams.isEmpty || mark < 0) return;
    final existing = <String>{};
    for (final chunk in url.substring(mark + 1).split('&')) {
      final equals = chunk.indexOf('=');
      existing.add(equals < 0 ? chunk : chunk.substring(0, equals));
    }
    final clash = queryParams.keys.where(existing.contains).toList()..sort();
    if (clash.isNotEmpty) {
      throw SdkUsageError(
          "query params ${clash.join(', ')} already in the path");
    }
  }

  /// Whether a 401 means the access token rather than the request.
  static bool _meansExpiredToken(ApiResponse response, String method) {
    if (response.statusCode != 401) return false;
    final body = response.map;
    if (body is! Map) return !RetryPolicy.isUnsafeMethod(method);
    if (_normalisedReason(body['error']) == _tokenFailureError) return true;
    return _tokenFailureMessages.contains(_normalisedReason(body['message']));
  }

  static String _normalisedReason(Object? value) =>
      value == null ? '' : value.toString().trim().toLowerCase();

  /// Report that a request is in flight, or that a retry is waiting.
  void _reportProgress(String message) {
    if (_config.printApiInfo && !_config.printOnlyOnError) {
      // ignore: avoid_print
      print(message);
    }
    _log('INFO', message);
  }

  bool get _wantsPrint =>
      _config.printApiInfo ||
      _config.printRequestPayload ||
      _config.printResponseBody ||
      _config.printHeaders ||
      _config.printCurl;

  /// Print and log a send that never produced a response.
  void _reportFailure(
    RequestInfo info,
    Object? reportedBody, {
    Map<String, Object?>? files,
    Map<String, Object?>? formData,
  }) {
    if (_wantsPrint) {
      // ignore: avoid_print
      print(Console.renderFailure(info, reportedBody, _config,
          files: files, formEncoded: formData != null));
    }
    _log(
        'ERROR',
        '${info.httpMethod} ${info.endpointTemplate} -> '
            '${Console.noResponseStatus} in ${info.elapsedSeconds}s '
            '(attempt ${info.attemptCount}/${info.maxAttempts})');
  }

  void _reportExchange(
    ApiResponse response,
    Object? reportedBody, {
    Map<String, Object?>? files,
    Map<String, Object?>? formData,
    required bool warning,
  }) {
    final RequestInfo? info = response.requestInfo;
    if (info != null) {
      if (_wantsPrint && !(_config.printOnlyOnError && response.succeeded)) {
        // ignore: avoid_print
        print(Console.renderExchange(response, reportedBody, _config,
            files: files, formEncoded: formData != null));
      }
      final level = warning ? 'WARNING' : 'INFO';
      // The template, not the resolved URL, which carries a record's id.
      _log(
          level,
          '${info.httpMethod} ${info.endpointTemplate} -> ${response.statusCode} '
          'in ${info.elapsedSeconds}s '
          '(attempt ${info.attemptCount}/${info.maxAttempts})');
    }

    if (_config.logBodies) {
      _log(
          'DEBUG',
          'payload=${Console.renderJsonValue(Redaction.redactValue(reportedBody), compact: true)} '
              'response=${Console.renderJsonValue(Redaction.redactValue(response.map), compact: true)}');
    }
  }

  /// One record to both the `onLog` hook and the `logFile` sink, gated by `logLevel`.
  void _log(String level, String message) {
    final threshold = _levelRanks[_config.logLevel]!;
    if (_levelRanks[level]! < threshold) return;
    _onLog?.call('$level $message');
    _writeLogFile(level, message);
  }

  static const Map<String, int> _levelRanks = <String, int>{
    'DEBUG': 0,
    'INFO': 1,
    'WARNING': 2,
    'ERROR': 3,
    'CRITICAL': 4,
  };

  void _writeLogFile(String level, String message) {
    final sink = _logSink;
    if (sink == null) return;
    sink.write('${DateTime.now().toIso8601String()} $level '
        '$loggerName.${_loggerSafe(_config.clientName)} $message');
  }

  void _detachLogFile() {
    final sink = _logSink;
    if (sink == null) return;
    _logSink = null;
    sink.release();
  }

  /// Warn when TLS verification is off or a plain `http://` URL leaves this machine.
  void _warnAboutInsecureTransport() {
    if (!_config.verifySsl) {
      _emitWarning('TLS verification is disabled (verifySsl: false); '
          'responses cannot be trusted');
    }
    final parsed = Uri.tryParse(_config.baseUrl);
    if (parsed != null &&
        parsed.scheme == 'http' &&
        !_isLoopbackHost(parsed.host)) {
      _emitWarning(
          'baseUrl uses http://, so every request to ${parsed.host} crosses '
          'the network in cleartext - the bearer token, and the credentials '
          'in the token request itself. Use https:// unless this is a local '
          'development instance');
    }
  }

  /// Emitted once per isolate per message, though logged on every client construction.
  static final Set<String> _warningsShown = <String>{};

  /// Re-arm the once-per-isolate insecure-transport warning.
  static void resetWarningDeduplication() => _warningsShown.clear();

  void _emitWarning(String message) {
    _log('WARNING', message);
    if (_warningsShown.add(message)) {
      final warning = InsecureTransportWarning(message);
      _onWarning?.call(warning);
      writeWarning(warning.toString());
    }
  }

  static const Set<String> _loopbackHostnames = <String>{
    'localhost',
    'localhost.localdomain',
  };

  static bool _isLoopbackHost(String host) {
    final lower = host.toLowerCase();
    if (_loopbackHostnames.contains(lower)) return true;
    final bare = lower.replaceAll('[', '').replaceAll(']', '');
    return bare == '::1' || RegExp(r'^127\.\d+\.\d+\.\d+$').hasMatch(bare);
  }
}

/// Build a client for one registered instance: the default, or the one [instance]
/// names by index or `clientName`.
WebCommanderClient buildClient({
  Object? instance,
  List<Object>? credentials,
  AuthConfig? auth,
  String? apiVersion,
  double? timeoutSeconds,
  double? connectTimeoutSeconds,
  int? maxRetries,
  Set<int>? retryableHttpCodes,
  Set<int>? unsafeRetryableHttpCodes,
  double? retryBackoffSeconds,
  double? retryBackoffMaxSeconds,
  bool? verifySsl,
  Object? caBundle = SdkConfig.noOverride,
  Object? proxyUrl = SdkConfig.noOverride,
  int? poolMaxsize,
  int? maxResponseBytes,
  int? maxRequestBytes,
  int? maxRequestSourceBytes,
  int? maxMultipartOverheadBytes,
  int? maxTokenCacheBytes,
  int? maxCaBundleBytes,
  Map<String, String>? defaultHeaders,
  bool? raiseOnError,
  String? userAgent,
  String? logLevel,
  bool? logBodies,
  Object? logFile = SdkConfig.noOverride,
  bool? printApiInfo,
  bool? printRequestPayload,
  bool? printResponseBody,
  bool? printHeaders,
  bool? printCurl,
  bool? printOnlyOnError,
  String? printFormat,
  bool? printColor,
  int? printMaxChars,
  String? responseFormat,
}) {
  final blocks = credentials ?? ClientRegistry.getRegisteredInstances();
  final config = SdkConfig.fromCredentials(
    blocks,
    instance: instance,
    auth: auth,
    apiVersion: apiVersion,
    timeoutSeconds: timeoutSeconds,
    connectTimeoutSeconds: connectTimeoutSeconds,
    maxRetries: maxRetries,
    retryableHttpCodes: retryableHttpCodes,
    unsafeRetryableHttpCodes: unsafeRetryableHttpCodes,
    retryBackoffSeconds: retryBackoffSeconds,
    retryBackoffMaxSeconds: retryBackoffMaxSeconds,
    verifySsl: verifySsl,
    caBundle: caBundle,
    proxyUrl: proxyUrl,
    poolMaxsize: poolMaxsize,
    maxResponseBytes: maxResponseBytes,
    maxRequestBytes: maxRequestBytes,
    maxRequestSourceBytes: maxRequestSourceBytes,
    maxMultipartOverheadBytes: maxMultipartOverheadBytes,
    maxTokenCacheBytes: maxTokenCacheBytes,
    maxCaBundleBytes: maxCaBundleBytes,
    defaultHeaders: defaultHeaders,
    raiseOnError: raiseOnError,
    userAgent: userAgent,
    logLevel: logLevel,
    logBodies: logBodies,
    logFile: logFile,
    printApiInfo: printApiInfo,
    printRequestPayload: printRequestPayload,
    printResponseBody: printResponseBody,
    printHeaders: printHeaders,
    printCurl: printCurl,
    printOnlyOnError: printOnlyOnError,
    printFormat: printFormat,
    printColor: printColor,
    printMaxChars: printMaxChars,
    responseFormat: responseFormat,
  );
  return WebCommanderClient(config);
}
