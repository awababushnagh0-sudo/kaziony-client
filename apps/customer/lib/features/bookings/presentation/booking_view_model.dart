import 'package:kernel/kernel.dart';

import '../domain/booking.dart';
import 'bookings_view_model.dart';

/// One booking, for its pickup code page: cancelling it, and rating the
/// store once it's picked up.
class BookingViewModel extends AsyncViewModel<Booking> {
  BookingViewModel(this.bookingId);

  final String bookingId;

  @override
  Future<Booking> build() async =>
      switch (await ref.watch(bookingsRepositoryProvider).get(bookingId)) {
        Ok(:final value) => value,
        Err(:final failure) => throw failure,
      };

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
        state = AsyncData(value);
        ref.invalidate(bookingsViewModel);
        return null;
      case Err(:final failure):
        return failure;
    }
  }
}

final bookingViewModel = AsyncNotifierProvider.autoDispose
    .family<BookingViewModel, Booking, String>(BookingViewModel.new);
