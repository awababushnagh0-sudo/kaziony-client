import 'package:kernel/kernel.dart';

import '../domain/store.dart';
import 'stores_view_model.dart';

/// One store's details, and the admin's actions on it.
class StoreDetailsViewModel extends AsyncViewModel<StoreDetails> {
  StoreDetailsViewModel(this.storeId);

  final String storeId;

  StoreRepository get _stores => ref.read(storeRepositoryProvider);

  @override
  Future<StoreDetails> build() async {
    final result = await ref.watch(storeRepositoryProvider).get(storeId);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Hides the store from customers (and stops new offers), or shows it
  /// again.
  Future<Result<StoreDetails>> setActive({required bool active}) async {
    final result = await _stores.setActive(storeId, active: active);
    if (result case Ok(:final value)) {
      state = AsyncData(value);
      // The list beneath shows the status too.
      ref.invalidate(storePageProvider);
    }
    return result;
  }

  Future<Result<void>> delete() async {
    final result = await _stores.delete(storeId);
    if (result.isOk) ref.invalidate(storePageProvider);
    return result;
  }
}

final storeDetailsViewModel = AsyncNotifierProvider.autoDispose
    .family<StoreDetailsViewModel, StoreDetails, String>(
      StoreDetailsViewModel.new,
    );
