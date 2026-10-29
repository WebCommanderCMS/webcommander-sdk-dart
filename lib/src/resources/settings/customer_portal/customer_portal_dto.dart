/// Typed views over the customer portal bodies.
library;

import '../../../client/dto.dart';

/// One entry of `default_groups` or `approval_groups` as a read sends it.
class CustomerGroup extends Dto {
  const CustomerGroup({this.id, this.name});

  static CustomerGroup? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerGroup(
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

/// The `portal` section — the one switch that turns the customer portal on.
class Portal extends Dto {
  const Portal({this.enabled});

  static Portal? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'portal');
    if (source == null) return null;
    return Portal(enabled: readFlag(source['enabled']));
  }

  final bool? enabled;

  @override
  String? get envelopeKey => 'portal';

  @override
  Map<String, Object?> get fields => <String, Object?>{'enabled': enabled};
}

/// The `terms` block — the terms line shown on the registration form.
class RegistrationTerms extends Dto {
  const RegistrationTerms({
    this.enabled,
    this.text,
    this.anchorText,
    this.type,
    this.reference,
  });

  static RegistrationTerms? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return RegistrationTerms(
      enabled: readFlag(source['enabled']),
      text: readText(source['text']),
      anchorText: readText(source['anchor_text']),
      type: readText(source['type']),
      reference: readText(source['reference']),
    );
  }

  final bool? enabled;

  final String? text;

  final String? anchorText;

  final String? type;

  final String? reference;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'text': text,
        'anchor_text': anchorText,
        'type': type,
        'reference': reference,
      };
}

/// The `facebook` block — registering through Facebook.
class FacebookLogin extends Dto {
  const FacebookLogin({this.enabled, this.appId});

  static FacebookLogin? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return FacebookLogin(
      enabled: readFlag(source['enabled']),
      appId: readText(source['app_id']),
    );
  }

  final bool? enabled;

  final String? appId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'app_id': appId,
      };
}

/// The `google` block — registering through Google.
class GoogleLogin extends Dto {
  const GoogleLogin({this.enabled, this.clientId});

  static GoogleLogin? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return GoogleLogin(
      enabled: readFlag(source['enabled']),
      clientId: readText(source['client_id']),
    );
  }

  final bool? enabled;

  final String? clientId;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'client_id': clientId,
      };
}

/// The `b2b_configuration` block — what a new registrant is created as.
class B2bConfiguration extends Dto {
  const B2bConfiguration({
    this.enabled,
    this.createAsOrganisation,
    this.createAsCustomer,
    this.organisationSelected,
  });

  static B2bConfiguration? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return B2bConfiguration(
      enabled: readFlag(source['enabled']),
      createAsOrganisation: readFlag(source['create_as_organisation']),
      createAsCustomer: readFlag(source['create_as_customer']),
      organisationSelected: readFlag(source['organisation_selected']),
    );
  }

  final bool? enabled;

  final bool? createAsOrganisation;

  final bool? createAsCustomer;

  final bool? organisationSelected;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'create_as_organisation': createAsOrganisation,
        'create_as_customer': createAsCustomer,
        'organisation_selected': organisationSelected,
      };
}

/// The `alternate_login` block — third-party login and whether it offers an
/// email field.
class AlternateLogin extends Dto {
  const AlternateLogin({this.enabled, this.enableEmailField});

  static AlternateLogin? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AlternateLogin(
      enabled: readFlag(source['enabled']),
      enableEmailField: readFlag(source['enable_email_field']),
    );
  }

  final bool? enabled;

  final bool? enableEmailField;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'enable_email_field': enableEmailField,
      };
}

/// The `registration` section — whether customers may register, what they are
/// made into and what they must accept.
class Registration extends Dto {
  const Registration({
    this.enabled,
    this.closeRegistrationMessage,
    this.assignDefaultGroup,
    this.defaultGroups,
    this.requiresApproval,
    this.approvalGroups,
    this.terms,
    this.facebook,
    this.google,
    this.b2bConfiguration,
    this.alternateLogin,
  });

