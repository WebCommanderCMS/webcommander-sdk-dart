/// Search result page settings path templates; the client fills
/// `{api_version}`.
class SearchResultPageUrls {
  SearchResultPageUrls._();

  static const String searchResultPage =
      '/api/{api_version}/admin/settings/page_settings/search_result_page';

  static const String searchResultPageSection =
      '/api/{api_version}/admin/settings/page_settings/search_result_page/{section}';

  static const String searchResultPageProductPromotions =
      '/api/{api_version}/admin/settings/page_settings/search_result_page/product_promotion';

  static const String searchResultPageProductPromotion =
      '/api/{api_version}/admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}';

  static const String searchResultPageProductPromotionActive =
      '/api/{api_version}/admin/settings/page_settings/search_result_page/product_promotion/{promotion_id}/active';
}
