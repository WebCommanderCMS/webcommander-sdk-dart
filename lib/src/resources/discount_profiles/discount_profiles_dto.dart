/// Typed views over the discount profile bodies.
library;

import '../../client/dto.dart';

/// The block an `amount` profile carries.
class AmountDetails extends Dto {
  const AmountDetails({
    this.type,
    this.applyTo,
    this.singleAmount,
    this.singleAmountType,
    this.minimumAmountOn,
    this.tiers,
  });

  /// Reads the block inside a row.
  static AmountDetails? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AmountDetails(
      type: readText(source['type']),
      applyTo: readText(source['apply_to']),
      singleAmount: readDecimal(source['single_amount']),
      singleAmountType: readText(source['single_amount_type']),
      minimumAmountOn: readText(source['minimum_amount_on']),
      tiers: readList<int>(source['tiers'], readInteger),
    );
  }

  /// `type` — `single` or `tiered`.
  final String? type;

  final String? applyTo;

  /// `single_amount` — read back as a decimal, `10` sent reading `10.0`.
  final double? singleAmount;

  final String? singleAmountType;

  /// `minimum_amount_on` — `each_item` when a write omits it.
  final String? minimumAmountOn;

  /// `tiers` — tier ids; a row made through the API reads `[]`.
  final List<int?>? tiers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'apply_to': applyTo,
        'single_amount': singleAmount,
        'single_amount_type': singleAmountType,
        'minimum_amount_on': minimumAmountOn,
        'tiers': tiers,
      };
}

/// The block a `shipping` profile carries.
class ShippingDetails extends Dto {
  const ShippingDetails({
    this.type,
    this.applyTo,
    this.minimumQtyOn,
    this.amountType,
    this.singleAmountType,
    this.minimumQty,
    this.minimumAmount,
    this.singleAmount,
    this.capAmount,
    this.maximumTime,
    this.zone,
    this.shippingClass,
    this.tiers,
  });

  /// Reads the block inside a row.
  static ShippingDetails? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingDetails(
      type: readText(source['type']),
      applyTo: readText(source['apply_to']),
      minimumQtyOn: readText(source['minimum_qty_on']),
      amountType: readText(source['amount_type']),
      singleAmountType: readText(source['single_amount_type']),
      minimumQty: readInteger(source['minimum_qty']),
      minimumAmount: readDecimal(source['minimum_amount']),
      singleAmount: readAny(source['single_amount']),
      capAmount: readAny(source['cap_amount']),
      maximumTime: readAny(source['maximum_time']),
      zone: readAny(source['zone']),
      shippingClass: readAny(source['shipping_class']),
      tiers: readList<Object>(source['tiers'], readAny),
    );
  }

  final String? type;

  final String? applyTo;

  final String? minimumQtyOn;

  /// `amount_type` — `FLAT` sent reads `single`.
  final String? amountType;

  final String? singleAmountType;

  /// `minimum_qty` — kept as sent, `2` reading `2`.
  final int? minimumQty;

  /// `minimum_amount` — kept as sent, `50` reading `50.0`.
  final double? minimumAmount;

  final Object? singleAmount;

  final Object? capAmount;

  final Object? maximumTime;

  final Object? zone;

  final Object? shippingClass;

  final List<Object?>? tiers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'apply_to': applyTo,
        'minimum_qty_on': minimumQtyOn,
        'amount_type': amountType,
        'single_amount_type': singleAmountType,
        'minimum_qty': minimumQty,
        'minimum_amount': minimumAmount,
        'single_amount': singleAmount,
        'cap_amount': capAmount,
        'maximum_time': maximumTime,
        'zone': zone,
        'shipping_class': shippingClass,
        'tiers': tiers,
      };
}

/// The block a `product` profile carries.
class DiscountProfileProductDetails extends Dto {
  const DiscountProfileProductDetails({
    this.type,
    this.freeProductMinQtyOn,
    this.freeProductMaxQty,
    this.freeProductMinAmount,
    this.minimumQtyOn,
    this.amountType,
    this.singleAmountType,
    this.singleAmount,
    this.capPrice,
    this.capPriceMaxQty,
    this.productIds,
    this.categoryIds,
    this.tiers,
  });

