/// Typed views over the dashboard report bodies.
library;

import '../../client/dto.dart';

/// The period a report covers and the one before it, as dates; `time_zone` is
/// the store's and `currency` the code money figures are in. `duration` is
/// `custom` for a date range.
class ReportPeriod extends Dto {
  const ReportPeriod({
    this.duration,
    this.startDate,
    this.endDate,
    this.previousStartDate,
    this.previousEndDate,
    this.timeZone,
    this.currency,
  });

  /// Reads a [ReportPeriod] from a decoded body.
  static ReportPeriod? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportPeriod(
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

/// One figure with the previous period's. `format` is `money`, `count` or
/// `percent` and `direction` is `up`, `down` or `flat`; `change_percent` is
/// `null` when the previous value was zero. In `trends` there is no `group`.
class ReportKpi extends Dto {
  const ReportKpi({
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

  /// Reads a [ReportKpi] from a decoded body.
  static ReportKpi? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportKpi(
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

/// Order counts of the period.
class ReportOrders extends Dto {
  const ReportOrders({
    this.count,
    this.pending,
    this.cancelled,
  });

  /// Reads a [ReportOrders] from a decoded body.
  static ReportOrders? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportOrders(
      count: readInteger(source['count']),
      pending: readInteger(source['pending']),
      cancelled: readInteger(source['cancelled']),
    );
  }

  final int? count;

  final int? pending;

  final int? cancelled;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'count': count,
        'pending': pending,
        'cancelled': cancelled,
      };
}

/// Sales figures of the period, rounded to 2 decimals.
class ReportSales extends Dto {
  const ReportSales({
    this.subtotal,
    this.total,
    this.itemsSold,
    this.averageOrderValue,
  });

  /// Reads a [ReportSales] from a decoded body.
  static ReportSales? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportSales(
      subtotal: readDecimal(source['subtotal']),
      total: readDecimal(source['total']),
      itemsSold: readInteger(source['items_sold']),
      averageOrderValue: readDecimal(source['average_order_value']),
    );
  }

  final double? subtotal;

  final double? total;

  final int? itemsSold;

  final double? averageOrderValue;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'subtotal': subtotal,
        'total': total,
        'items_sold': itemsSold,
        'average_order_value': averageOrderValue,
      };
}

/// Customers registered in the period.
class ReportCustomers extends Dto {
  const ReportCustomers({this.newCount});

  /// Reads a [ReportCustomers] from a decoded body.
  static ReportCustomers? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportCustomers(
      newCount: readInteger(source['new']),
    );
  }

  final int? newCount;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'new': newCount,
      };
}

/// Products added in the period, and those out of stock now.
class ReportProducts extends Dto {
  const ReportProducts({
    this.newCount,
    this.outOfStock,
  });

  /// Reads a [ReportProducts] from a decoded body.
  static ReportProducts? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportProducts(
      newCount: readInteger(source['new']),
      outOfStock: readInteger(source['out_of_stock']),
    );
  }

  final int? newCount;

  final int? outOfStock;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'new': newCount,
        'out_of_stock': outOfStock,
      };
}

/// Page views of the period.
class ReportPageViews extends Dto {
  const ReportPageViews({
    this.total,
    this.unique,
  });

  /// Reads a [ReportPageViews] from a decoded body.
  static ReportPageViews? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportPageViews(
      total: readInteger(source['total']),
      unique: readInteger(source['unique']),
    );
  }

  final int? total;

  final int? unique;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'total': total,
        'unique': unique,
      };
}

/// A page, product or post by id and name.
class ReportEntity extends Dto {
  const ReportEntity({
    this.id,
    this.name,
  });

  /// Reads a [ReportEntity] from a decoded body.
  static ReportEntity? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportEntity(
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

/// One row of the most viewed list: a `page` or, with `entity_name` `product`, a
/// `product`.
class ReportViewItem extends Dto {
  const ReportViewItem({
    this.page,
    this.product,
    this.views,
  });

  /// Reads a [ReportViewItem] from a decoded body.
  static ReportViewItem? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportViewItem(
      page: ReportEntity.fromMap(source['page']),
      product: ReportEntity.fromMap(source['product']),
      views: readInteger(source['views']),
    );
  }

  final ReportEntity? page;

  final ReportEntity? product;

  final int? views;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'page': page,
        'product': product,
        'views': views,
      };
}

