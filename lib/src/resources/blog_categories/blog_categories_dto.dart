/// Typed views over the blog category bodies.
library;

import '../../client/dto.dart';

/// A category's `image`, `{}` until one is uploaded; the query string on
/// `link` changes on every read.
class BlogCategoryImage extends Dto {
  const BlogCategoryImage({
    this.title,
    this.alternativeText,
    this.fileName,
    this.link,
  });

  /// Reads one row's `image`.
  static BlogCategoryImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCategoryImage(
      title: readText(source['title']),
      alternativeText: readText(source['alternative_text']),
      fileName: readText(source['file_name']),
      link: readText(source['link']),
    );
  }

  final String? title;

  final String? alternativeText;

  final String? fileName;

  /// `link` — the store's copy of the upload, behind a cache-busting query
  /// string.
  final String? link;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'title': title,
        'alternative_text': alternativeText,
        'file_name': fileName,
        'link': link,
      };
}

/// One `seo_configs` entry; no write here sets the list, so a created
/// category's is empty.
class BlogCategorySeoConfig extends Dto {
  const BlogCategorySeoConfig({this.id, this.value, this.type, this.configKey});

  /// Reads one entry of `seo_configs`.
  static BlogCategorySeoConfig? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCategorySeoConfig(
      id: readInteger(source['id']),
      value: readText(source['value']),
      type: readText(source['type']),
      configKey: readText(source['config_key']),
    );
  }

  final int? id;

  /// `value` — text, a flag included (`"false"`).
  final String? value;

  final String? type;

  final String? configKey;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'value': value,
        'type': type,
        'config_key': configKey,
      };
}

/// One blog category: a listing row, a row path's body and every write's
/// answer, the same eleven fields each time. The row never lists its blogs.
class BlogCategory extends Dto {
  const BlogCategory({
    this.id,
    this.uuid,
    this.name,
    this.url,
    this.description,
    this.isDisposable,
    this.isInTrash,
    this.image,
    this.createdOn,
    this.lastUpdatedOn,
    this.seoConfigs,
  });

  /// Reads a row path's or a write's `blog_category` envelope, or a bare
  /// listing row.
  static BlogCategory? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'blog_category');
    if (source == null) return null;
    return BlogCategory(
      id: readInteger(source['id']),
      uuid: readText(source['uuid']),
      name: readText(source['name']),
      url: readText(source['url']),
      description: readText(source['description']),
      isDisposable: readFlag(source['is_disposable']),
      isInTrash: readFlag(source['is_in_trash']),
      image: BlogCategoryImage.fromMap(source['image']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      seoConfigs: readList<BlogCategorySeoConfig>(
          source['seo_configs'], BlogCategorySeoConfig.fromMap),
    );
  }

  /// `id` — an integer the store assigns; what a `{blog_category_id}` slot
  /// takes.
  final int? id;

  /// `uuid` — a UUID string the store assigns; a create or update naming
  /// another one keeps the stored one.
  final String? uuid;

  final String? name;

  /// `url` — a lowercase hyphenated slug of at most 50 characters, made from
  /// `name` when a write leaves it out.
  final String? url;

  final String? description;

  final bool? isDisposable;

  final bool? isInTrash;

  final BlogCategoryImage? image;

  /// `created_on` — `YYYY-MM-DDTHH:MM:SS` with no zone designator.
  final String? createdOn;

  final String? lastUpdatedOn;

  final List<BlogCategorySeoConfig?>? seoConfigs;

  @override
  String? get envelopeKey => 'blog_category';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'uuid': uuid,
        'name': name,
        'url': url,
        'description': description,
        'is_disposable': isDisposable,
        'is_in_trash': isInTrash,
        'image': image,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'seo_configs': seoConfigs,
      };
}

/// An image upload; `title` and `alternative_text` are stored only beside a
/// `base64`, which carries no `data:` prefix.
class BlogCategoryImageInput extends Dto {
  const BlogCategoryImageInput({
    this.fileName,
    this.base64,
    this.title,
    this.alternativeText,
  });

  final String? fileName;

  final String? base64;

  final String? title;

  final String? alternativeText;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'file_name': fileName,
        'base64': base64,
        'title': title,
        'alternative_text': alternativeText,
      };
}

/// A blog post the category is linked to, by `id`.
class BlogCategoryBlog extends Dto {
  const BlogCategoryBlog({this.id});

  final int? id;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
      };
}

/// The writable form of [BlogCategory], in the wrapper both writes require; an
/// update blanks an unset `description`, keeps `url`, `image` and blog links.
class BlogCategoryInput extends Dto {
  const BlogCategoryInput({
    this.name,
    this.url,
    this.description,
    this.image,
    this.blogs,
  });

  /// `name` — required by both writes, 2 to 255 characters, and unique.
  final String? name;

  final String? url;

  final String? description;

  final BlogCategoryImageInput? image;

  /// `blogs` — links the blog posts it names; neither omitting it nor `[]`
  /// on an update removes a link.
  final List<BlogCategoryBlog>? blogs;

  @override
  String? get envelopeKey => 'blog_category';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'url': url,
        'description': description,
        'image': image,
        'blogs': blogs,
      };
}

/// The listing's ten-key `pagination` block; `limit` is the size the store
/// applied.
class BlogCategoryPagination extends Dto {
  const BlogCategoryPagination({
    this.total,
    this.limit,
    this.offset,
    this.count,
    this.currentPage,
    this.totalPages,
    this.hasNext,
    this.hasPrevious,
    this.previousPage,
    this.nextPage,
  });

  /// Reads the block beside the rows.
  static BlogCategoryPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCategoryPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      count: readInteger(source['count']),
      currentPage: readInteger(source['current_page']),
      totalPages: readInteger(source['total_pages']),
      hasNext: readFlag(source['has_next']),
      hasPrevious: readFlag(source['has_previous']),
      previousPage: readText(source['previous_page']),
      nextPage: readText(source['next_page']),
    );
  }

  final int? total;

  final int? limit;

  final int? offset;

  /// `count` — the rows on this page.
  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  /// `previous_page` — a whole URL carrying `limit` and `offset`, `null`
  /// exactly when [hasPrevious] is `false`.
  final String? previousPage;

  final String? nextPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'count': count,
        'current_page': currentPage,
        'total_pages': totalPages,
        'has_next': hasNext,
        'has_previous': hasPrevious,
        'previous_page': previousPage,
        'next_page': nextPage,
      };
}

/// One page of the listing. `field_metadata` is accepted and adds no key.
class BlogCategoryPage extends Dto {
  const BlogCategoryPage({this.blogCategories, this.pagination});

  /// Reads a listing body.
  static BlogCategoryPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCategoryPage(
      blogCategories: readList<BlogCategory>(
          source['blog_categories'], BlogCategory.fromMap),
      pagination: BlogCategoryPagination.fromMap(source['pagination']),
    );
  }

  /// `blog_categories` — the rows, ordered by `name` unless `sort` is sent.
  final List<BlogCategory?>? blogCategories;

  final BlogCategoryPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'blog_categories': blogCategories,
        'pagination': pagination,
      };
}
