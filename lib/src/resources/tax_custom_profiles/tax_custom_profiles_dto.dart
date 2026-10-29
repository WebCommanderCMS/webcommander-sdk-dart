/// Typed views over the custom tax profile bodies.
library;

import '../../client/dto.dart';

/// One profile a rule is filed under, on the rule's `profiles`.
class CustomProfileReference extends Dto {
  const CustomProfileReference({this.id, this.name});

  /// Reads one entry of `profiles`.
  static CustomProfileReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfileReference(
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

/// One entry of a custom profile's `rules` — the list **only the row path
/// sends**; the listing carries `rules_count` instead.
class CustomProfileRule extends Dto {
  const CustomProfileRule({
    this.id,
    this.name,
    this.description,
    this.zonesCount,
    this.profiles,
    this.createdOn,
    this.lastUpdatedOn,
  });

  /// Reads one entry of `rules`.
  static CustomProfileRule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfileRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      zonesCount: readInteger(source['zones_count']),
      profiles: readList<CustomProfileReference>(
          source['profiles'], CustomProfileReference.fromMap),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  final int? zonesCount;

  /// `profiles` — every profile the rule is filed under, this one included.
  final List<CustomProfileReference?>? profiles;

  final String? createdOn;

  final String? lastUpdatedOn;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'zones_count': zonesCount,
        'profiles': profiles,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
      };
}

/// One custom tax profile; the row path adds `rules` to the eight keys a
/// listing row, the create and the update answer carry.
class CustomProfile extends Dto {
  const CustomProfile({
    this.id,
    this.name,
    this.taxCode,
    this.description,
    this.isDefault,
    this.rulesCount,
    this.createdOn,
    this.lastUpdatedOn,
    this.rules,
  });

  /// Reads a row path's `custom_profile` envelope, or a bare listing row.
  static CustomProfile? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'custom_profile');
    if (source == null) return null;
    return CustomProfile(
      id: readInteger(source['id']),
      name: readText(source['name']),
      taxCode: readText(source['tax_code']),
      description: readText(source['description']),
      isDefault: readFlag(source['is_default']),
      rulesCount: readInteger(source['rules_count']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      rules: readList<CustomProfileRule>(
          source['rules'], CustomProfileRule.fromMap),
    );
  }

  final int? id;

  final String? name;

  /// `tax_code` — written by either write; `code` sent instead is discarded.
  final String? taxCode;

  final String? description;

  final bool? isDefault;

  /// `rules_count` — what the listing sends in place of [rules].
  final int? rulesCount;

  final String? createdOn;

  final String? lastUpdatedOn;

  /// `rules` — **the row path only**; nothing on this resource writes one.
  final List<CustomProfileRule?>? rules;

  @override
  String? get envelopeKey => 'custom_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'tax_code': taxCode,
        'description': description,
        'is_default': isDefault,
        'rules_count': rulesCount,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'rules': rules,
      };
}

/// The writable form of [CustomProfile], shared by the create and the update:
/// `{"custom_profile": {...}}` with `transaction_no` beside the envelope.
class CustomProfileInput extends Dto {
  const CustomProfileInput({
    this.name,
    this.taxCode,
    this.description,
    this.isDefault,
    this.transactionNo,
  });

  /// `name` — required by the create; omitted on the update it is kept.
  final String? name;

  /// `tax_code` — omitted on the update comes back `null`.
  final String? taxCode;

  /// `description` — omitted on the update comes back `null`.
  final String? description;

  final bool? isDefault;

  /// `transaction_no` — the create files the profile under it; the update files
  /// it only on a profile no number holds yet.
  final String? transactionNo;

  @override
  String? get envelopeKey => 'custom_profile';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'tax_code': taxCode,
        'description': description,
        'is_default': isDefault,
        'transaction_no': transactionNo,
      };
}

/// One `group_meta` entry: what the path is, whether it is writable and where.
class CustomProfileResourceMeta extends Dto {
  const CustomProfileResourceMeta({this.kind, this.writable, this.href});

  /// Reads one entry of `group_meta`.
  static CustomProfileResourceMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfileResourceMeta(
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

/// The `group_meta` block only the listing sends.
class CustomProfileGroupMeta extends Dto {
  const CustomProfileGroupMeta({this.customProfile, this.rules});

  /// Reads a `group_meta` block.
  static CustomProfileGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfileGroupMeta(
      customProfile:
          CustomProfileResourceMeta.fromMap(source['custom_profile']),
      rules: CustomProfileResourceMeta.fromMap(source['rules']),
    );
  }

  final CustomProfileResourceMeta? customProfile;

  final CustomProfileResourceMeta? rules;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'custom_profile': customProfile,
        'rules': rules,
      };
}

/// The `pagination` block this listing sends.
class CustomProfilePagination extends Dto {
  const CustomProfilePagination({
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
  static CustomProfilePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfilePagination(
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

  /// `total` — every row matching, not just this page.
  final int? total;

  /// `limit` — the page size in force, `TaxCustomProfileUrls.pageSize` when
  /// none was sent and capped at 100.
  final int? limit;

  /// `offset` — `(page - 1) * limit` when the request named `page` instead.
  final int? offset;

  /// `count` — the rows on this page, which is what a window advances by.
  final int? count;

  final int? currentPage;

  /// `total_pages` — `ceil(total / limit)`, with the `limit` in force.
  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  /// `previous_page` — a whole URL carrying the query, `null` on the first page.
  final String? previousPage;

  /// `next_page` — a whole URL carrying the query, `null` on the last.
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

/// One page of the custom profile listing: its rows, `group_meta` and the
/// `pagination` block.
class CustomProfilePage extends Dto {
  const CustomProfilePage(
      {this.customProfiles, this.groupMeta, this.pagination});

  /// Reads a listing body.
  static CustomProfilePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProfilePage(
      customProfiles: readList<CustomProfile>(
          source['custom_profiles'], CustomProfile.fromMap),
      groupMeta: CustomProfileGroupMeta.fromMap(source['group_meta']),
      pagination: CustomProfilePagination.fromMap(source['pagination']),
    );
  }

  /// `custom_profiles` — the rows, each without its `rules`.
  final List<CustomProfile?>? customProfiles;

  final CustomProfileGroupMeta? groupMeta;

  final CustomProfilePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'custom_profiles': customProfiles,
        'group_meta': groupMeta,
        'pagination': pagination,
      };
}