/// The most viewed pages, or products when the query's `entity_name` is
/// `product`; `entity` says which.
class ReportViews extends Dto {
  const ReportViews({
    this.entity,
    this.items,
  });

  /// Reads a [ReportViews] from a decoded body.
  static ReportViews? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return ReportViews(
      entity: readText(source['entity']),
      items: readList<ReportViewItem>(source['items'], ReportViewItem.fromMap),
    );
  }

  final String? entity;

  final List<ReportViewItem?>? items;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'entity': entity,
        'items': items,
      };
}

/// The quick report. `kpis` holds the 27 metrics, or only the ones the query's
/// `kpis` names, in that order. Inside a summary only the grouped totals and
/// `view_report` are present.
class QuickReport extends Dto {
  const QuickReport({
    this.period,
    this.kpis,
    this.orders,
    this.sales,
    this.customers,
    this.products,
    this.pageViews,
    this.viewReport,
    this.trends,
  });

  /// Reads a [QuickReport] from a decoded body.
  static QuickReport? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return QuickReport(
      period: ReportPeriod.fromMap(source['period']),
      kpis: readList<ReportKpi>(source['kpis'], ReportKpi.fromMap),
      orders: ReportOrders.fromMap(source['orders']),
      sales: ReportSales.fromMap(source['sales']),
      customers: ReportCustomers.fromMap(source['customers']),
      products: ReportProducts.fromMap(source['products']),
      pageViews: ReportPageViews.fromMap(source['page_views']),
      viewReport: ReportViews.fromMap(source['view_report']),
      trends: readList<ReportKpi>(source['trends'], ReportKpi.fromMap),
    );
  }

  final ReportPeriod? period;

  final List<ReportKpi?>? kpis;

  final ReportOrders? orders;

  final ReportSales? sales;

  final ReportCustomers? customers;

  final ReportProducts? products;

  final ReportPageViews? pageViews;

  final ReportViews? viewReport;

  final List<ReportKpi?>? trends;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'period': period,
        'kpis': kpis,
        'orders': orders,
        'sales': sales,
        'customers': customers,
        'products': products,
        'page_views': pageViews,
        'view_report': viewReport,
        'trends': trends,
      };
}

/// One row of the sales report: a day for a period up to a month, else a month.
/// Without `breakdown` only the date fields, `label`, `month_name`, `sales` and
/// `total_sales` are present; `day` is present on day rows only.
class SalesRow extends Dto {
  const SalesRow({
    this.date,
    this.year,
    this.month,
    this.day,
    this.label,
    this.monthName,
    this.sales,
    this.totalSales,
    this.orders,
    this.ordersValue,
    this.grossSales,
    this.shipping,
    this.handling,
    this.tax,
    this.discount,
    this.refunds,
    this.averageOrderValue,
    this.topProduct,
  });

  /// Reads a [SalesRow] from a decoded body.
  static SalesRow? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SalesRow(
      date: readText(source['date']),
      year: readInteger(source['year']),
      month: readInteger(source['month']),
      day: readInteger(source['day']),
      label: readText(source['label']),
      monthName: readText(source['month_name']),
      sales: readDecimal(source['sales']),
      totalSales: readDecimal(source['total_sales']),
      orders: readInteger(source['orders']),
      ordersValue: readDecimal(source['orders_value']),
      grossSales: readDecimal(source['gross_sales']),
      shipping: readDecimal(source['shipping']),
      handling: readDecimal(source['handling']),
      tax: readDecimal(source['tax']),
      discount: readDecimal(source['discount']),
      refunds: readDecimal(source['refunds']),
      averageOrderValue: readDecimal(source['average_order_value']),
      topProduct: ReportEntity.fromMap(source['top_product']),
    );
  }

  final String? date;

  final int? year;

  final int? month;

  final int? day;

  final String? label;

  final String? monthName;

  final double? sales;

  final double? totalSales;

  final int? orders;

  final double? ordersValue;

  final double? grossSales;

  final double? shipping;

  final double? handling;

  final double? tax;

  final double? discount;

  final double? refunds;

  final double? averageOrderValue;

  final ReportEntity? topProduct;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'date': date,
        'year': year,
        'month': month,
        'day': day,
        'label': label,
        'month_name': monthName,
        'sales': sales,
        'total_sales': totalSales,
        'orders': orders,
        'orders_value': ordersValue,
        'gross_sales': grossSales,
        'shipping': shipping,
        'handling': handling,
        'tax': tax,
        'discount': discount,
        'refunds': refunds,
        'average_order_value': averageOrderValue,
        'top_product': topProduct,
      };
}

