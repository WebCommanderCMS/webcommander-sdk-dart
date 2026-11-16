/// Admin cart and checkout path templates; the client fills `{api_version}`.
class AdminCartUrls {
  AdminCartUrls._();

  /// Start a cart.
  static const String adminCarts = '/api/{api_version}/admin/orders/carts';

  /// One cart, by the `session_id` the start answered.
  static const String adminCart =
      '/api/{api_version}/admin/orders/carts/{session_id}';

  /// The lines of a cart.
  static const String adminCartItems =
      '/api/{api_version}/admin/orders/carts/{session_id}/cart_items';

  /// One line of a cart, by its `cart_item_id`.
  static const String adminCartItem =
      '/api/{api_version}/admin/orders/carts/{session_id}/cart_items/{cart_item_id}';

  /// The checkout of a cart.
  static const String adminCheckout =
      '/api/{api_version}/admin/orders/checkout/{session_id}';

  /// Place the order from the checkout.
  static const String adminCheckoutConfirm =
      '/api/{api_version}/admin/orders/checkout/{session_id}/confirm';

  /// Apply or remove the coupon.
  static const String adminCheckoutCoupon =
      '/api/{api_version}/admin/orders/checkout/{session_id}/coupon';

  /// Apply or remove the gift card.
  static const String adminCheckoutGiftCard =
      '/api/{api_version}/admin/orders/checkout/{session_id}/gift_card';

  /// Read, choose or clear the delivery schedule.
  static const String adminCheckoutDeliverySchedules =
      '/api/{api_version}/admin/orders/checkout/{session_id}/delivery_schedules';

  /// Files the order a checkout places under this transaction number;
  /// a differing top-level `transaction_no` is `400 header_body_mismatch`.
  static const String transactionNoHeader = 'X-Transaction-No';
}