  /// Reads the block inside a row.
  static DiscountProfileProductDetails? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfileProductDetails(
      type: readText(source['type']),
      freeProductMinQtyOn: readText(source['free_product_min_qty_on']),
      freeProductMaxQty: readInteger(source['free_product_max_qty']),
      freeProductMinAmount: readDecimal(source['free_product_min_amount']),
      minimumQtyOn: readText(source['minimum_qty_on']),
      amountType: readText(source['amount_type']),
      singleAmountType: readText(source['single_amount_type']),
      singleAmount: readAny(source['single_amount']),
      capPrice: readAny(source['cap_price']),
      capPriceMaxQty: readAny(source['cap_price_max_qty']),
      productIds: readList<Object>(source['product_ids'], readAny),
      categoryIds: readList<Object>(source['category_ids'], readAny),
      tiers: readList<Object>(source['tiers'], readAny),
    );
  }

  final String? type;

  final String? freeProductMinQtyOn;

  final int? freeProductMaxQty;

  /// `free_product_min_amount` — kept as sent, `25` reading `25.0`.
  final double? freeProductMinAmount;

  final String? minimumQtyOn;

  /// `amount_type` — `FLAT` sent reads `single`.
  final String? amountType;

  final String? singleAmountType;

  final Object? singleAmount;

  final Object? capPrice;

  final Object? capPriceMaxQty;

  /// `product_ids` — `[]` on every read, whatever ids were sent.
  final List<Object?>? productIds;

  final List<Object?>? categoryIds;

  final List<Object?>? tiers;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'free_product_min_qty_on': freeProductMinQtyOn,
        'free_product_max_qty': freeProductMaxQty,
        'free_product_min_amount': freeProductMinAmount,
        'minimum_qty_on': minimumQtyOn,
        'amount_type': amountType,
        'single_amount_type': singleAmountType,
        'single_amount': singleAmount,
        'cap_price': capPrice,
        'cap_price_max_qty': capPriceMaxQty,
        'product_ids': productIds,
        'category_ids': categoryIds,
        'tiers': tiers,
      };
}

/// One generated coupon on a profile.
class CustomerCoupon extends Dto {
  const CustomerCoupon({this.id, this.code, this.customerEmail});

  /// Reads one entry of `customer_coupons`.
  static CustomerCoupon? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerCoupon(
      id: readInteger(source['id']),
      code: readText(source['code']),
      customerEmail: readText(source['customer_email']),
    );
  }

  final int? id;

  final String? code;

  /// `customer_email` — `""` until a customer is assigned the code.
  final String? customerEmail;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'customer_email': customerEmail,
      };
}

/// One discount profile: a listing row, a row path's body and every write's
/// answer. It carries the one details block its `discount_details_type` names.
class DiscountProfile extends Dto {
  const DiscountProfile({
    this.id,
    this.uuid,
    this.name,
    this.type,
    this.discountDetailsType,
    this.amountDetails,
    this.shippingDetails,
    this.productDetails,
    this.isActive,
    this.startDate,
    this.isSpecifyEndDate,
    this.endDate,
    this.isApplyCouponCode,
    this.defaultCouponCode,
    this.isCouponCodeAutoGenerate,
    this.isCreateUniqueCouponEachCustomer,
    this.isImportedCoupon,
    this.isMaximumUseTotal,
    this.maximumUseCount,
    this.isMaximumUseCustomer,
    this.maximumUseCustomerCount,
    this.isMaximumDiscountAllowed,
    this.maximumDiscountAllowedAmount,
    this.isExcludeProductsOnSale,
    this.isDiscountUsedWithOtherDiscount,
    this.isDisplayDiscountInformationProdDetail,
    this.isDisplayTextCoupon,
    this.displayTextCoupon,
    this.isDisplayTextCart,
    this.displayTextCart,
    this.isDisplayTextPartialDiscountCondition,
    this.displayTextPartialDiscountCondition,
    this.invoiceNote,
    this.excludeProducts,
    this.customerCoupons,
    this.usage,
    this.createdOn,
    this.lastUpdatedOn,
    this.fieldMetadata,
  });

