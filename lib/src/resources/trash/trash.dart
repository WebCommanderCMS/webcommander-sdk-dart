import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'trash_dto.dart';
import 'trash_urls.dart';

/// Trash endpoints, bound to one client.
class Trash {
  /// Bind the resource to a client; normally reached via `client.trash`.
  Trash(this._client);

  final WebCommanderClient _client;

  /// List trashed rows, newest change first — `GET /admin/trash`.
  Future<ApiResponse> listTrash({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTrash(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the listing is reachable — `HEAD /admin/trash`.
  Future<ApiResponse> headTrash({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _headTrash(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// List the types the trash holds — `GET /admin/trash/types`.
  Future<ApiResponse> listTrashTypes(
          {bool? raiseOnError, String? responseFormat}) =>
      _listTrashTypes(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether the type list is reachable — `HEAD /admin/trash/types`.
  Future<ApiResponse> headTrashTypes(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTrashTypes(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Restore one trashed row —
  /// `POST /admin/trash/{trash_type}/{trash_item_id}/restore`.
  Future<ApiResponse> restoreTrashItem(String trashType, Object trashItemId,
          {bool? raiseOnError, String? responseFormat}) =>
      _restoreTrashItem(_client, trashType, trashItemId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete one trashed row for good —
  /// `DELETE /admin/trash/{trash_type}/{trash_item_id}`.
  Future<ApiResponse> deleteTrashItem(String trashType, Object trashItemId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteTrashItem(_client, trashType, trashItemId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Restore up to 100 rows — `POST /admin/trash/bulk-restore`.
  Future<ApiResponse> bulkRestoreTrash(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _bulkRestoreTrash(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Delete up to 100 trashed rows for good — `POST /admin/trash/bulk-delete`.
  Future<ApiResponse> bulkDeleteTrash(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _bulkDeleteTrash(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List trashed rows, newest change first — `GET /admin/trash`. `type` (a
/// `types` value, any case, or a comma list), `search` or `searchText`, `sort`
/// `name`, `type`, `updated` or `removed_at` with `order` or `dir`, `limit` or
/// `max` (above 100 is `400`), `offset`, `page`, `removed_from` and
/// `removed_to`; any other name is `400`. An unfiltered page, or one of type
/// `Customer`, can outrun the default `timeoutSeconds`.
Future<ApiResponse> listTrash(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TrashUrls.trash,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TrashPage.fromMap);

/// Ask whether the listing is reachable — `HEAD /admin/trash`; no body. It
/// takes the listing's query names and runs the same query, so pass a `type`
/// as on the `GET`.
Future<ApiResponse> headTrash(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendApiRequest('HEAD', TrashUrls.trash,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// List the types the trash holds — `GET /admin/trash/types`, snake_case names
/// such as `category`, `customer` and `blog_post`. Any query name is `400`.
Future<ApiResponse> listTrashTypes(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TrashUrls.trashTypes,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TrashTypeList.fromMap);

/// Ask whether the type list is reachable — `HEAD /admin/trash/types`; no body.
Future<ApiResponse> headTrashTypes(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TrashUrls.trashTypes,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Restore one trashed row —
/// `POST /admin/trash/{trash_type}/{trash_item_id}/restore`, answered `200`
/// with the row under `item`; sends no body. A live row is `409`, an id the
/// type does not hold `404`.
Future<ApiResponse> restoreTrashItem(
        WebCommanderClient client, String trashType, Object trashItemId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TrashUrls.trashItemRestore,
        pathParams: {'trash_type': trashType, 'trash_item_id': trashItemId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TrashItem.fromMap);

/// Delete one trashed row for good —
/// `DELETE /admin/trash/{trash_type}/{trash_item_id}`, `204`. A live row is
/// `409`; once purged, every read and a second delete are `404`.
Future<ApiResponse> deleteTrashItem(
        WebCommanderClient client, String trashType, Object trashItemId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(TrashUrls.trashItem,
        pathParams: {'trash_type': trashType, 'trash_item_id': trashItemId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Restore up to 100 rows — `POST /admin/trash/bulk-restore` with
/// `{"items": [{"type", "id"}]}`. `200` when every item is restored, `207`
/// with the same body when any fails.
Future<ApiResponse> bulkRestoreTrash(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TrashUrls.trashBulkRestore,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TrashBulkRestoreResult.fromMap);

/// Delete up to 100 trashed rows for good — `POST /admin/trash/bulk-delete`,
/// the bulk restore's body. `200` when every item is deleted, `207` with the
/// same body when any fails.
Future<ApiResponse> bulkDeleteTrash(WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(TrashUrls.trashBulkDelete,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TrashBulkDeleteResult.fromMap);

final _listTrash = listTrash;
final _headTrash = headTrash;
final _listTrashTypes = listTrashTypes;
final _headTrashTypes = headTrashTypes;
final _restoreTrashItem = restoreTrashItem;
final _deleteTrashItem = deleteTrashItem;
final _bulkRestoreTrash = bulkRestoreTrash;
final _bulkDeleteTrash = bulkDeleteTrash;
