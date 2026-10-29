/// Typed views over the customer group bodies.
library;

import '../../client/dto.dart';

/// The shipping profile a group names; a write sends the bare `id`, not this
/// record.
class CustomerGroupShippingProfile extends Dto {
  const CustomerGroupShippingProfile({this.id, this.name});

  /// Reads a row's `shipping_profile`.
  static CustomerGroupShippingProfile? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupShippingProfile(
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

/// The stored image; a write sends a base64 or `data:` URI string, and `null`
/// removes it.
class CustomerGroupBackgroundImage extends Dto {
  const CustomerGroupBackgroundImage({this.url, this.width, this.height});

  /// Reads a row's `background_image`.
  static CustomerGroupBackgroundImage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupBackgroundImage(
      url: readText(source['url']),
      width: readInteger(source['width']),
      height: readInteger(source['height']),
    );
  }

  final String? url;

  final int? width;

  final int? height;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'url': url,
        'width': width,
        'height': height,
      };
}

/// An `enabled` switch and its `amount`: `minimum_purchase`, `max_purchase` and
/// `credit_limit` all take this shape.
class CustomerGroupAmountSetting extends Dto {
  const CustomerGroupAmountSetting({this.enabled, this.amount});

  /// Reads one amount setting.
  static CustomerGroupAmountSetting? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupAmountSetting(
      enabled: readFlag(source['enabled']),
      amount: readDecimal(source['amount']),
    );
  }

  final bool? enabled;

  /// `amount` — sent by the store as an integer, so `50` reads `50.0` here.
  final double? amount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'amount': amount,
      };
}

/// `terms` is written `NET_30`, `NET_60` or `NET_90` and reads back in lower
/// case.
class CustomerGroupPaymentTerms extends Dto {
  const CustomerGroupPaymentTerms({this.enabled, this.terms});

  /// Reads the `payment_terms` block.
  static CustomerGroupPaymentTerms? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupPaymentTerms(
      enabled: readFlag(source['enabled']),
      terms: readText(source['terms']),
    );
  }

  final bool? enabled;

  final String? terms;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'terms': terms,
      };
}

/// The `on_account_purchase` block.
class CustomerGroupOnAccountPurchase extends Dto {
  const CustomerGroupOnAccountPurchase({
    this.enabled,
    this.maxPurchase,
    this.creditLimit,
    this.paymentTerms,
  });

  /// Reads the block.
  static CustomerGroupOnAccountPurchase? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupOnAccountPurchase(
      enabled: readFlag(source['enabled']),
      maxPurchase: CustomerGroupAmountSetting.fromMap(source['max_purchase']),
      creditLimit: CustomerGroupAmountSetting.fromMap(source['credit_limit']),
      paymentTerms: CustomerGroupPaymentTerms.fromMap(source['payment_terms']),
    );
  }

  final bool? enabled;

  final CustomerGroupAmountSetting? maxPurchase;

  final CustomerGroupAmountSetting? creditLimit;

  final CustomerGroupPaymentTerms? paymentTerms;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'max_purchase': maxPurchase,
        'credit_limit': creditLimit,
        'payment_terms': paymentTerms,
      };
}

/// The `purchase_preference` block.
class CustomerGroupPurchasePreference extends Dto {
  const CustomerGroupPurchasePreference({
    this.minimumPurchase,
    this.onAccountPurchase,
  });

  /// Reads the block.
  static CustomerGroupPurchasePreference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupPurchasePreference(
      minimumPurchase:
          CustomerGroupAmountSetting.fromMap(source['minimum_purchase']),
      onAccountPurchase:
          CustomerGroupOnAccountPurchase.fromMap(source['on_account_purchase']),
    );
  }

  final CustomerGroupAmountSetting? minimumPurchase;

  final CustomerGroupOnAccountPurchase? onAccountPurchase;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'minimum_purchase': minimumPurchase,
        'on_account_purchase': onAccountPurchase,
      };
}

/// The `tax_configuration` block; `base_price_rounding` is `nearest`, `up` or
/// `down`.
class CustomerGroupTaxConfiguration extends Dto {
  const CustomerGroupTaxConfiguration({
    this.overrideStoreTax,
    this.taxExempt,
    this.taxMessage,
    this.showPricesWithTaxIncluded,
    this.pricesEnteredWithTaxIncluded,
    this.basePriceRounding,
  });

