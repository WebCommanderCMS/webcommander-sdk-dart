/// Typed views over the SEO configuration settings bodies.
library;

import '../../../client/dto.dart';

/// One content type's block of `global_store_settings` — `pages`, `products` or
/// `categories`.
class SeoTemplates extends Dto {
  const SeoTemplates({
    this.disableIndexing,
    this.titleTemplate,
    this.descriptionTemplate,
  });

  static SeoTemplates? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SeoTemplates(
      disableIndexing: readFlag(source['disable_indexing']),
      titleTemplate: readList<String>(source['title_template'], readText),
      descriptionTemplate:
          readList<String>(source['description_template'], readText),
    );
  }

  final bool? disableIndexing;

  /// `title_template` — the tokens a generated title is built from, in order.
  final List<String?>? titleTemplate;

  final List<String?>? descriptionTemplate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'disable_indexing': disableIndexing,
        'title_template': titleTemplate,
        'description_template': descriptionTemplate,
      };
}

/// The `global_store_settings` section — the store name, the title-token
/// separator and one [SeoTemplates] block per content type.
class GlobalStoreSettings extends Dto {
  const GlobalStoreSettings({
    this.storeName,
    this.titleSeparator,
    this.pages,
    this.products,
    this.categories,
  });

  static GlobalStoreSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'global_store_settings');
    if (source == null) return null;
    return GlobalStoreSettings(
      storeName: readText(source['store_name']),
      titleSeparator: readText(source['title_separator']),
      pages: SeoTemplates.fromMap(source['pages']),
      products: SeoTemplates.fromMap(source['products']),
      categories: SeoTemplates.fromMap(source['categories']),
    );
  }

  final String? storeName;

  final String? titleSeparator;

  final SeoTemplates? pages;

  final SeoTemplates? products;

  final SeoTemplates? categories;

  @override
  String? get envelopeKey => 'global_store_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'store_name': storeName,
        'title_separator': titleSeparator,
        'pages': pages,
        'products': products,
        'categories': categories,
      };
}

/// The `header` or `footer` block of `custom_code`.
class CustomCodeBlock extends Dto {
  const CustomCodeBlock({this.enabled, this.code});

  static CustomCodeBlock? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomCodeBlock(
      enabled: readFlag(source['enabled']),
      code: readText(source['code']),
    );
  }

  final bool? enabled;

  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'code': code,
      };
}

/// The `custom_code` section — the two blocks whose [CustomCodeBlock.code]
/// reaches every storefront page.
class CustomCode extends Dto {
  const CustomCode({this.header, this.footer});

  static CustomCode? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'custom_code');
    if (source == null) return null;
    return CustomCode(
      header: CustomCodeBlock.fromMap(source['header']),
      footer: CustomCodeBlock.fromMap(source['footer']),
    );
  }

  final CustomCodeBlock? header;

  final CustomCodeBlock? footer;

  @override
  String? get envelopeKey => 'custom_code';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'header': header,
        'footer': footer,
      };
}

/// One redirect row: the store's [id], and the pair of URLs.
class Redirect extends Dto {
  const Redirect({this.id, this.sourceUrl, this.destinationUrl});

  static Redirect? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'redirect');
    if (source == null) return null;
    return Redirect(
      id: readInteger(source['id']),
      sourceUrl: readText(source['source_url']),
      destinationUrl: readText(source['destination_url']),
    );
  }

  /// `id` — the store's, and what a `{redirect_id}` path slot takes.
  final int? id;

  final String? sourceUrl;

  final String? destinationUrl;

  @override
  String? get envelopeKey => 'redirect';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'source_url': sourceUrl,
        'destination_url': destinationUrl,
      };
}

/// The `redirects` block inside `url_settings` — the rows inlined for reading,
/// with no `pagination`, so a count here is not the collection's `total`.
class RedirectsPreview extends Dto {
  const RedirectsPreview({this.items});

  static RedirectsPreview? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return RedirectsPreview(
      items: readList<Redirect>(source['items'], Redirect.fromMap),
    );
  }

  final List<Redirect?>? items;

  @override
  Map<String, Object?> get fields => <String, Object?>{'items': items};
}

/// The `url_settings` section — whether renaming an item rewrites its URL,
/// whether a rewrite leaves a redirect behind, and the inlined rows.
class UrlSettings extends Dto {
  const UrlSettings({
    this.regenerateUrlOnItemUpdate,
    this.autoRedirectOnUrlChange,
    this.redirects,
  });

