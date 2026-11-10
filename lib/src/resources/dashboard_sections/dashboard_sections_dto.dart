/// Typed views over the dashboard section bodies.
library;

import '../../client/dto.dart';

/// The period a section covers and the one before it, as dates; `time_zone` is
/// the store's and `currency` the code money figures are in.
class SectionPeriod extends Dto {
  const SectionPeriod({
    this.duration,
    this.startDate,
    this.endDate,
    this.previousStartDate,
    this.previousEndDate,
    this.timeZone,
    this.currency,
  });

  /// Reads a [SectionPeriod] from a decoded body.
  static SectionPeriod? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionPeriod(
      duration: readText(source['duration']),
      startDate: readText(source['start_date']),
      endDate: readText(source['end_date']),
      previousStartDate: readText(source['previous_start_date']),
      previousEndDate: readText(source['previous_end_date']),
      timeZone: readText(source['time_zone']),
      currency: readText(source['currency']),
    );
  }

  final String? duration;

  final String? startDate;

  final String? endDate;

  final String? previousStartDate;

  final String? previousEndDate;

  final String? timeZone;

  final String? currency;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'duration': duration,
        'start_date': startDate,
        'end_date': endDate,
        'previous_start_date': previousStartDate,
        'previous_end_date': previousEndDate,
        'time_zone': timeZone,
        'currency': currency,
      };
}

/// A product, page or post by id and name.
class SectionEntity extends Dto {
  const SectionEntity({
    this.id,
    this.name,
  });

  /// Reads a [SectionEntity] from a decoded body.
  static SectionEntity? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionEntity(
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

/// What needs attention now; `pending_fulfillment` is the orders waiting to
/// ship.
class SectionOrderUpdates extends Dto {
  const SectionOrderUpdates({
    this.lowStockItems,
    this.pendingFulfillment,
    this.paymentsToCapture,
  });

  /// Reads a [SectionOrderUpdates] from a decoded body.
  static SectionOrderUpdates? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionOrderUpdates(
      lowStockItems: readInteger(source['low_stock_items']),
      pendingFulfillment: readInteger(source['pending_fulfillment']),
      paymentsToCapture: readInteger(source['payments_to_capture']),
    );
  }

  final int? lowStockItems;

  final int? pendingFulfillment;

  final int? paymentsToCapture;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'low_stock_items': lowStockItems,
        'pending_fulfillment': pendingFulfillment,
        'payments_to_capture': paymentsToCapture,
      };
}

/// A product and the units sold, highest first.
class SectionBestSeller extends Dto {
  const SectionBestSeller({
    this.product,
    this.unitsSold,
  });

  /// Reads a [SectionBestSeller] from a decoded body.
  static SectionBestSeller? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionBestSeller(
      product: SectionEntity.fromMap(source['product']),
      unitsSold: readInteger(source['units_sold']),
    );
  }

  final SectionEntity? product;

  final int? unitsSold;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product': product,
        'units_sold': unitsSold,
      };
}

/// One content item to review; `count` is an empty string on the rows measured.
class SectionContentUpdate extends Dto {
  const SectionContentUpdate({
    this.key,
    this.label,
    this.count,
  });

  /// Reads a [SectionContentUpdate] from a decoded body.
  static SectionContentUpdate? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionContentUpdate(
      key: readText(source['key']),
      label: readText(source['label']),
      count: readText(source['count']),
    );
  }

  final String? key;

  final String? label;

  final String? count;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'label': label,
        'count': count,
      };
}

/// A page and its views.
class SectionTopPage extends Dto {
  const SectionTopPage({
    this.page,
    this.views,
  });

  /// Reads a [SectionTopPage] from a decoded body.
  static SectionTopPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionTopPage(
      page: SectionEntity.fromMap(source['page']),
      views: readInteger(source['views']),
    );
  }

  final SectionEntity? page;

  final int? views;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page': page,
        'views': views,
      };
}

/// The bookings that need attention: how many, and the latest of them, whose row
/// shape is not known because the store measured has none.
class SectionNeedsAttention extends Dto {
  const SectionNeedsAttention({
    this.count,
    this.latest,
  });

  /// Reads a [SectionNeedsAttention] from a decoded body.
  static SectionNeedsAttention? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionNeedsAttention(
      count: readInteger(source['count']),
      latest: readList<Object>(source['latest'], readAny),
    );
  }

  final int? count;

  final List<Object?>? latest;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
        'latest': latest,
      };
}

/// A blog draft waiting to be published.
class SectionDraft extends Dto {
  const SectionDraft({
    this.post,
    this.updatedAt,
  });