  static Registration? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'registration');
    if (source == null) return null;
    return Registration(
      enabled: readFlag(source['enabled']),
      closeRegistrationMessage: readText(source['close_registration_message']),
      assignDefaultGroup: readFlag(source['assign_default_group']),
      defaultGroups: readList(source['default_groups'], CustomerGroup.fromMap),
      requiresApproval: readFlag(source['requires_approval']),
      approvalGroups:
          readList(source['approval_groups'], CustomerGroup.fromMap),
      terms: RegistrationTerms.fromMap(source['terms']),
      facebook: FacebookLogin.fromMap(source['facebook']),
      google: GoogleLogin.fromMap(source['google']),
      b2bConfiguration: B2bConfiguration.fromMap(source['b2b_configuration']),
      alternateLogin: AlternateLogin.fromMap(source['alternate_login']),
    );
  }

  final bool? enabled;

  final String? closeRegistrationMessage;

  final bool? assignDefaultGroup;

  /// `default_groups` — records on the way in, bare ids on the way out.
  final List<CustomerGroup?>? defaultGroups;

  final bool? requiresApproval;

  /// `approval_groups` — the same two forms as [defaultGroups].
  final List<CustomerGroup?>? approvalGroups;

  final RegistrationTerms? terms;

  final FacebookLogin? facebook;

  final GoogleLogin? google;

  final B2bConfiguration? b2bConfiguration;

  final AlternateLogin? alternateLogin;

  @override
  String? get envelopeKey => 'registration';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'close_registration_message': closeRegistrationMessage,
        'assign_default_group': assignDefaultGroup,
        'default_groups': defaultGroups,
        'requires_approval': requiresApproval,
        'approval_groups': approvalGroups,
        'terms': terms,
        'facebook': facebook,
        'google': google,
        'b2b_configuration': b2bConfiguration,
        'alternate_login': alternateLogin,
      };
}

/// The `captcha` block — the challenge shown after failed logins.
class LoginCaptcha extends Dto {
  const LoginCaptcha({this.enabled, this.failCount});

  static LoginCaptcha? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return LoginCaptcha(
      enabled: readFlag(source['enabled']),
      failCount: readInteger(source['fail_count']),
    );
  }

  final bool? enabled;

  final int? failCount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'fail_count': failCount,
      };
}

/// The `login` section — whether customers may sign in and what the sign-in
/// page offers.
class Login extends Dto {
  const Login({
    this.enabled,
    this.loginDisabledMessage,
    this.awaitingApprovalMessage,
    this.passwordRecovery,
    this.registrationLink,
    this.captcha,
    this.enableLandingPageAfterSuccessfulLogin,
    this.landingPageAfterSuccessfulLogin,
  });

  static Login? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'login');
    if (source == null) return null;
    return Login(
      enabled: readFlag(source['enabled']),
      loginDisabledMessage: readText(source['login_disabled_message']),
      awaitingApprovalMessage: readText(source['awaiting_approval_message']),
      passwordRecovery: readFlag(source['password_recovery']),
      registrationLink: readFlag(source['registration_link']),
      captcha: LoginCaptcha.fromMap(source['captcha']),
      enableLandingPageAfterSuccessfulLogin:
          readFlag(source['enable_landing_page_after_successful_login']),
      landingPageAfterSuccessfulLogin:
          readText(source['landing_page_after_successful_login']),
    );
  }

  final bool? enabled;

  final String? loginDisabledMessage;

  final String? awaitingApprovalMessage;

  /// `password_recovery` — a plain boolean the SDK's redaction hides by name.
  final bool? passwordRecovery;

  final bool? registrationLink;

  final LoginCaptcha? captcha;

  final bool? enableLandingPageAfterSuccessfulLogin;

  final String? landingPageAfterSuccessfulLogin;

  @override
  String? get envelopeKey => 'login';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'login_disabled_message': loginDisabledMessage,
        'awaiting_approval_message': awaitingApprovalMessage,
        'password_recovery': passwordRecovery,
        'registration_link': registrationLink,
        'captcha': captcha,
        'enable_landing_page_after_successful_login':
            enableLandingPageAfterSuccessfulLogin,
        'landing_page_after_successful_login': landingPageAfterSuccessfulLogin,
      };
}

