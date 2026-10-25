import 'dart:async';

import 'package:kernel/kernel.dart';

import '../../../core/list/paged_list_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/product.dart';

/// The search and the current or archived products.
class ProductQuery {
  const ProductQuery({this.search = '', this.archived = false});

  final String search;
  final bool archived;

  @override
  bool operator ==(Object other) =>
      other is ProductQuery &&
      other.search == search &&
      other.archived == archived;

  @override
  int get hashCode => Object.hash(search, archived);
}

class ProductQueryController extends ViewModel<ProductQuery> {
  static const searchDelay = Duration(milliseconds: 300);

  Timer? _debounce;

  @override
  ProductQuery build() {
    ref.onDispose(() => _debounce?.cancel());
    return const ProductQuery();
  }

  /// Waits for a pause in typing before searching.
  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(searchDelay, () {
      final search = value.trim();
      if (search != state.search) {
        state = ProductQuery(search: search, archived: state.archived);
      }
    });
  }

  void setArchived({required bool archived}) =>
      state = ProductQuery(search: state.search, archived: archived);
}

final productQueryProvider =
    NotifierProvider.autoDispose<ProductQueryController, ProductQuery>(
      ProductQueryController.new,
    );

class ProductsViewModel
    extends PagedListViewModel<Product, (String?, ProductQuery)> {
  @override
  (String?, ProductQuery) watchQuery() => (
    ref.watch(currentStoreProvider)?.storeId,
    ref.watch(productQueryProvider),
  );

  @override
  Future<Result<PageResult<Product>>> fetch(
    (String?, ProductQuery) query, {
    required int page,
  }) async {
    final (storeId, filter) = query;
    // The tab only opens inside a store.
    if (storeId == null) return const Err(NotFoundFailure());
    return ref
        .read(productRepositoryProvider)
        .list(
          storeId,
          page: page,
          pageSize: PagedListViewModel.pageSize,
          search: filter.search,
          archived: filter.archived,
        );
  }
}

final productsViewModel =
    AsyncNotifierProvider.autoDispose<ProductsViewModel, PagedItems<Product>>(
      ProductsViewModel.new,
    );
