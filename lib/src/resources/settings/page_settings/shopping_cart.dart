import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'shopping_cart_dto.dart';
import 'shopping_cart_urls.dart';

/// Shopping cart settings endpoints, bound to one client.
class ShoppingCartSettings {
  ShoppingCartSettings(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getShoppingCart({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getShoppingCart(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchShoppingCart(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShoppingCart(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headShoppingCart(
          {bool? raiseOnError, String? responseFormat}) =>
      _headShoppingCart(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getShoppingCartSection(
    String section, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getShoppingCartSection(_client, section,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchShoppingCartSection(String section, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchShoppingCartSection(_client, section, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/page_settings/shopping_cart`.
Future<ApiResponse> getShoppingCart(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShoppingCartUrls.shoppingCart,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShoppingCart.fromMap);

/// Write fields in one section or both —
/// `PATCH /admin/settings/page_settings/shopping_cart`.
Future<ApiResponse> patchShoppingCart(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShoppingCartUrls.shoppingCart,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShoppingCart.fromMap);

/// Ask whether the area is reachable —
/// `HEAD /admin/settings/page_settings/shopping_cart`.
Future<ApiResponse> headShoppingCart(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ShoppingCartUrls.shoppingCart,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Read one section —
/// `GET /admin/settings/page_settings/shopping_cart/{section}`.
Future<ApiResponse> getShoppingCartSection(
  WebCommanderClient client,
  String section, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ShoppingCartUrls.shoppingCartSection,
        pathParams: {'section': section},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShoppingCart.fromMap);

/// Write fields in one section —
/// `PATCH /admin/settings/page_settings/shopping_cart/{section}`.
Future<ApiResponse> patchShoppingCartSection(
        WebCommanderClient client, String section, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ShoppingCartUrls.shoppingCartSection,
        pathParams: {'section': section},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ShoppingCart.fromMap);

final _getShoppingCart = getShoppingCart;
final _patchShoppingCart = patchShoppingCart;
final _headShoppingCart = headShoppingCart;
final _getShoppingCartSection = getShoppingCartSection;
final _patchShoppingCartSection = patchShoppingCartSection;
