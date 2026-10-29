/// Typed views over the category bodies.
library;

import '../../client/dto.dart';

/// Another record a category points at, read as `{id, name}`; a write needs
/// only `id`.
class CategoryReference extends Dto {
  const CategoryReference({this.id, this.name});

  /// Reads one reference.
  static CategoryReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryReference(
      id: readInteger(source['id']),
      name: readText(source['name']),
    );
  }

  final int? id;

  /// `name` — read back beside the id; one sent on a write is ignored.
  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
      };
}

/// The `general` section as read.
class CategoryGeneral extends Dto {
  const CategoryGeneral({
    this.name,
    this.title,
    this.sku,
    this.url,
    this.heading,
    this.parentCategory,
    this.filterProfile,
    this.layout,
    this.summary,
  });

  /// Reads the section.
  static CategoryGeneral? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryGeneral(
      name: readText(source['name']),
      title: readText(source['title']),
      sku: readText(source['sku']),
      url: readText(source['url']),
      heading: readText(source['heading']),
      parentCategory: CategoryReference.fromMap(source['parent_category']),
      filterProfile: readAny(source['filter_profile']),
      layout: CategoryReference.fromMap(source['layout']),
      summary: readText(source['summary']),
    );
  }

  final String? name;

  final String? title;

  /// `sku` — generated when a create omits it.
  final String? sku;

  /// `url` — derived from the name on a create; a rename by `PUT` keeps it.
  final String? url;

  final String? heading;

  final CategoryReference? parentCategory;

  /// `filter_profile` — belongs to a filter plugin and reads `null` without
  /// one; a write naming an `id` there is then `400`, a `null` accepted.
  final Object? filterProfile;

  final CategoryReference? layout;

  final String? summary;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'title': title,
        'sku': sku,
        'url': url,
        'heading': heading,
        'parent_category': parentCategory,
        'filter_profile': filterProfile,
        'layout': layout,
        'summary': summary,
      };
}

/// The `description` section, the same one field read and written.
class CategoryDescription extends Dto {
  const CategoryDescription({this.content});

  /// Reads the section.
  static CategoryDescription? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryDescription(content: readText(source['content']));
  }

  final String? content;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'content': content,
      };
}

/// The `images_media` section as read: the two stored images' URLs and the
/// image's alt text, each `""` when unset.
class CategoryImagesMedia extends Dto {
  const CategoryImagesMedia(
      {this.imageUrl, this.imageAlt, this.backgroundImageUrl});

  /// Reads the section.
  static CategoryImagesMedia? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryImagesMedia(
      imageUrl: readText(source['image_url']),
      imageAlt: readText(source['image_alt']),
      backgroundImageUrl: readText(source['background_image_url']),
    );
  }

  final String? imageUrl;

  final String? imageAlt;

  final String? backgroundImageUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'image_url': imageUrl,
        'image_alt': imageAlt,
        'background_image_url': backgroundImageUrl,
      };
}

/// Who `available_for: "selected"` admits, each customer and group read as
/// `{id, name}`.
class CategorySelectedCustomers extends Dto {
  const CategorySelectedCustomers({this.customers, this.groups});

  /// Reads the block.
  static CategorySelectedCustomers? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategorySelectedCustomers(
      customers: readList<CategoryReference>(
          source['customers'], CategoryReference.fromMap),
      groups: readList<CategoryReference>(
          source['groups'], CategoryReference.fromMap),
    );
  }

  final List<CategoryReference?>? customers;

  final List<CategoryReference?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// The `availability_visibility` section as read; `password` is never echoed.
class CategoryAvailabilityVisibility extends Dto {
  const CategoryAvailabilityVisibility({
    this.available,
    this.visible,
    this.availableFor,
    this.selectedCustomers,
    this.availableOnDateRange,
    this.availableFromDate,
    this.availableToDate,
    this.passwordProtected,
    this.customSorting,
    this.defaultSorting,
    this.disableTracking,
  });

  /// Reads the section.
  static CategoryAvailabilityVisibility? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryAvailabilityVisibility(
      available: readFlag(source['available']),
      visible: readFlag(source['visible']),
      availableFor: readText(source['available_for']),
      selectedCustomers:
          CategorySelectedCustomers.fromMap(source['selected_customers']),
      availableOnDateRange: readFlag(source['available_on_date_range']),
      availableFromDate: readText(source['available_from_date']),
      availableToDate: readText(source['available_to_date']),
      passwordProtected: readFlag(source['password_protected']),
      customSorting: readFlag(source['custom_sorting']),
      defaultSorting: readText(source['default_sorting']),
      disableTracking: readFlag(source['disable_tracking']),
    );
  }

  final bool? available;

  final bool? visible;

  /// `available_for` — `everyone`, `customer` or `selected`.
  final String? availableFor;

  final CategorySelectedCustomers? selectedCustomers;

  final bool? availableOnDateRange;

  final String? availableFromDate;

  final String? availableToDate;

  final bool? passwordProtected;

  final bool? customSorting;

  /// `default_sorting` — `null` until set, and no write sets it back to `null`.
  final String? defaultSorting;

  final bool? disableTracking;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'available': available,
        'visible': visible,
        'available_for': availableFor,
        'selected_customers': selectedCustomers,
        'available_on_date_range': availableOnDateRange,
        'available_from_date': availableFromDate,
        'available_to_date': availableToDate,
        'password_protected': passwordProtected,
        'custom_sorting': customSorting,
        'default_sorting': defaultSorting,
        'disable_tracking': disableTracking,
      };
}

