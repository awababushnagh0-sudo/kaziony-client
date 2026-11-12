import 'package:kernel/kernel.dart';

import '../../home/presentation/home_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/claim.dart';
import 'deliveries_view_model.dart';
import 'pickups_view_model.dart';

/// A scanned or typed code, looked up for the counter.
class ClaimViewModel extends AsyncViewModel<Claim> {
  ClaimViewModel(this.code);

  final String code;

  @override
  Future<Claim> build() async {
    final storeId = ref.watch(currentStoreProvider)?.storeId;
    if (storeId == null) throw const NotFoundFailure();
    return switch (await ref
        .watch(claimRepositoryProvider)
        .lookup(storeId, code)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }
}

final claimViewModel = AsyncNotifierProvider.autoDispose
    .family<ClaimViewModel, Claim, String>(ClaimViewModel.new);

/// What the counter does with a booking.
enum ClaimAction {
  /// Handed over at the counter.
  pickup,

  /// Given to the store's driver.
  send,

  /// The driver handed it over.
  delivered,

  /// The delivery didn't happen: the booking is cancelled.
  notDelivered,
}

class PickupState {
  const PickupState({this.running, this.done, this.doneWith});

  /// What's being sent.
  final ClaimAction? running;

  /// The claim as the last action left it.
  final Claim? done;
  final ClaimAction? doneWith;
}

/// What the counter does with a booking: picking it up, or the delivery
/// steps. Each is sent once, however often its button is tapped.
class PickupViewModel extends ViewModel<PickupState> {
  PickupViewModel(this.code);

  final String code;

  @override
  PickupState build() => const PickupState();

  /// Each returns what went wrong, or null when it's done or the claim
  /// changed meanwhile (it's then loaded again, showing why).
  Future<AppFailure?> confirm() => _run(
    ClaimAction.pickup,
    (claims, storeId) => claims.redeem(storeId, code),
  );

  Future<AppFailure?> send() => _run(
    ClaimAction.send,
    (claims, storeId) => claims.sendForDelivery(storeId, code),
  );

  Future<AppFailure?> delivered(String claimId) => _run(
    ClaimAction.delivered,
    (claims, storeId) => claims.delivered(storeId, claimId),
  );

  Future<AppFailure?> notDelivered(String claimId) => _run(
    ClaimAction.notDelivered,
    (claims, storeId) => claims.notDelivered(storeId, claimId),
  );

  Future<AppFailure?> _run(
    ClaimAction action,
    Future<Result<Claim>> Function(ClaimRepository claims, String storeId) call,
  ) async {
    if (state.running != null || state.done != null) return null;
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    state = PickupState(running: action);
    final result = await call(ref.read(claimRepositoryProvider), storeId);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = PickupState(done: value, doneWith: action);
        ref
          ..invalidate(pickupsViewModel)
          ..invalidate(deliveriesViewModel)
          ..invalidate(homeViewModel);
        return null;
      case Err(failure: ConflictFailure()):
        // Picked up on another phone, cancelled, expired or closed
        // meanwhile.
        state = const PickupState();
        ref.invalidate(claimViewModel(code));
        return null;
      case Err(:final failure):
        state = const PickupState();
        return failure;
    }
  }
}

final pickupViewModel = NotifierProvider.autoDispose
    .family<PickupViewModel, PickupState, String>(PickupViewModel.new);
