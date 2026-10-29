/// Typed views over the page bodies.
library;

import '../../client/dto.dart';

/// An `{id, name}` pair: the layout, an access-list customer or group, the
/// navigation and the author. A write names one by `{"id": ...}`; `name` is
/// read-only.
class PageReference extends Dto {
  const PageReference({this.id, this.name});

  /// Reads one reference.
  static PageReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageReference(
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

/// The password gate.
class PagePasswordProtection extends Dto {
  const PagePasswordProtection({this.enabled, this.password});

  /// Reads a row's `password_protection`.
  static PagePasswordProtection? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PagePasswordProtection(
      enabled: readFlag(source['enabled']),
      password: readText(source['password']),
    );
  }

  final bool? enabled;

  /// `password` — `***` on a listing row, as saved on the row read and the
  /// writes; switching the gate off keeps the stored password.
  final String? password;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'password': password,
      };
}

/// Whether the page is linked from a navigation.
class PageMenuPlacement extends Dto {
  const PageMenuPlacement({this.enabled, this.navigation});

  /// Reads a row's `menu_placement`.
  static PageMenuPlacement? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageMenuPlacement(
      enabled: readFlag(source['enabled']),
      navigation: PageReference.fromMap(source['navigation']),
    );
  }

  final bool? enabled;

  /// `navigation` — `null` when the page is not placed; a write sending
  /// `enabled` `true` must name one by `{"id": ...}`.
  final PageReference? navigation;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'navigation': navigation,
      };
}

/// The draft and approval state; the draft and published ids are `null`,
/// never `0`.
class PagePublishing extends Dto {
  const PagePublishing({
    this.draft,
    this.draftPageId,
    this.publishedPageId,
    this.pendingApproval,
    this.pendingApprovalCount,
    this.pendingApprovalIds,
    this.disposable,
  });

  /// Reads a row's `publishing`.
  static PagePublishing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PagePublishing(
      draft: readFlag(source['draft']),
      draftPageId: readInteger(source['draft_page_id']),
      publishedPageId: readInteger(source['published_page_id']),
      pendingApproval: readFlag(source['pending_approval']),
      pendingApprovalCount: readInteger(source['pending_approval_count']),
      pendingApprovalIds:
          readList<int>(source['pending_approval_ids'], readInteger),
      disposable: readFlag(source['disposable']),
    );
  }

  final bool? draft;

  final int? draftPageId;

  final int? publishedPageId;

  final bool? pendingApproval;

  final int? pendingApprovalCount;

  final List<int?>? pendingApprovalIds;

  final bool? disposable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'draft': draft,
        'draft_page_id': draftPageId,
        'published_page_id': publishedPageId,
        'pending_approval': pendingApproval,
        'pending_approval_count': pendingApprovalCount,
        'pending_approval_ids': pendingApprovalIds,
        'disposable': disposable,
      };
}

