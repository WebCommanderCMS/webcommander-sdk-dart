import '../../client/api_response.dart';
import '../../client/web_commander_client.dart';
import 'gift_cards_dto.dart';
import 'gift_cards_urls.dart';

/// Gift card endpoints, bound to one client.
class GiftCards {
  /// Bind the resource to a client; normally reached via `client.giftCards`.
  GiftCards(this._client);

  final WebCommanderClient _client;

  /// List gift cards — `GET /admin/gift_cards`, newest first.
  Future<ApiResponse> listGiftCards({
    Map<String, Object?>? queryParams,
    bool? raiseOnError,
    String? responseFormat,
  }) =>
      _listGiftCards(_client,
          queryParams: queryParams,
          raiseOnError: raiseOnError,
          responseFormat: responseFormat);
}

/// List gift cards — `GET /admin/gift_cards`, newest first. `code` matches a
/// whole code and `email` a whole address, in any case; `is_active` takes
/// `true`, `false`, `1` or `0`, and `limit` caps at 20 with `offset` or `page`
/// to move on. Any other name is `400` `unknown_parameter`.
Future<ApiResponse> listGiftCards(WebCommanderClient client,
        {Map<String, Object?>? queryParams,
        bool? raiseOnError,
        String? responseFormat}) =>
    client.sendGetRequest(GiftCardUrls.giftCards,
        queryParams: queryParams,
        raiseOnError: raiseOnError,
        responseFormat: responseFormat,
        dtoDecoder: GiftCardPage.fromMap);

final _listGiftCards = listGiftCards;
