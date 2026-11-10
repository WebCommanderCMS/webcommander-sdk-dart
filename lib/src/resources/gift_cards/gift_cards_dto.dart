/// Typed views over the gift card bodies.
library;

import '../../client/dto.dart';

/// One gift card. `code` is what an order preview's `gift-card` call takes; a
/// card can be applied only while `is_active` and `is_paid`, with a `balance`
/// above zero, before its `available_to` date and with `email` equal to the
/// previewed customer's email.
class GiftCard extends Dto {
  const GiftCard({
    this.id,
    this.code,
    this.balance,
    this.initialAmount,
    this.email,
    this.firstName,
    this.lastName,
    this.message,
    this.isActive,
    this.isPaid,
    this.availableTo,
    this.externalReference,
    this.productName,
    this.createdOn,
  });

  /// Reads one listing row.
  static GiftCard? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GiftCard(
      id: readInteger(source['id']),
      code: readText(source['code']),
      balance: readDecimal(source['balance']),
      initialAmount: readDecimal(source['initial_amount']),
      email: readText(source['email']),
      firstName: readText(source['first_name']),
      lastName: readText(source['last_name']),
      message: readText(source['message']),
      isActive: readFlag(source['is_active']),
      isPaid: readFlag(source['is_paid']),
      availableTo: readText(source['available_to']),
      externalReference: readText(source['external_reference']),
      productName: readText(source['product_name']),
      createdOn: readText(source['created_on']),
    );
  }

  final int? id;

  final String? code;

  final double? balance;

  final double? initialAmount;

  final String? email;

  final String? firstName;

  final String? lastName;

  final String? message;

  final bool? isActive;

  final bool? isPaid;

  /// A date, or `null` for a card that does not expire.
  final String? availableTo;

  final String? externalReference;

  final String? productName;

  final String? createdOn;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'code': code,
        'balance': balance,
        'initial_amount': initialAmount,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'message': message,
        'is_active': isActive,
        'is_paid': isPaid,
        'available_to': availableTo,
        'external_reference': externalReference,
        'product_name': productName,
        'created_on': createdOn,
      };
}

/// The listing's ten-key `pagination` block; `limit` is the size the store
/// applied, at most 20.
class GiftCardPagination extends Dto {
  const GiftCardPagination({
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
  static GiftCardPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GiftCardPagination(
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

  final int? limit;

  final int? offset;

  final int? count;

  final int? currentPage;

  final int? totalPages;

  final bool? hasNext;

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

/// One page of the listing, newest first.
class GiftCardPage extends Dto {
  const GiftCardPage({this.giftCards, this.pagination});

  /// Reads a listing body.
  static GiftCardPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GiftCardPage(
      giftCards: readList<GiftCard>(source['gift_cards'], GiftCard.fromMap),
      pagination: GiftCardPagination.fromMap(source['pagination']),
    );
  }

  final List<GiftCard?>? giftCards;

  final GiftCardPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'gift_cards': giftCards,
        'pagination': pagination,
      };
}