/// One page: a listing row, the row read and every write's answer, the same
/// 23 keys.
class PageRecord extends Dto {
  const PageRecord({
    this.id,
    this.name,
    this.title,
    this.subtitle,
    this.url,
    this.fullUrl,
    this.layout,
    this.visibility,
    this.visibleTo,
    this.customers,
    this.customerGroups,
    this.bodyClass,
    this.passwordProtection,
    this.menuPlacement,
    this.active,
    this.disableTracking,
    this.landing,
    this.inTrash,
    this.publishing,
    this.store,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `page` envelope, or a bare listing row.
  static PageRecord? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'page');
    if (source == null) return null;
    return PageRecord(
      id: readInteger(source['id']),
      name: readText(source['name']),
      title: readText(source['title']),
      subtitle: readText(source['subtitle']),
      url: readText(source['url']),
      fullUrl: readText(source['full_url']),
      layout: PageReference.fromMap(source['layout']),
      visibility: readText(source['visibility']),
      visibleTo: readText(source['visible_to']),
      customers:
          readList<PageReference>(source['customers'], PageReference.fromMap),
      customerGroups: readList<PageReference>(
          source['customer_groups'], PageReference.fromMap),
      bodyClass: readText(source['body_class']),
      passwordProtection:
          PagePasswordProtection.fromMap(source['password_protection']),
      menuPlacement: PageMenuPlacement.fromMap(source['menu_placement']),
      active: readFlag(source['active']),
      disableTracking: readFlag(source['disable_tracking']),
      landing: readFlag(source['landing']),
      inTrash: readFlag(source['in_trash']),
      publishing: PagePublishing.fromMap(source['publishing']),
      store: readAny(source['store']),
      author: PageReference.fromMap(source['author']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? title;

  final String? subtitle;

  final String? url;

  final String? fullUrl;

  final PageReference? layout;

  /// `visibility` — `open`, `hidden` or `restricted`.
  final String? visibility;

  /// `visible_to` — `all` or `selected` on a restricted page, `null` otherwise.
  final String? visibleTo;

  final List<PageReference?>? customers;

  final List<PageReference?>? customerGroups;

  final String? bodyClass;

  final PagePasswordProtection? passwordProtection;

  final PageMenuPlacement? menuPlacement;

  final bool? active;

  final bool? disableTracking;

  /// `landing` — held by one page; only the landing sub-path moves it.
  final bool? landing;

  /// `in_trash` — `true` on a deleted page the row read still answers.
  final bool? inTrash;

  final PagePublishing? publishing;

  /// `store` — `null` on every page the store holds, so left untyped.
  final Object? store;

  final PageReference? author;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'title': title,
        'subtitle': subtitle,
        'url': url,
        'full_url': fullUrl,
        'layout': layout,
        'visibility': visibility,
        'visible_to': visibleTo,
        'customers': customers,
        'customer_groups': customerGroups,
        'body_class': bodyClass,
        'password_protection': passwordProtection,
        'menu_placement': menuPlacement,
        'active': active,
        'disable_tracking': disableTracking,
        'landing': landing,
        'in_trash': inTrash,
        'publishing': publishing,
        'store': store,
        'author': author,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable fields, wrapped in `page`, for the create, the `PUT` replace
/// and the `PATCH`. Fields left `null` are not sent: to clear one, pass a map.
class PageInput extends Dto {
  const PageInput({
    this.name,
    this.title,
    this.subtitle,
    this.url,
    this.layout,
    this.visibility,
    this.visibleTo,
    this.customers,
    this.customerGroups,
    this.bodyClass,
    this.passwordProtection,
    this.menuPlacement,
    this.active,
    this.disableTracking,
  });

  final String? name;

  final String? title;

  final String? subtitle;

  final String? url;

  final PageReference? layout;

  final String? visibility;

  final String? visibleTo;

  /// `customers` — public `customer_id` values, bare or as a [PageReference].
  final List<Object?>? customers;

  /// `customer_groups` — group ids, bare or as a [PageReference].
  final List<Object?>? customerGroups;

  final String? bodyClass;

  final PagePasswordProtection? passwordProtection;

  final PageMenuPlacement? menuPlacement;

  final bool? active;

  final bool? disableTracking;

  @override
  String? get envelopeKey => 'page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'title': title,
        'subtitle': subtitle,
        'url': url,
        'layout': layout,
        'visibility': visibility,
        'visible_to': visibleTo,
        'customers': customers,
        'customer_groups': customerGroups,
        'body_class': bodyClass,
        'password_protection': passwordProtection,
        'menu_placement': menuPlacement,
        'active': active,
        'disable_tracking': disableTracking,
      };
}

/// The URL write's bare body, `{"url": ...}`; a `page` wrapper is `400`.
class PageUrlInput extends Dto {
  const PageUrlInput({this.url});

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'url': url,
      };
}

/// The five-key `pagination` block; `limit` is the page size applied, the
/// total under `limit=all`.
class PagePagination extends Dto {
  const PagePagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static PagePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PagePagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

  final int? limit;

  final int? offset;

  final bool? hasPrevious;

  final bool? hasNext;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'has_previous': hasPrevious,
        'has_next': hasNext,
      };
}

/// One page of the listing: the rows, outside the trash, and where they sit.
class PageListing extends Dto {
  const PageListing({this.pages, this.pagination});

  /// Reads a listing body.
  static PageListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageListing(
      pages: readList<PageRecord>(source['pages'], PageRecord.fromMap),
      pagination: PagePagination.fromMap(source['pagination']),
    );
  }

  final List<PageRecord?>? pages;

  final PagePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'pages': pages,
        'pagination': pagination,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class PageCount extends Dto {
  const PageCount({this.total});

  /// Reads a count body.
  static PageCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}

/// One reason the page cannot be deleted, such as `landing_page`.
class PageDeleteBlocker extends Dto {
  const PageDeleteBlocker({this.code, this.message});

  /// Reads one `blockers` entry.
  static PageDeleteBlocker? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageDeleteBlocker(
      code: readText(source['code']),
      message: readText(source['message']),
    );
  }

  final String? code;

  final String? message;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
        'message': message,
      };
}

/// The delete check's body: whether a delete would pass, what blocks it and
/// what links to the page.
class PageDeleteBlockers extends Dto {
  const PageDeleteBlockers({this.canDelete, this.blockers, this.linked});

  /// Reads a delete check body.
  static PageDeleteBlockers? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return PageDeleteBlockers(
      canDelete: readFlag(source['can_delete']),
      blockers: readList<PageDeleteBlocker>(
          source['blockers'], PageDeleteBlocker.fromMap),
      linked: readList<Object>(source['linked'], readAny),
    );
  }

  final bool? canDelete;

  final List<PageDeleteBlocker?>? blockers;

  /// `linked` — empty on every page read, so its rows stay untyped.
  final List<Object?>? linked;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'can_delete': canDelete,
        'blockers': blockers,
        'linked': linked,
      };
}
