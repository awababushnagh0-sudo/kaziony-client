import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../domain/search_term.dart';
import 'search_terms_view_model.dart';

/// What customers search for in the app, the most searched first. Those
/// that found nothing are the words the search should learn. Only admins
/// see it.
class SearchTermsScreen extends AppView {
  const SearchTermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SScaffold(
      title: s.searchesTitle,
      padded: false,
      body: PagedTable<SearchTerm, SearchTermFilter>(
        query: searchTermQueryProvider,
        page: searchTermPageProvider,
        searchHint: s.searchesSearch,
        filters: [
          (SearchTermFilter.nothingFound, s.filterNothingFound),
          (SearchTermFilter.found, s.filterFound),
        ],
        totalLabel: s.searchesTotal,
        columns: [
          TableColumn(
            label: s.columnSearch,
            flex: 3,
            cell: (term) => SCellText(term.query, strong: true),
          ),
          TableColumn(
            label: s.columnSearchCount,
            cell: (term) => SCellText('${term.searchCount}'),
          ),
          TableColumn(
            label: s.columnFound,
            cell: (term) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: term.lastResultCount == 0
                  ? SBadge(s.foundNothing, tone: BadgeTone.danger)
                  : SBadge(s.foundOffers(term.lastResultCount)),
            ),
          ),
          TableColumn(
            label: s.columnLastSearched,
            minWidth: 640,
            cell: (term) => SCellText(
              formatDate(term.lastSearchedAt, languageCode: language),
            ),
          ),
        ],
        empty: SEmptyView(
          title: s.searchesEmpty,
          message: s.searchesEmptyMessage,
          icon: SIcons.search,
        ),
      ),
    );
  }
}