/// The `azure_ad.data_mapping` block — which assertion attribute fills which
/// customer field.
class AzureAdDataMapping extends Dto {
  const AzureAdDataMapping({
    this.addressLine1,
    this.addressLine2,
    this.postCode,
    this.phone,
    this.mobile,
    this.countryId,
    this.state,
    this.city,
  });

  static AzureAdDataMapping? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AzureAdDataMapping(
      addressLine1: readText(source['address_line_1']),
      addressLine2: readText(source['address_line_2']),
      postCode: readText(source['post_code']),
      phone: readText(source['phone']),
      mobile: readText(source['mobile']),
      countryId: readInteger(source['country_id']),
      state: readText(source['state']),
      city: readText(source['city']),
    );
  }

  final String? addressLine1;

  final String? addressLine2;

  final String? postCode;

  final String? phone;

  final String? mobile;

  final int? countryId;

  final String? state;

  final String? city;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'post_code': postCode,
        'phone': phone,
        'mobile': mobile,
        'country_id': countryId,
        'state': state,
        'city': city,
      };
}

/// The `azure_ad` block — the SAML provider.
class AzureAd extends Dto {
  const AzureAd({
    this.dataMapping,
    this.identifier,
    this.loginUrl,
    this.replyUrlPostfix,
  });

  static AzureAd? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AzureAd(
      dataMapping: AzureAdDataMapping.fromMap(source['data_mapping']),
      identifier: readText(source['identifier']),
      loginUrl: readText(source['login_url']),
      replyUrlPostfix: readText(source['reply_url_postfix']),
    );
  }

  final AzureAdDataMapping? dataMapping;

  final String? identifier;

  final String? loginUrl;

  final String? replyUrlPostfix;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'data_mapping': dataMapping,
        'identifier': identifier,
        'login_url': loginUrl,
        'reply_url_postfix': replyUrlPostfix,
      };
}

/// The `azure_ad_b2c` block — the B2C provider, carrying [clientSecret].
class AzureAdB2c extends Dto {
  const AzureAdB2c({
    this.tenantName,
    this.policyName,
    this.clientId,
    this.clientSecret,
    this.replyUrlPrefix,
    this.replyUrlPostfix,
  });

  static AzureAdB2c? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AzureAdB2c(
      tenantName: readText(source['tenant_name']),
      policyName: readText(source['policy_name']),
      clientId: readText(source['client_id']),
      clientSecret: readText(source['client_secret']),
      replyUrlPrefix: readText(source['reply_url_prefix']),
      replyUrlPostfix: readText(source['reply_url_postfix']),
    );
  }

  final String? tenantName;

  final String? policyName;

  final String? clientId;

  /// `client_secret` — a plain string to the store, hidden by this SDK's redaction.
  final String? clientSecret;

  final String? replyUrlPrefix;

  final String? replyUrlPostfix;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'tenant_name': tenantName,
        'policy_name': policyName,
        'client_id': clientId,
        'client_secret': clientSecret,
        'reply_url_prefix': replyUrlPrefix,
        'reply_url_postfix': replyUrlPostfix,
      };
}

/// The `sso` section — single sign-on and which provider serves it.
class Sso extends Dto {
  const Sso({
    this.enabled,
    this.requireSiteAccess,
    this.serviceProvider,
    this.azureAd,
    this.azureAdB2c,
  });

  static Sso? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'sso');
    if (source == null) return null;
    return Sso(
      enabled: readFlag(source['enabled']),
      requireSiteAccess: readFlag(source['require_site_access']),
      serviceProvider: readText(source['service_provider']),
      azureAd: AzureAd.fromMap(source['azure_ad']),
      azureAdB2c: AzureAdB2c.fromMap(source['azure_ad_b2c']),
    );
  }

  final bool? enabled;

  final bool? requireSiteAccess;

  final String? serviceProvider;

  final AzureAd? azureAd;

  final AzureAdB2c? azureAdB2c;

  @override
  String? get envelopeKey => 'sso';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enabled': enabled,
        'require_site_access': requireSiteAccess,
        'service_provider': serviceProvider,
        'azure_ad': azureAd,
        'azure_ad_b2c': azureAdB2c,
      };
}

