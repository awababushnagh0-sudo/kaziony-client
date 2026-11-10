import 'package:kernel/kernel.dart';

import '../../offers/domain/offer.dart';
import '../domain/booking.dart';
import 'bookings_view_model.dart';

class ReserveState {
  const ReserveState({
    required this.quantity,
    this.sending = false,
    this.failure,
  });

  final int quantity;
  final bool sending;

  /// Why the last try was refused, said in the confirmation sheet.
  final AppFailure? failure;
}

/// How many pieces of [offer] to reserve, picked on its page, and
/// reserving them once confirmed.
class ReserveViewModel extends ViewModel<ReserveState> {
  ReserveViewModel(this.offer);

  final Offer offer;

  @override
  ReserveState build() => const ReserveState(quantity: 1);

  void setQuantity(int quantity) =>
      state = ReserveState(quantity: quantity.clamp(1, offer.maxReservable));

  /// A fresh try: the last refusal isn't said again.
  void clearFailure() => state = ReserveState(quantity: state.quantity);

  /// The booking made, or null when it was refused ([ReserveState.failure]
  /// says why).
  Future<Booking?> reserve() async {
    if (state.sending) return null;
    final quantity = state.quantity;
    state = ReserveState(quantity: quantity, sending: true);
    final result = await ref
        .read(bookingsRepositoryProvider)
        .reserve(offer.id, quantity: quantity);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        // One more held: the warnings count it.
        ref.invalidate(bookingStandingProvider);
        state = ReserveState(quantity: quantity);
        return value;
      case Err(:final failure):
        // Refused for where the customer stands, which changed since it
        // was loaded: the pages catch up.
        if (failure
            case ForbiddenFailure(code: 'ClaimBanned') ||
                ConflictFailure(code: 'TooManyReservations')) {
          ref.invalidate(bookingStandingProvider);
        }
        state = ReserveState(quantity: quantity, failure: failure);
        return null;
    }
  }
}

final reserveViewModel = NotifierProvider.autoDispose
    .family<ReserveViewModel, ReserveState, Offer>(ReserveViewModel.new);
