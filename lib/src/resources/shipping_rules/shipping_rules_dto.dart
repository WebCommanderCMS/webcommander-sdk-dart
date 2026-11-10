/// Typed views over the shipping rule bodies.
library;

import '../../client/dto.dart';

/// An `{id, name}` pair: the rule's class, rate, zones and profiles. A write
/// names a class, a rate or a zone by its id, bare or as `{"id": ...}`; `name`
/// is read-only.
class ShippingRuleReference extends Dto {
  const ShippingRuleReference({this.id, this.name});

  /// Reads one reference.
  static ShippingRuleReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRuleReference(
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

/// One rule, the same ten keys on a listing row, the row read and every
/// write's answer. `shipping_class` and `shipping_rate` are `null` when unset,
/// `zones` and `profiles` empty lists.
class ShippingRule extends Dto {
  const ShippingRule({
    this.id,
    this.name,
    this.description,
    this.shippingClass,
    this.shippingRate,
    this.zones,
    this.profiles,
    this.transactionNo,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `shipping_rule` envelope, or a bare listing row.
  static ShippingRule? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_rule');
    if (source == null) return null;
    return ShippingRule(
      id: readInteger(source['id']),
      name: readText(source['name']),
      description: readText(source['description']),
      shippingClass: ShippingRuleReference.fromMap(source['shipping_class']),
      shippingRate: ShippingRuleReference.fromMap(source['shipping_rate']),
      zones: readList<ShippingRuleReference>(
          source['zones'], ShippingRuleReference.fromMap),
      profiles: readList<ShippingRuleReference>(
          source['profiles'], ShippingRuleReference.fromMap),
      transactionNo: readText(source['transaction_no']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? description;

  final ShippingRuleReference? shippingClass;

  final ShippingRuleReference? shippingRate;

  final List<ShippingRuleReference?>? zones;

  final List<ShippingRuleReference?>? profiles;

  final String? transactionNo;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'shipping_rule';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'description': description,
        'shipping_class': shippingClass,
        'shipping_rate': shippingRate,
        'zones': zones,
        'profiles': profiles,
        'transaction_no': transactionNo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable fields, wrapped in `shipping_rule`, for the create, the `PUT`
/// replace and the `PATCH`. `zones` is the whole list of zones, each once;
/// `profile_id` adds the new rule to a profile on a create. `PUT` needs
/// `name`, `description`, `shipping_class`, `shipping_rate` and `zones`.
/// Fields left `null` are not sent: to clear a class or a rate, pass a map
/// holding `null`.
class ShippingRuleInput extends Dto {
  const ShippingRuleInput({
    this.name,
    this.description,
    this.shippingClass,
    this.shippingRate,
    this.zones,
    this.profileId,
    this.transactionNo,
    this.suggestName,
  });

  final String? name;

  final String? description;

  /// `shipping_class` — a class id, bare or as a [ShippingRuleReference].
  final Object? shippingClass;

  /// `shipping_rate` — a rate id, bare or as a [ShippingRuleReference].
  final Object? shippingRate;

  /// `zones` — zone ids, bare or as a [ShippingRuleReference].
  final List<Object?>? zones;

  final int? profileId;

  final String? transactionNo;

  /// `suggest_name` — `true` saves the next free `name(1)` instead of a `409`.
  final bool? suggestName;

  @override
  String? get envelopeKey => 'shipping_rule';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'description': description,
        'shipping_class': shippingClass,
        'shipping_rate': shippingRate,
        'zones': zones,
        'profile_id': profileId,
        'transaction_no': transactionNo,
        'suggest_name': suggestName,
      };
}

/// The five-key `pagination` block; `limit` is the size the store applied.
class ShippingRulePagination extends Dto {
  const ShippingRulePagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static ShippingRulePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRulePagination(
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
class ShippingRuleListing extends Dto {
  const ShippingRuleListing({this.shippingRules, this.pagination});

  /// Reads a listing body.
  static ShippingRuleListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRuleListing(
      shippingRules: readList<ShippingRule>(
          source['shipping_rules'], ShippingRule.fromMap),
      pagination: ShippingRulePagination.fromMap(source['pagination']),
    );
  }

  final List<ShippingRule?>? shippingRules;

  final ShippingRulePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_rules': shippingRules,
        'pagination': pagination,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class ShippingRuleCount extends Dto {
  const ShippingRuleCount({this.total});

  /// Reads a count body.
  static ShippingRuleCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRuleCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}
