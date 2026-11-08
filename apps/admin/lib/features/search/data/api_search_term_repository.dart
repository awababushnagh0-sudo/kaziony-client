import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/search_term.dart';

class ApiSearchTermRepository implements SearchTermRepository {
  ApiSearchTermRepository(this._api);

  final Api _api;
  late final _terms = _api.client(AdminSearchClient.new);

  @override
  Future<Result<SearchTermPage>> list(SearchTermQuery query) async {
    final result = await _api.guard(
      () => _terms.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        nothingFound: switch (query.filter) {
          null => null,
          SearchTermFilter.nothingFound => true,
          SearchTermFilter.found => false,
        },
      ),
    );
    return result.map(
      (dto) => SearchTermPage(
        total: dto.meta.total.toInt(),
        items: [
          for (final term in dto.items)
            SearchTerm(
              query: term.query,
              searchCount: term.searchCount.toInt(),
              lastResultCount: term.lastResultCount.toInt(),
              lastSearchedAt: term.lastSearchedAt,
            ),
        ],
      ),
    );
  }
}
