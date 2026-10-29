/// Typed views over the transaction-number bodies.
library;

import '../../client/dto.dart';

/// One listing row: a number, how many records carry it, and its read path.
class TransactionListEntry extends Dto {
  const TransactionListEntry({this.transactionNo, this.totalRecords, this.url});

  /// Reads one row of `transactions`.
  static TransactionListEntry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionListEntry(
      transactionNo: readText(source['transaction_no']),
      totalRecords: readInteger(source['total_records']),
      url: readText(source['url']),
    );
  }

  final String? transactionNo;

  final int? totalRecords;

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'total_records': totalRecords,
        'url': url,
      };
}

/// One `by_type` row of a number's read: `count` is `created` plus `updated`,
/// and `trashed` counts those of them now in the trash.
class TransactionTypeCount extends Dto {
  const TransactionTypeCount({
    this.type,
    this.count,
    this.created,
    this.updated,
    this.trashed,
    this.itemsUrl,
  });

  /// Reads one row of `by_type`.
  static TransactionTypeCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionTypeCount(
      type: readText(source['type']),
      count: readInteger(source['count']),
      created: readInteger(source['created']),
      updated: readInteger(source['updated']),
      trashed: readInteger(source['trashed']),
      itemsUrl: readText(source['items_url']),
    );
  }

  final String? type;

  final int? count;

  final int? created;

  final int? updated;

  /// `trashed` — a subset of `count`, not a third part of the split.
  final int? trashed;

  /// `items_url` — sent on every row, `count` `0` included; it form-encodes the
  /// number, so a space arrives as `+`.
  final String? itemsUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'count': count,
        'created': created,
        'updated': updated,
        'trashed': trashed,
        'items_url': itemsUrl,
      };
}

/// One number's read: a bare body, its 15 `by_type` rows always in the same
/// order.
class Transaction extends Dto {
  const Transaction({this.transactionNo, this.totalRecords, this.byType});

  /// Reads a number's body.
  static Transaction? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Transaction(
      transactionNo: readText(source['transaction_no']),
      totalRecords: readInteger(source['total_records']),
      byType: readList<TransactionTypeCount>(
          source['by_type'], TransactionTypeCount.fromMap),
    );
  }

  final String? transactionNo;

  final int? totalRecords;

  final List<TransactionTypeCount?>? byType;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'total_records': totalRecords,
        'by_type': byType,
      };
}

/// One record under a number, as `detail=slim` sends it: `type`, `id`, `stamp`
/// (`created` or `updated`), `trashed` and the fields of its `type`. `category` sends `name` and `url`; `product` and
/// `product_variation` add `sku`; `product_review` adds `rating`; `customer`
/// sends `email`, `first_name`, `last_name` and `url`; `order` sends
/// `order_no`, `grand_total`, `status` and a `url` ending in `order_no`;
/// `currency` adds `code` and `symbol`; `custom_tax_profile` adds `code`;
/// `custom_tax_rule` sends `name` alone; `custom_tax_rule_zone` sends
/// `country_code`, `state_name`, `postcode`, `rate` and `priority`;
/// `shipping_profile` adds `description`; `shipping_rate` adds `policy_type`.
/// A field the type does not send reads `null`. Under `detail=full` a row is
/// the record's own read body, which stays in `response.map`.
class TransactionItem extends Dto {
  const TransactionItem({
    this.type,
    this.id,
    this.stamp,
    this.trashed,
    this.name,
    this.sku,
    this.rating,
    this.email,
    this.firstName,
    this.lastName,
    this.orderNo,
    this.grandTotal,
    this.status,
    this.code,
    this.symbol,
    this.countryCode,
    this.stateName,
    this.postcode,
    this.rate,
    this.priority,
    this.description,
    this.policyType,
    this.url,
  });

