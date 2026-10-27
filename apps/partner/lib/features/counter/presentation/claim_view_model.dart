import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../domain/claim.dart';
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

class PickupState {
  const PickupState({this.sending = false, this.done});

  final bool sending;

  /// The claim as it was picked up.
  final Claim? done;
}

/// Confirming a pickup: sent once, however often the button is tapped.
class PickupViewModel extends ViewModel<PickupState> {
  PickupViewModel(this.code);

  final String code;

  @override
  PickupState build() => const PickupState();

  /// Returns what went wrong, or null when it's picked up or the claim
  /// changed meanwhile (it's then loaded again, showing why).
  Future<AppFailure?> confirm({String? branchId}) async {
    if (state.sending || state.done != null) return null;
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    state = const PickupState(sending: true);
    final result = await ref
        .read(claimRepositoryProvider)
        .redeem(storeId, code, branchId: branchId);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = PickupState(done: value);
        ref.invalidate(pickupsViewModel);
        return null;
      case Err(failure: ConflictFailure()):
        // Picked up on another phone, cancelled or expired meanwhile.
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
