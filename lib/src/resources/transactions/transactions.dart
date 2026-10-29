import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'transactions_dto.dart';
import 'transactions_urls.dart';

/// Transaction-number endpoints, bound to one client.
class Transactions {
  /// Bind the resource to a client; normally reached via `client.transactions`.
  Transactions(this._client);

  final WebCommanderClient _client;

  /// List the numbers — `GET /admin/transactions`.
  Future<ApiResponse> listTransactions({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTransactions(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the collection is reachable — `HEAD /admin/transactions`.
  Future<ApiResponse> headTransactions(
          {bool? raiseOnError, String? responseFormat}) =>
      _headTransactions(_client,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Count the records one number tagged, by type —
  /// `GET /admin/transactions/{transaction_no}`.
  Future<ApiResponse> getTransaction(String transactionNo,
          {bool? raiseOnError, String? responseFormat}) =>
      _getTransaction(_client, transactionNo,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// Ask whether one number has records —
  /// `HEAD /admin/transactions/{transaction_no}`.
  Future<ApiResponse> headTransaction(String transactionNo,
          {bool? raiseOnError, String? responseFormat}) =>
      _headTransaction(_client, transactionNo,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  /// List the records a number tagged —
  /// `GET /admin/transactions/{transaction_no}/items`.
  Future<ApiResponse> listTransactionItems(
    String transactionNo, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listTransactionItems(_client, transactionNo,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  /// Ask whether the records under a number are reachable —
  /// `HEAD /admin/transactions/{transaction_no}/items`.
  Future<ApiResponse> headTransactionItems(
    String transactionNo, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _headTransactionItems(_client, transactionNo,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// List the numbers in ascending order — `GET /admin/transactions`. `limit` (or
/// `max`) from 1, default 20, held to 200; `offset`, `page`; `transaction_no`
/// matches exactly and case-sensitively. `search`, `q`, `sort` and `order`
/// change nothing.
Future<ApiResponse> listTransactions(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TransactionUrls.transactions,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TransactionPage.fromMap);

/// Ask whether the collection is reachable — `HEAD /admin/transactions`; no
/// body.
Future<ApiResponse> headTransactions(WebCommanderClient client,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TransactionUrls.transactions,
        raiseOnError: raiseOnError, responseFormat: responseFormat);

/// Count the records one number tagged, by type —
/// `GET /admin/transactions/{transaction_no}`. Matched exactly and
/// case-sensitively; a number holding `/` is refused by the server, `400` HTML,
/// as an encoded slash.
Future<ApiResponse> getTransaction(
        WebCommanderClient client, String transactionNo,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(TransactionUrls.transaction,
        pathParams: {'transaction_no': transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Transaction.fromMap);

/// Ask whether one number has records —
/// `HEAD /admin/transactions/{transaction_no}`; no body.
Future<ApiResponse> headTransaction(
        WebCommanderClient client, String transactionNo,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendApiRequest('HEAD', TransactionUrls.transaction,
        pathParams: {'transaction_no': transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// List the records a number tagged, newest first —
/// `GET /admin/transactions/{transaction_no}/items`. `type` is optional: left
/// out, every type is listed; sent, it takes one or more of the 15 `by_type`
/// names, comma-separated. `limit` (or `max`) 1 to 200, `offset`, `page`,
/// `detail` `slim` or `full`. A `slim` item is `type`, `id`, `stamp`, `trashed`
/// and the fields of its type, such as `name`, `sku` and `url` for a product. A
/// number or a type with no records answers `200` with `items` empty and
/// `total` `0`, not `404`.
Future<ApiResponse> listTransactionItems(
  WebCommanderClient client,
  String transactionNo, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(TransactionUrls.transactionItems,
        pathParams: {'transaction_no': transactionNo},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: TransactionItemPage.fromMap);

/// Ask whether the records under a number are reachable; no body. `type` is
/// optional here too. `HEAD /admin/transactions/{transaction_no}/items`
Future<ApiResponse> headTransactionItems(
  WebCommanderClient client,
  String transactionNo, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendApiRequest('HEAD', TransactionUrls.transactionItems,
        pathParams: {'transaction_no': transactionNo},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

final _listTransactions = listTransactions;
final _headTransactions = headTransactions;
final _getTransaction = getTransaction;
final _headTransaction = headTransaction;
final _listTransactionItems = listTransactionItems;
final _headTransactionItems = headTransactionItems;
