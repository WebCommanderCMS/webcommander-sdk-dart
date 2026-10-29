/// Inventory location path templates; the client fills `{api_version}`.
class InventoryLocationUrls {
  InventoryLocationUrls._();

  /// List and create.
  static const String inventoryLocations =
      '/api/{api_version}/admin/inventory_locations';

  /// One location by id.
  static const String inventoryLocation =
      '/api/{api_version}/admin/inventory_locations/{inventory_location_id}';

  /// What one location holds.
  static const String inventoryLocationStock =
      '/api/{api_version}/admin/inventory_locations/{inventory_location_id}/stock';

  /// Hand one location the `default` flag. `PUT` only, and it takes no body.
  static const String inventoryLocationDefault =
      '/api/{api_version}/admin/inventory_locations/{inventory_location_id}/default';

  /// Move one location's `active`. `PUT` only, and `active` is required.
  static const String inventoryLocationStatus =
      '/api/{api_version}/admin/inventory_locations/{inventory_location_id}/status';
}