/// One row of an address or account form on the profile page — which field,
/// whether it is drawn and where.
class ProfileField extends Dto {
  const ProfileField({this.key, this.active, this.order});

  static ProfileField? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProfileField(
      key: readText(source['key']),
      active: readFlag(source['active']),
      order: readInteger(source['order']),
    );
  }

  final String? key;

  final bool? active;

  final int? order;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'active': active,
        'order': order,
      };
}

/// One row of a named list on the profile page — a tab, a section or an
/// entitlement.
class ProfileEntry extends ProfileField {
  const ProfileEntry({super.key, super.active, super.order, this.label});

  static ProfileEntry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProfileEntry(
      key: readText(source['key']),
      active: readFlag(source['active']),
      order: readInteger(source['order']),
      label: readText(source['label']),
    );
  }

  final String? label;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'label': label,
      };
}

/// One row of `overview`.
class ProfileOverviewEntry extends ProfileEntry {
  const ProfileOverviewEntry({
    super.key,
    super.active,
    super.order,
    super.label,
    this.showProductInfo,
  });

  static ProfileOverviewEntry? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ProfileOverviewEntry(
      key: readText(source['key']),
      active: readFlag(source['active']),
      order: readInteger(source['order']),
      label: readText(source['label']),
      showProductInfo: readFlag(source['show_product_info']),
    );
  }

  final bool? showProductInfo;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        ...super.fields,
        'show_product_info': showProductInfo,
      };
}

/// The `manage_my_account` block — the account screen's own sections and the
/// fields each of the three forms draws.
class ManageMyAccount extends Dto {
  const ManageMyAccount({
    this.sections,
    this.accountInformation,
    this.billingAddress,
    this.shippingAddress,
  });

  static ManageMyAccount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ManageMyAccount(
      sections: readList(source['sections'], ProfileEntry.fromMap),
      accountInformation:
          readList(source['account_information'], ProfileField.fromMap),
      billingAddress: readList(source['billing_address'], ProfileField.fromMap),
      shippingAddress:
          readList(source['shipping_address'], ProfileField.fromMap),
    );
  }

  final List<ProfileEntry?>? sections;

  final List<ProfileField?>? accountInformation;

  final List<ProfileField?>? billingAddress;

  final List<ProfileField?>? shippingAddress;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sections': sections,
        'account_information': accountInformation,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      };
}

/// The `my_orders.flags` block — six booleans.
class MyOrderFlags extends Dto {
  const MyOrderFlags({
    this.enableDuePayment,
    this.showTrackMyOrders,
    this.displayTrackInColumn,
    this.showOrderChannel,
    this.showPayNow,
    this.allowOrderShare,
  });

  static MyOrderFlags? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return MyOrderFlags(
      enableDuePayment: readFlag(source['enable_due_payment']),
      showTrackMyOrders: readFlag(source['show_track_my_orders']),
      displayTrackInColumn: readFlag(source['display_track_in_column']),
      showOrderChannel: readFlag(source['show_order_channel']),
      showPayNow: readFlag(source['show_pay_now']),
      allowOrderShare: readFlag(source['allow_order_share']),
    );
  }

  final bool? enableDuePayment;

  final bool? showTrackMyOrders;

  final bool? displayTrackInColumn;

  final bool? showOrderChannel;

  final bool? showPayNow;

  final bool? allowOrderShare;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'enable_due_payment': enableDuePayment,
        'show_track_my_orders': showTrackMyOrders,
        'display_track_in_column': displayTrackInColumn,
        'show_order_channel': showOrderChannel,
        'show_pay_now': showPayNow,
        'allow_order_share': allowOrderShare,
      };
}

/// The `my_orders` block — what the orders tab shows and which order lists it
/// offers.
class MyOrders extends Dto {
  const MyOrders({this.flags, this.sections});

