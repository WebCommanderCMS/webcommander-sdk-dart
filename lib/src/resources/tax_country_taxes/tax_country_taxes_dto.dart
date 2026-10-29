/// Typed views over the country tax bodies.
library;

import '../../client/dto.dart';

/// A country as a country tax nests it on `country`, resolved by the store from
/// the `country_code` a create sends; `null` on the rest-of-the-world row.
class CountryTaxCountry extends Dto {
  const CountryTaxCountry({this.id, this.name, this.code});

  /// Reads one nested country.
  static CountryTaxCountry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxCountry(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  final int? id;

  final String? name;

  /// `code` — the country's own ISO code, which a country tax's `tax_code`
  /// need not match.
  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// A state as a state rule nests it on `state`.
class CountryTaxState extends Dto {
  const CountryTaxState({this.id, this.name, this.code});

  /// Reads one nested state.
  static CountryTaxState? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxState(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  final int? id;

  final String? name;

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// One entry of a country tax's `state_rules`, which only the row path and the
/// update send.
class CountryTaxStateRule extends Dto {
  const CountryTaxStateRule({
    this.id,
    this.name,
    this.state,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postCode,
    this.taxRate,
    this.taxRule,
    this.effectiveTaxRate,
    this.isDefault,
    this.createdOn,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
  });

  /// Reads one entry of `state_rules`.
  static CountryTaxStateRule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxStateRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      state: CountryTaxState.fromMap(source['state']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      city: readText(source['city']),
      postCode: readText(source['post_code']),
      taxRate: readDecimal(source['tax_rate']),
      taxRule: readText(source['tax_rule']),
      effectiveTaxRate: readDecimal(source['effective_tax_rate']),
      isDefault: readFlag(source['is_default']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      lastUpdatedBy: readAny(source['last_updated_by']),
    );
  }

  final int? id;

  final String? name;

  /// `state` — `null` on the rest-of-the-world row.
  final CountryTaxState? state;

  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  /// `post_code` — a single string.
  final String? postCode;

  final double? taxRate;

  final String? taxRule;

  final double? effectiveTaxRate;

  final bool? isDefault;

  final String? createdOn;

  final String? lastUpdatedOn;

  /// `last_updated_by` — only ever seen `null`, so its type is not claimed.
  final Object? lastUpdatedBy;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'state': state,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'post_code': postCode,
        'tax_rate': taxRate,
        'tax_rule': taxRule,
        'effective_tax_rate': effectiveTaxRate,
        'is_default': isDefault,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'last_updated_by': lastUpdatedBy,
      };
}

/// One country tax; the row path and the update add `state_rules` to the
/// twelve keys a listing row and the create answer carry.
class CountryTax extends Dto {
  const CountryTax({
    this.id,
    this.name,
    this.country,
    this.taxCode,
    this.taxRate,
    this.taxMethod,
    this.isDefault,
    this.isRestOfWorld,
    this.stateRulesCount,
    this.createdOn,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.stateRules,
  });

  /// Reads a row path's `country_tax` envelope, or a bare listing row.
  static CountryTax? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'country_tax');
    if (source == null) return null;
    return CountryTax(
      id: readInteger(source['id']),
      name: readText(source['name']),
      country: CountryTaxCountry.fromMap(source['country']),
      taxCode: readText(source['tax_code']),
      taxRate: readDecimal(source['tax_rate']),
      taxMethod: readText(source['tax_method']),
      isDefault: readFlag(source['is_default']),
      isRestOfWorld: readFlag(source['is_rest_of_world']),
      stateRulesCount: readInteger(source['state_rules_count']),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      lastUpdatedBy: readAny(source['last_updated_by']),
      stateRules: readList<CountryTaxStateRule>(
          source['state_rules'], CountryTaxStateRule.fromMap),
    );
  }

  final int? id;

  final String? name;

  /// `country` — resolved from the create's `country_code`, and `null` on the
  /// store's rest-of-the-world row.
  final CountryTaxCountry? country;

  /// `tax_code` — written by the create, the country's code when left out.
  final String? taxCode;

  final double? taxRate;

  /// `tax_method` — `fixed_rate`, `api` or `no_tax`, read lower case.
  final String? taxMethod;

  /// `is_default` — not exclusive: several rows may hold it.
  final bool? isDefault;

  final bool? isRestOfWorld;

  /// `state_rules_count` — what the listing sends in place of [stateRules].
  final int? stateRulesCount;

  final String? createdOn;

  final String? lastUpdatedOn;

  /// `last_updated_by` — only ever seen `null`, so its type is not claimed.
  final Object? lastUpdatedBy;

  /// `state_rules` — **the row path and the update only**.
  final List<CountryTaxStateRule?>? stateRules;

  @override
  String? get envelopeKey => 'country_tax';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'country': country,
        'tax_code': taxCode,
        'tax_rate': taxRate,
        'tax_method': taxMethod,
        'is_default': isDefault,
        'is_rest_of_world': isRestOfWorld,
        'state_rules_count': stateRulesCount,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'last_updated_by': lastUpdatedBy,
        'state_rules': stateRules,
      };
}