  /// Reads one row of `items`.
  static TransactionItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionItem(
      type: readText(source['type']),
      id: readInteger(source['id']),
      stamp: readText(source['stamp']),
      trashed: readFlag(source['trashed']),
      name: readText(source['name']),
      sku: readText(source['sku']),
      rating: readDecimal(source['rating']),
      email: readText(source['email']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      orderNo: readInteger(source['order_no']),
      grandTotal: readDecimal(source['grand_total']),
      status: readText(source['status']),
      code: readText(source['code']),
      symbol: readText(source['symbol']),
      countryCode: readText(source['country_code']),
      stateName: readText(source['state_name']),
      postcode: readText(source['postcode']),
      rate: readDecimal(source['rate']),
      priority: readInteger(source['priority']),
      description: readText(source['description']),
      policyType: readText(source['policy_type']),
      url: readText(source['url']),
    );
  }

  final String? type;

  final int? id;

  /// `stamp` — `created` or `updated`.
  final String? stamp;

  final bool? trashed;

  /// `name` — not sent for `customer`, `order` or `custom_tax_rule_zone`.
  final String? name;

  /// `sku` — a `product` or `product_variation`.
  final String? sku;

  /// `rating` — a `product_review`.
  final double? rating;

  /// `email` — a `customer`.
  final String? email;

  /// `first_name` — a `customer`.
  final String? firstName;

  /// `last_name` — a `customer`.
  final String? lastName;

  /// `order_no` — an `order`; its `url` ends with this, not `id`.
  final int? orderNo;

  /// `grand_total` — an `order`.
  final double? grandTotal;

  /// `status` — an `order`.
  final String? status;

  /// `code` — a `currency` or `custom_tax_profile`.
  final String? code;

  /// `symbol` — a `currency`.
  final String? symbol;

  /// `country_code` — a `custom_tax_rule_zone`.
  final String? countryCode;

  /// `state_name` — a `custom_tax_rule_zone`; `null` when the zone has none.
  final String? stateName;

  /// `postcode` — a `custom_tax_rule_zone`.
  final String? postcode;

  /// `rate` — a `custom_tax_rule_zone`.
  final double? rate;

  /// `priority` — a `custom_tax_rule_zone`.
  final int? priority;

  /// `description` — a `shipping_profile`.
  final String? description;

  /// `policy_type` — a `shipping_rate`.
  final String? policyType;

  /// `url` — the record's own read path; not sent for `custom_tax_rule` or
  /// `custom_tax_rule_zone`.
  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'id': id,
        'stamp': stamp,
        'trashed': trashed,
        'name': name,
        'sku': sku,
        'rating': rating,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'order_no': orderNo,
        'grand_total': grandTotal,
        'status': status,
        'code': code,
        'symbol': symbol,
        'country_code': countryCode,
        'state_name': stateName,
        'postcode': postcode,
        'rate': rate,
        'priority': priority,
        'description': description,
        'policy_type': policyType,
        'url': url,
      };
}

/// The five-key `pagination` block of both listings; there is no next-page
/// link, so step `offset`.
class TransactionPagination extends Dto {
  const TransactionPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static TransactionPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionPagination(
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

/// One page of the numbers; a `transaction_no` filter answers `pagination` too.
class TransactionPage extends Dto {
  const TransactionPage({this.transactions, this.pagination});

  /// Reads a listing body.
  static TransactionPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionPage(
      transactions: readList<TransactionListEntry>(
          source['transactions'], TransactionListEntry.fromMap),
      pagination: TransactionPagination.fromMap(source['pagination']),
    );
  }

  final List<TransactionListEntry?>? transactions;

  final TransactionPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transactions': transactions,
        'pagination': pagination,
      };
}

/// One page of the records carrying a number, beside the number; each item
/// names its own `type`. A number or a type with no records answers `items`
/// empty and `pagination.total` `0`.
class TransactionItemPage extends Dto {
  const TransactionItemPage({
    this.transactionNo,
    this.items,
    this.pagination,
  });

  /// Reads an items body.
  static TransactionItemPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TransactionItemPage(
      transactionNo: readText(source['transaction_no']),
      items:
          readList<TransactionItem>(source['items'], TransactionItem.fromMap),
      pagination: TransactionPagination.fromMap(source['pagination']),
    );
  }

  final String? transactionNo;

  final List<TransactionItem?>? items;

  final TransactionPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'transaction_no': transactionNo,
        'items': items,
        'pagination': pagination,
      };
}