/// The rows added up; `sales` always, the rest with `breakdown`.
class SalesTotals extends Dto {
  const SalesTotals({
    this.sales,
    this.orders,
    this.ordersValue,
    this.grossSales,
    this.shipping,
    this.handling,
    this.tax,
    this.discount,
    this.refunds,
    this.averageOrderValue,
  });

  /// Reads a [SalesTotals] from a decoded body.
  static SalesTotals? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SalesTotals(
      sales: readDecimal(source['sales']),
      orders: readInteger(source['orders']),
      ordersValue: readDecimal(source['orders_value']),
      grossSales: readDecimal(source['gross_sales']),
      shipping: readDecimal(source['shipping']),
      handling: readDecimal(source['handling']),
      tax: readDecimal(source['tax']),
      discount: readDecimal(source['discount']),
      refunds: readDecimal(source['refunds']),
      averageOrderValue: readDecimal(source['average_order_value']),
    );
  }

  final double? sales;

  final int? orders;

  final double? ordersValue;

  final double? grossSales;

  final double? shipping;

  final double? handling;

  final double? tax;

  final double? discount;

  final double? refunds;

  final double? averageOrderValue;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'sales': sales,
        'orders': orders,
        'orders_value': ordersValue,
        'gross_sales': grossSales,
        'shipping': shipping,
        'handling': handling,
        'tax': tax,
        'discount': discount,
        'refunds': refunds,
        'average_order_value': averageOrderValue,
      };
}

/// The sales report. `group_by` is `day` for a period up to a month and `month`
/// for a longer one; `sort` (`date` or `sales`) and `order` (`asc` or `desc`)
/// echo what was applied. A period with no sales has no rows.
class SalesReport extends Dto {
  const SalesReport({
    this.period,
    this.groupBy,
    this.sort,
    this.order,
    this.rows,
    this.totals,
  });

  /// Reads a [SalesReport] from a decoded body.
  static SalesReport? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SalesReport(
      period: ReportPeriod.fromMap(source['period']),
      groupBy: readText(source['group_by']),
      sort: readText(source['sort']),
      order: readText(source['order']),
      rows: readList<SalesRow>(source['rows'], SalesRow.fromMap),
      totals: SalesTotals.fromMap(source['totals']),
    );
  }

  final ReportPeriod? period;

  final String? groupBy;

  final String? sort;

  final String? order;

  final List<SalesRow?>? rows;

  final SalesTotals? totals;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'period': period,
        'group_by': groupBy,
        'sort': sort,
        'order': order,
        'rows': rows,
        'totals': totals,
      };
}

/// Orders placed in one month.
class DashboardOrderCount extends Dto {
  const DashboardOrderCount({
    this.date,
    this.year,
    this.month,
    this.count,
  });

  /// Reads a [DashboardOrderCount] from a decoded body.
  static DashboardOrderCount? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return DashboardOrderCount(
      date: readText(source['date']),
      year: readInteger(source['year']),
      month: readInteger(source['month']),
      count: readInteger(source['count']),
    );
  }

  final String? date;

  final int? year;

  final int? month;

  final int? count;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'date': date,
        'year': year,
        'month': month,
        'count': count,
      };
}