  /// Reads a [SectionDraft] from a decoded body.
  static SectionDraft? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionDraft(
      post: SectionEntity.fromMap(source['post']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final SectionEntity? post;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'post': post,
        'updated_at': updatedAt,
      };
}

/// The blog drafts to publish: how many, and the latest.
class SectionDrafts extends Dto {
  const SectionDrafts({
    this.count,
    this.latest,
  });

  /// Reads a [SectionDrafts] from a decoded body.
  static SectionDrafts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionDrafts(
      count: readInteger(source['count']),
      latest: readList<SectionDraft>(source['latest'], SectionDraft.fromMap),
    );
  }

  final int? count;

  final List<SectionDraft?>? latest;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
        'latest': latest,
      };
}

/// A blog post and its views.
class SectionViewedPost extends Dto {
  const SectionViewedPost({
    this.post,
    this.views,
  });

  /// Reads a [SectionViewedPost] from a decoded body.
  static SectionViewedPost? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionViewedPost(
      post: SectionEntity.fromMap(source['post']),
      views: readInteger(source['views']),
    );
  }

  final SectionEntity? post;

  final int? views;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'post': post,
        'views': views,
      };
}

/// One tab of the Dashboard. `section` echoes the path value, and only the
/// fields of that tab are present. `ecommerce`: `order_updates`,
/// `best_selling_products`. `content`: `content_updates`, `top_pages`.
/// `bookings`: `needs_attention`, `upcoming`. `courses`: `new_enrolments`,
/// `unpaid_orders`, `popular_courses`. `blog`: `comments_to_moderate`,
/// `drafts_to_publish`, `most_viewed_posts`. `upcoming` and `popular_courses`
/// are empty on the store measured, so their row shape is not known.
class DashboardSectionReport extends Dto {
  const DashboardSectionReport({
    this.section,
    this.period,
    this.orderUpdates,
    this.bestSellingProducts,
    this.contentUpdates,
    this.topPages,
    this.needsAttention,
    this.upcoming,
    this.newEnrolments,
    this.unpaidOrders,
    this.popularCourses,
    this.commentsToModerate,
    this.draftsToPublish,
    this.mostViewedPosts,
  });

  /// Reads a [DashboardSectionReport] from a decoded body.
  static DashboardSectionReport? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardSectionReport(
      section: readText(source['section']),
      period: SectionPeriod.fromMap(source['period']),
      orderUpdates: SectionOrderUpdates.fromMap(source['order_updates']),
      bestSellingProducts: readList<SectionBestSeller>(
          source['best_selling_products'], SectionBestSeller.fromMap),
      contentUpdates: readList<SectionContentUpdate>(
          source['content_updates'], SectionContentUpdate.fromMap),
      topPages:
          readList<SectionTopPage>(source['top_pages'], SectionTopPage.fromMap),
      needsAttention: SectionNeedsAttention.fromMap(source['needs_attention']),
      upcoming: readList<Object>(source['upcoming'], readAny),
      newEnrolments: readInteger(source['new_enrolments']),
      unpaidOrders: readInteger(source['unpaid_orders']),
      popularCourses: readList<Object>(source['popular_courses'], readAny),
      commentsToModerate: readInteger(source['comments_to_moderate']),
      draftsToPublish: SectionDrafts.fromMap(source['drafts_to_publish']),
      mostViewedPosts: readList<SectionViewedPost>(
          source['most_viewed_posts'], SectionViewedPost.fromMap),
    );
  }

  final String? section;

  final SectionPeriod? period;

  final SectionOrderUpdates? orderUpdates;

  final List<SectionBestSeller?>? bestSellingProducts;

  final List<SectionContentUpdate?>? contentUpdates;

  final List<SectionTopPage?>? topPages;

  final SectionNeedsAttention? needsAttention;

  final List<Object?>? upcoming;

  final int? newEnrolments;

  final int? unpaidOrders;

  final List<Object?>? popularCourses;

  final int? commentsToModerate;

  final SectionDrafts? draftsToPublish;

  final List<SectionViewedPost?>? mostViewedPosts;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'section': section,
        'period': period,
        'order_updates': orderUpdates,
        'best_selling_products': bestSellingProducts,
        'content_updates': contentUpdates,
        'top_pages': topPages,
        'needs_attention': needsAttention,
        'upcoming': upcoming,
        'new_enrolments': newEnrolments,
        'unpaid_orders': unpaidOrders,
        'popular_courses': popularCourses,
        'comments_to_moderate': commentsToModerate,
        'drafts_to_publish': draftsToPublish,
        'most_viewed_posts': mostViewedPosts,
      };
}
