/// Typed views over the common settings bodies.
library;

import '../../client/dto.dart';

/// One entry of a settings group, for a write's lists; a read's entries have
/// the same keys. A value is text, `***` on a read of a masked one.
class Setting extends Dto {
  const Setting({this.configKey, this.value});

  final String? configKey;

  final String? value;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'config_key': configKey,
        'value': value,
      };
}

/// What the read and both writes answer: `settings`, group name to a list of
/// `{"config_key", "value"}` maps.
class CommonSettings extends Dto {
  const CommonSettings({this.settings});

  /// Reads a settings body.
  static CommonSettings? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CommonSettings(settings: readAny(source['settings']));
  }

  /// `settings` — not typed: the `notifications` group alone is a map of name
  /// to `bool`, not a list.
  final Object? settings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'settings': settings,
      };
}

/// The list form both writes take: `settings` maps a group name to its
/// [Setting] entries. A group as `{config_key: value}` or
/// `{name: {"config_key", "value"}}` goes as a `Map` or a JSON `String`.
class CommonSettingsInput extends Dto {
  const CommonSettingsInput({this.settings});

  final Map<String, List<Setting>>? settings;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'settings': settings,
      };
}

/// The registration form's `fields_configs`: six keys for each of the store's
/// 20 fields. `_active` and `_required` are booleans here, though the settings
/// read answers them as text.
class CustomerFieldConfigs extends Dto {
  const CustomerFieldConfigs({
    this.firstNameOrder,
    this.firstNameKey,
    this.firstNameLabel,
    this.firstNamePlaceholder,
    this.firstNameActive,
    this.firstNameRequired,
    this.lastNameOrder,
    this.lastNameKey,
    this.lastNameLabel,
    this.lastNamePlaceholder,
    this.lastNameActive,
    this.lastNameRequired,
    this.addressLine1Order,
    this.addressLine1Key,
    this.addressLine1Label,
    this.addressLine1Placeholder,
    this.addressLine1Active,
    this.addressLine1Required,
    this.addressLine2Order,
    this.addressLine2Key,
    this.addressLine2Label,
    this.addressLine2Placeholder,
    this.addressLine2Active,
    this.addressLine2Required,
    this.postCodeOrder,
    this.postCodeKey,
    this.postCodeLabel,
    this.postCodePlaceholder,
    this.postCodeActive,
    this.postCodeRequired,
    this.cityOrder,
    this.cityKey,
    this.cityLabel,
    this.cityPlaceholder,
    this.cityActive,
    this.cityRequired,
    this.phoneOrder,
    this.phoneKey,
    this.phoneLabel,
    this.phonePlaceholder,
    this.phoneActive,
    this.phoneRequired,
    this.mobileOrder,
    this.mobileKey,
    this.mobileLabel,
    this.mobilePlaceholder,
    this.mobileActive,
    this.mobileRequired,
    this.faxOrder,
    this.faxKey,
    this.faxLabel,
    this.faxPlaceholder,
    this.faxActive,
    this.faxRequired,
    this.emailOrder,
    this.emailKey,
    this.emailLabel,
    this.emailPlaceholder,
    this.emailActive,
    this.emailRequired,
    this.confirmEmailOrder,
    this.confirmEmailKey,
    this.confirmEmailLabel,
    this.confirmEmailPlaceholder,
    this.confirmEmailActive,
    this.confirmEmailRequired,
    this.passwordOrder,
    this.passwordKey,
    this.passwordLabel,
    this.passwordPlaceholder,
    this.passwordActive,
    this.passwordRequired,
    this.retypePasswordOrder,
    this.retypePasswordKey,
    this.retypePasswordLabel,
    this.retypePasswordPlaceholder,
    this.retypePasswordActive,
    this.retypePasswordRequired,
    this.countryOrder,
    this.countryKey,
    this.countryLabel,
    this.countryPlaceholder,
    this.countryActive,
    this.countryRequired,
    this.customerTypeOrder,
    this.customerTypeKey,
    this.customerTypeLabel,
    this.customerTypePlaceholder,
    this.customerTypeActive,
    this.customerTypeRequired,
    this.sexOrder,
    this.sexKey,
    this.sexLabel,
    this.sexPlaceholder,
    this.sexActive,
    this.sexRequired,
    this.abnOrder,
    this.abnKey,
    this.abnLabel,
    this.abnPlaceholder,
    this.abnActive,
    this.abnRequired,
    this.abnBranchOrder,
    this.abnBranchKey,
    this.abnBranchLabel,
    this.abnBranchPlaceholder,
    this.abnBranchActive,
    this.abnBranchRequired,
    this.companyNameOrder,
    this.companyNameKey,
    this.companyNameLabel,
    this.companyNamePlaceholder,
    this.companyNameActive,
    this.companyNameRequired,
    this.dateOfBirthOrder,
    this.dateOfBirthKey,
    this.dateOfBirthLabel,
    this.dateOfBirthPlaceholder,
    this.dateOfBirthActive,
    this.dateOfBirthRequired,
  });