  /// Reads a `discount_profile` envelope, with the `field_metadata` beside it,
  /// or a bare listing row.
  static DiscountProfile? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'discount_profile');
    if (source == null) return null;
    return DiscountProfile(
      id: readInteger(source['id']),
      uuid: readText(source['uuid']),
      name: readText(source['name']),
      type: readText(source['type']),
      discountDetailsType: readText(source['discount_details_type']),
      amountDetails: AmountDetails.fromMap(source['amount_details']),
      shippingDetails: ShippingDetails.fromMap(source['shipping_details']),
      productDetails:
          DiscountProfileProductDetails.fromMap(source['product_details']),
      isActive: readFlag(source['is_active']),
      startDate: readText(source['start_date']),
      isSpecifyEndDate: readFlag(source['is_specify_end_date']),
      endDate: readText(source['end_date']),
      isApplyCouponCode: readFlag(source['is_apply_coupon_code']),
      defaultCouponCode: readText(source['default_coupon_code']),
      isCouponCodeAutoGenerate:
          readFlag(source['is_coupon_code_auto_generate']),
      isCreateUniqueCouponEachCustomer:
          readFlag(source['is_create_unique_coupon_each_customer']),
      isImportedCoupon: readFlag(source['is_imported_coupon']),
      isMaximumUseTotal: readFlag(source['is_maximum_use_total']),
      maximumUseCount: readInteger(source['maximum_use_count']),
      isMaximumUseCustomer: readFlag(source['is_maximum_use_customer']),
      maximumUseCustomerCount:
          readInteger(source['maximum_use_customer_count']),
      isMaximumDiscountAllowed: readFlag(source['is_maximum_discount_allowed']),
      maximumDiscountAllowedAmount:
          readDecimal(source['maximum_discount_allowed_amount']),
      isExcludeProductsOnSale: readFlag(source['is_exclude_products_on_sale']),
      isDiscountUsedWithOtherDiscount:
          readFlag(source['is_discount_used_with_other_discount']),
      isDisplayDiscountInformationProdDetail:
          readFlag(source['is_display_discount_information_prod_detail']),
      isDisplayTextCoupon: readFlag(source['is_display_text_coupon']),
      displayTextCoupon: readText(source['display_text_coupon']),
      isDisplayTextCart: readFlag(source['is_display_text_cart']),
      displayTextCart: readText(source['display_text_cart']),
      isDisplayTextPartialDiscountCondition:
          readFlag(source['is_display_text_partial_discount_condition']),
      displayTextPartialDiscountCondition:
          readText(source['display_text_partial_discount_condition']),
      invoiceNote: readText(source['invoice_note']),
      excludeProducts: readList<int>(source['exclude_products'], readInteger),
      customerCoupons: readList<CustomerCoupon>(
          source['customer_coupons'], CustomerCoupon.fromMap),
      usage: readList<int>(source['usage'], readInteger),
      createdOn: readText(source['created_on']),
      lastUpdatedOn: readText(source['last_updated_on']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `id` — what a `{discount_profile_id}` slot takes.
  final int? id;

  final String? uuid;

  /// `name` — unique ignoring case, at most 255 characters.
  final String? name;

  /// `type` — one of the four types, or `""` when a create omits it.
  final String? type;

  /// `discount_details_type` — `amount`, `shipping` or `product`, naming the
  /// one block the row carries.
  final String? discountDetailsType;

  final AmountDetails? amountDetails;

  final ShippingDetails? shippingDetails;

  final DiscountProfileProductDetails? productDetails;

  final bool? isActive;

  /// `start_date` — sent `yyyy-MM-dd HH:mm:ss`, read `yyyy-MM-ddTHH:mm:ss` in
  /// UTC with no zone; `null` when unset.
  final String? startDate;

  final bool? isSpecifyEndDate;

  /// `end_date` — read as `start_date` is, but `""` when unset.
  final String? endDate;

  final bool? isApplyCouponCode;

  final String? defaultCouponCode;

  final bool? isCouponCodeAutoGenerate;

  final bool? isCreateUniqueCouponEachCustomer;

  final bool? isImportedCoupon;

  final bool? isMaximumUseTotal;

  final int? maximumUseCount;

  final bool? isMaximumUseCustomer;

  final int? maximumUseCustomerCount;

  final bool? isMaximumDiscountAllowed;

  final double? maximumDiscountAllowedAmount;

  final bool? isExcludeProductsOnSale;

  final bool? isDiscountUsedWithOtherDiscount;

  final bool? isDisplayDiscountInformationProdDetail;

  final bool? isDisplayTextCoupon;

  final String? displayTextCoupon;

  final bool? isDisplayTextCart;

  final String? displayTextCart;

  final bool? isDisplayTextPartialDiscountCondition;

  final String? displayTextPartialDiscountCondition;

  final String? invoiceNote;

  /// `exclude_products` — product ids.
  final List<int?>? excludeProducts;

  /// `customer_coupons` — the generated codes, in the order generated.
  final List<CustomerCoupon?>? customerCoupons;

  final List<int?>? usage;

  final String? createdOn;

  final String? lastUpdatedOn;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'discount_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'uuid': uuid,
        'name': name,
        'type': type,
        'discount_details_type': discountDetailsType,
        'amount_details': amountDetails,
        'shipping_details': shippingDetails,
        'product_details': productDetails,
        'is_active': isActive,
        'start_date': startDate,
        'is_specify_end_date': isSpecifyEndDate,
        'end_date': endDate,
        'is_apply_coupon_code': isApplyCouponCode,
        'default_coupon_code': defaultCouponCode,
        'is_coupon_code_auto_generate': isCouponCodeAutoGenerate,
        'is_create_unique_coupon_each_customer':
            isCreateUniqueCouponEachCustomer,
        'is_imported_coupon': isImportedCoupon,
        'is_maximum_use_total': isMaximumUseTotal,
        'maximum_use_count': maximumUseCount,
        'is_maximum_use_customer': isMaximumUseCustomer,
        'maximum_use_customer_count': maximumUseCustomerCount,
        'is_maximum_discount_allowed': isMaximumDiscountAllowed,
        'maximum_discount_allowed_amount': maximumDiscountAllowedAmount,
        'is_exclude_products_on_sale': isExcludeProductsOnSale,
        'is_discount_used_with_other_discount': isDiscountUsedWithOtherDiscount,
        'is_display_discount_information_prod_detail':
            isDisplayDiscountInformationProdDetail,
        'is_display_text_coupon': isDisplayTextCoupon,
        'display_text_coupon': displayTextCoupon,
        'is_display_text_cart': isDisplayTextCart,
        'display_text_cart': displayTextCart,
        'is_display_text_partial_discount_condition':
            isDisplayTextPartialDiscountCondition,
        'display_text_partial_discount_condition':
            displayTextPartialDiscountCondition,
        'invoice_note': invoiceNote,
        'exclude_products': excludeProducts,
        'customer_coupons': customerCoupons,
        'usage': usage,
        'created_on': createdOn,
        'last_updated_on': lastUpdatedOn,
        'field_metadata': fieldMetadata,
      };
}

