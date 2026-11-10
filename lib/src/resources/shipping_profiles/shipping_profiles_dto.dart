/// Typed views over the shipping profile bodies.
library;

import '../../client/dto.dart';

/// An `{id, name}` pair: a rule's rate, and a zone named in the wizard, where
/// a write sends `{"id": ...}` for an existing zone or `{"name": ...}` to
/// create one.
class ShippingProfileReference extends Dto {
  const ShippingProfileReference({this.id, this.name});

  /// Reads one reference.
  static ShippingProfileReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingProfileReference(
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

/// A rule on a profile; `shipping_rate` is `null` on a rule that has no rate.
class ShippingProfileRule extends Dto {
  const ShippingProfileRule({this.id, this.name, this.shippingRate});

  /// Reads one `shipping_rules` entry.
  static ShippingProfileRule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingProfileRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      shippingRate: ShippingProfileReference.fromMap(source['shipping_rate']),
    );
  }

  final int? id;

  final String? name;

  final ShippingProfileReference? shippingRate;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'shipping_rate': shippingRate,
      };
}

/// One profile, the same ten keys on a listing row, the row read and every
/// write's answer. `rule_preference` reads `product_assigned_rule`,
/// `lowest_shipping_cost_rule` or `highest_shipping_cost_rule`; exactly one
/// profile has `default` true.
class ShippingProfile extends Dto {
  const ShippingProfile({
    this.id,
    this.name,
    this.description,
    this.rulePreference,
    this.isDefault,
    this.rulesCount,
    this.shippingRules,
    this.transactionNo,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `shipping_profile` envelope, or a bare listing row.
  static ShippingProfile? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_profile');
    if (source == null) return null;
    return ShippingProfile(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      rulePreference: readText(source['rule_preference']),
      isDefault: readFlag(source['default']),
      rulesCount: readInteger(source['rules_count']),
      shippingRules: readList<ShippingProfileRule>(
          source['shipping_rules'], ShippingProfileRule.fromMap),
      transactionNo: readText(source['transaction_no']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  final String? rulePreference;

  /// `default` — true on the one store default profile.
  final bool? isDefault;

  final int? rulesCount;

  final List<ShippingProfileRule?>? shippingRules;

  final String? transactionNo;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'shipping_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'rule_preference': rulePreference,
        'default': isDefault,
        'rules_count': rulesCount,
        'shipping_rules': shippingRules,
        'transaction_no': transactionNo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable fields, wrapped in `shipping_profile`, for the create, the
/// `PUT` replace and the `PATCH`. `shipping_rules` is the whole list of rule
/// ids, each rule once; `PUT` needs `name`, `description`, `rule_preference`
/// and `shipping_rules`. `default` takes only `true` or `false`. Fields left
/// `null` are not sent: to clear one, pass a map.
class ShippingProfileInput extends Dto {
  const ShippingProfileInput({
    this.name,
    this.description,
    this.rulePreference,
    this.isDefault,
    this.shippingRules,
    this.transactionNo,
    this.suggestName,
  });

  final String? name;

  final String? description;

  final String? rulePreference;

  /// `default`.
  final bool? isDefault;

  final List<int>? shippingRules;

  final String? transactionNo;

  /// `suggest_name` — `true` saves the next free `name(1)` instead of a `409`.
  final bool? suggestName;

  @override
  String? get envelopeKey => 'shipping_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'rule_preference': rulePreference,
        'default': isDefault,
        'shipping_rules': shippingRules,
        'transaction_no': transactionNo,
        'suggest_name': suggestName,
      };
}

/// The rate a wizard rule creates; the fields of a rate write, `name` and
/// `method` required.
class ShippingProfileWizardRate extends Dto {
  const ShippingProfileWizardRate({
    this.name,
    this.method,
    this.calculateForEntireOrder,
    this.priceEnteredWithTax,
    this.shippingCost,
    this.handlingCost,
    this.conditions,
    this.additionalRule,
    this.transactionNo,
  });

  final String? name;

  final String? method;

  final bool? calculateForEntireOrder;

  final bool? priceEnteredWithTax;

  /// `shipping_cost` — `{amount, type}`, left untyped here.
  final Object? shippingCost;

  final Object? handlingCost;

  /// `conditions` — one row per range, left untyped.
  final List<Object?>? conditions;

  final Object? additionalRule;

  final String? transactionNo;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'method': method,
        'calculate_for_entire_order': calculateForEntireOrder,
        'price_entered_with_tax': priceEnteredWithTax,
        'shipping_cost': shippingCost,
        'handling_cost': handlingCost,
        'conditions': conditions,
        'additional_rule': additionalRule,
        'transaction_no': transactionNo,
      };
}

/// A rule the wizard creates beside its rate: `name` is required,
/// `shipping_class` is a class id, and `zones` name existing zones by
/// `{"id": ...}` or new ones by `{"name": ...}`.
class ShippingProfileWizardRule extends Dto {
  const ShippingProfileWizardRule({
    this.name,
    this.description,
    this.shippingClass,
    this.shippingRate,
    this.zones,
  });

  final String? name;

  final String? description;

  final int? shippingClass;

  final ShippingProfileWizardRate? shippingRate;

  final List<ShippingProfileReference>? zones;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'shipping_class': shippingClass,
        'shipping_rate': shippingRate,
        'zones': zones,
      };
}

/// The wizard's body, wrapped in `shipping_profile`: the profile fields and
/// the rules, each with its rate, to create under it.
class ShippingProfileWizardInput extends Dto {
  const ShippingProfileWizardInput({
    this.name,
    this.description,
    this.rulePreference,
    this.shippingRules,
  });

  final String? name;

  final String? description;

  final String? rulePreference;

  final List<ShippingProfileWizardRule>? shippingRules;

  @override
  String? get envelopeKey => 'shipping_profile';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'rule_preference': rulePreference,
        'shipping_rules': shippingRules,
      };
}

/// The five-key `pagination` block; `limit` is the size the store applied.
class ShippingProfilePagination extends Dto {
  const ShippingProfilePagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static ShippingProfilePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingProfilePagination(
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

/// One page of the listing, newest first.
class ShippingProfileListing extends Dto {
  const ShippingProfileListing({this.shippingProfiles, this.pagination});

  /// Reads a listing body.
  static ShippingProfileListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingProfileListing(
      shippingProfiles: readList<ShippingProfile>(
          source['shipping_profiles'], ShippingProfile.fromMap),
      pagination: ShippingProfilePagination.fromMap(source['pagination']),
    );
  }

  final List<ShippingProfile?>? shippingProfiles;

  final ShippingProfilePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_profiles': shippingProfiles,
        'pagination': pagination,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class ShippingProfileCount extends Dto {
  const ShippingProfileCount({this.total});

  /// Reads a count body.
  static ShippingProfileCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingProfileCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}
