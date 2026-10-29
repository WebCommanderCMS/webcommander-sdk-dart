import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import '../../errors.dart';
import 'admin_customers_dto.dart';
import 'admin_customers_urls.dart';

/// Admin customer endpoints, bound to one client.
class AdminCustomers {
  AdminCustomers(this._client);

  final WebCommanderClient _client;

  Future<ApiResponse> getCustomers({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomers(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> getCustomer(Object customerId,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCustomer(_client, customerId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCustomerCount({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerCount(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> getCustomerEmailExists(String email,
          {bool? raiseOnError, String? responseFormat}) =>
      _getCustomerEmailExists(_client, email,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCustomerExport({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerExport(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> createCustomer(Object payload,
          {String? transactionNo,
          bool? raiseOnError,
          String? responseFormat}) =>
      _createCustomer(_client, payload,
          transactionNo: transactionNo,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> updateCustomer(Object customerId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _updateCustomer(_client, customerId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> deleteCustomer(Object customerId,
          {bool? raiseOnError, String? responseFormat}) =>
      _deleteCustomer(_client, customerId,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> createCustomerAddresses(Object customerId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createCustomerAddresses(_client, customerId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> resetCustomerPassword(Object customerId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _resetCustomerPassword(_client, customerId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> changeCustomerPassword(Object customerId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _changeCustomerPassword(_client, customerId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> bulkResetCustomerPasswords(Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _bulkResetCustomerPasswords(_client, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> importCustomers(Map<String, Object?> files,
          {bool? raiseOnError, String? responseFormat}) =>
      _importCustomers(_client, files,
          raiseOnError: raiseOnError, responseFormat: responseFormat);

  Future<ApiResponse> getCustomerStoreCreditAdjustments(
    Object customerId, {
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _getCustomerStoreCreditAdjustments(_client, customerId,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);

  Future<ApiResponse> createCustomerStoreCreditAdjustment(
          Object customerId, Object payload,
          {bool? raiseOnError, String? responseFormat}) =>
      _createCustomerStoreCreditAdjustment(_client, customerId, payload,
          raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// List customers — `GET /admin/customers`.
Future<ApiResponse> getCustomers(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerUrls.adminCustomers,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Page.of(Customer.fromMap));

/// One customer — `GET /admin/customers/{customer_id}`. `.dto` is a `Customer`.
Future<ApiResponse> getCustomer(WebCommanderClient client, Object customerId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendGetRequest(CustomerUrls.adminCustomer,
        pathParams: {'customer_id': customerId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Customer.fromMap);

/// Count customers — `GET /admin/customers/count`; `.map` is `{"total": n}`
/// alone.
Future<ApiResponse> getCustomerCount(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerUrls.adminCustomersCount,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Whether an email is registered — `GET /admin/customers/check-email`.
Future<ApiResponse> getCustomerEmailExists(
    WebCommanderClient client, String email,
    {bool? raiseOnError, String? responseFormat}) {
  _requireEmail(email);
  return client.sendGetRequest(CustomerUrls.adminCustomersCheckEmail,
      queryParams: {'email': email},
      raiseOnError: raiseOnError,
      responseFormat: responseFormat);
}

/// Export customers — `GET /admin/customers/export`.
Future<ApiResponse> getCustomerExport(
  WebCommanderClient client, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerUrls.adminCustomersExport,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Create a customer — `POST /admin/customers`. [transactionNo] is sent as
/// `X-Transaction-No` and files the customer under that number.
Future<ApiResponse> createCustomer(WebCommanderClient client, Object payload,
        {String? transactionNo, bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomers,
        jsonBody: payload,
        headers: transactionNo == null
            ? null
            : {CustomerUrls.transactionNoHeader: transactionNo},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Customer.fromMap);

/// Update a customer — `PUT /admin/customers/{customer_id}`; a partial update.
Future<ApiResponse> updateCustomer(
        WebCommanderClient client, Object customerId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPutRequest(CustomerUrls.adminCustomer,
        pathParams: {'customer_id': customerId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Customer.fromMap);

/// Delete a customer — `DELETE /admin/customers/{customer_id}`; `204`.
Future<ApiResponse> deleteCustomer(WebCommanderClient client, Object customerId,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendDeleteRequest(CustomerUrls.adminCustomer,
        pathParams: {'customer_id': customerId},
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Add addresses — `POST /admin/customers/{customer_id}/addresses`.
Future<ApiResponse> createCustomerAddresses(
        WebCommanderClient client, Object customerId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomerAddresses,
        pathParams: {'customer_id': customerId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Customer.fromMap);

/// Reset a password — `POST /admin/customers/{customer_id}/reset-password`, no
/// current one needed.
Future<ApiResponse> resetCustomerPassword(
        WebCommanderClient client, Object customerId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomerResetPassword,
        pathParams: {'customer_id': customerId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Change a password — `POST /admin/customers/{customer_id}/change-password`;
/// [payload] needs `email`, `old_password` and `password`.
Future<ApiResponse> changeCustomerPassword(
        WebCommanderClient client, Object customerId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomerChangePassword,
        pathParams: {'customer_id': customerId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Queue resets — `POST /admin/customers/bulk-reset-password`, [payload] being
/// `{'customer_ids': [...]}`.
Future<ApiResponse> bulkResetCustomerPasswords(
        WebCommanderClient client, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomersBulkResetPassword,
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat);

/// Import customers — `POST /admin/customers/import`.
Future<ApiResponse> importCustomers(
    WebCommanderClient client, Map<String, Object?> files,
    {bool? raiseOnError, String? responseFormat}) {
  _requireFiles(files);
  return client.sendPostRequest(CustomerUrls.adminCustomersImport,
      files: files, raiseOnError: raiseOnError, responseFormat: responseFormat);
}

/// Store-credit history, newest first —
/// `GET /admin/customers/{customer_id}/store-credit/adjustments`.
Future<ApiResponse> getCustomerStoreCreditAdjustments(
  WebCommanderClient client,
  Object customerId, {
  Map<String, Object?>? queryParams,
  bool? raiseOnError,
  String? responseFormat,
}) =>
    client.sendGetRequest(CustomerUrls.adminCustomerStoreCreditAdjustments,
        pathParams: {'customer_id': customerId},
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: Page.of(StoreCreditAdjustment.fromMap));

/// Move store credit, recording why —
/// `POST /admin/customers/{customer_id}/store-credit/adjustments`.
Future<ApiResponse> createCustomerStoreCreditAdjustment(
        WebCommanderClient client, Object customerId, Object payload,
        {bool? raiseOnError, String? responseFormat}) =>
    client.sendPostRequest(CustomerUrls.adminCustomerStoreCreditAdjustments,
        pathParams: {'customer_id': customerId},
        jsonBody: payload,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: StoreCreditAdjustment.fromMap);

final _getCustomers = getCustomers;
final _getCustomer = getCustomer;
final _getCustomerCount = getCustomerCount;
final _getCustomerEmailExists = getCustomerEmailExists;
final _getCustomerExport = getCustomerExport;
final _createCustomer = createCustomer;
final _updateCustomer = updateCustomer;
final _deleteCustomer = deleteCustomer;
final _createCustomerAddresses = createCustomerAddresses;
final _resetCustomerPassword = resetCustomerPassword;
final _changeCustomerPassword = changeCustomerPassword;
final _bulkResetCustomerPasswords = bulkResetCustomerPasswords;
final _importCustomers = importCustomers;
final _getCustomerStoreCreditAdjustments = getCustomerStoreCreditAdjustments;
final _createCustomerStoreCreditAdjustment =
    createCustomerStoreCreditAdjustment;

void _requireFiles(Map<String, Object?> files) {
  if (files.isEmpty) {
    throw SdkUsageError(
        "files must carry the 'file' upload: [filename, contents] with a .xlsx, "
        '.xls or .csv filename');
  }
}

void _requireEmail(String email) {
  if (email.trim().isEmpty) {
    throw SdkUsageError('email must not be blank');
  }
}