/// A discount profile as the store accepts it — the writable form of
/// [DiscountProfile], for the create and the update; no envelope. The update
/// resets every `is_*` flag, date and limit it omits.
class DiscountProfileInput extends Dto {
  const DiscountProfileInput({
    this.name,
    this.type,
    this.discountDetailsType,
    this.amountDetails,
    this.shippingDetails,
    this.productDetails,
    this.isActive,
    this.startDate,
    this.isSpecifyEndDate,
    this.endDate,
    this.isApplyCouponCode,
    this.defaultCouponCode,
    this.isCouponCodeAutoGenerate,
    this.isCreateUniqueCouponEachCustomer,
    this.isImportedCoupon,
    this.isMaximumUseTotal,
    this.maximumUseCount,
    this.isMaximumUseCustomer,
    this.maximumUseCustomerCount,
    this.isMaximumDiscountAllowed,
    this.maximumDiscountAllowedAmount,
    this.isExcludeProductsOnSale,
    this.isDiscountUsedWithOtherDiscount,
    this.isDisplayDiscountInformationProdDetail,
    this.isDisplayTextCoupon,
    this.displayTextCoupon,
    this.isDisplayTextCart,
    this.displayTextCart,
    this.isDisplayTextPartialDiscountCondition,
    this.displayTextPartialDiscountCondition,
    this.invoiceNote,
    this.excludeProducts,
  });

