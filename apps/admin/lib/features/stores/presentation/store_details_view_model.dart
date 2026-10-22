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

  Future<Result<StoreDetails>> save(EditedStore edited) =>
      _apply(_stores.update(storeId, edited));

  /// Hides the store from customers (and stops new offers), or shows it
  /// again.
  Future<Result<StoreDetails>> setActive({required bool active}) =>
      _apply(_stores.setActive(storeId, active: active));

  Future<Result<StoreDetails>> _apply(
    Future<Result<StoreDetails>> change,
  ) async {
    final result = await change;
    if (result case Ok(:final value) when ref.mounted) {
      state = AsyncData(value);
      // The list beneath shows the name, category and status too.
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
