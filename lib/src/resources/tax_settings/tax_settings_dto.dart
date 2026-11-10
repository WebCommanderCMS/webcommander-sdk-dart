/// Typed views over the tax settings bodies.
library;

import '../../client/dto.dart';

/// The country tax the store charges by default, as `tax_region` reads it.
class TaxRegion extends Dto {
  const TaxRegion({this.countryTaxId, this.countryCode, this.countryName});

  /// Reads `tax_region`.
  static TaxRegion? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxRegion(
      countryTaxId: readInteger(source['country_tax_id']),
      countryCode: readText(source['country_code']),
      countryName: readText(source['country_name']),
    );
  }

  final int? countryTaxId;

  final String? countryCode;

  final String? countryName;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country_tax_id': countryTaxId,
        'country_code': countryCode,
        'country_name': countryName,
      };
}

/// A custom tax profile as a read names it: its id and name, or `null`.
class TaxProfileReference extends Dto {
  const TaxProfileReference({this.id, this.name});

  /// Reads `custom_tax_profile`.
  static TaxProfileReference? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxProfileReference(
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
class TaxSettingsAreaMeta extends Dto {
  const TaxSettingsAreaMeta({this.kind, this.writable, this.href});

  /// Reads one `group_meta` entry.
  static TaxSettingsAreaMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxSettingsAreaMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  final String? kind;

  final bool? writable;

  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block: the settings area and the two tax collections
/// beside it.
class TaxSettingsGroupMeta extends Dto {
  const TaxSettingsGroupMeta({
    this.taxSettings,
    this.taxProfiles,
    this.taxRules,
  });

  /// Reads `group_meta`.
  static TaxSettingsGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return TaxSettingsGroupMeta(
      taxSettings: TaxSettingsAreaMeta.fromMap(source['tax_settings']),
      taxProfiles: TaxSettingsAreaMeta.fromMap(source['tax_profiles']),
      taxRules: TaxSettingsAreaMeta.fromMap(source['tax_rules']),
    );
  }

  final TaxSettingsAreaMeta? taxSettings;

  final TaxSettingsAreaMeta? taxProfiles;

  final TaxSettingsAreaMeta? taxRules;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_settings': taxSettings,
        'tax_profiles': taxProfiles,
        'tax_rules': taxRules,
      };
}

/// The nine keys under `tax_settings`, with `group_meta` and, when asked for,
/// `field_metadata`.
class TaxSettings extends Dto {
  const TaxSettings({
    this.taxRateForCustomers,
    this.taxRegion,
    this.customTaxProfile,
    this.isPriceShownWithTax,
    this.pricesInCatalog,
    this.calculatedBy,
    this.isOutOfRegionTaxFree,
    this.taxMessage,
    this.basePriceRounding,
    this.groupMeta,
    this.fieldMetadata,
  });

  /// Reads the facade's `tax_settings` envelope, or a bare record.
  static TaxSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_settings');
    if (source == null) return null;
    return TaxSettings(
      taxRateForCustomers: readText(source['tax_rate_for_customers']),
      taxRegion: TaxRegion.fromMap(source['tax_region']),
      customTaxProfile:
          TaxProfileReference.fromMap(source['custom_tax_profile']),
      isPriceShownWithTax: readFlag(source['is_price_shown_with_tax']),
      pricesInCatalog: readText(source['prices_in_catalog']),
      calculatedBy: readText(source['calculated_by']),
      isOutOfRegionTaxFree: readFlag(source['is_out_of_region_tax_free']),
      taxMessage: readText(source['tax_message']),
      basePriceRounding: readText(source['base_price_rounding']),
      groupMeta: TaxSettingsGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  /// `tax_rate_for_customers` — `system_default` or `custom_tax_profile`.
  final String? taxRateForCustomers;

  final TaxRegion? taxRegion;

  final TaxProfileReference? customTaxProfile;

  final bool? isPriceShownWithTax;

  /// `prices_in_catalog` — `excluding_tax` or `including_tax`.
  final String? pricesInCatalog;

  /// `calculated_by` — read-only.
  final String? calculatedBy;

  final bool? isOutOfRegionTaxFree;

  /// `tax_message` — free text, or `null`.
  final String? taxMessage;

  /// `base_price_rounding` — `nearest`, `up` or `down`.
  final String? basePriceRounding;

  final TaxSettingsGroupMeta? groupMeta;

  /// `field_metadata` — only when the read asks for it with `field_metadata=true`.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'tax_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_rate_for_customers': taxRateForCustomers,
        'tax_region': taxRegion,
        'custom_tax_profile': customTaxProfile,
        'is_price_shown_with_tax': isPriceShownWithTax,
        'prices_in_catalog': pricesInCatalog,
        'calculated_by': calculatedBy,
        'is_out_of_region_tax_free': isOutOfRegionTaxFree,
        'tax_message': taxMessage,
        'base_price_rounding': basePriceRounding,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}

/// `tax_region` as a write takes it: a `country_code` (with an optional
/// `state_code`) or a `country_tax_id`.
class TaxRegionInput extends Dto {
  const TaxRegionInput({this.countryTaxId, this.countryCode, this.stateCode});

  final int? countryTaxId;

  final String? countryCode;

  final String? stateCode;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'country_tax_id': countryTaxId,
        'country_code': countryCode,
        'state_code': stateCode,
      };
}

/// The body `PUT` and `PATCH` take, wrapped in `tax_settings`; both merge. The
/// profile is written as `custom_tax_profile_id`; `calculated_by` is read-only.
class TaxSettingsInput extends Dto {
  const TaxSettingsInput({
    this.taxRateForCustomers,
    this.taxRegion,
    this.customTaxProfileId,
    this.isPriceShownWithTax,
    this.pricesInCatalog,
    this.isOutOfRegionTaxFree,
    this.taxMessage,
    this.basePriceRounding,
  });

  final String? taxRateForCustomers;

  final TaxRegionInput? taxRegion;

  final int? customTaxProfileId;

  final bool? isPriceShownWithTax;

  final String? pricesInCatalog;

  final bool? isOutOfRegionTaxFree;

  final String? taxMessage;

  final String? basePriceRounding;

  @override
  String? get envelopeKey => 'tax_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tax_rate_for_customers': taxRateForCustomers,
        'tax_region': taxRegion,
        'custom_tax_profile_id': customTaxProfileId,
        'is_price_shown_with_tax': isPriceShownWithTax,
        'prices_in_catalog': pricesInCatalog,
        'is_out_of_region_tax_free': isOutOfRegionTaxFree,
        'tax_message': taxMessage,
        'base_price_rounding': basePriceRounding,
      };
}
