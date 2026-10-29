/// Category path templates; the client fills `{api_version}`.
class CategoryUrls {
  CategoryUrls._();

  /// List and create.
  static const String categories = '/api/{api_version}/admin/categories';

  /// How many rows the listing holds, trashed rows not counted.
  static const String categoriesCount =
      '/api/{api_version}/admin/categories/count';

  /// Whether a name is free; `name` goes on the query string.
  static const String categoriesCheckName =
      '/api/{api_version}/admin/categories/check-name';

  /// One category by id.
  static const String category =
      '/api/{api_version}/admin/categories/{category_id}';

  /// One section of one category; `{section}` is one of [sections].
  static const String categorySection =
      '/api/{api_version}/admin/categories/{category_id}/{section}';

  /// The six values `{section}` takes, each also a key of the row and of
  /// `group_meta`.
  static const List<String> sections = <String>[
    'general',
    'description',
    'images_media',
    'availability_visibility',
    'tax_shipping',
    'assign_products',
  ];

  /// Files a new category under this transaction number; it beats
  /// `category.transaction_no`.
  static const String transactionNoHeader = 'X-Transaction-No';
}