  /// Reads the block.
  static CustomerGroupTaxConfiguration? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupTaxConfiguration(
      overrideStoreTax: readFlag(source['override_store_tax']),
      taxExempt: readFlag(source['tax_exempt']),
      taxMessage: readText(source['tax_message']),
      showPricesWithTaxIncluded:
          readFlag(source['show_prices_with_tax_included']),
      pricesEnteredWithTaxIncluded:
          readFlag(source['prices_entered_with_tax_included']),
      basePriceRounding: readText(source['base_price_rounding']),
    );
  }

  final bool? overrideStoreTax;

  final bool? taxExempt;

  final String? taxMessage;

  final bool? showPricesWithTaxIncluded;

  final bool? pricesEnteredWithTaxIncluded;

  final String? basePriceRounding;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'override_store_tax': overrideStoreTax,
        'tax_exempt': taxExempt,
        'tax_message': taxMessage,
        'show_prices_with_tax_included': showPricesWithTaxIncluded,
        'prices_entered_with_tax_included': pricesEnteredWithTaxIncluded,
        'base_price_rounding': basePriceRounding,
      };
}

/// The `product_display` block; `price_display_method` is `lowest` or
/// `highest`.
class CustomerGroupProductDisplay extends Dto {
  const CustomerGroupProductDisplay({
    this.overwriteDefault,
    this.variationDisplayType,
    this.displayParentImage,
    this.activateColourVariationImage,
    this.showSelectedVariationValue,
    this.strikeThroughOutOfStock,
    this.singleClickVariationLoading,
    this.priceDisplayMethod,
  });

  /// Reads the block.
  static CustomerGroupProductDisplay? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupProductDisplay(
      overwriteDefault: readFlag(source['overwrite_default']),
      variationDisplayType: readText(source['variation_display_type']),
      displayParentImage: readFlag(source['display_parent_image']),
      activateColourVariationImage:
          readFlag(source['activate_colour_variation_image']),
      showSelectedVariationValue:
          readFlag(source['show_selected_variation_value']),
      strikeThroughOutOfStock: readFlag(source['strike_through_out_of_stock']),
      singleClickVariationLoading:
          readFlag(source['single_click_variation_loading']),
      priceDisplayMethod: readText(source['price_display_method']),
    );
  }

  final bool? overwriteDefault;

  final String? variationDisplayType;

  final bool? displayParentImage;

  final bool? activateColourVariationImage;

  final bool? showSelectedVariationValue;

  final bool? strikeThroughOutOfStock;

  final bool? singleClickVariationLoading;

  final String? priceDisplayMethod;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'overwrite_default': overwriteDefault,
        'variation_display_type': variationDisplayType,
        'display_parent_image': displayParentImage,
        'activate_colour_variation_image': activateColourVariationImage,
        'show_selected_variation_value': showSelectedVariationValue,
        'strike_through_out_of_stock': strikeThroughOutOfStock,
        'single_click_variation_loading': singleClickVariationLoading,
        'price_display_method': priceDisplayMethod,
      };
}

/// One member, by its `customer_id`: an entry of `customers` and the member
/// read's `customer`.
class CustomerGroupMember extends Dto {
  const CustomerGroupMember({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  /// Reads the member read's `customer` envelope, or a bare entry of
  /// `customers`.
  static CustomerGroupMember? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer');
    if (source == null) return null;
    return CustomerGroupMember(
      id: readInteger(source['id']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
    );
  }

  /// `id` — the customer's `customer_id`, never its `internal_id`.
  final int? id;

  final String? firstName;

  final String? lastName;

  final String? email;

  @override
  String? get envelopeKey => 'customer';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      };
}

/// One customer group.
class CustomerGroupRecord extends Dto {
  const CustomerGroupRecord({
    this.id,
    this.name,
    this.description,
    this.status,
    this.defaultTaxCode,
    this.addAsNewCustomerDefaultGroup,
    this.shippingProfile,
    this.backgroundImage,
    this.purchasePreference,
    this.taxConfiguration,
    this.productDisplay,
    this.createdAt,
    this.updatedAt,
    this.customerCount,
    this.customers,
    this.fieldMetadata,
  });

  /// Reads a row path's `customer_group` envelope, or a bare listing row.
  static CustomerGroupRecord? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer_group');
    if (source == null) return null;
    return CustomerGroupRecord(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      status: readText(source['status']),
      defaultTaxCode: readText(source['default_tax_code']),
      addAsNewCustomerDefaultGroup:
          readFlag(source['add_as_new_customer_default_group']),
      shippingProfile:
          CustomerGroupShippingProfile.fromMap(source['shipping_profile']),
      backgroundImage:
          CustomerGroupBackgroundImage.fromMap(source['background_image']),
      purchasePreference: CustomerGroupPurchasePreference.fromMap(
          source['purchase_preference']),
      taxConfiguration:
          CustomerGroupTaxConfiguration.fromMap(source['tax_configuration']),
      productDisplay:
          CustomerGroupProductDisplay.fromMap(source['product_display']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
      customerCount: readInteger(source['customer_count']),
      customers: readList<CustomerGroupMember>(
          source['customers'], CustomerGroupMember.fromMap),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  /// `status` — `A` or `I`, whichever of the four spellings was written.
  final String? status;

  final String? defaultTaxCode;

  final bool? addAsNewCustomerDefaultGroup;

  final CustomerGroupShippingProfile? shippingProfile;

  final CustomerGroupBackgroundImage? backgroundImage;

  final CustomerGroupPurchasePreference? purchasePreference;

  final CustomerGroupTaxConfiguration? taxConfiguration;

  final CustomerGroupProductDisplay? productDisplay;

  final String? createdAt;

  final String? updatedAt;

  final int? customerCount;

  final List<CustomerGroupMember?>? customers;

  /// `field_metadata` — untyped; beside the row when it was asked for.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'customer_group';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'status': status,
        'default_tax_code': defaultTaxCode,
        'add_as_new_customer_default_group': addAsNewCustomerDefaultGroup,
        'shipping_profile': shippingProfile,
        'background_image': backgroundImage,
        'purchase_preference': purchasePreference,
        'tax_configuration': taxConfiguration,
        'product_display': productDisplay,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'customer_count': customerCount,
        'customers': customers,
        'field_metadata': fieldMetadata,
      };
}

/// The listing's five-key `pagination` block.
class CustomerGroupPagination extends Dto {
  const CustomerGroupPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static CustomerGroupPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

