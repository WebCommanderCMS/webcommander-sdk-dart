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

/// The `group_meta` entry: what the area is and whether it can be written.
class AreaMeta extends Dto {
  const AreaMeta({this.kind, this.writable});

  static AreaMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AreaMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
    );
  }

  /// `kind` — `"setting"` on the one entry here.
  final String? kind;

  /// `writable` — `true` on the one entry here.
  final bool? writable;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
      };
}

/// The `group_meta` block — a single [AreaMeta], keyed by the area itself.
class ShippingSettingsGroupMeta extends Dto {
  const ShippingSettingsGroupMeta({this.shippingSettings});

  static ShippingSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ShippingSettingsGroupMeta(
      shippingSettings: AreaMeta.fromMap(source['shipping_settings']),
    );
  }

  final AreaMeta? shippingSettings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'shipping_settings': shippingSettings,
      };
}

/// The shipping settings: seven fields flat under `shipping_settings`.
class ShippingSettings extends Dto {
  const ShippingSettings({
    this.defaultShippingProfile,
    this.enableShippingDefaultTax,
    this.defaultDeliveryProfile,
    this.enableDeliveryDefaultTax,
    this.shippingTaxProfile,
    this.enableShippingClass,
    this.enableFlatViewClass,
    this.groupMeta,
    this.fieldMetadata,
  });

  static ShippingSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'shipping_settings');
    if (source == null) return null;
    return ShippingSettings(
      defaultShippingProfile:
          ProfileReference.fromMap(source['default_shipping_profile']),
      enableShippingDefaultTax: readFlag(source['enable_shipping_default_tax']),
      defaultDeliveryProfile:
          ProfileReference.fromMap(source['default_delivery_profile']),
      enableDeliveryDefaultTax: readFlag(source['enable_delivery_default_tax']),
      shippingTaxProfile:
          ProfileReference.fromMap(source['shipping_tax_profile']),
      enableShippingClass: readFlag(source['enable_shipping_class']),
      enableFlatViewClass: readFlag(source['enable_flat_view_class']),
      groupMeta: ShippingSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final ProfileReference? defaultShippingProfile;

  final bool? enableShippingDefaultTax;

  final ProfileReference? defaultDeliveryProfile;

  final bool? enableDeliveryDefaultTax;

  final ProfileReference? shippingTaxProfile;

  final bool? enableShippingClass;

  /// `enable_flat_view_class` — gated by [enableShippingClass], which also moves it.
  final bool? enableFlatViewClass;

  /// `group_meta` — beside the settings on every answer this area sends.
  final ShippingSettingsGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'shipping_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'default_shipping_profile': defaultShippingProfile,
        'enable_shipping_default_tax': enableShippingDefaultTax,
        'default_delivery_profile': defaultDeliveryProfile,
        'enable_delivery_default_tax': enableDeliveryDefaultTax,
        'shipping_tax_profile': shippingTaxProfile,
        'enable_shipping_class': enableShippingClass,
        'enable_flat_view_class': enableFlatViewClass,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
