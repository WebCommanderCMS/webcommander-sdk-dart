/// Typed views over the admin customer bodies.
library;

import '../../client/dto.dart';

/// A lookup value the API sends as an object, not a bare id.
class Reference extends Dto {
  const Reference({this.id, this.name, this.code});

  static Reference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Reference(
      id: readInteger(source['id']),
      name: readText(source['name']),
      code: readText(source['code']),
    );
  }

  final int? id;

  final String? name;

  /// `code` — `"AU"` on a country, absent on a customer group.
  final String? code;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'code': code,
      };
}

/// One entry of a customer's [Customer.addresses].
class Address extends Dto {
  const Address({
    this.id,
    this.type,
    this.firstName,
    this.lastName,
    this.email,
    this.companyName,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.city,
    this.postCode,
    this.mobile,
    this.phone,
    this.fax,
  });

  static Address? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Address(
      id: readInteger(source['id']),
      type: readText(source['type']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
      companyName: readText(source['company_name']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      country: Reference.fromMap(source['country']),
      state: Reference.fromMap(source['state']),
      city: readText(source['city']),
      postCode: readText(source['post_code']),
      mobile: readText(source['mobile']),
      phone: readText(source['phone']),
      fax: readText(source['fax']),
    );
  }

  final int? id;

  /// `type` — `"primary"`, `"shipping"` or `"billing"`.
  final String? type;

  final String? firstName;

  final String? lastName;

  final String? email;

  final String? companyName;

  final String? addressLine1;

  final String? addressLine2;

  final Reference? country;

  /// `state` — `{}` when the store holds none, so an all-`null` [Reference].
  final Reference? state;

  final String? city;

  final String? postCode;

  final String? mobile;

  final String? phone;

  final String? fax;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'type': type,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'company_name': companyName,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'country': country,
        'state': state,
        'city': city,
        'post_code': postCode,
        'mobile': mobile,
        'phone': phone,
        'fax': fax,
      };
}

/// One entry of a customer's [Customer.customProperties] — a name/value pair.
class CustomProperty extends Dto {
  const CustomProperty({this.id, this.label, this.description});

  static CustomProperty? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomProperty(
      id: readInteger(source['id']),
      label: readText(source['label']),
      description: readText(source['description']),
    );
  }

  /// `id` — the store's, keyed on the [label]/[description] pair, not the write.
  final int? id;

  final String? label;

  final String? description;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'label': label,
        'description': description,
      };
}

/// One customer, as a listing entry or a detail fetch sends it.
class Customer extends Dto {
  const Customer({
    this.customerId,
    this.internalId,
    this.uuid,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.status,
    this.gender,
    this.companyName,
    this.storeCredit,
    this.customerGroups,
    this.shippingProfile,
    this.addresses,
    this.createdAt,
    this.updatedAt,
    this.abn,
    this.abnBranch,
    this.accountHold,
    this.activeBillingAddress,
    this.activeShippingAddress,
    this.allowCreditLimit,
    this.backgroundImage,
    this.baseUrl,
    this.countReferralCodeUsed,
    this.creditLimit,
    this.customProperties,
    this.customerPasswordExpired,
    this.defaultTaxCode,
    this.emailVerified,
    this.hidePrice,
    this.howDoYouKnow,
    this.isInTrash,
    this.newsletters,
    this.note,
    this.paymentTerm,
    this.profilePicture,
    this.referralCode,
    this.smsSubscribed,
    this.source,
    this.timezone,
    this.transactionNumber,
    this.usedReferralCode,
    this.version,
  });