  static MyOrders? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return MyOrders(
      flags: MyOrderFlags.fromMap(source['flags']),
      sections: readList(source['sections'], ProfileEntry.fromMap),
    );
  }

  final MyOrderFlags? flags;

  final List<ProfileEntry?>? sections;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'flags': flags,
        'sections': sections,
      };
}

/// The `assign_to_customer` block — the assigned-pages tab and how it
/// paginates.
class AssignToCustomer extends Dto {
  const AssignToCustomer({this.items, this.showPagination, this.itemPerPage});

  static AssignToCustomer? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return AssignToCustomer(
      items: readList(source['items'], ProfileEntry.fromMap),
      showPagination: readText(source['show_pagination']),
      itemPerPage: readInteger(source['item_per_page']),
    );
  }

  final List<ProfileEntry?>? items;

  final String? showPagination;

  final int? itemPerPage;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'items': items,
        'show_pagination': showPagination,
        'item_per_page': itemPerPage,
      };
}

/// The `profile_page` section — every tab of the logged-in customer's own page.
class ProfilePage extends Dto {
  const ProfilePage({
    this.pageHtml,
    this.tabs,
    this.overview,
    this.manageMyAccount,
    this.myOrders,
    this.myEntitlements,
    this.assignToCustomer,
  });

  static ProfilePage? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'profile_page');
    if (source == null) return null;
    return ProfilePage(
      pageHtml: readText(source['page_html']),
      tabs: readList(source['tabs'], ProfileEntry.fromMap),
      overview: readList(source['overview'], ProfileOverviewEntry.fromMap),
      manageMyAccount: ManageMyAccount.fromMap(source['manage_my_account']),
      myOrders: MyOrders.fromMap(source['my_orders']),
      myEntitlements: readList(source['my_entitlements'], ProfileEntry.fromMap),
      assignToCustomer: AssignToCustomer.fromMap(source['assign_to_customer']),
    );
  }

  final String? pageHtml;

  final List<ProfileEntry?>? tabs;

  final List<ProfileOverviewEntry?>? overview;

  final ManageMyAccount? manageMyAccount;

  final MyOrders? myOrders;

  final List<ProfileEntry?>? myEntitlements;

  final AssignToCustomer? assignToCustomer;

  @override
  String? get envelopeKey => 'profile_page';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page_html': pageHtml,
        'tabs': tabs,
        'overview': overview,
        'manage_my_account': manageMyAccount,
        'my_orders': myOrders,
        'my_entitlements': myEntitlements,
        'assign_to_customer': assignToCustomer,
      };
}

/// One row of the registration form's field catalog.
class RegistrationField extends Dto {
  const RegistrationField({
    this.key,
    this.label,
    this.defaultLabel,
    this.active,
    this.required,
    this.system,
    this.order,
    this.placeholder,
  });

  static RegistrationField? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return RegistrationField(
      key: readText(source['key']),
      label: readText(source['label']),
      defaultLabel: readText(source['default_label']),
      active: readFlag(source['active']),
      required: readFlag(source['required']),
      system: readFlag(source['system']),
      order: readInteger(source['order']),
      placeholder: readText(source['placeholder']),
    );
  }

  final String? key;

  final String? label;

  final String? defaultLabel;

  final bool? active;

  final bool? required;

  final bool? system;

  final int? order;

  final String? placeholder;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'label': label,
        'default_label': defaultLabel,
        'active': active,
        'required': required,
        'system': system,
        'order': order,
        'placeholder': placeholder,
      };
}

/// The `registration_fields` section — the registration form's field catalog.
class RegistrationFields extends Dto {
  const RegistrationFields({this.registrationFields});

  static RegistrationFields? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'registration_fields');
    if (source == null) return null;
    return RegistrationFields(
      registrationFields: readList(source['fields'], RegistrationField.fromMap),
    );
  }

  /// `fields` — every row of the registration form's catalog.
  final List<RegistrationField?>? registrationFields;

  @override
  String? get envelopeKey => 'registration_fields';

  @override
  Map<String, Object?> get fields =>
      <String, Object?>{'fields': registrationFields};
}

