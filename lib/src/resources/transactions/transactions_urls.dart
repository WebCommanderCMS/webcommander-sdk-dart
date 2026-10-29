/// Transaction-number path templates; the client fills `{api_version}`.
class TransactionUrls {
  TransactionUrls._();

  /// The listing. `POST`, `PUT`, `PATCH` and `DELETE` on every path here are `405`.
  static const String transactions = '/api/{api_version}/admin/transactions';

  /// One number, matched exactly and case-sensitively.
  static const String transaction =
      '/api/{api_version}/admin/transactions/{transaction_no}';

  static const String transactionItems =
      '/api/{api_version}/admin/transactions/{transaction_no}/items';
}
