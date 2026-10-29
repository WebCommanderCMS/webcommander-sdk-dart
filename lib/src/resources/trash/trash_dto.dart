/// Typed views over the trash bodies.
library;

import '../../client/dto.dart';

/// One trashed row, and the `item` a restore answers, named by its type and its
/// own id. A restore and a bulk delete send no `removed_at`.
class TrashItem extends Dto {
  const TrashItem({this.type, this.id, this.name, this.removedAt, this.url});

  /// Reads one listing row, or the restore answer under `item`.
  static TrashItem? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'item');
    if (source == null) return null;
    return TrashItem(
      type: readText(source['type']),
      id: readInteger(source['id']),
      name: readText(source['name']),
      removedAt: readText(source['removed_at']),
      url: readText(source['url']),
    );
  }

  /// `type` — the snake_case name the type list answers, whatever was sent.
  final String? type;

  final int? id;

  final String? name;

  /// `removed_at` — when the row was trashed, in UTC.
  final String? removedAt;

  /// `url` — the record's own path; `null` for a `blog_post`.
  final String? url;

  @override
  String? get envelopeKey => 'item';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'id': id,
        'name': name,
        'removed_at': removedAt,
        'url': url,
      };
}

/// The five-key `pagination` block; there is no next-page link, so step
/// `offset`.
class TrashPagination extends Dto {
  const TrashPagination({
    this.total,
    this.limit,
    this.offset,
    this.hasPrevious,
    this.hasNext,
  });

  /// Reads the block beside the rows.
  static TrashPagination? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashPagination(
      total: readInteger(source['total']),
      limit: readInteger(source['limit']),
      offset: readInteger(source['offset']),
      hasPrevious: readFlag(source['has_previous']),
      hasNext: readFlag(source['has_next']),
    );
  }

  final int? total;

  /// `limit` — the page size applied; over 100 is refused with `400`.
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

/// One page of the listing: the rows and where they sit.
class TrashPage extends Dto {
  const TrashPage({this.items, this.pagination});

  /// Reads a listing body.
  static TrashPage? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashPage(
      items: readList<TrashItem>(source['items'], TrashItem.fromMap),
      pagination: TrashPagination.fromMap(source['pagination']),
    );
  }

  final List<TrashItem?>? items;

  final TrashPagination? pagination;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'items': items,
        'pagination': pagination,
      };
}

/// One type the trash holds, as a path's `{trash_type}` takes it.
class TrashType extends Dto {
  const TrashType({this.type});

  /// Reads one entry of the type list.
  static TrashType? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashType(type: readText(source['type']));
  }

  final String? type;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
      };
}

/// The `types` body: every type, alphabetical.
class TrashTypeList extends Dto {
  const TrashTypeList({this.types});

  /// Reads the type list body.
  static TrashTypeList? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashTypeList(
        types: readList<TrashType>(source['types'], TrashType.fromMap));
  }

  final List<TrashType?>? types;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'types': types,
      };
}

/// One item a bulk call could not act on: an error `code` such as `not_found`
/// or `not_in_trash`, and why in words.
class TrashBulkError extends Dto {
  const TrashBulkError({this.type, this.id, this.code, this.message});

  /// Reads one `failed` entry.
  static TrashBulkError? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashBulkError(
      type: readText(source['type']),
      id: readInteger(source['id']),
      code: readText(source['code']),
      message: readText(source['message']),
    );
  }

  final String? type;

  final int? id;

  final String? code;

  final String? message;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'id': id,
        'code': code,
        'message': message,
      };
}

/// The bulk restore's body: the rows restored, and an entry per failed item.
class TrashBulkRestoreResult extends Dto {
  const TrashBulkRestoreResult({this.restored, this.failed});

  /// Reads a bulk restore body.
  static TrashBulkRestoreResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashBulkRestoreResult(
      restored: readList<TrashItem>(source['restored'], TrashItem.fromMap),
      failed:
          readList<TrashBulkError>(source['failed'], TrashBulkError.fromMap),
    );
  }

  final List<TrashItem?>? restored;

  final List<TrashBulkError?>? failed;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'restored': restored,
        'failed': failed,
      };
}

/// The bulk delete's body: the rows deleted, each `type`, `id` and `name`, and
/// an entry per failed item.
class TrashBulkDeleteResult extends Dto {
  const TrashBulkDeleteResult({this.deleted, this.failed});

  /// Reads a bulk delete body.
  static TrashBulkDeleteResult? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TrashBulkDeleteResult(
      deleted: readList<TrashItem>(source['deleted'], TrashItem.fromMap),
      failed:
          readList<TrashBulkError>(source['failed'], TrashBulkError.fromMap),
    );
  }

  final List<TrashItem?>? deleted;

  final List<TrashBulkError?>? failed;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'deleted': deleted,
        'failed': failed,
      };
}

/// One item of a bulk body; `type` in any letter case, `id` a number.
class TrashBulkItemInput extends Dto {
  const TrashBulkItemInput({this.type, this.id});

  final String? type;

  final int? id;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'type': type,
        'id': id,
      };
}

/// The bulk body, `{"items": [...]}`, 1 to 100 items; no envelope.
class TrashBulkInput extends Dto {
  const TrashBulkInput({this.items});

  final List<TrashBulkItemInput?>? items;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'items': items,
      };
}
