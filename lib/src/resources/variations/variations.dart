import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'variations_dto.dart';
import 'variations_urls.dart';

/// Variation type and product variant endpoints, bound to one client.
class VariationsResource {
  /// Bind the resource to a client; normally reached via `client.variations`.
  VariationsResource(this._client);

  final WebCommanderClient _client;

  /// List the types by ascending id — `GET /admin/variations`.
  Future<ApiResponse> listVariations({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listVariations(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/variations`.
  Future<ApiResponse> headVariations(
          {bool? raiseOnError, String? responseFormat}) =>
      _headVariations(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Create a type — `POST /admin/variations`.
  Future<ApiResponse> createVariation(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createVariation(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Retrieve one type — `GET /admin/variations/{variation_id}`.
  Future<ApiResponse> getVariation(
    Object variationId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getVariation(_client, variationId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether one type is there — `HEAD /admin/variations/{variation_id}`.
  Future<ApiResponse> headVariation(Object variationId,
          {bool? raiseOnError, String? responseFormat}) =>
      _headVariation(_client, variationId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Replace one type — `PUT /admin/variations/{variation_id}`.
  Future<ApiResponse> updateVariation(Object variationId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateVariation(_client, variationId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Merge into one type — `PATCH /admin/variations/{variation_id}`.
  Future<ApiResponse> patchVariation(Object variationId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _patchVariation(_client, variationId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one type — `DELETE /admin/variations/{variation_id}`.
  Future<ApiResponse> deleteVariation(
    Object variationId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _deleteVariation(_client, variationId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Delete one option of a type —
  /// `DELETE /admin/variations/{variation_id}/options/{variation_option_id}`.
  Future<ApiResponse> deleteVariationOption(
          Object variationId, Object variationOptionId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteVariationOption(_client, variationId, variationOptionId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// One product's variants — `GET /admin/products/{product_id}/variations`.
  Future<ApiResponse> listProductVariations(Object productId,
          {bool? raiseOnError, String? responseFormat}) =>
      _listProductVariations(_client, productId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Add or change a product's variants by `key` —
  /// `POST /admin/products/{product_id}/variations`.
  Future<ApiResponse> importProductVariations(Object productId, Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _importProductVariations(_client, productId, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Set fields on several variants of one product —
  /// `PATCH /admin/products/{product_id}/variations/bulk`.
  Future<ApiResponse> updateProductVariations(
    Object productId,
    Object payload, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _updateProductVariations(_client, productId, payload,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// List the types by ascending id — `GET /admin/variations`. Takes `search`
/// (name), `standard`, `limit` (1 to 100), `offset` or `page`, and
/// `field_metadata`.
Future<ApiResponse> listVariations(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(VariationUrls.variations,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: VariationPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/variations`; no body.
Future<ApiResponse> headVariations(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', VariationUrls.variations,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Create a type — `POST /admin/variations`, answered `201`. The body is
/// `{"variation": {...}}` with `name`, `standard` and at least one option.
Future<ApiResponse> createVariation(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(VariationUrls.variations,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Variation.fromMap);

/// Retrieve one type — `GET /admin/variations/{variation_id}`;
/// `field_metadata` adds the schema beside it.
Future<ApiResponse> getVariation(
  WebCommanderClient client,
  Object variationId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(VariationUrls.variation,
        pathParams: {'variation_id': variationId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Variation.fromMap);

/// Ask whether one type is there — `HEAD /admin/variations/{variation_id}`;
/// no body, and the row read's `ETag`.
Future<ApiResponse> headVariation(WebCommanderClient client, Object variationId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', VariationUrls.variation,
        pathParams: {'variation_id': variationId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Replace one type — `PUT /admin/variations/{variation_id}`. `name` and
/// `options` are required, and an option left out of the list is deleted.
Future<ApiResponse> updateVariation(
        WebCommanderClient client, Object variationId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(VariationUrls.variation,
        pathParams: {'variation_id': variationId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Variation.fromMap);

/// Merge into one type — `PATCH /admin/variations/{variation_id}`. Only the
/// options sent are added, or changed where an `id` names one.
Future<ApiResponse> patchVariation(
        WebCommanderClient client, Object variationId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPatchRequest(VariationUrls.variation,
        pathParams: {'variation_id': variationId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Variation.fromMap);

/// Delete one type — `DELETE /admin/variations/{variation_id}`, `204`. A type
/// with options is `409` unless `cascade` is `true`, which deletes them with it.
Future<ApiResponse> deleteVariation(
  WebCommanderClient client,
  Object variationId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendDeleteRequest(VariationUrls.variation,
        pathParams: {'variation_id': variationId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Delete one option of a type —
/// `DELETE /admin/variations/{variation_id}/options/{variation_option_id}`,
/// `204`; a type's last option is `409`.
Future<ApiResponse> deleteVariationOption(
        WebCommanderClient client, Object variationId, Object variationOptionId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(VariationUrls.variationOption,
        pathParams: {
          'variation_id': variationId,
          'variation_option_id': variationOptionId,
        },
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// One product's variants, grouped and unpaged —
/// `GET /admin/products/{product_id}/variations`. A tax-inclusive product's
/// prices read net of tax.
Future<ApiResponse> listProductVariations(
        WebCommanderClient client, Object productId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(VariationUrls.productVariations,
        pathParams: {'product_id': productId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductVariations.fromMap);

/// Add or change a product's variants by `key`; `201`. A `product_key` naming
/// other types than the product's is `409`. [transactionNo] is sent as
/// `X-Transaction-No`. `POST /admin/products/{product_id}/variations`
Future<ApiResponse> importProductVariations(
        WebCommanderClient client, Object productId, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(VariationUrls.productVariations,
        pathParams: {'product_id': productId},
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {VariationUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductVariationsImportResult.fromMap);

/// Set fields on several variants of one product —
/// `PATCH /admin/products/{product_id}/variations/bulk`; a bare record, no
/// envelope. `response` is `slim` or `full`.
Future<ApiResponse> updateProductVariations(
  WebCommanderClient client,
  Object productId,
  Object payload, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendPatchRequest(VariationUrls.productVariationsBulk,
        pathParams: {'product_id': productId},
        queryParams: queryParams,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: ProductVariationsBulkResult.fromMap);

final _listVariations = listVariations;
final _headVariations = headVariations;
final _createVariation = createVariation;
final _getVariation = getVariation;
final _headVariation = headVariation;
final _updateVariation = updateVariation;
final _patchVariation = patchVariation;
final _deleteVariation = deleteVariation;
final _deleteVariationOption = deleteVariationOption;
final _listProductVariations = listProductVariations;
final _importProductVariations = importProductVariations;
final _updateProductVariations = updateProductVariations;
