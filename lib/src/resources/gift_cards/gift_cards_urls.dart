/// Gift card path templates; the client fills `{api_version}`.
class GiftCardUrls {
  GiftCardUrls._();

  /// The listing.
  static const String giftCards = '/api/{api_version}/admin/gift_cards';
}