  /// `limit` — the page size applied.
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

/// One page of the listing, with the `field_metadata` block when it was asked
/// for.
class CustomerGroupPage extends Dto {
  const CustomerGroupPage({
    this.customerGroups,
    this.pagination,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static CustomerGroupPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupPage(
      customerGroups: readList<CustomerGroupRecord>(
          source['customer_groups'], CustomerGroupRecord.fromMap),
      pagination: CustomerGroupPagination.fromMap(source['pagination']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final List<CustomerGroupRecord?>? customerGroups;

  final CustomerGroupPagination? pagination;

  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_groups': customerGroups,
        'pagination': pagination,
        'field_metadata': fieldMetadata,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class CustomerGroupCount extends Dto {
  const CustomerGroupCount({this.total});

  /// Reads the count body.
  static CustomerGroupCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}

/// The assign answer: `added` is `false` when the customer was already a
/// member.
class CustomerGroupAssignment extends Dto {
  const CustomerGroupAssignment({
    this.status,
    this.customerId,
    this.email,
    this.group,
    this.added,
  });

  /// Reads an assign body.
  static CustomerGroupAssignment? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroupAssignment(
      status: readText(source['status']),
      customerId: readInteger(source['customer_id']),
      email: readText(source['email']),
      group: CustomerGroupRecord.fromMap(source['group']),
      added: readFlag(source['added']),
    );
  }

  final String? status;

  final int? customerId;

  final String? email;

  /// `group` — the thirteen listing fields.
  final CustomerGroupRecord? group;

  final bool? added;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'customer_id': customerId,
        'email': email,
        'group': group,
        'added': added,
      };
}

/// The writable form of [CustomerGroupRecord], for the create and the patch.
/// `status` takes `A`, `I`, `active` or `inactive`; `shippingProfile` is a bare
/// id.
class CustomerGroupInput extends Dto {
  const CustomerGroupInput({
    this.name,
    this.description,
    this.status,
    this.defaultTaxCode,
    this.addAsNewCustomerDefaultGroup,
    this.shippingProfile,
    this.backgroundImage,
    this.purchasePreference,
    this.taxConfiguration,
    this.productDisplay,
  });

  /// `name` — required on the create, trimmed and unique in any letter case.
  final String? name;

  final String? description;

  final String? status;

  final String? defaultTaxCode;

  final bool? addAsNewCustomerDefaultGroup;

  final int? shippingProfile;

  /// `background_image` — a base64 or `data:` URI string.
  final String? backgroundImage;

  final CustomerGroupPurchasePreference? purchasePreference;

  final CustomerGroupTaxConfiguration? taxConfiguration;

  final CustomerGroupProductDisplay? productDisplay;

  @override
  String? get envelopeKey => 'customer_group';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'status': status,
        'default_tax_code': defaultTaxCode,
        'add_as_new_customer_default_group': addAsNewCustomerDefaultGroup,
        'shipping_profile': shippingProfile,
        'background_image': backgroundImage,
        'purchase_preference': purchasePreference,
        'tax_configuration': taxConfiguration,
        'product_display': productDisplay,
      };
}

/// The member write's body: the whole member list, replacing the stored one;
/// `[]` empties it.
class CustomerGroupCustomersInput extends Dto {
  const CustomerGroupCustomersInput({this.customers});

  /// `customers` — `customer_id` values, numbers or strings.
  final List<Object?>? customers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customers': customers,
      };
}

/// The assign body, both ids bare: `customer` is a `customer_id`.
class CustomerGroupAssignInput extends Dto {
  const CustomerGroupAssignInput({this.customer, this.group});

  final Object? customer;

  final Object? group;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer': customer,
        'group': group,
      };
}
