/// Typed views over the blog and blog comment bodies.
library;

import '../../client/dto.dart';

/// A category a blog is filed under; a write names it `{"id": …}`.
class BlogCategoryReference extends Dto {
  const BlogCategoryReference({
    this.id,
    this.name,
    this.isDisposable,
    this.isInTrash,
  });

  /// Reads one entry of a row's `categories`.
  static BlogCategoryReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCategoryReference(
      id: readInteger(source['id']),
      name: readText(source['name']),
      isDisposable: readFlag(source['is_disposable']),
      isInTrash: readFlag(source['is_in_trash']),
    );
  }

  final int? id;

  final String? name;

  final bool? isDisposable;

  final bool? isInTrash;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'is_disposable': isDisposable,
        'is_in_trash': isInTrash,
      };
}

/// The cover image as a read answers it, `{}` when there is none.
class BlogImage extends Dto {
  const BlogImage({this.title, this.alternativeText, this.fileName, this.link});

  /// Reads a row's `image`.
  static BlogImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogImage(
      title: readText(source['title']),
      alternativeText: readText(source['alternative_text']),
      fileName: readText(source['file_name']),
      link: readText(source['link']),
    );
  }

  final String? title;

  final String? alternativeText;

  final String? fileName;

  /// `link` — its query string differs on every read.
  final String? link;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'title': title,
        'alternative_text': alternativeText,
        'file_name': fileName,
        'link': link,
      };
}

/// The cover image a write uploads; without `base64` the stored image is left
/// as it was.
class BlogImageInput extends Dto {
  const BlogImageInput({
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

/// `created_by`; `{}` on a row the store recorded no author for.
class BlogAuthor extends Dto {
  const BlogAuthor({this.id, this.name});

  /// Reads a row's `created_by`.
  static BlogAuthor? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogAuthor(
      id: readInteger(source['id']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
      };
}

/// One customer, by `internal_id`, or one customer group a restricted blog is
/// shown to.
class BlogAudienceMember extends Dto {
  const BlogAudienceMember({this.id, this.name});

  /// Reads one entry of `customers` or `groups`.
  static BlogAudienceMember? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogAudienceMember(
      id: readInteger(source['id']),
      name: readText(source['name']),
    );
  }

  final int? id;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
      };
}

/// `selected_customers` once it names anyone; the store sends `[]` when it
/// names no one, which reads as `null` here.
class BlogAudience extends Dto {
  const BlogAudience({this.customers, this.groups});

  /// Reads a row's `selected_customers` in its object form.
  static BlogAudience? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogAudience(
      customers: readList<BlogAudienceMember>(
          source['customers'], BlogAudienceMember.fromMap),
      groups: readList<BlogAudienceMember>(
          source['groups'], BlogAudienceMember.fromMap),
    );
  }

  final List<BlogAudienceMember?>? customers;

  final List<BlogAudienceMember?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// The audience a write names: customer `internal_id` values and customer group
/// ids. A `customer_id` is dropped without a refusal.
class BlogAudienceInput extends Dto {
  const BlogAudienceInput({this.customers, this.groups});

  final List<int?>? customers;

  final List<int?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// One `meta_tag` entry, the same two fields on a write and a read.
class BlogMetaTag extends Dto {
  const BlogMetaTag({this.name, this.value});

  /// Reads one entry of `meta_tag`.
  static BlogMetaTag? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogMetaTag(
      name: readText(source['name']),
      value: readText(source['value']),
    );
  }

  final String? name;

  final String? value;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'value': value,
      };
}

/// `seo_configs`, an object holding the `meta_tag` list.
class BlogSeoConfigs extends Dto {
  const BlogSeoConfigs({this.metaTag});

  /// Reads a row's `seo_configs`.
  static BlogSeoConfigs? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogSeoConfigs(
      metaTag: readList<BlogMetaTag>(source['meta_tag'], BlogMetaTag.fromMap),
    );
  }

  final List<BlogMetaTag?>? metaTag;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'meta_tag': metaTag,
      };
}

/// The one `group_meta` entry: what the collection is, whether it is writable
/// and where.
class BlogResourceMeta extends Dto {
  const BlogResourceMeta({this.kind, this.writable, this.href});

  /// Reads the `blogs` entry of `group_meta`.
  static BlogResourceMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogResourceMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  final String? kind;