  /// `name` — required on a create; an update that omits it keeps it.
  final String? name;

  final String? type;

  /// `discount_details_type` — required on a create, beside the block it
  /// names.
  final String? discountDetailsType;

  final AmountDetails? amountDetails;

  final ShippingDetails? shippingDetails;

  final DiscountProfileProductDetails? productDetails;

  final bool? isActive;

  /// `start_date` — `yyyy-MM-dd HH:mm:ss`.
  final String? startDate;

  final bool? isSpecifyEndDate;

  /// `end_date` — dropped by a create that does not send `is_specify_end_date`
  /// `true`.
  final String? endDate;

  final bool? isApplyCouponCode;

  /// `default_coupon_code` — generated by the store when `is_apply_coupon_code`
  /// is sent without one.
  final String? defaultCouponCode;

  final bool? isCouponCodeAutoGenerate;

  final bool? isCreateUniqueCouponEachCustomer;

  final bool? isImportedCoupon;

  final bool? isMaximumUseTotal;

  final int? maximumUseCount;

  final bool? isMaximumUseCustomer;

  final int? maximumUseCustomerCount;

  final bool? isMaximumDiscountAllowed;

  final double? maximumDiscountAllowedAmount;

  final bool? isExcludeProductsOnSale;

  final bool? isDiscountUsedWithOtherDiscount;

  final bool? isDisplayDiscountInformationProdDetail;

  final bool? isDisplayTextCoupon;

  final String? displayTextCoupon;

  final bool? isDisplayTextCart;

  final String? displayTextCart;

  final bool? isDisplayTextPartialDiscountCondition;

  final String? displayTextPartialDiscountCondition;

  final String? invoiceNote;

  final List<int>? excludeProducts;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'type': type,
        'discount_details_type': discountDetailsType,
        'amount_details': amountDetails,
        'shipping_details': shippingDetails,
        'product_details': productDetails,
        'is_active': isActive,
        'start_date': startDate,
        'is_specify_end_date': isSpecifyEndDate,
        'end_date': endDate,
        'is_apply_coupon_code': isApplyCouponCode,
        'default_coupon_code': defaultCouponCode,
        'is_coupon_code_auto_generate': isCouponCodeAutoGenerate,
        'is_create_unique_coupon_each_customer':
            isCreateUniqueCouponEachCustomer,
        'is_imported_coupon': isImportedCoupon,
        'is_maximum_use_total': isMaximumUseTotal,
        'maximum_use_count': maximumUseCount,
        'is_maximum_use_customer': isMaximumUseCustomer,
        'maximum_use_customer_count': maximumUseCustomerCount,
        'is_maximum_discount_allowed': isMaximumDiscountAllowed,
        'maximum_discount_allowed_amount': maximumDiscountAllowedAmount,
        'is_exclude_products_on_sale': isExcludeProductsOnSale,
        'is_discount_used_with_other_discount': isDiscountUsedWithOtherDiscount,
        'is_display_discount_information_prod_detail':
            isDisplayDiscountInformationProdDetail,
        'is_display_text_coupon': isDisplayTextCoupon,
        'display_text_coupon': displayTextCoupon,
        'is_display_text_cart': isDisplayTextCart,
        'display_text_cart': displayTextCart,
        'is_display_text_partial_discount_condition':
            isDisplayTextPartialDiscountCondition,
        'display_text_partial_discount_condition':
            displayTextPartialDiscountCondition,
        'invoice_note': invoiceNote,
        'exclude_products': excludeProducts,
      };
}

