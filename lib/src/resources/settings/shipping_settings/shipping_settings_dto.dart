/// Typed views over the shipping settings body.
library;

import '../../../client/dto.dart';

/// What a reference field holds: the id the store keeps and the name it
/// resolves to, or `null`.
class ProfileReference extends Dto {
  const ProfileReference({this.id, this.name});

  static ProfileReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProfileReference(
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

/// One `group_meta` entry: what the area is, whether it can be written, and
/// its path.
class AreaMeta extends Dto {
  const AreaMeta({this.kind, this.writable, this.href});

  static AreaMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AreaMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on the settings entry.
  final String? kind;

  /// `writable` — `true` on the settings entry.
  final bool? writable;

  /// `href` — the path of the area the entry names.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block: the settings area and the two collections beside it.
class ShippingSettingsGroupMeta extends Dto {
  const ShippingSettingsGroupMeta({
    this.shippingSettings,
    this.shippingMethods,
    this.shippingClasses,
  });

  static ShippingSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingSettingsGroupMeta(
      shippingSettings: AreaMeta.fromMap(source['shipping_settings']),
      shippingMethods: AreaMeta.fromMap(source['shipping_methods']),
      shippingClasses: AreaMeta.fromMap(source['shipping_classes']),
    );
  }

  final AreaMeta? shippingSettings;

  final AreaMeta? shippingMethods;

  final AreaMeta? shippingClasses;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_settings': shippingSettings,
        'shipping_methods': shippingMethods,
        'shipping_classes': shippingClasses,
      };
}

/// The shipping settings: seven fields flat under `shipping_settings`.
class ShippingSettings extends Dto {
  const ShippingSettings({
    this.defaultShippingProfile,
    this.applyStoreTaxSettingsToShipping,
    this.defaultDeliveryProfile,
    this.applyStoreTaxSettingsToDelivery,
    this.shippingTaxProfile,
    this.enableShippingClass,
    this.enableClassInFlatView,
    this.groupMeta,
    this.fieldMetadata,
  });

  static ShippingSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_settings');
    if (source == null) return null;
    return ShippingSettings(
      defaultShippingProfile:
          ProfileReference.fromMap(source['default_shipping_profile']),
      applyStoreTaxSettingsToShipping:
          readFlag(source['apply_store_tax_settings_to_shipping']),
      defaultDeliveryProfile:
          ProfileReference.fromMap(source['default_delivery_profile']),
      applyStoreTaxSettingsToDelivery:
          readFlag(source['apply_store_tax_settings_to_delivery']),
      shippingTaxProfile:
          ProfileReference.fromMap(source['shipping_tax_profile']),
      enableShippingClass: readFlag(source['enable_shipping_class']),
      enableClassInFlatView: readFlag(source['enable_class_in_flat_view']),
      groupMeta: ShippingSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final ProfileReference? defaultShippingProfile;

  final bool? applyStoreTaxSettingsToShipping;

  final ProfileReference? defaultDeliveryProfile;

  final bool? applyStoreTaxSettingsToDelivery;

  final ProfileReference? shippingTaxProfile;

  final bool? enableShippingClass;

  /// `enable_class_in_flat_view` — gated by [enableShippingClass], which also moves it.
  final bool? enableClassInFlatView;

  /// `group_meta` — beside the settings on every answer this area sends.
  final ShippingSettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'shipping_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'default_shipping_profile': defaultShippingProfile,
        'apply_store_tax_settings_to_shipping': applyStoreTaxSettingsToShipping,
        'default_delivery_profile': defaultDeliveryProfile,
        'apply_store_tax_settings_to_delivery': applyStoreTaxSettingsToDelivery,
        'shipping_tax_profile': shippingTaxProfile,
        'enable_shipping_class': enableShippingClass,
        'enable_class_in_flat_view': enableClassInFlatView,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