  /// Reads a detail body with its `customer` envelope or a bare listing entry.
  static Customer? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer');
    if (source == null) return null;
    return Customer(
      customerId: readInteger(source['customer_id']),
      internalId: readInteger(source['internal_id']),
      uuid: readText(source['uuid']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      name: readText(source['name']),
      email: readText(source['email']),
      status: readText(source['status']),
      gender: readText(source['gender']),
      companyName: readText(source['company_name']),
      storeCredit: readDecimal(source['store_credit']),
      customerGroups:
          readList<Reference>(source['customer_groups'], Reference.fromMap),
      shippingProfile: readAny(source['shipping_profile']),
      addresses: readList<Address>(source['addresses'], Address.fromMap),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
      abn: readText(source['abn']),
      abnBranch: readText(source['abn_branch']),
      accountHold: readFlag(source['account_hold']),
      activeBillingAddress: readInteger(source['active_billing_address']),
      activeShippingAddress: readInteger(source['active_shipping_address']),
      allowCreditLimit: readFlag(source['allow_credit_limit']),
      backgroundImage: readText(source['background_image']),
      baseUrl: readText(source['base_url']),
      countReferralCodeUsed: readInteger(source['count_referral_code_used']),
      creditLimit: readDecimal(source['credit_limit']),
      customProperties: readList<CustomProperty>(
          source['custom_properties'], CustomProperty.fromMap),
      customerPasswordExpired: readFlag(source['customer_password_expired']),
      defaultTaxCode: readText(source['default_tax_code']),
      emailVerified: readFlag(source['email_verified']),
      hidePrice: readFlag(source['hide_price']),
      howDoYouKnow: readText(source['how_do_you_know']),
      isInTrash: readFlag(source['is_in_trash']),
      newsletters: readList<Object>(source['newsletters'], readAny),
      note: readText(source['note']),
      paymentTerm: readAny(source['payment_term']),
      profilePicture: readAny(source['profile_picture']),
      referralCode: readAny(source['referral_code']),
      smsSubscribed: readFlag(source['sms_subscribed']),
      source: readText(source['source']),
      timezone: readText(source['timezone']),
      transactionNumber: readText(source['transaction_number']),
      usedReferralCode: readAny(source['used_referral_code']),
      version: readInteger(source['version']),
    );
  }

  /// `customer_id` — what a `{customer_id}` path slot takes, not [internalId].
  final int? customerId;

  final int? internalId;

  /// `uuid` — a UUID string the store assigns; a create or update naming
  /// another one keeps the stored one.
  final String? uuid;

  final String? firstName;

  final String? lastName;

  final String? name;

  final String? email;

  /// `status` — `"active"`, `"awaiting_verification"` and so on.
  final String? status;

  final String? gender;

  final String? companyName;

  final double? storeCredit;

  final List<Reference?>? customerGroups;

  final Object? shippingProfile;

  final List<Address?>? addresses;

  final String? createdAt;

  final String? updatedAt;

  final String? abn;

  final String? abnBranch;

  final bool? accountHold;

  /// `active_billing_address` — the id of the address, not the address.
  final int? activeBillingAddress;

  /// `active_shipping_address` — the id of the address, not the address.
  final int? activeShippingAddress;

  final bool? allowCreditLimit;

  final String? backgroundImage;

  final String? baseUrl;

  final int? countReferralCodeUsed;

  final double? creditLimit;

  /// `custom_properties` — on a detail body and never on a listing.
  final List<CustomProperty?>? customProperties;

  final bool? customerPasswordExpired;

  final String? defaultTaxCode;

  /// `email_verified` — on a single read only.
  final bool? emailVerified;

  final bool? hidePrice;

  final String? howDoYouKnow;

  /// `is_in_trash` — a delete is a soft one, and this is how it shows.
  final bool? isInTrash;

  final List<Object?>? newsletters;

  final String? note;

  final Object? paymentTerm;

  final Object? profilePicture;

  final Object? referralCode;

  final bool? smsSubscribed;

  final String? source;

  final String? timezone;

  final String? transactionNumber;

  final Object? usedReferralCode;

  final int? version;

