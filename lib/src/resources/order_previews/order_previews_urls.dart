/// Order preview path templates; the client fills `{api_version}`.
class OrderPreviewUrls {
  OrderPreviewUrls._();

  /// Start a preview.
  static const String orderPreviews = '/api/{api_version}/admin/orders/preview';

  /// One preview, by the `session_id` the start answered.
  static const String orderPreview =
      '/api/{api_version}/admin/orders/preview/{preview_session_id}';

  /// Place the order from the preview.
  static const String orderPreviewConfirm =
      '/api/{api_version}/admin/orders/preview/{preview_session_id}/confirm';

  /// Apply or remove the coupon.
  static const String orderPreviewCoupon =
      '/api/{api_version}/admin/orders/preview/{preview_session_id}/coupon';

  /// Apply or remove the gift card.
  static const String orderPreviewGiftCard =
      '/api/{api_version}/admin/orders/preview/{preview_session_id}/gift-card';
}
