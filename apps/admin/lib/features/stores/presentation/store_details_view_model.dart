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

  /// With [cancelBookings], hours that close the store before bookings
  /// waiting are due cancel them.
  Future<Result<StoreDetails>> save(
    EditedStore edited, {
    bool cancelBookings = false,
  }) => _apply(_stores.update(storeId, edited, cancelBookings: cancelBookings));

  /// Hides the store from customers (and stops new offers), or shows it
  /// again.
  Future<Result<StoreDetails>> setActive({required bool active}) =>
      _apply(_stores.setActive(storeId, active: active));

  /// What turning it off touches, read fresh for the confirmation.
  Future<Result<StoreOngoing>> ongoing() => _stores.ongoing(storeId);

  /// Once it's off: its customers are told why. How many it cancelled.
  Future<Result<int>> cancelBookings() => _stores.cancelBookings(storeId);

  /// Puts [photo] in place of the logo or cover; [onProgress] goes from 0
  /// to 1.
  Future<Result<StoreDetails>> setImage(
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) => _apply(_stores.setImage(storeId, image, photo, onProgress: onProgress));

  /// A live store keeps its logo: that fails with [StoreCodes.notReady].
  Future<Result<StoreDetails>> removeImage(StoreImage image) =>
      _apply(_stores.removeImage(storeId, image));

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
