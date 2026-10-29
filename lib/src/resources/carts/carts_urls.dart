/// Cart path templates; the client fills `{api_version}`.
class CartUrls {
  CartUrls._();

  /// The add. A storefront path, under no `/admin`, on the same bearer token.
  static const String carts = '/api/{api_version}/carts';

  /// One cart, named by the session id the caller chose.
  static const String cart = '/api/{api_version}/carts/{session_id}';

  /// One line of a cart; `{cart_item_id}` is a line's `id`, unique across carts.
  static const String cartItem =
      '/api/{api_version}/carts/{session_id}/cart_items/{cart_item_id}';

  /// The one cart path under `/admin`.
  static const String cartOrder =
      '/api/{api_version}/admin/orders/carts/{session_id}';

  /// Files the order a cart becomes under this transaction number; it beats
  /// `transaction_no`.
  static const String transactionNoHeader = 'X-Transaction-No';
}
