import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';

/// Which searches the list shows: those that found no offer the last
/// time, or those that found some. Null shows both.
enum SearchTermFilter { nothingFound, found }

/// Something customers searched for, counted by the words, never by who.
class SearchTerm {
  const SearchTerm({
    required this.query,
    required this.searchCount,
    required this.lastResultCount,
    required this.lastSearchedAt,
  });

  /// As the search reads it: normalized, without words that say nothing.
  final String query;
  final int searchCount;

  /// Offers found the last time. None: words the search should learn.
  final int lastResultCount;
  final DateTime lastSearchedAt;
}

typedef SearchTermQuery = ListQuery<SearchTermFilter>;
typedef SearchTermPage = PageResult<SearchTerm>;

abstract interface class SearchTermRepository {
  /// The most searched first.
  Future<Result<SearchTermPage>> list(SearchTermQuery query);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final searchTermRepositoryProvider = Provider<SearchTermRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
