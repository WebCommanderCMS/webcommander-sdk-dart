/// Dashboard section path templates; the client fills `{api_version}`.
class DashboardSectionUrls {
  DashboardSectionUrls._();

  /// One tab of the Dashboard, by its key.
  static const String section =
      '/api/{api_version}/admin/dashboard/sections/{section}';

  /// The five `{section}` path values, the tabs of the Dashboard's
  /// `section_tabs` section.
  static const List<String> sections = <String>[
    'ecommerce',
    'content',
    'bookings',
    'courses',
    'blog',
  ];
}
