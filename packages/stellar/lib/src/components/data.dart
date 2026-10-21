import 'package:flutter/widgets.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import 'app_icon.dart';

// Lists in the style of ERPNext. A list screen is an AppScaffold whose body
// is an AppListPage holding the filters, an AppTable and an AppPager.

/// The rows of a list, with a pinned header that ends with [totalLabel].
/// Made of slivers: put it in an [AppListPage].
class AppTable<T> extends StatelessWidget {
  const AppTable({
    required this.rows,
    required this.columns,
    required this.totalLabel,
    this.onOpen,
    super.key,
  });

  final List<T> rows;
  final List<TableColumn<T>> columns;
  final String totalLabel;
  final ValueChanged<T>? onOpen;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).data.table<T>(
    context,
    TableSpec<T>(
      rows: rows,
      columns: columns,
      totalLabel: totalLabel,
      onOpen: onOpen,
    ),
  );
}

/// The body of a list screen. [table] is an [AppTable]; when it is null
/// (no rows yet, or an error), [placeholder] fills the space instead.
class AppListPage extends StatelessWidget {
  const AppListPage({
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
  Widget build(BuildContext context) => StellarKit.of(context).data.listPage(
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

/// Page size choice, which page of how many, and previous/next.
class AppPager extends StatelessWidget {
  const AppPager({
    required this.pageLabel,
    required this.pageSize,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrevious,
    required this.onNext,
    required this.previousLabel,
    required this.nextLabel,
    super.key,
  });

  final String pageLabel;
  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String previousLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).data.pager(
    context,
    PagerSpec(
      pageLabel: pageLabel,
      pageSize: pageSize,
      pageSizes: pageSizes,
      onPageSize: onPageSize,
      onPrevious: onPrevious,
      onNext: onNext,
      previousLabel: previousLabel,
      nextLabel: nextLabel,
    ),
  );
}

/// The bar above a list: a search box, then filter pills.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    required this.search,
    this.filters = const [],
    super.key,
  });

  final Widget search;
  final List<Widget> filters;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 640;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: narrow ? constraints.maxWidth : 280, child: search),
            ...filters,
          ],
        );
      },
    ),
  );
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).data.searchField(
    context,
    SearchFieldSpec(
      hint: hint,
      onChanged: onChanged,
      initialValue: initialValue,
    ),
  );
}

/// A small toggle (filters, page size), dark when [selected].
class AppPill extends StatelessWidget {
  const AppPill({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final AppIcon? icon;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).data.pill(
    context,
    PillSpec(label: label, selected: selected, onTap: onTap, icon: icon),
  );
}

/// A small rounded status label, like ERPNext's indicator pills.
class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {this.tone = BadgeTone.neutral, super.key});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).data.badge(context, label, tone);
}

/// A table cell's text. [strong] for the column that names the row, [ltr]
/// for numbers, phones and emails.
class AppCellText extends StatelessWidget {
  const AppCellText(
    this.text, {
    this.strong = false,
    this.ltr = false,
    super.key,
  });

  final String text;
  final bool strong;
  final bool ltr;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).data
          .cellText(context, text, strong: strong, ltr: ltr);
}
