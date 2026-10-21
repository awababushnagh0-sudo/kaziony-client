import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_list_page_renderer.dart';

// Lists in the style of ERPNext. A list screen is an SScaffold whose body
// is an SListPage holding the filters, an STable and an SPager.

/// The body of a list screen. [table] is an STable; when it is null
/// (no rows yet, or an error), [placeholder] fills the space instead.
class SListPage extends StatelessWidget {
  const SListPage({
    required this.table,
    required this.placeholder,
    this.filters,
    this.pager,
    this.loading = false,
    super.key,
  }) : assert(table != null || placeholder != null);

  final Widget? table;
  final Widget? placeholder;
  final Widget? filters;
  final Widget? pager;

  /// Shows a thin bar at the top while a new page loads.
  final bool loading;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listPage.render(
    context,
    ListPageSpec(
      content: table ?? placeholder!,
      contentIsSliver: table != null,
      filters: filters,
      pager: table == null ? null : pager,
      loading: loading,
    ),
  );
}
