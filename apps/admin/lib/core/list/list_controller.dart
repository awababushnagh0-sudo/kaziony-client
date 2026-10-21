import 'dart:async';

import 'package:kernel/kernel.dart';

import 'list_query.dart';

/// Holds a list's [ListQuery]. Changing the search, filter or page size
/// goes back to the first page.
///
/// ```dart
/// final storeQueryProvider = NotifierProvider.autoDispose<
///   ListController<StoreStatus>, ListQuery<StoreStatus>
/// >(ListController.new);
/// ```
class ListController<F> extends ViewModel<ListQuery<F>> {
  static const searchDelay = Duration(milliseconds: 300);

  Timer? _debounce;

  @override
  ListQuery<F> build() {
    ref.onDispose(() => _debounce?.cancel());
    return ListQuery<F>();
  }

  /// Waits for a pause in typing before searching.
  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(searchDelay, () {
      final search = value.trim();
      if (search != state.search) {
        state = state.copyWith(search: search, page: 1);
      }
    });
  }

  void setFilter(F? filter) => state = state.withFilter(filter);

  void setPageSize(int size) => state = state.copyWith(pageSize: size, page: 1);

  void nextPage() => state = state.copyWith(page: state.page + 1);

  void previousPage() =>
      state = state.copyWith(page: state.page > 1 ? state.page - 1 : 1);
}

/// Loads the page for [query] through [load], turning a failure into an
/// error the list shows with a retry button. While the next page loads,
/// the provider keeps the previous one, so the table doesn't flash.
Future<PageResult<T>> loadPage<T, F>(
  Future<Result<PageResult<T>>> Function(ListQuery<F> query) load,
  ListQuery<F> query,
) async => switch (await load(query)) {
  Ok(:final value) => value,
  Err(:final failure) => throw failure,
};