/// One entry of `group_meta`: what a thing is, whether it can be written and
/// where it is managed.
class CustomerPortalSectionMeta extends Dto {
  const CustomerPortalSectionMeta({this.kind, this.writable, this.href});

  static CustomerPortalSectionMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerPortalSectionMeta(
      kind: readText(source['kind']),
      writable: readFlag(source['writable']),
      href: readText(source['href']),
    );
  }

  /// `kind` — `"setting"` on the four writable entries, `"resource"` on the two
  /// read-only ones.
  final String? kind;

  /// `writable` — `true` on four of the six entries here.
  final bool? writable;

  /// `href` — the section's own path on this resource, for all six entries.
  final String? href;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'kind': kind,
        'writable': writable,
        'href': href,
      };
}

/// The `group_meta` block — one [CustomerPortalSectionMeta] per section the
/// area declares.
class CustomerPortalGroupMeta extends Dto {
  const CustomerPortalGroupMeta({
    this.portal,
    this.registration,
    this.login,
    this.sso,
    this.profilePage,
    this.registrationFields,
  });

  static CustomerPortalGroupMeta? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return CustomerPortalGroupMeta(
      portal: CustomerPortalSectionMeta.fromMap(source['portal']),
      registration: CustomerPortalSectionMeta.fromMap(source['registration']),
      login: CustomerPortalSectionMeta.fromMap(source['login']),
      sso: CustomerPortalSectionMeta.fromMap(source['sso']),
      profilePage: CustomerPortalSectionMeta.fromMap(source['profile_page']),
      registrationFields:
          CustomerPortalSectionMeta.fromMap(source['registration_fields']),
    );
  }

  final CustomerPortalSectionMeta? portal;

  final CustomerPortalSectionMeta? registration;

  final CustomerPortalSectionMeta? login;

  final CustomerPortalSectionMeta? sso;

  final CustomerPortalSectionMeta? profilePage;

  final CustomerPortalSectionMeta? registrationFields;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'portal': portal,
        'registration': registration,
        'login': login,
        'sso': sso,
        'profile_page': profilePage,
        'registration_fields': registrationFields,
      };
}

/// The customer portal settings, as the facade or one section sends them.
class CustomerPortal extends Dto {
  const CustomerPortal({
    this.portal,
    this.registration,
    this.login,
    this.sso,
    this.profilePage,
    this.registrationFields,
    this.groupMeta,
    this.fieldMetadata,
  });

  static CustomerPortal? fromMap(Object? body) {
    final source = readRecord(body, envelopeKey: 'customer_portal');
    if (source == null) return null;
    return CustomerPortal(
      portal: Portal.fromMap(source['portal']),
      registration: Registration.fromMap(source['registration']),
      login: Login.fromMap(source['login']),
      sso: Sso.fromMap(source['sso']),
      profilePage: ProfilePage.fromMap(source['profile_page']),
      registrationFields:
          RegistrationFields.fromMap(source['registration_fields']),
      groupMeta: CustomerPortalGroupMeta.fromMap(source['group_meta']),
      fieldMetadata: readAny(source['field_metadata']),
    );
  }

  final Portal? portal;

  final Registration? registration;

  final Login? login;

  final Sso? sso;

  /// `profile_page` — `kind: "resource"`, `writable: false`: read, never written.
  final ProfilePage? profilePage;

  /// `registration_fields` — `kind: "resource"`, `writable: false`: read, never
  /// written.
  final RegistrationFields? registrationFields;

  /// `group_meta` — on the facade's answer only.
  final CustomerPortalGroupMeta? groupMeta;

  /// `field_metadata` — untyped, because its entries differ by field type.
  final Object? fieldMetadata;

  @override
  String? get envelopeKey => 'customer_portal';

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'portal': portal,
        'registration': registration,
        'login': login,
        'sso': sso,
        'profile_page': profilePage,
        'registration_fields': registrationFields,
        'group_meta': groupMeta,
        'field_metadata': fieldMetadata,
      };
}
