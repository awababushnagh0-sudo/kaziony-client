import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../pill/s_pill.dart';
import 's_list_page.dart';
import 's_pager.dart';

/// [SListPage] as one scroll view: the table's slivers, or an empty or
/// error view filling the rest.
class SListPageMaterial extends StatelessWidget implements SListPage {
  const SListPageMaterial({
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
  Widget build(BuildContext context) {
    Widget fill(Widget child) =>
        SliverFillRemaining(hasScrollBody: false, child: child);
    final table = this.table;
    return CustomScrollView(
      slivers: [
        if (filters case final filters?) SliverToBoxAdapter(child: filters),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 2,
            child: loading ? const LinearProgressIndicator() : null,
          ),
        ),
        // The table is made of slivers; empty and error views are boxes.
        if (table != null) table else fill(placeholder!),
        // At the bottom of the window when the rows don't fill it.
        if (table != null && pager != null)
          fill(
            Align(alignment: AlignmentDirectional.bottomCenter, child: pager),
          ),
      ],
    );
  }
}

/// [SPager] on a bar with a line above it, Material's [IconButton]s for
/// previous and next.
class SPagerMaterial extends StatelessWidget implements SPager {
  const SPagerMaterial({
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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          for (final size in pageSizes)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.xs),
              child: SPill(
                label: '$size',
                selected: size == pageSize,
                onTap: () => onPageSize(size),
              ),
            ),
          const Spacer(),
          Text(
            pageLabel,
            style: TextStyle(
              color: c.textMuted,
              fontSize: context.style.text.small,
            ),
          ),
          const Gap(Space.sm),
          IconButton(
            tooltip: previousLabel,
            icon: Icon(
              materialIcon(SIcons.chevronBack),
              size: SIconSize.sm.pixels,
            ),
            onPressed: onPrevious,
          ),
          IconButton(
            tooltip: nextLabel,
            icon: Icon(materialIcon(SIcons.chevron), size: SIconSize.sm.pixels),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