  @override
  String? get envelopeKey => 'customer';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'customer_id': customerId,
        'internal_id': internalId,
        'uuid': uuid,
        'first_name': firstName,
        'last_name': lastName,
        'name': name,
        'email': email,
        'status': status,
        'gender': gender,
        'company_name': companyName,
        'store_credit': storeCredit,
        'customer_groups': customerGroups,
        'shipping_profile': shippingProfile,
        'addresses': addresses,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'abn': abn,
        'abn_branch': abnBranch,
        'account_hold': accountHold,
        'active_billing_address': activeBillingAddress,
        'active_shipping_address': activeShippingAddress,
        'allow_credit_limit': allowCreditLimit,
        'background_image': backgroundImage,
        'base_url': baseUrl,
        'count_referral_code_used': countReferralCodeUsed,
        'credit_limit': creditLimit,
        'custom_properties': customProperties,
        'customer_password_expired': customerPasswordExpired,
        'default_tax_code': defaultTaxCode,
        'email_verified': emailVerified,
        'hide_price': hidePrice,
        'how_do_you_know': howDoYouKnow,
        'is_in_trash': isInTrash,
        'newsletters': newsletters,
        'note': note,
        'payment_term': paymentTerm,
        'profile_picture': profilePicture,
        'referral_code': referralCode,
        'sms_subscribed': smsSubscribed,
        'source': source,
        'timezone': timezone,
        'transaction_number': transactionNumber,
        'used_referral_code': usedReferralCode,
        'version': version,
      };
}

/// A customer as the store accepts it — the writable form of [Customer].
class CustomerInput extends Dto {
  const CustomerInput({
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerified,
    this.password,
    this.oldPassword,
    this.status,
    this.company,
    this.companyName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postCode,
    this.addresses,
    this.customProperties,
    this.transactionNo,
  });

  static CustomerInput? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer');
    if (source == null) return null;
    return CustomerInput(
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      email: readText(source['email']),
      emailVerified: readFlag(source['email_verified']),
      password: readText(source['password']),
      oldPassword: readText(source['old_password']),
      status: readText(source['status']),
      company: readFlag(source['company']),
      companyName: readText(source['company_name']),
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      city: readText(source['city']),
      state: readIdOrName(source['state']),
      country: readIdOrName(source['country']),
      postCode: readText(source['post_code']),
      addresses: readList<Address>(source['addresses'], Address.fromMap),
      customProperties: readList<CustomProperty>(
          source['custom_properties'], CustomProperty.fromMap),
      transactionNo: readText(source['transaction_no']),
    );
  }

  /// `first_name` — required by the store on a create.
  final String? firstName;

  final String? lastName;

  /// `email` — unique across the store, and what change-password identifies by.
  final String? email;

  /// `email_verified` — written by a create and by `updateCustomer`; it does
  /// not change `status`.
  final bool? emailVerified;

  final String? password;

  /// `old_password` — change-password only.
  final String? oldPassword;

  /// `status` — omitted files the customer under `awaiting_verification`, which
  /// cannot sign in even after a reset; pass `'active'` for one that can.
  final String? status;

  final bool? company;

  final String? companyName;

  final String? addressLine1;

  final String? addressLine2;

  final String? city;

  /// `state` — an id or a name; anything else is dropped, not sent.
  final Object? state;

  /// `country` — an id or a name; anything else is dropped, not sent.
  final Object? country;

  final String? postCode;

  /// `addresses` — what `createCustomerAddresses` sends.
  final List<Address?>? addresses;

  /// `custom_properties` — replaces the whole list rather than adding to it.
  final List<CustomProperty?>? customProperties;

  /// `transaction_no` — sent beside the `customer` envelope, not inside it.
  final String? transactionNo;

  @override
  String? get envelopeKey => 'customer';

  @override
  Set<String> get topLevelFields => const <String>{'transaction_no'};

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'email_verified': emailVerified,
        'password': password,
        'old_password': oldPassword,
        'status': status,
        'company': company,
        'company_name': companyName,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'state': state,
        'country': country,
        'post_code': postCode,
        'addresses': addresses,
        'custom_properties': customProperties,
        'transaction_no': transactionNo,
      };
}

/// One movement of a customer's store credit, as a write or a history entry
/// sends it.
class StoreCreditAdjustment extends Dto {
  const StoreCreditAdjustment({
    this.id,
    this.customerId,
    this.internalId,
    this.action,
    this.amount,
    this.note,
    this.createdAt,
    this.createdBy,
    this.balanceBefore,
    this.balanceAfter,
    this.storeCredit,
  });

