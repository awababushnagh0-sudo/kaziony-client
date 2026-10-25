import 'package:kernel/kernel.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';

/// The current store's details, for its info, branches and team pages.
class StoreViewModel extends AsyncViewModel<Store> {
  @override
  Future<Store> build() async {
    // The pages that use this only open inside a store.
    final storeId = ref.watch(currentStoreProvider)?.storeId;
    if (storeId == null) throw const NotFoundFailure();
    final result = await ref.watch(storeRepositoryProvider).getStore(storeId);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }

  /// Shows the store the server returned after an edit, without loading
  /// it again.
  void replace(Store store) => state = AsyncData(store);
}

final storeViewModel = AsyncNotifierProvider.autoDispose<StoreViewModel, Store>(
  StoreViewModel.new,
);
