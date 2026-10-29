/// Typed views over the search settings bodies.
library;

import '../../../client/dto.dart';

/// One entry of an `excluded` list as a read sends it.
class ExcludedRecord extends Dto {
  const ExcludedRecord({this.id, this.name});

  static ExcludedRecord? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ExcludedRecord(
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

/// One content type the site search covers — whether it is searched, the
/// heading its hits are grouped under, and the rows held out of it.
class SearchableContentGroup extends Dto {
  const SearchableContentGroup({
    this.enabled,
    this.displayHeading,
    this.excluded,
  });

  static SearchableContentGroup? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchableContentGroup(
      enabled: readFlag(source['enabled']),
      displayHeading: readText(source['display_heading']),
      excluded: readList(source['excluded'], ExcludedRecord.fromMap),
    );
  }

  final bool? enabled;

  final String? displayHeading;

  /// `excluded` — records on the way in, bare ids or those same records on the
  /// way out.
  final List<ExcludedRecord?>? excluded;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'display_heading': displayHeading,
        'excluded': excluded,
      };
}

/// The `product_categories` block — the only content group carrying a fourth
/// field.
class ProductCategoriesContent extends SearchableContentGroup {
  const ProductCategoriesContent({
    super.enabled,
    super.displayHeading,
    super.excluded,
    this.hideParentCategory,
  });

  static ProductCategoriesContent? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProductCategoriesContent(
      enabled: readFlag(source['enabled']),
      hideParentCategory: readFlag(source['hide_parent_category']),
      displayHeading: readText(source['display_heading']),
      excluded: readList(source['excluded'], ExcludedRecord.fromMap),
    );
  }

  final bool? hideParentCategory;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'hide_parent_category': hideParentCategory,
        'display_heading': displayHeading,
        'excluded': excluded,
      };
}

/// The `searchable_content` section — what the search box says and which
/// content types it reaches.
class SearchableContent extends Dto {
  const SearchableContent({
    this.placeholderText,
    this.product,
    this.productCategories,
    this.blog,
    this.otherPages,
  });

  static SearchableContent? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'searchable_content');
    if (source == null) return null;
    return SearchableContent(
      placeholderText: readText(source['placeholder_text']),
      product: SearchableContentGroup.fromMap(source['product']),
      productCategories:
          ProductCategoriesContent.fromMap(source['product_categories']),
      blog: SearchableContentGroup.fromMap(source['blog']),
      otherPages: SearchableContentGroup.fromMap(source['other_pages']),
    );
  }

  final String? placeholderText;

  final SearchableContentGroup? product;

  final ProductCategoriesContent? productCategories;

  final SearchableContentGroup? blog;

  final SearchableContentGroup? otherPages;

  @override
  String? get envelopeKey => 'searchable_content';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'placeholder_text': placeholderText,
        'product': product,
        'product_categories': productCategories,
        'blog': blog,
        'other_pages': otherPages,
      };
}

/// One row of `search_fields.fields` — a product field and where it ranks.
class SearchFieldPriority extends Dto {
  const SearchFieldPriority({this.field, this.priority});

  static SearchFieldPriority? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchFieldPriority(
      field: readText(source['field']),
      priority: readInteger(source['priority']),
    );
  }

  final String? field;

  final int? priority;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'field': field,
        'priority': priority,
      };
}

/// The `search_fields` section — how a query is matched and which fields it is
/// matched against.
class SearchFields extends Dto {
  const SearchFields({
    this.matchKeywordsExactly,
    this.matchFullSentences,
    this.searchFields,
  });

  static SearchFields? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'search_fields');
    if (source == null) return null;
    return SearchFields(
      matchKeywordsExactly: readFlag(source['match_keywords_exactly']),
      matchFullSentences: readFlag(source['match_full_sentences']),
      searchFields: readList(source['fields'], SearchFieldPriority.fromMap),
    );
  }

  final bool? matchKeywordsExactly;

  final bool? matchFullSentences;

  /// `fields` — every product field the query is matched against, and its rank.
  final List<SearchFieldPriority?>? searchFields;

  @override
  String? get envelopeKey => 'search_fields';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'match_keywords_exactly': matchKeywordsExactly,
        'match_full_sentences': matchFullSentences,
        'fields': searchFields,
      };
}

