/// Typed views over the dashboard banner bodies.
library;

import '../../client/dto.dart';

/// One step of an `open_modal` banner's walkthrough.
class BannerStep extends Dto {
  const BannerStep({
    this.title,
    this.description,
  });

  /// Reads a [BannerStep] from a decoded body.
  static BannerStep? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BannerStep(
      title: readText(source['title']),
      description: readText(source['description']),
    );
  }

  final String? title;

  final String? description;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'title': title,
        'description': description,
      };
}

/// What the banner's learn-more button does. `action` is `open_link`, with an
/// `https` `url`, or `open_modal`, with a `title`, a `subtitle` and at least one
/// of `steps`. A patch replaces the whole block, so an `open_modal` block sent
/// over an `open_link` one drops the `url`.
class BannerLearnMore extends Dto {
  const BannerLearnMore({
    this.action,
    this.label,
    this.url,
    this.title,
    this.subtitle,
    this.steps,
  });

  /// Reads a [BannerLearnMore] from a decoded body.
  static BannerLearnMore? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BannerLearnMore(
      action: readText(source['action']),
      label: readText(source['label']),
      url: readText(source['url']),
      title: readText(source['title']),
      subtitle: readText(source['subtitle']),
      steps: readList<BannerStep>(source['steps'], BannerStep.fromMap),
    );
  }

  final String? action;

  final String? label;

  final String? url;

  final String? title;

  final String? subtitle;

  final List<BannerStep?>? steps;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'action': action,
        'label': label,
        'url': url,
        'title': title,
        'subtitle': subtitle,
        'steps': steps,
      };
}

/// The optional second button; both fields are needed.
class BannerTryIt extends Dto {
  const BannerTryIt({
    this.label,
    this.url,
  });

  /// Reads a [BannerTryIt] from a decoded body.
  static BannerTryIt? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BannerTryIt(
      label: readText(source['label']),
      url: readText(source['url']),
    );
  }

  final String? label;

  final String? url;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'label': label,
        'url': url,
      };
}

/// One banner. `key` is the `banner_key` of the other calls. `position` counts
/// from 1 over every banner, hidden ones included, and `active` false hides it
/// from the Dashboard feed only.
class DashboardBanner extends Dto {
  const DashboardBanner({
    this.key,
    this.position,
    this.active,
    this.icon,
    this.title,
    this.description,
    this.tags,
    this.learnMore,
    this.tryIt,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a [DashboardBanner] from a decoded body.
  static DashboardBanner? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardBanner(
      key: readText(source['key']),
      position: readInteger(source['position']),
      active: readFlag(source['active']),
      icon: readText(source['icon']),
      title: readText(source['title']),
      description: readText(source['description']),
      tags: readList<String>(source['tags'], readText),
      learnMore: BannerLearnMore.fromMap(source['learn_more']),
      tryIt: BannerTryIt.fromMap(source['try_it']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final String? key;

  final int? position;

  final bool? active;

  final String? icon;

  final String? title;

  final String? description;

  final List<String?>? tags;

  final BannerLearnMore? learnMore;

  final BannerTryIt? tryIt;

  final String? createdAt;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'position': position,
        'active': active,
        'icon': icon,
        'title': title,
        'description': description,
        'tags': tags,
        'learn_more': learnMore,
        'try_it': tryIt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The management list: every banner, active or not, in position order.
class DashboardBannerListing extends Dto {
  const DashboardBannerListing({this.banners});

  /// Reads a [DashboardBannerListing] from a decoded body.
  static DashboardBannerListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardBannerListing(
      banners:
          readList<DashboardBanner>(source['banners'], DashboardBanner.fromMap),
    );
  }

  final List<DashboardBanner?>? banners;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'banners': banners,
      };
}

/// The write body, bare. A create needs `key` (`a-z`, `0-9` and `_`, starting
/// with a letter, up to 64 characters, unique), `title` (1 to 80 characters),
/// `description` (1 to 200) and `learn_more`; `tags` holds at most 3, `active`
/// defaults to `true` and `position` to the end of the list. A patch sends only
/// what changes and cannot send `key`. `icon` is stored as sent. `position` runs
/// from 1 to one past the banner count, and the banners after it shift down. A
/// typed input leaves out a field it does not set, so removing the second button
/// with `try_it` `null` takes a map.
class DashboardBannerInput extends Dto {
  const DashboardBannerInput({
    this.key,
    this.icon,
    this.title,
    this.description,
    this.tags,
    this.learnMore,
    this.tryIt,
    this.position,
    this.active,
  });

  final String? key;

  final String? icon;

  final String? title;

  final String? description;

  final List<String?>? tags;

  final BannerLearnMore? learnMore;

  final BannerTryIt? tryIt;

  final int? position;

  final bool? active;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'icon': icon,
        'title': title,
        'description': description,
        'tags': tags,
        'learn_more': learnMore,
        'try_it': tryIt,
        'position': position,
        'active': active,
      };
}

/// The support card of the Dashboard.
class BannerContact extends Dto {
  const BannerContact({
    this.email,
    this.phone,
    this.liveChat,
    this.helpCenterUrl,
  });

  /// Reads a [BannerContact] from a decoded body.
  static BannerContact? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BannerContact(
      email: readText(source['email']),
      phone: readText(source['phone']),
      liveChat: readText(source['live_chat']),
      helpCenterUrl: readText(source['help_center_url']),
    );
  }

  final String? email;

  final String? phone;

  final String? liveChat;

  final String? helpCenterUrl;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'email': email,
        'phone': phone,
        'live_chat': liveChat,
        'help_center_url': helpCenterUrl,
      };
}

/// The Dashboard's feed: only the active banners, in position order, the support
/// card, whether the store is an online store and the label of the membership.
class DashboardContentInfo extends Dto {
  const DashboardContentInfo({
    this.banners,
    this.contact,
    this.onlineStore,
    this.memberLabel,
  });

  /// Reads a [DashboardContentInfo] from a decoded body.
  static DashboardContentInfo? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardContentInfo(
      banners:
          readList<DashboardBanner>(source['banners'], DashboardBanner.fromMap),
      contact: BannerContact.fromMap(source['contact']),
      onlineStore: readFlag(source['online_store']),
      memberLabel: readText(source['member_label']),
    );
  }

  final List<DashboardBanner?>? banners;

  final BannerContact? contact;

  final bool? onlineStore;

  final String? memberLabel;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'banners': banners,
        'contact': contact,
        'online_store': onlineStore,
        'member_label': memberLabel,
      };
}