  /// Reads the `fields_configs` block.
  static CustomerFieldConfigs? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerFieldConfigs(
      firstNameOrder: readText(source['first_name_order']),
      firstNameKey: readText(source['first_name_key']),
      firstNameLabel: readText(source['first_name_label']),
      firstNamePlaceholder: readText(source['first_name_placeholder']),
      firstNameActive: readFlag(source['first_name_active']),
      firstNameRequired: readFlag(source['first_name_required']),
      lastNameOrder: readText(source['last_name_order']),
      lastNameKey: readText(source['last_name_key']),
      lastNameLabel: readText(source['last_name_label']),
      lastNamePlaceholder: readText(source['last_name_placeholder']),
      lastNameActive: readFlag(source['last_name_active']),
      lastNameRequired: readFlag(source['last_name_required']),
      addressLine1Order: readText(source['address_line_1_order']),
      addressLine1Key: readText(source['address_line_1_key']),
      addressLine1Label: readText(source['address_line_1_label']),
      addressLine1Placeholder: readText(source['address_line_1_placeholder']),
      addressLine1Active: readFlag(source['address_line_1_active']),
      addressLine1Required: readFlag(source['address_line_1_required']),
      addressLine2Order: readText(source['address_line_2_order']),
      addressLine2Key: readText(source['address_line_2_key']),
      addressLine2Label: readText(source['address_line_2_label']),
      addressLine2Placeholder: readText(source['address_line_2_placeholder']),
      addressLine2Active: readFlag(source['address_line_2_active']),
      addressLine2Required: readFlag(source['address_line_2_required']),
      postCodeOrder: readText(source['post_code_order']),
      postCodeKey: readText(source['post_code_key']),
      postCodeLabel: readText(source['post_code_label']),
      postCodePlaceholder: readText(source['post_code_placeholder']),
      postCodeActive: readFlag(source['post_code_active']),
      postCodeRequired: readFlag(source['post_code_required']),
      cityOrder: readText(source['city_order']),
      cityKey: readText(source['city_key']),
      cityLabel: readText(source['city_label']),
      cityPlaceholder: readText(source['city_placeholder']),
      cityActive: readFlag(source['city_active']),
      cityRequired: readFlag(source['city_required']),
      phoneOrder: readText(source['phone_order']),
      phoneKey: readText(source['phone_key']),
      phoneLabel: readText(source['phone_label']),
      phonePlaceholder: readText(source['phone_placeholder']),
      phoneActive: readFlag(source['phone_active']),
      phoneRequired: readFlag(source['phone_required']),
      mobileOrder: readText(source['mobile_order']),
      mobileKey: readText(source['mobile_key']),
      mobileLabel: readText(source['mobile_label']),
      mobilePlaceholder: readText(source['mobile_placeholder']),
      mobileActive: readFlag(source['mobile_active']),
      mobileRequired: readFlag(source['mobile_required']),
      faxOrder: readText(source['fax_order']),
      faxKey: readText(source['fax_key']),
      faxLabel: readText(source['fax_label']),
      faxPlaceholder: readText(source['fax_placeholder']),
      faxActive: readFlag(source['fax_active']),
      faxRequired: readFlag(source['fax_required']),
      emailOrder: readText(source['email_order']),
      emailKey: readText(source['email_key']),
      emailLabel: readText(source['email_label']),
      emailPlaceholder: readText(source['email_placeholder']),
      emailActive: readFlag(source['email_active']),
      emailRequired: readFlag(source['email_required']),
      confirmEmailOrder: readText(source['confirm_email_order']),
      confirmEmailKey: readText(source['confirm_email_key']),
      confirmEmailLabel: readText(source['confirm_email_label']),
      confirmEmailPlaceholder: readText(source['confirm_email_placeholder']),
      confirmEmailActive: readFlag(source['confirm_email_active']),
      confirmEmailRequired: readFlag(source['confirm_email_required']),
      passwordOrder: readText(source['password_order']),
      passwordKey: readText(source['password_key']),
      passwordLabel: readText(source['password_label']),
      passwordPlaceholder: readText(source['password_placeholder']),
      passwordActive: readFlag(source['password_active']),
      passwordRequired: readFlag(source['password_required']),
      retypePasswordOrder: readText(source['retype_password_order']),
      retypePasswordKey: readText(source['retype_password_key']),
      retypePasswordLabel: readText(source['retype_password_label']),
      retypePasswordPlaceholder:
          readText(source['retype_password_placeholder']),
      retypePasswordActive: readFlag(source['retype_password_active']),
      retypePasswordRequired: readFlag(source['retype_password_required']),
      countryOrder: readText(source['country_order']),
      countryKey: readText(source['country_key']),
      countryLabel: readText(source['country_label']),
      countryPlaceholder: readText(source['country_placeholder']),
      countryActive: readFlag(source['country_active']),
      countryRequired: readFlag(source['country_required']),
      customerTypeOrder: readText(source['customer_type_order']),
      customerTypeKey: readText(source['customer_type_key']),
      customerTypeLabel: readText(source['customer_type_label']),
      customerTypePlaceholder: readText(source['customer_type_placeholder']),
      customerTypeActive: readFlag(source['customer_type_active']),
      customerTypeRequired: readFlag(source['customer_type_required']),
      sexOrder: readText(source['sex_order']),
      sexKey: readText(source['sex_key']),
      sexLabel: readText(source['sex_label']),
      sexPlaceholder: readText(source['sex_placeholder']),
      sexActive: readFlag(source['sex_active']),
      sexRequired: readFlag(source['sex_required']),
      abnOrder: readText(source['abn_order']),
      abnKey: readText(source['abn_key']),
      abnLabel: readText(source['abn_label']),
      abnPlaceholder: readText(source['abn_placeholder']),
      abnActive: readFlag(source['abn_active']),
      abnRequired: readFlag(source['abn_required']),
      abnBranchOrder: readText(source['abn_branch_order']),
      abnBranchKey: readText(source['abn_branch_key']),
      abnBranchLabel: readText(source['abn_branch_label']),
      abnBranchPlaceholder: readText(source['abn_branch_placeholder']),
      abnBranchActive: readFlag(source['abn_branch_active']),
      abnBranchRequired: readFlag(source['abn_branch_required']),
      companyNameOrder: readText(source['company_name_order']),
      companyNameKey: readText(source['company_name_key']),
      companyNameLabel: readText(source['company_name_label']),
      companyNamePlaceholder: readText(source['company_name_placeholder']),
      companyNameActive: readFlag(source['company_name_active']),
      companyNameRequired: readFlag(source['company_name_required']),
      dateOfBirthOrder: readText(source['date_of_birth_order']),
      dateOfBirthKey: readText(source['date_of_birth_key']),
      dateOfBirthLabel: readText(source['date_of_birth_label']),
      dateOfBirthPlaceholder: readText(source['date_of_birth_placeholder']),
      dateOfBirthActive: readFlag(source['date_of_birth_active']),
      dateOfBirthRequired: readFlag(source['date_of_birth_required']),
    );
  }

  /// `first_name_order` — every `_order` reads as text, such as `"1"`.
  final String? firstNameOrder;

  final String? firstNameKey;

  final String? firstNameLabel;

  final String? firstNamePlaceholder;

  final bool? firstNameActive;

  final bool? firstNameRequired;

  final String? lastNameOrder;

  final String? lastNameKey;

  final String? lastNameLabel;

  final String? lastNamePlaceholder;

  final bool? lastNameActive;

  final bool? lastNameRequired;

  final String? addressLine1Order;

  final String? addressLine1Key;

  final String? addressLine1Label;

  final String? addressLine1Placeholder;

  final bool? addressLine1Active;

  final bool? addressLine1Required;

  final String? addressLine2Order;

  final String? addressLine2Key;

  final String? addressLine2Label;

  final String? addressLine2Placeholder;

  final bool? addressLine2Active;

  final bool? addressLine2Required;

  final String? postCodeOrder;

  final String? postCodeKey;

  final String? postCodeLabel;

  final String? postCodePlaceholder;

  final bool? postCodeActive;

  final bool? postCodeRequired;

  final String? cityOrder;

  final String? cityKey;

  final String? cityLabel;

  final String? cityPlaceholder;

  final bool? cityActive;

  final bool? cityRequired;

  final String? phoneOrder;

  final String? phoneKey;

  final String? phoneLabel;

  final String? phonePlaceholder;

  final bool? phoneActive;

  final bool? phoneRequired;

  final String? mobileOrder;

  final String? mobileKey;

  final String? mobileLabel;

  final String? mobilePlaceholder;

  final bool? mobileActive;

  final bool? mobileRequired;

  final String? faxOrder;

  final String? faxKey;

  final String? faxLabel;

  final String? faxPlaceholder;

  final bool? faxActive;

  final bool? faxRequired;

  final String? emailOrder;

  final String? emailKey;

  final String? emailLabel;

  final String? emailPlaceholder;

  final bool? emailActive;

  final bool? emailRequired;

  final String? confirmEmailOrder;

  final String? confirmEmailKey;

  final String? confirmEmailLabel;

  final String? confirmEmailPlaceholder;

  final bool? confirmEmailActive;

  final bool? confirmEmailRequired;

  final String? passwordOrder;

  final String? passwordKey;

  final String? passwordLabel;

  final String? passwordPlaceholder;

  final bool? passwordActive;

  final bool? passwordRequired;

  final String? retypePasswordOrder;

  final String? retypePasswordKey;

  final String? retypePasswordLabel;

  final String? retypePasswordPlaceholder;

  final bool? retypePasswordActive;

  final bool? retypePasswordRequired;

  final String? countryOrder;

  final String? countryKey;

  final String? countryLabel;

  final String? countryPlaceholder;

  final bool? countryActive;

  final bool? countryRequired;

  final String? customerTypeOrder;

  final String? customerTypeKey;

  final String? customerTypeLabel;

  final String? customerTypePlaceholder;

  final bool? customerTypeActive;

  final bool? customerTypeRequired;

  final String? sexOrder;

  final String? sexKey;

  final String? sexLabel;

  final String? sexPlaceholder;

  final bool? sexActive;

  final bool? sexRequired;

  final String? abnOrder;

  final String? abnKey;

  final String? abnLabel;

  final String? abnPlaceholder;

  final bool? abnActive;

  final bool? abnRequired;

  final String? abnBranchOrder;

  final String? abnBranchKey;

  final String? abnBranchLabel;

  final String? abnBranchPlaceholder;

  final bool? abnBranchActive;

  final bool? abnBranchRequired;

  final String? companyNameOrder;

  final String? companyNameKey;

  final String? companyNameLabel;

  final String? companyNamePlaceholder;

  final bool? companyNameActive;

  final bool? companyNameRequired;

  final String? dateOfBirthOrder;

  final String? dateOfBirthKey;

  final String? dateOfBirthLabel;

  final String? dateOfBirthPlaceholder;

  final bool? dateOfBirthActive;

  final bool? dateOfBirthRequired;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'first_name_order': firstNameOrder,
        'first_name_key': firstNameKey,
        'first_name_label': firstNameLabel,
        'first_name_placeholder': firstNamePlaceholder,
        'first_name_active': firstNameActive,
        'first_name_required': firstNameRequired,
        'last_name_order': lastNameOrder,
        'last_name_key': lastNameKey,
        'last_name_label': lastNameLabel,
        'last_name_placeholder': lastNamePlaceholder,
        'last_name_active': lastNameActive,
        'last_name_required': lastNameRequired,
        'address_line_1_order': addressLine1Order,
        'address_line_1_key': addressLine1Key,
        'address_line_1_label': addressLine1Label,
        'address_line_1_placeholder': addressLine1Placeholder,
        'address_line_1_active': addressLine1Active,
        'address_line_1_required': addressLine1Required,
        'address_line_2_order': addressLine2Order,
        'address_line_2_key': addressLine2Key,
        'address_line_2_label': addressLine2Label,
        'address_line_2_placeholder': addressLine2Placeholder,
        'address_line_2_active': addressLine2Active,
        'address_line_2_required': addressLine2Required,
        'post_code_order': postCodeOrder,
        'post_code_key': postCodeKey,
        'post_code_label': postCodeLabel,
        'post_code_placeholder': postCodePlaceholder,
        'post_code_active': postCodeActive,
        'post_code_required': postCodeRequired,
        'city_order': cityOrder,
        'city_key': cityKey,
        'city_label': cityLabel,
        'city_placeholder': cityPlaceholder,
        'city_active': cityActive,
        'city_required': cityRequired,
        'phone_order': phoneOrder,
        'phone_key': phoneKey,
        'phone_label': phoneLabel,
        'phone_placeholder': phonePlaceholder,
        'phone_active': phoneActive,
        'phone_required': phoneRequired,
        'mobile_order': mobileOrder,
        'mobile_key': mobileKey,
        'mobile_label': mobileLabel,
        'mobile_placeholder': mobilePlaceholder,
        'mobile_active': mobileActive,
        'mobile_required': mobileRequired,
        'fax_order': faxOrder,
        'fax_key': faxKey,
        'fax_label': faxLabel,
        'fax_placeholder': faxPlaceholder,
        'fax_active': faxActive,
        'fax_required': faxRequired,
        'email_order': emailOrder,
        'email_key': emailKey,
        'email_label': emailLabel,
        'email_placeholder': emailPlaceholder,
        'email_active': emailActive,
        'email_required': emailRequired,
        'confirm_email_order': confirmEmailOrder,
        'confirm_email_key': confirmEmailKey,
        'confirm_email_label': confirmEmailLabel,
        'confirm_email_placeholder': confirmEmailPlaceholder,
        'confirm_email_active': confirmEmailActive,
        'confirm_email_required': confirmEmailRequired,
        'password_order': passwordOrder,
        'password_key': passwordKey,
        'password_label': passwordLabel,
        'password_placeholder': passwordPlaceholder,
        'password_active': passwordActive,
        'password_required': passwordRequired,
        'retype_password_order': retypePasswordOrder,
        'retype_password_key': retypePasswordKey,
        'retype_password_label': retypePasswordLabel,
        'retype_password_placeholder': retypePasswordPlaceholder,
        'retype_password_active': retypePasswordActive,
        'retype_password_required': retypePasswordRequired,
        'country_order': countryOrder,
        'country_key': countryKey,
        'country_label': countryLabel,
        'country_placeholder': countryPlaceholder,
        'country_active': countryActive,
        'country_required': countryRequired,
        'customer_type_order': customerTypeOrder,
        'customer_type_key': customerTypeKey,
        'customer_type_label': customerTypeLabel,
        'customer_type_placeholder': customerTypePlaceholder,
        'customer_type_active': customerTypeActive,
        'customer_type_required': customerTypeRequired,
        'sex_order': sexOrder,
        'sex_key': sexKey,
        'sex_label': sexLabel,
        'sex_placeholder': sexPlaceholder,
        'sex_active': sexActive,
        'sex_required': sexRequired,
        'abn_order': abnOrder,
        'abn_key': abnKey,
        'abn_label': abnLabel,
        'abn_placeholder': abnPlaceholder,
        'abn_active': abnActive,
        'abn_required': abnRequired,
        'abn_branch_order': abnBranchOrder,
        'abn_branch_key': abnBranchKey,
        'abn_branch_label': abnBranchLabel,
        'abn_branch_placeholder': abnBranchPlaceholder,
        'abn_branch_active': abnBranchActive,
        'abn_branch_required': abnBranchRequired,
        'company_name_order': companyNameOrder,
        'company_name_key': companyNameKey,
        'company_name_label': companyNameLabel,
        'company_name_placeholder': companyNamePlaceholder,
        'company_name_active': companyNameActive,
        'company_name_required': companyNameRequired,
        'date_of_birth_order': dateOfBirthOrder,
        'date_of_birth_key': dateOfBirthKey,
        'date_of_birth_label': dateOfBirthLabel,
        'date_of_birth_placeholder': dateOfBirthPlaceholder,
        'date_of_birth_active': dateOfBirthActive,
        'date_of_birth_required': dateOfBirthRequired,
      };
}

/// The registration form: the active fields' keys in their order, and every
/// field's configuration, inactive ones included.
class CustomerFields extends Dto {
  const CustomerFields({this.registrationFields, this.fieldsConfigs});

  /// Reads the `create-customer-fields` body.
  static CustomerFields? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerFields(
      registrationFields: readList<String>(source['fields'], readText),
      fieldsConfigs: CustomerFieldConfigs.fromMap(source['fields_configs']),
    );
  }

  /// `fields` on the wire, renamed because [Dto.fields] takes the name.
  final List<String?>? registrationFields;

  final CustomerFieldConfigs? fieldsConfigs;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'fields': registrationFields,
        'fields_configs': fieldsConfigs,
      };
}