/// The listing's ten-key `pagination` block.
class DiscountProfilePagination extends Dto {
  const DiscountProfilePagination({
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
  static DiscountProfilePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfilePagination(
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

  /// `current_page` — `offset ~/ limit + 1`, clamped to `total_pages` on an
  /// empty page past the end.
  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  /// `has_previous` — `false` on an empty page past the end, whatever `offset`.
  final bool? hasPrevious;

  /// `previous_page` — an absolute URL carrying the filters sent.
  final String? previousPage;

  /// `next_page` — an absolute URL carrying the filters sent.
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

/// The listing's one `group_meta` entry: `kind` `resource`, `writable` `true`.
class DiscountProfileResourceMeta extends Dto {
  const DiscountProfileResourceMeta({this.kind, this.writable, this.href});

  /// Reads the entry under the collection's own name.
  static DiscountProfileResourceMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfileResourceMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  final String? kind;

  final bool? writable;

  /// `href` — the listing's own path.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The listing's `group_meta` block, keyed by the collection's own name.
class DiscountProfileGroupMeta extends Dto {
  const DiscountProfileGroupMeta({this.discountProfiles});

  /// Reads the block beside the rows.
  static DiscountProfileGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfileGroupMeta(
      discountProfiles:
          DiscountProfileResourceMeta.fromMap(source['discount_profiles']),
    );
  }

  final DiscountProfileResourceMeta? discountProfiles;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'discount_profiles': discountProfiles,
      };
}

/// One page of the listing: the rows, where they sit, `group_meta` and any
/// schema.
class DiscountProfilePage extends Dto {
  const DiscountProfilePage({
    this.discountProfiles,
    this.pagination,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads a listing body.
  static DiscountProfilePage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfilePage(
      discountProfiles: readList<DiscountProfile>(
          source['discount_profiles'], DiscountProfile.fromMap),
      pagination: DiscountProfilePagination.fromMap(source['pagination']),
      groupMeta: DiscountProfileGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `discount_profiles` — the rows, newest `id` first unless sorted.
  final List<DiscountProfile?>? discountProfiles;

  final DiscountProfilePagination? pagination;

  final DiscountProfileGroupMeta? groupMeta;

  /// `field_metadata` — untyped, its entries differing in width.
  final Object? fieldMetadata;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'discount_profiles': discountProfiles,
        'pagination': pagination,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// The create-coupons answer: the codes generated, beside `status` and
/// `message`.
class DiscountProfileCoupons extends Dto {
  const DiscountProfileCoupons({this.status, this.message, this.codes});

  /// Reads a create-coupons body.
  static DiscountProfileCoupons? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DiscountProfileCoupons(
      status: readText(source['status']),
      message: readText(source['message']),
      codes: readList<String>(source['codes'], readText),
    );
  }

  final String? status;

  final String? message;

  /// `codes` — distinct, and appended to the profile's `customer_coupons` in
  /// this order.
  final List<String?>? codes;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'status': status,
        'message': message,
        'codes': codes,
      };
}

/// The create-coupons body; no envelope.
class DiscountProfileCouponsInput extends Dto {
  const DiscountProfileCouponsInput({this.requestedCodes});

  /// `requested_codes` — required and at least 1.
  final int? requestedCodes;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'requested_codes': requestedCodes,
      };
}

/// The assign-customer body: a generated `code` and the `email` of an existing
/// customer; no envelope.
class DiscountCouponCustomerInput extends Dto {
  const DiscountCouponCustomerInput({this.code, this.email});

  final String? code;

  /// `email` — matched against the store's customers ignoring case.
  final String? email;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'code': code,
        'email': email,
      };
}
