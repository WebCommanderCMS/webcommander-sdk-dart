/// Typed views over the dashboard KPI bodies.
library;

import '../../client/dto.dart';

/// The default layout the KPI tiles belong to; `id` is its `dashboard_id`.
class DashboardRef extends Dto {
  const DashboardRef({
    this.id,
    this.name,
  });

  /// Reads a [DashboardRef] from a decoded body.
  static DashboardRef? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardRef(
      id: readText(source['id']),
      name: readText(source['name']),
    );
  }

  final String? id;

  final String? name;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'id': id,
        'name': name,
      };
}

/// The period a figure covers and the one before it, as dates; `time_zone` is
/// the store's and `currency` the code money figures are in.
class KpiPeriod extends Dto {
  const KpiPeriod({
    this.duration,
    this.startDate,
    this.endDate,
    this.previousStartDate,
    this.previousEndDate,
    this.timeZone,
    this.currency,
  });

  /// Reads a [KpiPeriod] from a decoded body.
  static KpiPeriod? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiPeriod(
      duration: readText(source['duration']),
      startDate: readText(source['start_date']),
      endDate: readText(source['end_date']),
      previousStartDate: readText(source['previous_start_date']),
      previousEndDate: readText(source['previous_end_date']),
      timeZone: readText(source['time_zone']),
      currency: readText(source['currency']),
    );
  }

  final String? duration;

  final String? startDate;

  final String? endDate;

  final String? previousStartDate;

  final String? previousEndDate;

  final String? timeZone;

  final String? currency;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'duration': duration,
        'start_date': startDate,
        'end_date': endDate,
        'previous_start_date': previousStartDate,
        'previous_end_date': previousEndDate,
        'time_zone': timeZone,
        'currency': currency,
      };
}

/// One metric a tile can show. `key` is what a selection takes; `code` is the
/// report's own name for it and differs for some, such as `aov` and
/// `average_order_value`.
class KpiMetric extends Dto {
  const KpiMetric({
    this.key,
    this.code,
    this.label,
    this.format,
    this.inUse,
  });

  /// Reads a [KpiMetric] from a decoded body.
  static KpiMetric? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiMetric(
      key: readText(source['key']),
      code: readText(source['code']),
      label: readText(source['label']),
      format: readText(source['format']),
      inUse: readFlag(source['in_use']),
    );
  }

  final String? key;

  final String? code;

  final String? label;

  final String? format;

  final bool? inUse;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'code': code,
        'label': label,
        'format': format,
        'in_use': inUse,
      };
}

/// A group of metrics: `ecommerce`, `content`, `blog`, `bookings` or `courses`.
class KpiGroup extends Dto {
  const KpiGroup({
    this.key,
    this.label,
    this.metrics,
  });

  /// Reads a [KpiGroup] from a decoded body.
  static KpiGroup? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiGroup(
      key: readText(source['key']),
      label: readText(source['label']),
      metrics: readList<KpiMetric>(source['metrics'], KpiMetric.fromMap),
    );
  }

  final String? key;

  final String? label;

  final List<KpiMetric?>? metrics;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'key': key,
        'label': label,
        'metrics': metrics,
      };
}

/// Every metric a tile can show. `min` and `max` bound the number of tiles, and
/// `selected` lists the keys in use, in tile order.
class KpiOptions extends Dto {
  const KpiOptions({
    this.dashboard,
    this.min,
    this.max,
    this.selected,
    this.groups,
  });

  /// Reads a [KpiOptions] from a decoded body.
  static KpiOptions? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiOptions(
      dashboard: DashboardRef.fromMap(source['dashboard']),
      min: readInteger(source['min']),
      max: readInteger(source['max']),
      selected: readList<String>(source['selected'], readText),
      groups: readList<KpiGroup>(source['groups'], KpiGroup.fromMap),
    );
  }

  final DashboardRef? dashboard;

  final int? min;

  final int? max;

  final List<String?>? selected;

  final List<KpiGroup?>? groups;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'dashboard': dashboard,
        'min': min,
        'max': max,
        'selected': selected,
        'groups': groups,
      };
}

/// One selected tile with its figure. `format` is `money`, `count` or `percent`
/// and `direction` is `up`, `down` or `flat`; `change_percent` is `null` when
/// the previous period was zero. Every count is a decimal on the wire.
class KpiTile extends Dto {
  const KpiTile({
    this.position,
    this.key,
    this.code,
    this.label,
    this.group,
    this.format,
    this.value,
    this.previousValue,
    this.changePercent,
    this.direction,
  });

  /// Reads a [KpiTile] from a decoded body.
  static KpiTile? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiTile(
      position: readInteger(source['position']),
      key: readText(source['key']),
      code: readText(source['code']),
      label: readText(source['label']),
      group: readText(source['group']),
      format: readText(source['format']),
      value: readDecimal(source['value']),
      previousValue: readDecimal(source['previous_value']),
      changePercent: readDecimal(source['change_percent']),
      direction: readText(source['direction']),
    );
  }

  final int? position;

  final String? key;

  final String? code;

  final String? label;

  final String? group;

  final String? format;

  final double? value;

  final double? previousValue;

  final double? changePercent;

  final String? direction;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'position': position,
        'key': key,
        'code': code,
        'label': label,
        'group': group,
        'format': format,
        'value': value,
        'previous_value': previousValue,
        'change_percent': changePercent,
        'direction': direction,
      };
}

/// The tiles in use with their figures for the period; the read and the save
/// answer alike.
class KpiSelection extends Dto {
  const KpiSelection({
    this.dashboard,
    this.onlineStore,
    this.period,
    this.selected,
  });

  /// Reads a [KpiSelection] from a decoded body.
  static KpiSelection? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return KpiSelection(
      dashboard: DashboardRef.fromMap(source['dashboard']),
      onlineStore: readFlag(source['online_store']),
      period: KpiPeriod.fromMap(source['period']),
      selected: readList<KpiTile>(source['selected'], KpiTile.fromMap),
    );
  }

  final DashboardRef? dashboard;

  final bool? onlineStore;

  final KpiPeriod? period;

  final List<KpiTile?>? selected;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'dashboard': dashboard,
        'online_store': onlineStore,
        'period': period,
        'selected': selected,
      };
}

/// The save body, bare: `metrics` is the full list of 2 to 5 distinct metric
/// keys, in tile order. It replaces the default layout's tiles.
class KpiSelectionInput extends Dto {
  const KpiSelectionInput({this.metrics});

  final List<String?>? metrics;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'metrics': metrics,
      };
}