/// The `tax_shipping` section, read and written alike. A `shipping_profile`
/// sets `enable_shipping`, and `enable_shipping: false` clears the profile.
class CategoryTaxShipping extends Dto {
  const CategoryTaxShipping({
    this.taxExempt,
    this.taxProfile,
    this.taxMessage,
    this.showPriceWithTax,
    this.pricesEnteredWithTax,
    this.basePriceRounding,
    this.enableShipping,
    this.shippingProfile,
  });

  /// Reads the section.
  static CategoryTaxShipping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryTaxShipping(
      taxExempt: readFlag(source['tax_exempt']),
      taxProfile: CategoryReference.fromMap(source['tax_profile']),
      taxMessage: readText(source['tax_message']),
      showPriceWithTax: readFlag(source['show_price_with_tax']),
      pricesEnteredWithTax: readFlag(source['prices_entered_with_tax']),
      basePriceRounding: readText(source['base_price_rounding']),
      enableShipping: readFlag(source['enable_shipping']),
      shippingProfile: CategoryReference.fromMap(source['shipping_profile']),
    );
  }

  final bool? taxExempt;

  /// `tax_profile` — a `PUT` that does not name it resets it to `null`.
  final CategoryReference? taxProfile;

  final String? taxMessage;

  final bool? showPriceWithTax;

  final bool? pricesEnteredWithTax;

  final String? basePriceRounding;

  final bool? enableShipping;

  /// `shipping_profile` — a `PUT` that does not name it resets it to `null`.
  final CategoryReference? shippingProfile;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_exempt': taxExempt,
        'tax_profile': taxProfile,
        'tax_message': taxMessage,
        'show_price_with_tax': showPriceWithTax,
        'prices_entered_with_tax': pricesEnteredWithTax,
        'base_price_rounding': basePriceRounding,
        'enable_shipping': enableShipping,
        'shipping_profile': shippingProfile,
      };
}

/// One assigned product, as `assign_products` reads it.
class CategoryProduct extends Dto {
  const CategoryProduct({this.id, this.name, this.sku});

  /// Reads one entry of `products`.
  static CategoryProduct? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryProduct(
      id: readInteger(source['id']),
      name: readText(source['name']),
      sku: readText(source['sku']),
    );
  }

  final int? id;

  final String? name;

  final String? sku;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'sku': sku,
      };
}

/// The `assign_products` section as read.
class CategoryAssignProducts extends Dto {
  const CategoryAssignProducts({this.products});

  /// Reads the section.
  static CategoryAssignProducts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryAssignProducts(
      products: readList<CategoryProduct>(
          source['products'], CategoryProduct.fromMap),
    );
  }

  final List<CategoryProduct?>? products;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'products': products,
      };
}

/// One `group_meta` entry; `href` is the section's path, the row's id a
/// placeholder.
class CategorySectionMeta extends Dto {
  const CategorySectionMeta({this.kind, this.writable, this.href});

  /// Reads one entry.
  static CategorySectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategorySectionMeta(
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

/// The `group_meta` block the listing, a row read and every whole-row write
/// send.
class CategoryGroupMeta extends Dto {
  const CategoryGroupMeta({
    this.general,
    this.description,
    this.imagesMedia,
    this.availabilityVisibility,
    this.taxShipping,
    this.assignProducts,
  });

  /// Reads the block.
  static CategoryGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryGroupMeta(
      general: CategorySectionMeta.fromMap(source['general']),
      description: CategorySectionMeta.fromMap(source['description']),
      imagesMedia: CategorySectionMeta.fromMap(source['images_media']),
      availabilityVisibility:
          CategorySectionMeta.fromMap(source['availability_visibility']),
      taxShipping: CategorySectionMeta.fromMap(source['tax_shipping']),
      assignProducts: CategorySectionMeta.fromMap(source['assign_products']),
    );
  }

  final CategorySectionMeta? general;

  final CategorySectionMeta? description;

  final CategorySectionMeta? imagesMedia;

  final CategorySectionMeta? availabilityVisibility;

  final CategorySectionMeta? taxShipping;

  final CategorySectionMeta? assignProducts;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'general': general,
        'description': description,
        'images_media': imagesMedia,
        'availability_visibility': availabilityVisibility,
        'tax_shipping': taxShipping,
        'assign_products': assignProducts,
      };
}

