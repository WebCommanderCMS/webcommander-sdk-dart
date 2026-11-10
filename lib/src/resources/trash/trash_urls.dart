/// Trash path templates; the client fills `{api_version}`.
class TrashUrls {
  TrashUrls._();

  /// The listing.
  static const String trash = '/api/{api_version}/admin/trash';

  /// The types the trash holds, PascalCase.
  static const String trashTypes = '/api/{api_version}/admin/trash/types';

  /// One trashed row by its type and its own id. `DELETE` only; `GET` is `405`.
  static const String trashItem =
      '/api/{api_version}/admin/trash/{trash_type}/{trash_item_id}';

  static const String trashItemRestore =
      '/api/{api_version}/admin/trash/{trash_type}/{trash_item_id}/restore';

  /// The links outside the store a permanent delete would break. `GET` only.
  static const String trashItemExternalLinks =
      '/api/{api_version}/admin/trash/{trash_type}/{trash_item_id}/external_links';

  static const String trashBulkRestore =
      '/api/{api_version}/admin/trash/bulk-restore';

  static const String trashBulkDelete =
      '/api/{api_version}/admin/trash/bulk-delete';
}
