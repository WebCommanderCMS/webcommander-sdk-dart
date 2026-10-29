/// Typed views over the domain alias bodies.
library;

import '../../client/dto.dart';

/// One alias: a listing row, or the record a create answers under `alias`, the
/// same four fields either way.
class Alias extends Dto {
  const Alias({this.id, this.alias, this.createdAt, this.updatedAt});

  /// Reads a create's `alias` envelope, or a bare listing row, whose own
  /// `alias` is text and so is never unwrapped.
  static Alias? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'alias');
    if (source == null) return null;
    return Alias(
      id: readInteger(source['id']),
      alias: readText(source['alias']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final int? id;

  final String? alias;

  final String? createdAt;

  final String? updatedAt;

  @override
  String? get envelopeKey => 'alias';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'alias': alias,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The create body, `{"alias": "<hostname>"}`.
class AliasInput extends Dto {
  const AliasInput({this.alias});

  final String? alias;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'alias': alias,
      };
}

/// The listing's five-key `pagination` block; `limit` is the size the store
/// applied.
class AliasPagination extends Dto {
  const AliasPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasNext,
    this.hasPrevious,
  });

  static AliasPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AliasPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasNext: readFlag(source['has_next']),
      hasPrevious: readFlag(source['has_previous']),
    );
  }

  final int? total;

  final int? limit;

  final int? offset;

  final bool? hasNext;

  final bool? hasPrevious;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'limit': limit,
        'offset': offset,
        'has_next': hasNext,
        'has_previous': hasPrevious,
      };
}

/// One page of the listing.
class AliasPage extends Dto {
  const AliasPage({this.aliases, this.pagination});

  static AliasPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AliasPage(
      aliases: readList<Alias>(source['aliases'], Alias.fromMap),
      pagination: AliasPagination.fromMap(source['pagination']),
    );
  }

  final List<Alias?>? aliases;

  final AliasPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'aliases': aliases,
        'pagination': pagination,
      };
}