  /// Reads a write's `store_credit_adjustment` envelope, or a history entry.
  static StoreCreditAdjustment? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'store_credit_adjustment');
    if (source == null) return null;
    return StoreCreditAdjustment(
      id: readInteger(source['id']),
      customerId: readInteger(source['customer_id']),
      internalId: readInteger(source['internal_id']),
      action: readText(source['action']),
      amount: readDecimal(source['amount']),
      note: readText(source['note']),
      createdAt: readText(source['created_at']),
      createdBy: readAny(source['created_by']),
      balanceBefore: readDecimal(source['balance_before']),
      balanceAfter: readDecimal(source['balance_after']),
      storeCredit: readDecimal(source['store_credit']),
    );
  }

  final int? id;

  /// `customer_id` — the id space a `{customer_id}` path segment takes.
  final int? customerId;

  final int? internalId;

  /// `action` — `add` or `deduct`; the sign lives here, not in [amount].
  final String? action;

  /// `amount` — unsigned. An integer sent is answered as a float.
  final double? amount;

  final String? note;

  final String? createdAt;

  final Object? createdBy;

  /// `balance_before` — on a write's answer only; `null` on a history entry.
  final double? balanceBefore;

  /// `balance_after` — on a write's answer only; `null` on a history entry.
  final double? balanceAfter;

  /// `store_credit` — the balance this left behind, sent beside the record.
  final double? storeCredit;

  @override
  String? get envelopeKey => 'store_credit_adjustment';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'customer_id': customerId,
        'internal_id': internalId,
        'action': action,
        'amount': amount,
        'note': note,
        'created_at': createdAt,
        'created_by': createdBy,
        'balance_before': balanceBefore,
        'balance_after': balanceAfter,
        'store_credit': storeCredit,
      };
}

/// A store-credit movement as the store accepts it — the writable form of
/// [StoreCreditAdjustment].
class StoreCreditAdjustmentInput extends Dto {
  const StoreCreditAdjustmentInput({this.action, this.amount, this.note});

  /// `action` — `add` or `deduct`; the sign lives here, not in [amount].
  final String? action;

  final double? amount;

  final String? note;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'action': action,
        'amount': amount,
        'note': note,
      };
}

/// The `pagination` block of a listing.
class Pagination extends Dto {
  const Pagination({
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

  static Pagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Pagination(
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

  /// `total` — every customer, not just this page.
  final int? total;

  final int? limit;

  final int? offset;

  /// `count` — the records on this page.
  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

  final bool? hasPrevious;

  /// `previous_page` — an absolute URL, `null` on the first page.
  final String? previousPage;

  /// `next_page` — an absolute URL, `null` on the last.
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

/// One page of a listing, generic over the record type.
class Page<T> extends Dto {
  const Page({this.items, this.pagination});

  /// A decoder for pages whose records read as `T`:
  /// `dtoDecoder: Page.of(Customer.fromMap)`.
  static DtoDecoder of<T>(T? Function(Object? body) readItem) =>
      (Object? body) => fromMap<T>(body, readItem);

  /// Reads a listing envelope, [readItem] reading each record.
  static Page<T>? fromMap<T>(Object? body, T? Function(Object? body) readItem) {
    final source = readRecord(body);
    if (source == null) return null;
    return Page<T>(
      items: readList<T>(_records(source), readItem),
      pagination: Pagination.fromMap(source['pagination']),
    );
  }

  /// The body's one list-valued entry — the records, under whichever key.
  static Object? _records(Map<String, Object?> source) {
    Object? records;
    var found = 0;
    for (final value in source.values) {
      if (value is! List) continue;
      records = value;
      found++;
    }
    return found == 1 ? records : null;
  }

  /// The records, under whichever key the wire named them, each read as `T`.
  final List<T?>? items;

  final Pagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'items': items,
        'pagination': pagination,
      };
}
