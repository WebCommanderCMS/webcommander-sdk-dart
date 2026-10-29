/// Typed views over the tax settings bodies.
library;

import '../../client/dto.dart';

/// The nine keys the settings facade sends, flat.
class TaxSettings extends Dto {
  const TaxSettings({
    this.configurationType,
    this.systemDefaultTax,
    this.defaultCountry,
    this.customTaxProfileId,
    this.defaultTaxProfile,
    this.showPriceWithTax,
    this.isPriceWithTax,
    this.defaultTaxCode,
    this.taxMessage,
  });

  /// Reads the facade's `tax_settings` envelope, or a bare record.
  static TaxSettings? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'tax_settings');
    if (source == null) return null;
    return TaxSettings(
      configurationType: readText(source['configuration_type']),
      systemDefaultTax: readFlag(source['system_default_tax']),
      defaultCountry: readText(source['default_country']),
      customTaxProfileId: readInteger(source['custom_tax_profile_id']),
      defaultTaxProfile: readInteger(source['default_tax_profile']),
      showPriceWithTax: readFlag(source['show_price_with_tax']),
      isPriceWithTax: readFlag(source['is_price_with_tax']),
      defaultTaxCode: readText(source['default_tax_code']),
      taxMessage: readText(source['tax_message']),
    );
  }

  /// `configuration_type` — one of the types the store knows.
  final String? configurationType;

  final bool? systemDefaultTax;

  /// `default_country` — not checked by the write, which stores whatever is sent.
  final String? defaultCountry;

  /// `custom_tax_profile_id` — not checked by the write either.
  final int? customTaxProfileId;

  /// `default_tax_profile` — follows whichever tax profile holds `default`.
  final int? defaultTaxProfile;

  final bool? showPriceWithTax;

  final bool? isPriceWithTax;

  /// `default_tax_code` — not checked by the write.
  final String? defaultTaxCode;

  /// `tax_message` — free text.
  final String? taxMessage;

  @override
  String? get envelopeKey => 'tax_settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'configuration_type': configurationType,
        'system_default_tax': systemDefaultTax,
        'default_country': defaultCountry,
        'custom_tax_profile_id': customTaxProfileId,
        'default_tax_profile': defaultTaxProfile,
        'show_price_with_tax': showPriceWithTax,
        'is_price_with_tax': isPriceWithTax,
        'default_tax_code': defaultTaxCode,
        'tax_message': taxMessage,
      };
}

/// The body the settings `PUT` takes.
class TaxSettingsInput extends Dto {
  const TaxSettingsInput({
    this.configurationType,
    this.systemDefaultTax,
    this.defaultCountry,
    this.customTaxProfileId,
    this.defaultTaxProfile,
    this.showPriceWithTax,
    this.isPriceWithTax,
    this.defaultTaxCode,
    this.taxMessage,
  });

  /// `configuration_type` — checked before the write.
  final String? configurationType;

  final bool? systemDefaultTax;

  final String? defaultCountry;

  final int? customTaxProfileId;

  /// `default_tax_profile` — the id of the default tax profile.
  final int? defaultTaxProfile;

  final bool? showPriceWithTax;

  final bool? isPriceWithTax;

  final String? defaultTaxCode;

  final String? taxMessage;

  @override
  String? get envelopeKey => 'settings';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'configuration_type': configurationType,
        'system_default_tax': systemDefaultTax,
        'default_country': defaultCountry,
        'custom_tax_profile_id': customTaxProfileId,
        'default_tax_profile': defaultTaxProfile,
        'show_price_with_tax': showPriceWithTax,
        'is_price_with_tax': isPriceWithTax,
        'default_tax_code': defaultTaxCode,
        'tax_message': taxMessage,
      };
}
