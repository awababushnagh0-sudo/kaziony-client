import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../domain/product.dart';
import 'products_view_model.dart';

/// One product, for its page and its edit page.
class ProductViewModel extends AsyncViewModel<Product> {
  ProductViewModel(this.productId);

  final String productId;

  @override
  Future<Product> build() async {
    final storeId = ref.watch(currentStoreProvider)?.storeId;
    if (storeId == null) throw const NotFoundFailure();
    return switch (await ref
        .watch(productRepositoryProvider)
        .get(storeId, productId)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Hides the product from the list, or brings it back.
  Future<AppFailure?> setArchived({required bool archived}) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    final result = await ref
        .read(productRepositoryProvider)
        .setArchived(storeId, productId, archived: archived);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        replace(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  /// Shows the product the server returned after a change.
  void replace(Product product) {
    state = AsyncData(product);
    // The list shows the change when the user goes back to it.
    ref.invalidate(productsViewModel);
  }
}

final productViewModel = AsyncNotifierProvider.autoDispose
    .family<ProductViewModel, Product, String>(ProductViewModel.new);