/// One category: a listing row, a row read, a whole-row write's answer, or a
/// section's answer, which carries that one section alone under `category`.
class Category extends Dto {
  const Category({
    this.general,
    this.description,
    this.imagesMedia,
    this.availabilityVisibility,
    this.taxShipping,
    this.assignProducts,
    this.id,
    this.transactionNo,
    this.disposable,
    this.inTrash,
    this.parentInTrash,
    this.createdBy,
    this.createdOn,
    this.lastUpdatedBy,
    this.lastUpdatedOn,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads a `category` envelope with what sits beside it, or a bare listing
  /// row.
  static Category? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'category');
    if (source == null) return null;
    return Category(
      general: CategoryGeneral.fromMap(source['general']),
      description: CategoryDescription.fromMap(source['description']),
      imagesMedia: CategoryImagesMedia.fromMap(source['images_media']),
      availabilityVisibility: CategoryAvailabilityVisibility.fromMap(
          source['availability_visibility']),
      taxShipping: CategoryTaxShipping.fromMap(source['tax_shipping']),
      assignProducts: CategoryAssignProducts.fromMap(source['assign_products']),
      id: readInteger(source['id']),
      transactionNo: readText(source['transaction_no']),
      disposable: readFlag(source['disposable']),
      inTrash: readFlag(source['in_trash']),
      parentInTrash: readFlag(source['parent_in_trash']),
      createdBy: readText(source['created_by']),
      createdOn: readText(source['created_on']),
      lastUpdatedBy: readText(source['last_updated_by']),
      lastUpdatedOn: readText(source['last_updated_on']),
      groupMeta: CategoryGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final CategoryGeneral? general;

  final CategoryDescription? description;

  final CategoryImagesMedia? imagesMedia;

  final CategoryAvailabilityVisibility? availabilityVisibility;

  final CategoryTaxShipping? taxShipping;

  final CategoryAssignProducts? assignProducts;

  /// `id` — what a `{category_id}` slot takes; `null` on a section's answer.
  final int? id;

  /// `transaction_no` — the number the category was filed under, `null` when
  /// none.
  final String? transactionNo;

  final bool? disposable;

  /// `in_trash` — `true` once deleted; a trashed row still reads `200`.
  final bool? inTrash;

  /// `parent_in_trash` — stays `false` when the parent is trashed.
  final bool? parentInTrash;

  final String? createdBy;

  final String? createdOn;

  /// `last_updated_by` — `""` on every row read.
  final String? lastUpdatedBy;

  final String? lastUpdatedOn;

  /// `group_meta` — beside the envelope on a row read and a whole-row write.
  final CategoryGroupMeta? groupMeta;

  /// `field_metadata` — untyped, a schema nested by section.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'category';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'general': general,
        'description': description,
        'images_media': imagesMedia,
        'availability_visibility': availabilityVisibility,
        'tax_shipping': taxShipping,
        'assign_products': assignProducts,
        'id': id,
        'transaction_no': transactionNo,
        'disposable': disposable,
        'in_trash': inTrash,
        'parent_in_trash': parentInTrash,
        'created_by': createdBy,
        'created_on': createdOn,
        'last_updated_by': lastUpdatedBy,
        'last_updated_on': lastUpdatedOn,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The listing's ten-key `pagination` block.
class CategoryPagination extends Dto {
  const CategoryPagination({
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
  static CategoryPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryPagination(
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

  /// `count` — the rows on this page.
  final int? count;

  /// `current_page` — `offset ~/ limit + 1`, and `1` past the last row.
  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  /// `has_previous` — `offset > 0`, but `false` past the last row.
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

/// One page of the listing, with the `field_metadata` block when it was asked
/// for.
class CategoryListPage extends Dto {
  const CategoryListPage({
    this.categories,
    this.groupMeta,
    this.pagination,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static CategoryListPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CategoryListPage(
      categories: readList<Category>(source['categories'], Category.fromMap),
      groupMeta: CategoryGroupMeta.fromMap(source['group_meta']),
      pagination: CategoryPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `categories` — every level of the tree in one list, trashed rows left
  /// out.
  final List<Category?>? categories;

  final CategoryGroupMeta? groupMeta;

  final CategoryPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'categories': categories,
        'group_meta': groupMeta,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's `{"categories": {"count": N}}`.
class CategoryCount extends Dto {
  const CategoryCount({this.count});

  /// Reads the count body.
  static CategoryCount? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'categories');
    if (source == null) return null;
    return CategoryCount(count: readInteger(source['count']));
  }

  /// `count` — the listing's `pagination.total`, trashed rows not counted.
  final int? count;

  @override
  String? get envelopeKey => 'categories';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
      };
}

/// The writable `general` fields. `name` is required on a create and kept by a
/// `PUT` that omits it; a reference takes `CategoryReference(id: ...)`.
class CategoryGeneralInput extends Dto {
  const CategoryGeneralInput({
    this.name,
    this.title,
    this.sku,
    this.url,
    this.heading,
    this.parentCategory,
    this.layout,
    this.summary,
  });

  /// `name` — 2 to 255 characters.
  final String? name;

  /// `title` — at most 200 characters.
  final String? title;

  final String? sku;

  final String? url;

  final String? heading;

  final CategoryReference? parentCategory;

  final CategoryReference? layout;

  final String? summary;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'title': title,
        'sku': sku,
        'url': url,
        'heading': heading,
        'parent_category': parentCategory,
        'layout': layout,
        'summary': summary,
      };
}

/// One image upload: a file name and its bytes as base64.
class CategoryImage extends Dto {
  const CategoryImage({this.filename, this.base64});

  final String? filename;

  final String? base64;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'filename': filename,
        'base64': base64,
      };
}

/// The writable `images_media` fields; each image reads back as its `*_url`,
/// and neither a `null` nor an empty string removes a stored image.
class CategoryImagesMediaInput extends Dto {
  const CategoryImagesMediaInput(
      {this.image, this.imageAlt, this.backgroundImage});

  final CategoryImage? image;

  final String? imageAlt;

  final CategoryImage? backgroundImage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'image': image,
        'image_alt': imageAlt,
        'background_image': backgroundImage,
      };
}

/// The ids `available_for: "selected"` admits; an id no customer or group
/// holds is dropped without a refusal.
class CategorySelectedCustomersInput extends Dto {
  const CategorySelectedCustomersInput({this.customers, this.groups});

  final List<int?>? customers;

  final List<int?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
        'groups': groups,
      };
}

/// The writable `availability_visibility` fields: the read fields, plus the
/// write-only `password`, with `selected_customers` taking ids.
class CategoryAvailabilityVisibilityInput extends Dto {
  const CategoryAvailabilityVisibilityInput({
    this.available,
    this.visible,
    this.availableFor,
    this.selectedCustomers,
    this.availableOnDateRange,
    this.availableFromDate,
    this.availableToDate,
    this.passwordProtected,
    this.password,
    this.customSorting,
    this.defaultSorting,
    this.disableTracking,
  });

  final bool? available;

  final bool? visible;

  final String? availableFor;

  final CategorySelectedCustomersInput? selectedCustomers;

  final bool? availableOnDateRange;

  /// `available_from_date` — read back as sent; a bare date at midnight UTC.
  final String? availableFromDate;

  final String? availableToDate;

  final bool? passwordProtected;

  /// `password` — write-only; a read carries `password_protected` alone.
  final String? password;

  final bool? customSorting;

  /// `default_sorting` — one of the six sort names; `null` is `400`.
  final String? defaultSorting;

  final bool? disableTracking;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'available': available,
        'visible': visible,
        'available_for': availableFor,
        'selected_customers': selectedCustomers,
        'available_on_date_range': availableOnDateRange,
        'available_from_date': availableFromDate,
        'available_to_date': availableToDate,
        'password_protected': passwordProtected,
        'password': password,
        'custom_sorting': customSorting,
        'default_sorting': defaultSorting,
        'disable_tracking': disableTracking,
      };
}

/// The product ids to assign; a write replaces the whole assignment.
class CategoryAssignProductsInput extends Dto {
  const CategoryAssignProductsInput({this.products});

  final List<int?>? products;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'products': products,
      };
}

/// The body every write takes, `{"category": {<section>: {...}}}`; a section
/// `PATCH` reads only its own section out of it.
class CategoryInput extends Dto {
  const CategoryInput({
    this.general,
    this.description,
    this.imagesMedia,
    this.availabilityVisibility,
    this.taxShipping,
    this.assignProducts,
    this.transactionNo,
  });

  final CategoryGeneralInput? general;

  final CategoryDescription? description;

  final CategoryImagesMediaInput? imagesMedia;

  final CategoryAvailabilityVisibilityInput? availabilityVisibility;

  final CategoryTaxShipping? taxShipping;

  final CategoryAssignProductsInput? assignProducts;

  /// `transaction_no` — read inside the `category` wrapper only; beside it, it
  /// is ignored and nothing is filed.
  final String? transactionNo;

  @override
  String? get envelopeKey => 'category';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'general': general,
        'description': description,
        'images_media': imagesMedia,
        'availability_visibility': availabilityVisibility,
        'tax_shipping': taxShipping,
        'assign_products': assignProducts,
        'transaction_no': transactionNo,
      };
}
