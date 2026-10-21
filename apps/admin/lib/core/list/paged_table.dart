import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/admin_localizations.dart';
import 'list_controller.dart';
import 'list_query.dart';

/// A dashboard list, ERPNext-style: a search box and filter pills, the
/// table, and a pager. It also handles the in-between states: loading,
/// failed (with retry), nothing yet ([empty]) and no matches.
///
/// [query] and [page] are the list's providers (see [ListController] and
/// [loadPage]); the screen only describes its columns and filters.
class PagedTable<T, F> extends AppView {
  const PagedTable({
    required this.query,
    required this.page,
    required this.columns,
    required this.totalLabel,
    required this.searchHint,
    required this.empty,
    this.filters = const [],
    this.onOpen,
    super.key,
  });

  final NotifierProvider<ListController<F>, ListQuery<F>> query;
  final FutureProvider<PageResult<T>> page;
  final List<TableColumn<T>> columns;

  /// "12 stores", shown at the end of the table header.
  final String Function(int total) totalLabel;
  final String searchHint;

  /// Pills after "All", e.g. `[(StoreStatus.active, s.filterActive)]`.
  final List<(F, String)> filters;

  /// Shown when the list has no rows at all yet.
  final Widget empty;
  final void Function(T row)? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final current = ref.watch(query);
    final controller = ref.read(query.notifier);
    final result = ref.watch(page);
    final rows = result.value;

    final Widget? placeholder = switch (result) {
      _ when rows != null && rows.items.isNotEmpty => null,
      AsyncError(:final error) when rows == null => SErrorView(
        failure: error is AppFailure ? error : UnknownFailure(error),
        onRetry: () => ref.invalidate(page),
      ),
      _ when rows == null => const SLoadingView(),
      _ when current.hasFilters => SEmptyView(
        title: s.listNoResults,
        message: s.listNoResultsMessage,
        icon: SIcons.noResults,
      ),
      _ => empty,
    };

    return SListPage(
      loading: result.isLoading && rows != null,
      filters: SFilterBar(
        search: SSearchField(
          hint: searchHint,
          initialValue: current.search,
          onChanged: controller.setSearch,
        ),
        filters: [
          if (filters.isNotEmpty)
            for (final (filter, label) in [(null, s.filterAll), ...filters])
              SPill(
                label: label,
                selected: current.filter == filter,
                onTap: () => controller.setFilter(filter),
              ),
        ],
      ),
      placeholder: placeholder,
      table: placeholder != null || rows == null
          ? null
          : STable<T>(
              rows: rows.items,
              totalLabel: totalLabel(rows.total),
              columns: columns,
              onOpen: onOpen,
            ),
      pager: rows == null
          ? null
          : SPager(
              pageLabel: s.pageOf(
                current.page,
                rows.pageCount(current.pageSize),
              ),
              pageSize: current.pageSize,
              pageSizes: ListQuery.pageSizes,
              onPageSize: controller.setPageSize,
              onPrevious: current.page > 1 ? controller.previousPage : null,
              onNext: current.page < rows.pageCount(current.pageSize)
                  ? controller.nextPage
                  : null,
              previousLabel: s.previousPage,
              nextLabel: s.nextPage,
            ),
    );
  }
}