/// One group of `synonyms.groups` — words a query treats as each other.
class SynonymGroup extends Dto {
  const SynonymGroup({this.keywords});

  static SynonymGroup? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SynonymGroup(keywords: readList(source['keywords'], readText));
  }

  final List<String?>? keywords;

  @override
  Map<String, Object?> get fields => <String, Object?>{'keywords': keywords};
}

/// The `synonyms` section — read it, do not write it.
class Synonyms extends Dto {
  const Synonyms({this.groups});

  static Synonyms? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'synonyms');
    if (source == null) return null;
    return Synonyms(groups: readList(source['groups'], SynonymGroup.fromMap));
  }

  final List<SynonymGroup?>? groups;

  @override
  String? get envelopeKey => 'synonyms';

  @override
  Map<String, Object?> get fields => <String, Object?>{'groups': groups};
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class SearchSettingsSectionMeta extends Dto {
  const SearchSettingsSectionMeta({this.kind, this.writable, this.href});

  static SearchSettingsSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchSettingsSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on all three entries here.
  final String? kind;

  /// `writable` — `true` on all three entries here.
  final bool? writable;

  /// `href` — the section's own path on this resource, for all three entries.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [SearchSettingsSectionMeta] per section the
/// area declares.
class SearchSettingsGroupMeta extends Dto {
  const SearchSettingsGroupMeta({
    this.searchableContent,
    this.searchFields,
    this.synonyms,
  });

  static SearchSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SearchSettingsGroupMeta(
      searchableContent:
          SearchSettingsSectionMeta.fromMap(source['searchable_content']),
      searchFields: SearchSettingsSectionMeta.fromMap(source['search_fields']),
      synonyms: SearchSettingsSectionMeta.fromMap(source['synonyms']),
    );
  }

  final SearchSettingsSectionMeta? searchableContent;

  final SearchSettingsSectionMeta? searchFields;

  final SearchSettingsSectionMeta? synonyms;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'searchable_content': searchableContent,
        'search_fields': searchFields,
        'synonyms': synonyms,
      };
}

/// The `reindex_status` sub-resource — where the Elasticsearch reindex stands.
class ReindexStatus extends Dto {
  const ReindexStatus({
    this.state,
    this.startedAt,
    this.finishedAt,
    this.error,
  });

  static ReindexStatus? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReindexStatus(
      state: readText(source['state']),
      startedAt: readAny(source['started_at']),
      finishedAt: readAny(source['finished_at']),
      error: readAny(source['error']),
    );
  }

  final String? state;

  /// `started_at` — untyped.
  final Object? startedAt;

  /// `finished_at` — untyped.
  final Object? finishedAt;

  /// `error` — untyped.
  final Object? error;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'state': state,
        'started_at': startedAt,
        'finished_at': finishedAt,
        'error': error,
      };
}

/// The search settings, as the facade or one section sends them.
class SearchSettings extends Dto {
  const SearchSettings({
    this.searchableContent,
    this.searchFields,
    this.synonyms,
    this.groupMeta,
    this.fieldMetadata,
  });

  static SearchSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'search_settings');
    if (source == null) return null;
    return SearchSettings(
      searchableContent:
          SearchableContent.fromMap(source['searchable_content']),
      searchFields: SearchFields.fromMap(source['search_fields']),
      synonyms: Synonyms.fromMap(source['synonyms']),
      groupMeta: SearchSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final SearchableContent? searchableContent;

  final SearchFields? searchFields;

  /// `synonyms` — read and typed here, written by nothing: a write of it
  /// triggers a reindex that cannot be undone.
  final Synonyms? synonyms;

  /// `group_meta` — on the facade's answer only.
  final SearchSettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'search_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'searchable_content': searchableContent,
        'search_fields': searchFields,
        'synonyms': synonyms,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
