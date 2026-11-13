import 'package:kernel/kernel.dart';

import '../domain/store.dart';
import 'store_pause_view_model.dart';

/// How long a break lasts.
enum BreakLength {
  minutes15(Duration(minutes: 15)),
  minutes30(Duration(minutes: 30)),
  hour(Duration(hours: 1)),

  /// Until the store's hours open next: the rest of the day.
  untilOpen(null);

  const BreakLength(this.duration);

  final Duration? duration;
}

/// What's being sent.
enum BreakAction {
  /// Stopping new bookings; those made stand.
  stop,

  /// Closing suddenly: the waiting bookings are cancelled too.
  close,

  /// Taking bookings again.
  resume,
}

class TakeBreakState {
  const TakeBreakState({
    this.length = BreakLength.minutes30,
    this.sending,
    this.failure,
  });

  final BreakLength length;
  final BreakAction? sending;
  final AppFailure? failure;
}

/// Going offline from the home page and back: the break's length, picked
/// in its sheet, and the calls, sent once at a time.
class TakeBreakViewModel extends ViewModel<TakeBreakState> {
  @override
  TakeBreakState build() => const TakeBreakState();

  void choose(BreakLength length) => state = TakeBreakState(length: length);

  /// Goes offline for the chosen length; with [cancelBookings], cancels
  /// the waiting bookings too. Null when it didn't ([TakeBreakState.failure]
  /// says why).
  Future<StorePaused?> pause({required bool cancelBookings}) async {
    if (state.sending != null) return null;
    final length = state.length;
    state = TakeBreakState(
      length: length,
      sending: cancelBookings ? BreakAction.close : BreakAction.stop,
    );
    final result = await ref
        .read(storePauseViewModel.notifier)
        .pause(duration: length.duration, cancelBookings: cancelBookings);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = TakeBreakState(length: length);
        return value;
      case Err(:final failure):
        state = TakeBreakState(length: length, failure: failure);
        return null;
    }
  }

  /// Takes bookings again. Returns what went wrong, or null.
  Future<AppFailure?> resume() async {
    if (state.sending != null) return null;
    final length = state.length;
    state = TakeBreakState(length: length, sending: BreakAction.resume);
    final failure = await ref.read(storePauseViewModel.notifier).resume();
    if (ref.mounted) state = TakeBreakState(length: length);
    return failure;
  }
}

final takeBreakViewModel =
    NotifierProvider.autoDispose<TakeBreakViewModel, TakeBreakState>(
      TakeBreakViewModel.new,
    );
