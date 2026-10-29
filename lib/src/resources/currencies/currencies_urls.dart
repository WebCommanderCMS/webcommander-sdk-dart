/// Currency path templates; the client fills `{api_version}`.
class CurrencyUrls {
  CurrencyUrls._();

  /// List and create.
  static const String currencies = '/api/{api_version}/admin/currencies';

  /// How many currencies the listing's filters match.
  static const String currenciesCount =
      '/api/{api_version}/admin/currencies/count';

  /// One currency by id.
  static const String currency =
      '/api/{api_version}/admin/currencies/{currency_id}';

  /// Make one currency the store's base. `PUT` only, and it takes no body.
  static const String currencyBase =
      '/api/{api_version}/admin/currencies/{currency_id}/base';

  /// Files a new currency under this transaction number, the only way: a body
  /// field is `400`.
  static const String transactionNoHeader = 'X-Transaction-No';
}