/// The writable form of [CountryTax], shared by the create and the update:
/// `{"country_tax": {...}}` with `transaction_no` beside the envelope.
class CountryTaxInput extends Dto {
  const CountryTaxInput({
    this.countryCode,
    this.name,
    this.taxCode,
    this.taxRate,
    this.taxMethod,
    this.isDefault,
    this.transactionNo,
  });

  /// `country_code` — required by the create, and a key no read sends back.
  final String? countryCode;

  final String? name;

  final String? taxCode;

  final double? taxRate;

  final String? taxMethod;

  final bool? isDefault;

  /// `transaction_no` — the create files the row under it; the update re-files
  /// the row and the earlier number then answers `404`.
  final String? transactionNo;

  @override
  String? get envelopeKey => 'country_tax';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country_code': countryCode,
        'name': name,
        'tax_code': taxCode,
        'tax_rate': taxRate,
        'tax_method': taxMethod,
        'is_default': isDefault,
        'transaction_no': transactionNo,
      };
}

/// One `group_meta` entry: what the path is, whether it is writable and where.
class CountryTaxResourceMeta extends Dto {
  const CountryTaxResourceMeta({this.kind, this.writable, this.href});

  /// Reads one entry of `group_meta`.
  static CountryTaxResourceMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxResourceMeta(
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
class CountryTaxGroupMeta extends Dto {
  const CountryTaxGroupMeta({this.countryTax, this.stateRules});

  /// Reads a `group_meta` block.
  static CountryTaxGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxGroupMeta(
      countryTax: CountryTaxResourceMeta.fromMap(source['country_tax']),
      stateRules: CountryTaxResourceMeta.fromMap(source['state_rules']),
    );
  }

  final CountryTaxResourceMeta? countryTax;

  final CountryTaxResourceMeta? stateRules;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country_tax': countryTax,
        'state_rules': stateRules,
      };
}

/// The `pagination` block this listing sends.
class CountryTaxPagination extends Dto {
  const CountryTaxPagination({
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
  static CountryTaxPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxPagination(
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

  /// `limit` — the page size in force, `TaxCountryTaxUrls.pageSize` when none
  /// was sent and capped at 100.
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

/// One page of the country tax listing: its rows, `group_meta` and the
/// `pagination` block.
class CountryTaxPage extends Dto {
  const CountryTaxPage({this.countryTaxes, this.groupMeta, this.pagination});

  /// Reads a listing body.
  static CountryTaxPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CountryTaxPage(
      countryTaxes:
          readList<CountryTax>(source['country_taxes'], CountryTax.fromMap),
      groupMeta: CountryTaxGroupMeta.fromMap(source['group_meta']),
      pagination: CountryTaxPagination.fromMap(source['pagination']),
    );
  }

  /// `country_taxes` — the rows, each without its `state_rules`.
  final List<CountryTax?>? countryTaxes;

  final CountryTaxGroupMeta? groupMeta;

  final CountryTaxPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country_taxes': countryTaxes,
        'group_meta': groupMeta,
        'pagination': pagination,
      };
}
