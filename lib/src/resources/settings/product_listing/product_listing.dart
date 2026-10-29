import '../../../client/api_response.dart';
import '../../../client/web_commander_client.dart';
import 'product_listing_dto.dart';
import 'product_listing_urls.dart';

/// Product listing settings endpoints, bound to one client.
class ProductListingResource {
  ProductListingResource(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getProductListing({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getProductListing(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> patchProductListing(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchProductListing(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> headProductListing(
          {bool? raiseOnError, String? responseFormat}) =>
      _headProductListing(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Read the whole area — `GET /admin/settings/product_listing`.
Future<ApiResponse> getProductListing(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(ProductListingUrls.productListing,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductListingSettings.fromMap);

/// Write fields in one section or in several —
/// `PATCH /admin/settings/product_listing`.
Future<ApiResponse> patchProductListing(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(ProductListingUrls.productListing,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductListingSettings.fromMap);

/// Ask whether the area is reachable — `HEAD /admin/settings/product_listing`.
Future<ApiResponse> headProductListing(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', ProductListingUrls.productListing,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

final _getProductListing = getProductListing;
final _patchProductListing = patchProductListing;
final _headProductListing = headProductListing;
