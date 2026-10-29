/// Admin customer path templates; the client fills `{api_version}`.
/// `{customer_id}` takes `customer_id`, not the overlapping `internal_id`.
class CustomerUrls {
  CustomerUrls._();

  static const String adminCustomers = '/api/{api_version}/admin/customers';

  static const String adminCustomer =
      '/api/{api_version}/admin/customers/{customer_id}';

  static const String adminCustomersCount =
      '/api/{api_version}/admin/customers/count';

  static const String adminCustomersCheckEmail =
      '/api/{api_version}/admin/customers/check-email';

  static const String adminCustomersExport =
      '/api/{api_version}/admin/customers/export';

  static const String adminCustomersImport =
      '/api/{api_version}/admin/customers/import';

  static const String adminCustomersBulkResetPassword =
      '/api/{api_version}/admin/customers/bulk-reset-password';

  static const String adminCustomerAddresses =
      '/api/{api_version}/admin/customers/{customer_id}/addresses';

  static const String adminCustomerResetPassword =
      '/api/{api_version}/admin/customers/{customer_id}/reset-password';

  static const String adminCustomerChangePassword =
      '/api/{api_version}/admin/customers/{customer_id}/change-password';

  static const String adminCustomerStoreCreditAdjustments =
      '/api/{api_version}/admin/customers/{customer_id}/store-credit/adjustments';

  /// Files the new customer under this transaction number; it beats a
  /// `transaction_no` body field.
  static const String transactionNoHeader = 'X-Transaction-No';
}
