# WebCommander Dart SDK

A Dart client for the WebCommander v4 REST API, with OAuth2 token management, retries, typed
response views and secret redaction in all output.

## Requirements

- Dart 3.5 or later (`environment: sdk: ^3.5.0`). A Flutter SDK includes Dart.
- API credentials for a WebCommander instance: base URL, client ID, client secret, redirect URI
  and auth string.
- A server, backend-for-frontend or command-line tool to run it in. The package compiles for the
  VM, Flutter and the web, but the credentials are operator credentials and must not be shipped in
  a mobile or browser app.

## Installation

```bash
dart pub add webcommander
```

or add it to `pubspec.yaml` and run `dart pub get`:

```yaml
dependencies:
  webcommander: ^4.0.0
```

Everything is exported from one library:

```dart
import 'package:webcommander/webcommander.dart';
```

## Quick start

```dart
import 'dart:io';

import 'package:webcommander/webcommander.dart';

Future<void> main() async {
  final client = WebCommanderClient(SdkConfig(AuthConfig(
    clientName: 'default',
    baseUrl: Platform.environment['WC_BASE_URL']!,
    clientId: Platform.environment['WC_CLIENT_ID']!,
    clientSecret: Platform.environment['WC_CLIENT_SECRET']!,
    redirectUri: Platform.environment['WC_REDIRECT_URI']!,
    authString: Platform.environment['WC_AUTH_STRING']!,
  )));

  try {
    final response = await client.adminCustomers.getCustomers(queryParams: {'limit': 20});
    if (!response.succeeded) {
      print('${response.statusCode} ${response.getErrorMessages()}');
      return;
    }
    final body = response.map! as Map<String, Object?>;
    for (final customer in body['customers']! as List<Object?>) {
      final record = customer! as Map<String, Object?>;
      print('${record['customer_id']}  ${record['email']}');
    }
  } finally {
    client.close();
  }
}
```

- The first call fetches a token, caches it and renews it before it expires.
- A failed call returns a response with `succeeded == false` unless you set `raiseOnError`.
- `close()` releases the HTTP client. A request on a closed client is refused with
  `SdkUsageError`; build a new client instead.
- The SDK never reads credentials from the environment or from `.env`. The example reads them in
  your code.

## Configuration

`AuthConfig` holds the credentials. `SdkConfig` wraps it and takes every behaviour setting as a
named argument, each with a default. The settings you are most likely to change:

| Setting | Default | Meaning |
|---|---|---|
| `raiseOnError` | `false` | Throw an `SdkError` when a call fails. |
| `responseFormat` | `'map'` | What `response.data` holds: `'map'`, `'json'` or `'dto'`. |
| `timeoutSeconds` | `30.0` | Time limit for one attempt. |
| `maxRetries` | `1` | Total attempts, so `1` means no retry. |
| `logLevel` | `'WARNING'` | Lowest level passed to the `onLog` hook and `logFile`. |
| `printApiInfo` | `false` | Print method, URL, status and timing for each call. |

```dart
final client = WebCommanderClient(SdkConfig(auth, maxRetries: 3, raiseOnError: true));
```

To register several instances once and pick one by name:

```dart
registerInstances([productionAuth, stagingAuth]);
final client = buildClient(instance: 'staging');
```

## Usage

### Bound and explicit calls

Each resource is a getter on the client, and each operation is also a top-level function that
takes the client first. Both run the same code:

```dart
await client.adminCustomers.getCustomer(1192);   // bound to the client
await getCustomer(client, 1192);                 // explicit client
```

Every operation takes optional named `raiseOnError` and `responseFormat` arguments that override
the config for that call.

For a path without an operation, use `sendGetRequest`, `sendPostRequest`, `sendPutRequest`,
`sendPatchRequest`, `sendDeleteRequest` or `sendApiRequest` with a path template. Each
resource's templates are constants on its `*Urls` class:

```dart
await client.sendGetRequest('/api/{api_version}/admin/customers/{customer_id}',
    pathParams: {'customer_id': 1192});
```

### Payload forms

A body is a `Map`, a raw JSON `String` or a payload DTO. A map and a DTO send the same bytes; a
string is sent exactly as written:

```dart
await client.adminCustomers.createCustomer({'customer': {'email': 'ada@example.com'}});
await client.adminCustomers.createCustomer('{"customer": {"email": "ada@example.com"}}');
await client.adminCustomers.createCustomer(CustomerInput(email: 'ada@example.com'));
```

Keys and query parameter names go to the API exactly as you write them.

### Response forms

The body is available in four forms:

```dart
final response = await client.adminCustomers.getCustomer(1192);

response.data;   // the form responseFormat selects; the decoded body by default
response.map;    // always the decoded body: Map, List, String or List<int>
response.json;   // always the body text as received
response.dto;    // always the typed view, or null where the endpoint declares none
```

Choose the form per call, per client, or with the `WC_RESPONSE_FORMAT` environment variable:

```dart
final response = await client.adminCustomers.getCustomers(responseFormat: 'dto');
final page = response.data! as Page<Customer>;
print(page.items?.first?.email);
```

### Pagination

`iterPages` and `iterRecords` follow `pagination.next_page` for you as a lazy `Stream`:

```dart
await for (final customer in iterRecords(
    client, CustomerUrls.adminCustomers, 'customers',
    queryParams: {'limit': 20})) {
  print(customer['customer_id']);
}
```

Most listings cap `limit` at 20.

## Error handling

By default a failed call returns its response. Check `succeeded`, then read the status and
messages:

```dart
final response = await client.adminCustomers.getCustomer(1192);
if (!response.succeeded) {
  print('${response.statusCode} ${response.errorType} ${response.getErrorMessages()}');
}
```

With `raiseOnError` a failed call throws. Every error extends `SdkError`:

```dart
try {
  await client.adminCustomers.getCustomer(1192, raiseOnError: true);
} on SdkAuthError {
  // credentials rejected
} on SdkError catch (error) {
  print('${error.statusCode} ${error.errorType} ${error.getErrorMessages()}');
  print(error.explain());
}
```

A `200` whose body carries `{"isSuccess": false}` counts as a failure. Configuration mistakes
(`SdkConfigError`) and caller mistakes caught before any request (`SdkUsageError`) always throw.

## Resources

The client exposes 46 resources with 349 operations. The method, path and behaviour of each one
are in the API reference at <https://newlify.mintlify.app>.

| Resource | Client accessor | Operations |
|---|---|---:|
| Customers | `client.adminCustomers` | 15 |
| Aliases | `client.aliases` | 4 |
| Animation effects settings | `client.animationEffects` | 5 |
| Blog categories | `client.blogCategories` | 5 |
| Blogs | `client.blogs` | 12 |
| Carts | `client.carts` | 7 |
| Categories | `client.categories` | 10 |
| Category page settings | `client.categoryPage` | 5 |
| Checkout page settings | `client.checkoutPage` | 5 |
| Cities | `client.cities` | 2 |
| Common settings | `client.commonSettings` | 6 |
| Countries | `client.countries` | 8 |
| Currencies | `client.currencies` | 11 |
| Customer groups | `client.customerGroups` | 9 |
| Customer portal settings | `client.customerPortal` | 5 |
| Discount profiles | `client.discountProfiles` | 7 |
| Ecommerce settings | `client.ecommerceSettings` | 5 |
| Email | `client.email` | 1 |
| Inventory locations | `client.inventoryLocations` | 11 |
| Order custom fields | `client.orderCustomFields` | 4 |
| Order flags | `client.orderFlags` | 7 |
| Orders | `client.orders` | 25 |
| Pages | `client.pages` | 15 |
| Payment gateways | `client.paymentGateways` | 8 |
| Price display settings | `client.priceDisplaySettings` | 5 |
| Product listing settings | `client.productListing` | 3 |
| Product page settings | `client.productPage` | 5 |
| Products | `client.products` | 10 |
| Search result page settings | `client.searchResultPage` | 13 |
| Search settings | `client.searchSettings` | 9 |
| SEO configuration | `client.seoConfiguration` | 18 |
| Shipping classes | `client.shippingClasses` | 9 |
| Shipping methods | `client.shippingMethods` | 9 |
| Shipping settings | `client.shippingSettings` | 3 |
| Shopping cart settings | `client.shoppingCart` | 5 |
| Site settings | `client.siteSettings` | 5 |
| Tax codes | `client.taxCodes` | 7 |
| Tax country taxes | `client.taxCountryTaxes` | 5 |
| Tax custom profiles | `client.taxCustomProfiles` | 5 |
| Tax profiles | `client.taxProfiles` | 7 |
| Tax rules | `client.taxRules` | 7 |
| Tax settings | `client.taxSettings` | 2 |
| Tax zones | `client.taxZones` | 7 |
| Transactions | `client.transactions` | 6 |
| Trash | `client.trash` | 8 |
| Variations | `client.variations` | 12 |

`client.listResourceNames()` returns the accessor names, and `client.resourceByName('orders')`
returns a resource by name.

## Documentation

- API reference: <https://newlify.mintlify.app>

## License

MIT. See [LICENSE](LICENSE).