/// A product and its views.
class MostVisitedProduct extends Dto {
  const MostVisitedProduct({
    this.product,
    this.views,
  });

  /// Reads a [MostVisitedProduct] from a decoded body.
  static MostVisitedProduct? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return MostVisitedProduct(
      product: ReportEntity.fromMap(source['product']),
      views: readInteger(source['views']),
    );
  }

  final ReportEntity? product;

  final int? views;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product': product,
        'views': views,
      };
}

/// A product and the units sold, highest first.
class BestSellingProduct extends Dto {
  const BestSellingProduct({
    this.product,
    this.unitsSold,
  });

  /// Reads a [BestSellingProduct] from a decoded body.
  static BestSellingProduct? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return BestSellingProduct(
      product: ReportEntity.fromMap(source['product']),
      unitsSold: readInteger(source['units_sold']),
    );
  }

  final ReportEntity? product;

  final int? unitsSold;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'product': product,
        'units_sold': unitsSold,
      };
}

/// What needs attention now; `pending_fulfillment` is the orders waiting to
/// ship.
class OrderUpdates extends Dto {
  const OrderUpdates({
    this.lowStockItems,
    this.pendingFulfillment,
    this.paymentsToCapture,
  });

  /// Reads a [OrderUpdates] from a decoded body.
  static OrderUpdates? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return OrderUpdates(
      lowStockItems: readInteger(source['low_stock_items']),
      pendingFulfillment: readInteger(source['pending_fulfillment']),
      paymentsToCapture: readInteger(source['payments_to_capture']),
    );
  }

  final int? lowStockItems;

  final int? pendingFulfillment;

  final int? paymentsToCapture;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'low_stock_items': lowStockItems,
        'pending_fulfillment': pendingFulfillment,
        'payments_to_capture': paymentsToCapture,
      };
}

/// The summary: every section of the Dashboard in one answer. `quick_report` has
/// no `kpis`.
class SummaryReport extends Dto {
  const SummaryReport({
    this.period,
    this.quickReport,
    this.orderByMonth,
    this.ordersOverTime,
    this.salesReport,
    this.mostVisitedProducts,
    this.bestSellingProducts,
    this.orderUpdates,
  });

  /// Reads a [SummaryReport] from a decoded body.
  static SummaryReport? fromMap(Object? body) {
    final source = readRecord(body);
    if (source == null) return null;
    return SummaryReport(
      period: ReportPeriod.fromMap(source['period']),
      quickReport: QuickReport.fromMap(source['quick_report']),
      orderByMonth: readList<DashboardOrderCount>(
          source['order_by_month'], DashboardOrderCount.fromMap),
      ordersOverTime: readList<DashboardOrderCount>(
          source['orders_over_time'], DashboardOrderCount.fromMap),
      salesReport: readList<SalesRow>(source['sales_report'], SalesRow.fromMap),
      mostVisitedProducts: readList<MostVisitedProduct>(
          source['most_visited_products'], MostVisitedProduct.fromMap),
      bestSellingProducts: readList<BestSellingProduct>(
          source['best_selling_products'], BestSellingProduct.fromMap),
      orderUpdates: OrderUpdates.fromMap(source['order_updates']),
    );
  }

  final ReportPeriod? period;

  final QuickReport? quickReport;

  final List<DashboardOrderCount?>? orderByMonth;

  final List<DashboardOrderCount?>? ordersOverTime;

  final List<SalesRow?>? salesReport;

  final List<MostVisitedProduct?>? mostVisitedProducts;

  final List<BestSellingProduct?>? bestSellingProducts;

  final OrderUpdates? orderUpdates;

  @override
  Map<String, Object?> get fields => <String, Object?>{
        'period': period,
        'quick_report': quickReport,
        'order_by_month': orderByMonth,
        'orders_over_time': ordersOverTime,
        'sales_report': salesReport,
        'most_visited_products': mostVisitedProducts,
        'best_selling_products': bestSellingProducts,
        'order_updates': orderUpdates,
      };
}
