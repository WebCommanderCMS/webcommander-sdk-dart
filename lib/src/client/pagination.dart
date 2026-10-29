import '../errors.dart';
import 'api_response.dart';
import 'web_commander_client.dart';

/// One [ApiResponse] per page, following `pagination.next_page`.
Stream<ApiResponse> iterPages(
  WebCommanderClient client,
  String path, {
  Map<String, Object?>? queryParams,
  int? maxPages,
  bool raiseOnError = true,
}) async* {
  if (maxPages != null && maxPages < 1) {
    throw SdkUsageError(
        'maxPages: expected a positive integer or null, got $maxPages');
  }

  final visited = <String>{};
  var yielded = 0;

  var response = await client.sendGetRequest(path,
      queryParams: queryParams, raiseOnError: raiseOnError);

  while (true) {
    yield response;
    yielded++;

    if (!response.succeeded) return;
    if (maxPages != null && yielded >= maxPages) return;

    final nextPage = _readNextPage(response.map);
    if (nextPage == null) return;
    if (!visited.add(nextPage)) {
      throw SdkError('pagination loop at ${deriveEndpointTemplate(nextPage)}',
          requestInfo: response.requestInfo);
    }

    response =
        await client.sendGetRequest(nextPage, raiseOnError: raiseOnError);
  }
}

/// Each record of a listing, across every page.
Stream<Map<String, Object?>> iterRecords(
  WebCommanderClient client,
  String path,
  String recordKey, {
  Map<String, Object?>? queryParams,
  int? maxPages,
}) async* {
  if (recordKey.trim().isEmpty) {
    throw SdkUsageError(
        "recordKey: expected the envelope key holding the records, like 'customers', got "
        "'$recordKey'");
  }
  await for (final page in iterPages(client, path,
      queryParams: queryParams, maxPages: maxPages)) {
    yield* Stream<Map<String, Object?>>.fromIterable(
        _recordsOf(page, recordKey));
  }
}

String? _readNextPage(Object? data) {
  if (data is Map && data['pagination'] is Map) {
    final pagination = data['pagination'] as Map;
    final nextPage = pagination['next_page'];
    if (nextPage is String && nextPage.trim().isNotEmpty) return nextPage;
  }
  return null;
}

Iterable<Map<String, Object?>> _recordsOf(
    ApiResponse page, String recordKey) sync* {
  final data = page.map;
  if (data is Map && data[recordKey] is List) {
    for (final record in data[recordKey] as List) {
      // Checked, not cast: a `TypeError` here is not an `SdkError`.
      if (record is! Map) {
        throw SdkUsageError(
            "recordKey '$recordKey': the list under that key holds "
            '${record == null ? 'null' : record.runtimeType} rather than '
            'records; name the key that holds the objects');
      }
      yield record.cast<String, Object?>();
    }
    return;
  }
  final available = data is Map
      ? (data.keys.map((key) => key.toString()).toList()..sort()).join(', ')
      : 'a ${data.runtimeType} body';
  throw SdkUsageError(
      "recordKey '$recordKey': this page has no list under that key; it "
      'carries $available');
}
