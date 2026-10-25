import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../store/domain/current_store.dart';
import '../domain/product.dart';
import 'products_view_model.dart';

/// One product, for its edit page.
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

  /// Shows the product the server returned after a change.
  void replace(Product product) => state = AsyncData(product);
}

final productViewModel = AsyncNotifierProvider.autoDispose
    .family<ProductViewModel, Product, String>(ProductViewModel.new);

class ProductFormState {
  const ProductFormState({
    this.saving = false,
    this.archiving = false,
    this.failure,
  });

  final bool saving;
  final bool archiving;
  final AppFailure? failure;
}

/// Adds a product ([productId] null) or edits one. Editing starts from the
/// product its page has already loaded.
class ProductFormViewModel extends ViewModel<ProductFormState> {
  ProductFormViewModel(this.productId);

  final String? productId;

  late final FormGroup form;

  @override
  ProductFormState build() {
    final id = productId;
    final product = id == null
        ? null
        : ref.read(productViewModel(id)).requireValue;
    form = FormGroup({
      'title': FormControl<String>(
        value: product?.title,
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'description': FormControl<String>(
        value: product?.description,
        validators: [Validators.maxLength(1000)],
      ),
      'price': FormControl<String>(
        value: product?.regularPrice,
        validators: [Validators.required, SValidators.price],
      ),
    });
    ref.onDispose(form.dispose);
    return const ProductFormState();
  }

  /// Returns the saved product, or null when it wasn't saved.
  Future<Product?> save() async {
    if (state.saving || state.archiving) return null;
    if (form.invalid) {
      form.markAllAsTouched();
      return null;
    }
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return null;
    state = const ProductFormState(saving: true);

    final description = (form.control('description').value as String?)?.trim();
    final draft = ProductDraft(
      title: (form.control('title').value as String).trim(),
      description: description == null || description.isEmpty
          ? null
          : description,
      regularPrice: parsePrice(form.control('price').value as String)!,
    );
    final products = ref.read(productRepositoryProvider);
    final id = productId;
    final result = id == null
        ? await products.create(storeId, draft)
        : await products.update(storeId, id, draft);
    return _done(result) ? result.valueOrNull : null;
  }

  /// Hides the product from the list, or brings it back. Returns true when
  /// it worked.
  Future<bool> setArchived({required bool archived}) async {
    final id = productId;
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (id == null || storeId == null || state.saving || state.archiving) {
      return false;
    }
    state = const ProductFormState(archiving: true);
    final result = await ref
        .read(productRepositoryProvider)
        .setArchived(storeId, id, archived: archived);
    return _done(result);
  }

  bool _done(Result<Product> result) {
    if (!ref.mounted) return false;
    switch (result) {
      case Ok():
        // The list shows the change when the user goes back to it.
        ref.invalidate(productsViewModel);
        state = const ProductFormState();
      case Err(:final failure):
        state = ProductFormState(failure: failure);
    }
    return result.isOk;
  }
}

final productFormViewModel = NotifierProvider.autoDispose
    .family<ProductFormViewModel, ProductFormState, String?>(
      ProductFormViewModel.new,
    );
