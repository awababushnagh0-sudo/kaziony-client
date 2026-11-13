import 'package:kernel/kernel.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';

/// Whether the current store takes bookings now, for the home page, where
/// owners and staff take a break or close suddenly, and come back.
class StorePauseViewModel extends AsyncViewModel<StorePause> {
  @override
  Future<StorePause> build() async {
    final storeId = ref.watch(currentStoreProvider)?.storeId;
    if (storeId == null) throw const NotFoundFailure();
    final result = await ref.watch(storeRepositoryProvider).getPause(storeId);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Loads it again behind what's shown. Returns what went wrong, or null.
  Future<AppFailure?> refresh() async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    final result = await ref.read(storeRepositoryProvider).getPause(storeId);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = AsyncData(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  /// Stops new bookings for [duration], or until the hours open next when
  /// null; with [cancelBookings], cancels the waiting ones too.
  Future<Result<StorePaused>> pause({
    required Duration? duration,
    required bool cancelBookings,
  }) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const Err(NotFoundFailure());
    final result = await ref
        .read(storeRepositoryProvider)
        .pause(storeId, duration: duration, cancelBookings: cancelBookings);
    if (result case Ok(:final value) when ref.mounted) {
      state = AsyncData(value.pause);
    }
    return result;
  }

  /// Takes bookings again. Returns what went wrong, or null.
  Future<AppFailure?> resume() async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    final result = await ref.read(storeRepositoryProvider).resume(storeId);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = AsyncData(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }
}

final storePauseViewModel =
    AsyncNotifierProvider.autoDispose<StorePauseViewModel, StorePause>(
      StorePauseViewModel.new,
    );
