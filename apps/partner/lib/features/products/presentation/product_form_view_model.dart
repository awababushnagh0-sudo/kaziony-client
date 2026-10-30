import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../store/domain/current_store.dart';
import '../domain/product.dart';
import 'product_view_model.dart';
import 'products_view_model.dart';

class ProductFormState {
  const ProductFormState({this.saving = false, this.failure});

  final bool saving;
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
    if (state.saving) return null;
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
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        if (id == null) {
          // The list shows it when the user goes back to it.
          ref.invalidate(productsViewModel);
        } else {
          // Its page, under this one, and the list.
          ref.read(productViewModel(id).notifier).replace(value);
        }
        state = const ProductFormState();
        return value;
      case Err(:final failure):
        state = ProductFormState(failure: failure);
        return null;
    }
  }
}

final productFormViewModel = NotifierProvider.autoDispose
    .family<ProductFormViewModel, ProductFormState, String?>(
      ProductFormViewModel.new,
    );