  static UrlSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'url_settings');
    if (source == null) return null;
    return UrlSettings(
      regenerateUrlOnItemUpdate:
          readFlag(source['regenerate_url_on_item_update']),
      autoRedirectOnUrlChange: readFlag(source['auto_redirect_on_url_change']),
      redirects: RedirectsPreview.fromMap(source['redirects']),
    );
  }

  final bool? regenerateUrlOnItemUpdate;

  final bool? autoRedirectOnUrlChange;

  /// `redirects` — read-only here, and answered on a write to this section too.
  final RedirectsPreview? redirects;

  @override
  String? get envelopeKey => 'url_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'regenerate_url_on_item_update': regenerateUrlOnItemUpdate,
        'auto_redirect_on_url_change': autoRedirectOnUrlChange,
        'redirects': redirects,
      };
}

/// One file served from the store's document root.
class DocumentRootFile extends Dto {
  const DocumentRootFile({this.configKey, this.fileName, this.filePath});

  static DocumentRootFile? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'document_root_file');
    if (source == null) return null;
    return DocumentRootFile(
      configKey: readText(source['config_key']),
      fileName: readText(source['file_name']),
      filePath: readText(source['file_path']),
    );
  }

  /// `config_key` — the store's own id and the value the delete takes, not the
  /// file name.
  final String? configKey;

  final String? fileName;

  /// `file_path` — where the storefront serves the file from.
  final String? filePath;

  @override
  String? get envelopeKey => 'document_root_file';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'config_key': configKey,
        'file_name': fileName,
        'file_path': filePath,
      };
}

/// The `document_root` block the facade inlines — the rows with no
/// `pagination`, as with [RedirectsPreview].
class DocumentRootPreview extends Dto {
  const DocumentRootPreview({this.items});

  static DocumentRootPreview? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DocumentRootPreview(
      items:
          readList<DocumentRootFile>(source['items'], DocumentRootFile.fromMap),
    );
  }

  final List<DocumentRootFile?>? items;

  @override
  Map<String, Object?> get fields => <String, Object?>{'items': items};
}

/// One entry of `group_meta`: what a thing is, whether it can be written, and
/// where it lives.
class SectionMeta extends Dto {
  const SectionMeta({this.kind, this.writable, this.href, this.redirects});

  static SectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
      redirects: SectionMeta.fromMap(source['redirects']),
    );
  }

  /// `kind` — `"setting"` or `"collection"`.
  final String? kind;

  final bool? writable;

  /// `href` — the entry's own path, ending in its own name.
  final String? href;

  final SectionMeta? redirects;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
        'redirects': redirects,
      };
}

/// The `group_meta` block — one [SectionMeta] per thing the area declares.
class GroupMeta extends Dto {
  const GroupMeta({
    this.globalStoreSettings,
    this.customCode,
    this.documentRoot,
    this.urlSettings,
  });

  static GroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GroupMeta(
      globalStoreSettings: SectionMeta.fromMap(source['global_store_settings']),
      customCode: SectionMeta.fromMap(source['custom_code']),
      documentRoot: SectionMeta.fromMap(source['document_root']),
      urlSettings: SectionMeta.fromMap(source['url_settings']),
    );
  }

  final SectionMeta? globalStoreSettings;

  final SectionMeta? customCode;

  final SectionMeta? documentRoot;

  final SectionMeta? urlSettings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'global_store_settings': globalStoreSettings,
        'custom_code': customCode,
        'document_root': documentRoot,
        'url_settings': urlSettings,
      };
}

/// The SEO configuration, as the facade or one section sends it.
class SeoConfiguration extends Dto {
  const SeoConfiguration({
    this.globalStoreSettings,
    this.customCode,
    this.documentRoot,
    this.urlSettings,
    this.groupMeta,
    this.fieldMetadata,
  });

  static SeoConfiguration? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'seo_configuration');
    if (source == null) return null;
    return SeoConfiguration(
      globalStoreSettings:
          GlobalStoreSettings.fromMap(source['global_store_settings']),
      customCode: CustomCode.fromMap(source['custom_code']),
      documentRoot: DocumentRootPreview.fromMap(source['document_root']),
      urlSettings: UrlSettings.fromMap(source['url_settings']),
      groupMeta: GroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final GlobalStoreSettings? globalStoreSettings;

  final CustomCode? customCode;

  /// `document_root` — the collection inlined, so no `pagination` beside it.
  final DocumentRootPreview? documentRoot;

  final UrlSettings? urlSettings;

  /// `group_meta` — on the facade's answer only.
  final GroupMeta? groupMeta;

  /// `field_metadata` — untyped, because the store keys it differently in the
  /// two forms: by section on the facade, by field name on a section.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'seo_configuration';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'global_store_settings': globalStoreSettings,
        'custom_code': customCode,
        'document_root': documentRoot,
        'url_settings': urlSettings,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
