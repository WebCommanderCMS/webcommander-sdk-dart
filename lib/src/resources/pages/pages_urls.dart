/// Page path templates; the client fills `{api_version}`.
class PageUrls {
  PageUrls._();

  /// List and create.
  static const String pages = '/api/{api_version}/admin/pages';

  /// How many pages the listing's filters match.
  static const String pagesCount = '/api/{api_version}/admin/pages/count';

  /// One page by id.
  static const String page = '/api/{api_version}/admin/pages/{page_id}';

  /// Move one page to a new URL. `PUT` only.
  static const String pageUrl = '/api/{api_version}/admin/pages/{page_id}/url';

  /// Make one page the store's landing page. `PATCH` only, and it takes no
  /// body.
  static const String pageLanding =
      '/api/{api_version}/admin/pages/{page_id}/landing';

  /// Whether one page can be deleted, and what blocks it.
  static const String pageDeleteBlockers =
      '/api/{api_version}/admin/pages/{page_id}/delete-blockers';

  /// Copy one page. `POST` only.
  static const String pageDuplicate =
      '/api/{api_version}/admin/pages/{page_id}/duplicate';

  /// Carries the `ETag` a read answered; a stale one makes the write `412`.
  static const String ifMatchHeader = 'If-Match';
}