  final bool? writable;

  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block the listing, a row read and a `PATCH` answer carry.
class BlogGroupMeta extends Dto {
  const BlogGroupMeta({this.blogs});

  /// Reads a `group_meta` block.
  static BlogGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogGroupMeta(blogs: BlogResourceMeta.fromMap(source['blogs']));
  }

  final BlogResourceMeta? blogs;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'blogs': blogs,
      };
}

/// One blog, the same eighteen fields on a listing row, a row read and every
/// write's answer.
class Blog extends Dto {
  const Blog({
    this.id,
    this.uuid,
    this.title,
    this.url,
    this.content,
    this.date,
    this.isPublished,
    this.visibility,
    this.visibleTo,
    this.categories,
    this.createdOn,
    this.lastUpdatedOn,
    this.isDisposable,
    this.isInTrash,
    this.image,
    this.createdBy,
    this.selectedCustomers,
    this.seoConfigs,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads a row path's `blog` envelope, or a bare listing row.
  static Blog? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'blog');
    if (source == null) return null;
    return Blog(
      id: readInteger(source['id']),
      uuid: readText(source['uuid']),
      title: readText(source['title']),
      url: readText(source['url']),
      content: readText(source['content']),
      date: readText(source['date']),
      isPublished: readFlag(source['is_published']),
      visibility: readText(source['visibility']),
      visibleTo: readText(source['visible_to']),
      categories: readList<BlogCategoryReference>(
          source['categories'], BlogCategoryReference.fromMap),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      isDisposable: readFlag(source['is_disposable']),
      isInTrash: readFlag(source['is_in_trash']),
      image: BlogImage.fromMap(source['image']),
      createdBy: BlogAuthor.fromMap(source['created_by']),
      selectedCustomers: BlogAudience.fromMap(source['selected_customers']),
      seoConfigs: BlogSeoConfigs.fromMap(source['seo_configs']),
      groupMeta: BlogGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final int? id;

  /// `uuid` — a UUID string the store assigns; a create naming it is
  /// `400 unknown_field`.
  final String? uuid;

  final String? title;

  /// `url` — the title's slug on the create; a later write naming `title` takes
  /// a sent one.
  final String? url;

  final String? content;

  /// `date` — `yyyy-MM-ddTHH:mm:ss`, no zone.
  final String? date;

  final bool? isPublished;

  final String? visibility;

  /// `visible_to` — kept only while `visibility` is `restricted`.
  final String? visibleTo;

  final List<BlogCategoryReference?>? categories;

  final String? createdOn;

  final String? lastUpdatedOn;

  final bool? isDisposable;

  final bool? isInTrash;

  final BlogImage? image;

  final BlogAuthor? createdBy;

  /// `selected_customers` — `null` here while the store sends `[]`.
  final BlogAudience? selectedCustomers;

  final BlogSeoConfigs? seoConfigs;

  final BlogGroupMeta? groupMeta;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'blog';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'uuid': uuid,
        'title': title,
        'url': url,
        'content': content,
        'date': date,
        'is_published': isPublished,
        'visibility': visibility,
        'visible_to': visibleTo,
        'categories': categories,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'is_disposable': isDisposable,
        'is_in_trash': isInTrash,
        'image': image,
        'created_by': createdBy,
        'selected_customers': selectedCustomers,
        'seo_configs': seoConfigs,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The writable form of [Blog], for the create, the replace and the patch.
/// `title` is required by the first two and `visibility` by the replace.
class BlogInput extends Dto {
  const BlogInput({
    this.title,
    this.content,
    this.date,
    this.isPublished,
    this.visibility,
    this.visibleTo,
    this.categories,
    this.image,
    this.seoConfigs,
    this.selectedCustomers,
  });

  final String? title;

  final String? content;

  final String? date;

  final bool? isPublished;

  final String? visibility;

  final String? visibleTo;

  final List<BlogCategoryReference?>? categories;

  final BlogImageInput? image;

  final BlogSeoConfigs? seoConfigs;

  final BlogAudienceInput? selectedCustomers;

  @override
  String? get envelopeKey => 'blog';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'title': title,
        'content': content,
        'date': date,
        'is_published': isPublished,
        'visibility': visibility,
        'visible_to': visibleTo,
        'categories': categories,
        'image': image,
        'seo_configs': seoConfigs,
        'selected_customers': selectedCustomers,
      };
}

/// The ten-key `pagination` block of the listing.
class BlogPagination extends Dto {
  const BlogPagination({
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
  static BlogPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogPagination(
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

  /// `limit` — the size the store applied, capped at 20.
  final int? limit;

  final int? offset;

  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

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

/// One page of the listing: the rows, `group_meta`, the paging block and any
/// schema.
class BlogPage extends Dto {
  const BlogPage({
    this.blogs,
    this.groupMeta,
    this.pagination,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static BlogPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogPage(
      blogs: readList<Blog>(source['blogs'], Blog.fromMap),
      groupMeta: BlogGroupMeta.fromMap(source['group_meta']),
      pagination: BlogPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<Blog?>? blogs;

  final BlogGroupMeta? groupMeta;

  final BlogPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'blogs': blogs,
        'group_meta': groupMeta,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's body, `{"blogs": {"count": N}}`.
class BlogCount extends Dto {
  const BlogCount({this.count});

  /// Reads a count body, the plural key unwrapped.
  static BlogCount? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'blogs');
    if (source == null) return null;
    return BlogCount(count: readInteger(source['count']));
  }

  final int? count;

  @override
  String? get envelopeKey => 'blogs';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
      };
}

/// One comment, the same twelve fields in the listing and on its own path.
class BlogComment extends Dto {
  const BlogComment({
    this.id,
    this.status,
    this.name,
    this.email,
    this.postTitle,
    this.content,
    this.spam,
    this.likes,
    this.totalReply,
    this.createdOn,
    this.lastUpdatedOn,
    this.replies,
  });

  /// Reads one comment record.
  static BlogComment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogComment(
      id: readInteger(source['id']),
      status: readText(source['status']),
      name: readText(source['name']),
      email: readText(source['email']),
      postTitle: readText(source['post_title']),
      content: readText(source['content']),
      spam: readFlag(source['spam']),
      likes: readInteger(source['likes']),
      totalReply: readInteger(source['total_reply']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      replies: readList<Object>(source['replies'], readAny),
    );
  }

  final int? id;

  final String? status;

  final String? name;

  final String? email;

  /// `post_title` — the blog's current title.
  final String? postTitle;

  final String? content;

  final bool? spam;

  final int? likes;

  final int? totalReply;

  final String? createdOn;

  final String? lastUpdatedOn;

  /// `replies` — untyped: no write on this surface adds one.
  final List<Object?>? replies;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'status': status,
        'name': name,
        'email': email,
        'post_title': postTitle,
        'content': content,
        'spam': spam,
        'likes': likes,
        'total_reply': totalReply,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'replies': replies,
      };
}

/// The comments sub-path's body: the blog's `id` beside every comment it holds.
class BlogCommentList extends Dto {
  const BlogCommentList({this.id, this.comments});

  /// Reads a comment listing body; no envelope, or the blog's `id` would
  /// shadow each comment's.
  static BlogCommentList? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCommentList(
      id: readInteger(source['id']),
      comments: readList<BlogComment>(source['comments'], BlogComment.fromMap),
    );
  }

  /// `id` — the blog's.
  final int? id;

  final List<BlogComment?>? comments;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'comments': comments,
      };
}

/// One comment's body, from its own path and from each comment write: the
/// blog's `id` beside the `comment`.
class BlogCommentEnvelope extends Dto {
  const BlogCommentEnvelope({this.id, this.comment});

  /// Reads a single-comment body.
  static BlogCommentEnvelope? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BlogCommentEnvelope(
      id: readInteger(source['id']),
      comment: BlogComment.fromMap(source['comment']),
    );
  }

  /// `id` — the blog's.
  final int? id;

  final BlogComment? comment;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'comment': comment,
      };
}

/// The comment a create sends: `content` required, at most 1000 characters;
/// `name`, 2 to 100 once trimmed, and `email` may be left out.
class BlogCommentDraft extends Dto {
  const BlogCommentDraft({this.content, this.name, this.email});

  final String? content;

  final String? name;

  final String? email;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'content': content,
        'name': name,
        'email': email,
      };
}

/// The comment create's body, `{"blog": {"comment": {...}}}`.
class BlogCommentInput extends Dto {
  const BlogCommentInput({this.comment});

  final BlogCommentDraft? comment;

  @override
  String? get envelopeKey => 'blog';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'comment': comment,
      };
}
