import 'package:flutter/widgets.dart';

/// A list page's body: [filters] above the table, a thin bar while
/// [loading], then [content] (the table's slivers, or an empty or error
/// view) and the [pager] at the bottom.
@immutable
class ListPageSpec {
  const ListPageSpec({
    required this.content,
    required this.contentIsSliver,
    this.filters,
    this.pager,
    this.loading = false,
  });

  final Widget content;

  /// The table is made of slivers; empty and error views are boxes.
  final bool contentIsSliver;
  final Widget? filters;
  final Widget? pager;
  final bool loading;
}

@immutable
class PagerSpec {
  const PagerSpec({
    required this.pageLabel,
    required this.pageSize,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrevious,
    required this.onNext,
    required this.previousLabel,
    required this.nextLabel,
  });

  /// "Page 1 of 3".
  final String pageLabel;
  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;

  /// Null on the first (or last) page.
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String previousLabel;
  final String nextLabel;
}

abstract interface class ListPageRenderer {
  Widget render(BuildContext context, ListPageSpec spec);
  Widget pager(BuildContext context, PagerSpec spec);
}
