import '../errors.dart';
import 'web_commander_client.dart';

/// Builds one resource family over a client.
typedef ResourceFactory = Object Function(WebCommanderClient client);

final Map<String, ResourceFactory> _resourceModules = <String, ResourceFactory>{
  'adminCustomers': (WebCommanderClient client) => client.adminCustomers,
  'seoConfiguration': (WebCommanderClient client) => client.seoConfiguration,
  'searchResultPage': (WebCommanderClient client) => client.searchResultPage,
  'categoryPage': (WebCommanderClient client) => client.categoryPage,
  'shoppingCart': (WebCommanderClient client) => client.shoppingCart,
  'productPage': (WebCommanderClient client) => client.productPage,
  'checkoutPage': (WebCommanderClient client) => client.checkoutPage,
  'priceDisplaySettings': (WebCommanderClient client) =>
      client.priceDisplaySettings,
  'animationEffects': (WebCommanderClient client) => client.animationEffects,
  'productListing': (WebCommanderClient client) => client.productListing,
  'customerPortal': (WebCommanderClient client) => client.customerPortal,
  'siteSettings': (WebCommanderClient client) => client.siteSettings,
  'shippingSettings': (WebCommanderClient client) => client.shippingSettings,
  'searchSettings': (WebCommanderClient client) => client.searchSettings,
  'ecommerceSettings': (WebCommanderClient client) => client.ecommerceSettings,
  'orderFlags': (WebCommanderClient client) => client.orderFlags,
  'inventoryLocations': (WebCommanderClient client) =>
      client.inventoryLocations,
  'shippingMethods': (WebCommanderClient client) => client.shippingMethods,
  'shippingClasses': (WebCommanderClient client) => client.shippingClasses,
  'aliases': (WebCommanderClient client) => client.aliases,
  'countries': (WebCommanderClient client) => client.countries,
  'orders': (WebCommanderClient client) => client.orders,
  'carts': (WebCommanderClient client) => client.carts,
  'discountProfiles': (WebCommanderClient client) => client.discountProfiles,
  'categories': (WebCommanderClient client) => client.categories,
  'blogCategories': (WebCommanderClient client) => client.blogCategories,
  'orderCustomFields': (WebCommanderClient client) => client.orderCustomFields,
  'taxCodes': (WebCommanderClient client) => client.taxCodes,
  'taxProfiles': (WebCommanderClient client) => client.taxProfiles,
  'taxRules': (WebCommanderClient client) => client.taxRules,
  'taxZones': (WebCommanderClient client) => client.taxZones,
  'taxSettings': (WebCommanderClient client) => client.taxSettings,
  'taxCountryTaxes': (WebCommanderClient client) => client.taxCountryTaxes,
  'taxCustomProfiles': (WebCommanderClient client) => client.taxCustomProfiles,
  'blogs': (WebCommanderClient client) => client.blogs,
  'products': (WebCommanderClient client) => client.products,
  'currencies': (WebCommanderClient client) => client.currencies,
  'customerGroups': (WebCommanderClient client) => client.customerGroups,
  'variations': (WebCommanderClient client) => client.variations,
  'cities': (WebCommanderClient client) => client.cities,
  'transactions': (WebCommanderClient client) => client.transactions,
  'paymentGateways': (WebCommanderClient client) => client.paymentGateways,
  'trash': (WebCommanderClient client) => client.trash,
  'email': (WebCommanderClient client) => client.email,
  'commonSettings': (WebCommanderClient client) => client.commonSettings,
  'pages': (WebCommanderClient client) => client.pages,
};

/// Make a resource family reachable through `client.resourceByName(resourceName)`.
void registerResourceModule(String resourceName, ResourceFactory factory) {
  final registered = _resourceModules[resourceName];
  if (registered != null && registered != factory) {
    throw SdkUsageError(
        "cannot register resource '$resourceName': it is already registered "
        'against a different factory, and clients built before the change would '
        'keep the old one - pick another name');
  }
  _resourceModules[resourceName] = factory;
}

/// Every registered resource name, sorted, so the order does not depend on registration order.
List<String> registeredResourceNames() =>
    List<String>.unmodifiable(_resourceModules.keys.toList()..sort());

/// The factory registered under [resourceName].
ResourceFactory resolveResourceModule(String resourceName) {
  final factory = _resourceModules[resourceName];
  if (factory == null) {
    throw SdkAttributeError("no resource '$resourceName'; available: "
        '${registeredResourceNames().join(', ')}');
  }
  return factory;
}

/// A resource family with its client already applied, looked up by name.
class BoundResource {
  /// Bind the family registered under [name] to [client].
  BoundResource(this.name, WebCommanderClient client)
      : value = resolveResourceModule(name)(client);

  /// The registered resource name, e.g. `'adminCustomers'`.
  final String name;

  /// The constructed family; cast it to its concrete type.
  final Object value;

  @override
  String toString() => "BoundResource('$name', ${value.runtimeType})";
}
