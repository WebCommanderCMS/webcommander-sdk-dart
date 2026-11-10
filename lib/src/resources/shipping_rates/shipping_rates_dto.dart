/// Typed views over the shipping rate bodies.
library;

import '../../client/dto.dart';

/// An `{id, name}` pair: a rule that uses the rate.
class ShippingRateReference extends Dto {
  const ShippingRateReference({this.id, this.name});

  /// Reads one reference.
  static ShippingRateReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRateReference(
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

/// A shipping or handling cost; `type` is `fixed` or `percent`.
class ShippingRateCost extends Dto {
  const ShippingRateCost({this.amount, this.type});

  /// Reads one cost.
  static ShippingRateCost? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRateCost(
      amount: readDecimal(source['amount']),
      type: readText(source['type']),
    );
  }

  final double? amount;

  final String? type;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'amount': amount,
        'type': type,
      };
}

/// The charge for each item past the first; the other two keys read `null`
/// while `enabled` is false, and `enabled` true needs both.
class ShippingRateAdditionalRule extends Dto {
  const ShippingRateAdditionalRule({
    this.enabled,
    this.forEachAdditional,
    this.additionalCost,
  });

  /// Reads the `additional_rule` box.
  static ShippingRateAdditionalRule? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRateAdditionalRule(
      enabled: readFlag(source['enabled']),
      forEachAdditional: readInteger(source['for_each_additional']),
      additionalCost: readDecimal(source['additional_cost']),
    );
  }

  final bool? enabled;

  final int? forEachAdditional;

  final double? additionalCost;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'for_each_additional': forEachAdditional,
        'additional_cost': additionalCost,
      };
}

/// One rate, the same fourteen keys on a listing row, the row read and every
/// write's answer, whatever the method. `method` is `flat_rate`,
/// `free_shipping`, `ship_by_price`, `ship_by_quantity`, `ship_by_weight`,
/// `ship_by_variation` or `shipping_variant`. A flat rate carries
/// `shipping_cost` and `handling_cost`, the `ship_by_*` methods carry them per
/// row in `conditions`, and a key the method does not use reads `null` or an
/// empty list. `weight_unit` is the store's, `null` unless the method is
/// `ship_by_weight`.
class ShippingRate extends Dto {
  const ShippingRate({
    this.id,
    this.name,
    this.method,
    this.calculateForEntireOrder,
    this.priceEnteredWithTax,
    this.shippingCost,
    this.handlingCost,
    this.weightUnit,
    this.conditions,
    this.additionalRule,
    this.shippingRules,
    this.transactionNo,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a row path's `shipping_rate` envelope, or a bare listing row.
  static ShippingRate? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_rate');
    if (source == null) return null;
    return ShippingRate(
      id: readInteger(source['id']),
      name: readText(source['name']),
      method: readText(source['method']),
      calculateForEntireOrder: readFlag(source['calculate_for_entire_order']),
      priceEnteredWithTax: readFlag(source['price_entered_with_tax']),
      shippingCost: ShippingRateCost.fromMap(source['shipping_cost']),
      handlingCost: ShippingRateCost.fromMap(source['handling_cost']),
      weightUnit: readText(source['weight_unit']),
      conditions: readList<Object>(source['conditions'], readAny),
      additionalRule:
          ShippingRateAdditionalRule.fromMap(source['additional_rule']),
      shippingRules: readList<ShippingRateReference>(
          source['shipping_rules'], ShippingRateReference.fromMap),
      transactionNo: readText(source['transaction_no']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? name;

  final String? method;

  final bool? calculateForEntireOrder;

  final bool? priceEnteredWithTax;

  final ShippingRateCost? shippingCost;

  final ShippingRateCost? handlingCost;

  final String? weightUnit;

  /// `conditions` — one row per range or variation, each row `{from, to,
  /// shipping_cost, handling_cost}` and so on, left untyped.
  final List<Object?>? conditions;

  final ShippingRateAdditionalRule? additionalRule;

  final List<ShippingRateReference?>? shippingRules;

  final String? transactionNo;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'shipping_rate';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'method': method,
        'calculate_for_entire_order': calculateForEntireOrder,
        'price_entered_with_tax': priceEnteredWithTax,
        'shipping_cost': shippingCost,
        'handling_cost': handlingCost,
        'weight_unit': weightUnit,
        'conditions': conditions,
        'additional_rule': additionalRule,
        'shipping_rules': shippingRules,
        'transaction_no': transactionNo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The writable fields, wrapped in `shipping_rate`, for the create, the `PUT`
/// replace and the `PATCH`. `name` and `method` are required on a create; a
/// flat rate also needs `shipping_cost` and the `ship_by_*` methods need
/// `conditions`. `PUT` needs every field of the rate, `handling_cost` and
/// `additional_rule` as `null` when unused. `shipping_rule_id` attaches the
/// new rate to a rule that has none. Fields left `null` are not sent: to clear
/// one, pass a map.
class ShippingRateInput extends Dto {
  const ShippingRateInput({
    this.name,
    this.method,
    this.calculateForEntireOrder,
    this.priceEnteredWithTax,
    this.shippingCost,
    this.handlingCost,
    this.conditions,
    this.additionalRule,
    this.shippingRuleId,
    this.transactionNo,
    this.suggestName,
  });

  final String? name;

  final String? method;

  final bool? calculateForEntireOrder;

  final bool? priceEnteredWithTax;

  final ShippingRateCost? shippingCost;

  final ShippingRateCost? handlingCost;

  /// `conditions` — rows as maps, such as `{"from": 0, "to": 10,
  /// "shipping_cost": {...}, "handling_cost": {...}}`.
  final List<Object?>? conditions;

  final ShippingRateAdditionalRule? additionalRule;

  final int? shippingRuleId;

  final String? transactionNo;

  /// `suggest_name` — `true` saves the next free `name(1)` instead of a `409`.
  final bool? suggestName;

  @override
  String? get envelopeKey => 'shipping_rate';

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
        'shipping_rule_id': shippingRuleId,
        'transaction_no': transactionNo,
        'suggest_name': suggestName,
      };
}

/// The five-key `pagination` block; `limit` is the size the store applied.
class ShippingRatePagination extends Dto {
  const ShippingRatePagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static ShippingRatePagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRatePagination(
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
class ShippingRateListing extends Dto {
  const ShippingRateListing({this.shippingRates, this.pagination});

  /// Reads a listing body.
  static ShippingRateListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRateListing(
      shippingRates: readList<ShippingRate>(
          source['shipping_rates'], ShippingRate.fromMap),
      pagination: ShippingRatePagination.fromMap(source['pagination']),
    );
  }

  final List<ShippingRate?>? shippingRates;

  final ShippingRatePagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_rates': shippingRates,
        'pagination': pagination,
      };
}

/// The count sub-path's body, a bare `{"total": N}`.
class ShippingRateCount extends Dto {
  const ShippingRateCount({this.total});

  /// Reads a count body.
  static ShippingRateCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingRateCount(total: readInteger(source['total']));
  }

  final int? total;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
      };
}
