import 'package:kernel/kernel.dart';

/// The rows a phone list has loaded so far.
class PagedItems<T> {
  const PagedItems({
    required this.items,
    required this.total,
    this.loadingMore = false,
    this.moreFailure,
  });

  final List<T> items;

  /// How many rows match on the server.
  final int total;
  final bool loadingMore;

  /// Loading the next rows failed; the end of the list offers a retry.
  final AppFailure? moreFailure;

  bool get hasMore => items.length < total;
}

/// A phone list loaded [pageSize] rows at a time: more as the user scrolls
/// ([loadMore]), the first rows again when pulled down ([refresh]).
///
/// Subclasses say what to load ([watchQuery], watched so that a new search
/// starts over) and how ([fetch]).
abstract class PagedListViewModel<T, Q> extends AsyncViewModel<PagedItems<T>> {
  static const pageSize = 20;

  late Q _query;
  var _page = 1;

  /// Bumped whenever the list starts over, so rows that arrive for the
  /// list it replaced are dropped.
  var _generation = 0;

  /// Reads the search and filters with `ref.watch`.
  Q watchQuery();

  Future<Result<PageResult<T>>> fetch(Q query, {required int page});

  @override
  Future<PagedItems<T>> build() async {
    _query = watchQuery();
    _page = 1;
    _generation++;
    return switch (await fetch(_query, page: 1)) {
      Ok(:final value) => PagedItems(items: value.items, total: value.total),
      Err(:final failure) => throw failure,
    };
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    final generation = _generation;
    state = AsyncData(
      PagedItems(items: current.items, total: current.total, loadingMore: true),
    );
    final result = await fetch(_query, page: _page + 1);
    if (!ref.mounted || generation != _generation) return;
    switch (result) {
      case Ok(:final value):
        _page++;
        state = AsyncData(
          PagedItems(
            items: [...current.items, ...value.items],
            total: value.total,
          ),
        );
      case Err(:final failure):
        state = AsyncData(
          PagedItems(
            items: current.items,
            total: current.total,
            moreFailure: failure,
          ),
        );
    }
  }

  /// Loads the first rows again, keeping the list on screen meanwhile.
  /// Returns what went wrong, so the screen can say so over the old rows.
  Future<AppFailure?> refresh() async {
    final generation = ++_generation;
    final result = await fetch(_query, page: 1);
    if (!ref.mounted || generation != _generation) return null;
    switch (result) {
      case Ok(:final value):
        _page = 1;
        state = AsyncData(PagedItems(items: value.items, total: value.total));
        return null;
      case Err(:final failure):
        if (!state.hasValue) state = AsyncError(failure, StackTrace.current);
        return failure;
    }
  }
}
