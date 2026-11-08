import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/search_term.dart';

/// The searches list's search, filter and page.
final searchTermQueryProvider =
    NotifierProvider.autoDispose<
      ListController<SearchTermFilter>,
      SearchTermQuery
    >(ListController.new);

/// The current page of searches.
final searchTermPageProvider = FutureProvider.autoDispose<SearchTermPage>(
  (ref) => loadPage(
    ref.watch(searchTermRepositoryProvider).list,
    ref.watch(searchTermQueryProvider),
  ),
);
