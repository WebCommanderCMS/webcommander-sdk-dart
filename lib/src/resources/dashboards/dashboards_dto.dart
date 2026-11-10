/// Typed views over the dashboard layout bodies.
library;

import '../../client/dto.dart';

/// One part of the `seo` section. Read back, the title and `can_hide` come with
/// it; a write needs only `key` and `visible`. The `kpis` part cannot be hidden.
class DashboardPart extends Dto {
  const DashboardPart({
    this.key,
    this.title,
    this.visible,
    this.canHide,
  });

  /// Reads a [DashboardPart] from a decoded body.
  static DashboardPart? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardPart(
      key: readText(source['key']),
      title: readText(source['title']),
      visible: readFlag(source['visible']),
      canHide: readFlag(source['can_hide']),
    );
  }

  final String? key;

  final String? title;

  final bool? visible;

  final bool? canHide;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'title': title,
        'visible': visible,
        'can_hide': canHide,
      };
}

/// One tab of the `section_tabs` section: `ecommerce`, `content`, `bookings`,
/// `courses` or `blog`. A write needs `key` and sets `visible` or `position`,
/// counted from 1 among the tabs.
class DashboardTab extends Dto {
  const DashboardTab({
    this.key,
    this.title,
    this.description,
    this.visible,
    this.canHide,
    this.position,
  });

  /// Reads a [DashboardTab] from a decoded body.
  static DashboardTab? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardTab(
      key: readText(source['key']),
      title: readText(source['title']),
      description: readText(source['description']),
      visible: readFlag(source['visible']),
      canHide: readFlag(source['can_hide']),
      position: readInteger(source['position']),
    );
  }

  final String? key;

  final String? title;

  final String? description;

  final bool? visible;

  final bool? canHide;

  final int? position;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'title': title,
        'description': description,
        'visible': visible,
        'can_hide': canHide,
        'position': position,
      };
}

/// A section of a layout. The standard ones are `announcement`, `performance`,
/// `activity` and `contact`; they only show or hide, and `contact` cannot hide.
/// The customisable ones are `setup_guide`, `section_tabs` (with `tabs`) and
/// `seo` (with `parts`); they also take a `position`. Read back, the title,
/// description and `can_hide` come with it; a write needs only `key` and what
/// changes.
class DashboardSection extends Dto {
  const DashboardSection({
    this.key,
    this.title,
    this.description,
    this.visible,
    this.canHide,
    this.position,
    this.tabs,
    this.parts,
  });

  /// Reads a [DashboardSection] from a decoded body.
  static DashboardSection? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardSection(
      key: readText(source['key']),
      title: readText(source['title']),
      description: readText(source['description']),
      visible: readFlag(source['visible']),
      canHide: readFlag(source['can_hide']),
      position: readInteger(source['position']),
      tabs: readList<DashboardTab>(source['tabs'], DashboardTab.fromMap),
      parts: readList<DashboardPart>(source['parts'], DashboardPart.fromMap),
    );
  }

  final String? key;

  final String? title;

  final String? description;

  final bool? visible;

  final bool? canHide;

  final int? position;

  final List<DashboardTab?>? tabs;

  final List<DashboardPart?>? parts;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'title': title,
        'description': description,
        'visible': visible,
        'can_hide': canHide,
        'position': position,
        'tabs': tabs,
        'parts': parts,
      };
}

/// One KPI tile of a layout, in tile order. `key` is a `kpi_options` metric key.
class DashboardKpi extends Dto {
  const DashboardKpi({
    this.position,
    this.key,
    this.label,
    this.group,
  });

  /// Reads a [DashboardKpi] from a decoded body.
  static DashboardKpi? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardKpi(
      position: readInteger(source['position']),
      key: readText(source['key']),
      label: readText(source['label']),
      group: readText(source['group']),
    );
  }

  final int? position;

  final String? key;

  final String? label;

  final String? group;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'position': position,
        'key': key,
        'label': label,
        'group': group,
      };
}

/// One layout. `id` is the `dashboard_id` of the other calls, a UUID. Exactly
/// one layout is the default.
class Dashboard extends Dto {
  const Dashboard({
    this.id,
    this.name,
    this.isDefault,
    this.standardSections,
    this.customisableSections,
    this.kpis,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a [Dashboard] from a decoded body.
  static Dashboard? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return Dashboard(
      id: readText(source['id']),
      name: readText(source['name']),
      isDefault: readFlag(source['default']),
      standardSections: readList<DashboardSection>(
          source['standard_sections'], DashboardSection.fromMap),
      customisableSections: readList<DashboardSection>(
          source['customisable_sections'], DashboardSection.fromMap),
      kpis: readList<DashboardKpi>(source['kpis'], DashboardKpi.fromMap),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final String? id;

  final String? name;

  final bool? isDefault;

  final List<DashboardSection?>? standardSections;

  final List<DashboardSection?>? customisableSections;

  final List<DashboardKpi?>? kpis;

  final String? createdAt;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'default': isDefault,
        'standard_sections': standardSections,
        'customisable_sections': customisableSections,
        'kpis': kpis,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// A layout as the listing shows it, without its sections and tiles.
class DashboardSummary extends Dto {
  const DashboardSummary({
    this.id,
    this.name,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  /// Reads a [DashboardSummary] from a decoded body.
  static DashboardSummary? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardSummary(
      id: readText(source['id']),
      name: readText(source['name']),
      isDefault: readFlag(source['default']),
      createdAt: readText(source['created_at']),
      updatedAt: readText(source['updated_at']),
    );
  }

  final String? id;

  final String? name;

  final bool? isDefault;

  final String? createdAt;

  final String? updatedAt;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
        'default': isDefault,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// The listing: every layout of the admin, with no paging.
class DashboardListing extends Dto {
  const DashboardListing({this.dashboards});

  /// Reads a [DashboardListing] from a decoded body.
  static DashboardListing? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardListing(
      dashboards: readList<DashboardSummary>(
          source['dashboards'], DashboardSummary.fromMap),
    );
  }

  final List<DashboardSummary?>? dashboards;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'dashboards': dashboards,
      };
}

/// The write body, bare. A create needs `name`, unique among the admin's layouts
/// (`409`); it starts as a copy of the `copy_from` layout, the default one when
/// that is left out. A patch sends only what changes; the sections named are
/// merged into the layout, the rest is kept. `kpis` is the full list of 2 to 5
/// metric keys in tile order. A standard section takes no `position` (`400`).
/// `default` `true` makes this layout the store's default layout; `false` on the
/// default layout is `409`, as the default moves only by making another layout
/// the default.
class DashboardInput extends Dto {
  const DashboardInput({
    this.name,
    this.isDefault,
    this.copyFrom,
    this.standardSections,
    this.customisableSections,
    this.kpis,
  });

  final String? name;

  final bool? isDefault;

  final String? copyFrom;

  final List<DashboardSection?>? standardSections;

  final List<DashboardSection?>? customisableSections;

  final List<String?>? kpis;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'name': name,
        'default': isDefault,
        'copy_from': copyFrom,
        'standard_sections': standardSections,
        'customisable_sections': customisableSections,
        'kpis': kpis,
      };
}
