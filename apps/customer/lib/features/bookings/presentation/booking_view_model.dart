import 'dart:async';

import 'package:kernel/kernel.dart';

import '../domain/booking.dart';
import 'bookings_view_model.dart';

/// One booking, for its pickup code page: cancelling it, and rating the
/// store once it's picked up. While it waits at the counter, asked for
/// again every few seconds, so the page turns to the stars the moment the
/// store scans the code.
class BookingViewModel extends AsyncViewModel<Booking> {
  BookingViewModel(this.bookingId);

  final String bookingId;

  /// How often a booking waiting at the counter is asked for again: short
  /// enough to follow the scan, one small request.
  static const checkEvery = Duration(seconds: 5);

  Timer? _checks;

  @override
  Future<Booking> build() async {
    final booking = switch (await ref
        .watch(bookingsRepositoryProvider)
        .get(bookingId)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    if (booking.status == BookingStatus.reserved) {
      _checks = Timer.periodic(checkEvery, (_) => _check());
      ref.onDispose(() => _checks?.cancel());
    }
    return booking;
  }

  /// Quietly: a failed check keeps the page as it is, the next may pass.
  /// Run out, it comes back expired, which ends the checks too.
  Future<void> _check() async {
    final result = await ref.read(bookingsRepositoryProvider).get(bookingId);
    if (!ref.mounted) return;
    if (result case Ok(:final value) when value.status != state.value?.status) {
      _show(value);
    }
  }

  /// What went wrong, or null when it's cancelled.
  Future<AppFailure?> cancel() =>
      _change((bookings) => bookings.cancel(bookingId));

  /// What went wrong, or null when the store is rated [stars].
  Future<AppFailure?> rate(int stars) =>
      _change((bookings) => bookings.rate(bookingId, stars));

  /// Shows the booking as it is after [change], here and in the list.
  Future<AppFailure?> _change(
    Future<Result<Booking>> Function(BookingsRepository) change,
  ) async {
    final result = await change(ref.read(bookingsRepositoryProvider));
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        _show(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  /// Shows [booking] here and in the list, and stops checking once it's
  /// no longer waiting.
  void _show(Booking booking) {
    if (booking.status != BookingStatus.reserved) _checks?.cancel();
    state = AsyncData(booking);
    ref.invalidate(bookingsViewModel);
  }
}

final bookingViewModel = AsyncNotifierProvider.autoDispose
    .family<BookingViewModel, Booking, String>(BookingViewModel.new);
