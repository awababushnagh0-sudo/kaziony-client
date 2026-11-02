import 'package:flutter/widgets.dart';

import 's_list_page_material.dart';

// Lists in the style of ERPNext. A list screen is an SScaffold whose body
// is an SListPage holding the filters, an STable and an SPager.

/// The body of a list screen: [filters] above the table, then the table and
/// the [pager] at the bottom. [table] is an STable; when it is null (no rows
/// yet, or an error), [placeholder] fills the space instead.
abstract interface class SListPage implements Widget {
  /// [loading] shows a thin bar at the top while a new page loads.
  const factory SListPage({
    required Widget? table,
    required Widget? placeholder,
    Widget? filters,
    Widget? pager,
    bool loading,
    Key? key,
  }) = SListPageMaterial;
}
