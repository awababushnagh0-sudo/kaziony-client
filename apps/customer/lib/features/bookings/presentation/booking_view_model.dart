import 'package:kernel/kernel.dart';

import '../domain/booking.dart';
import 'bookings_view_model.dart';

/// One booking, for its pickup code page, and cancelling it.
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
  Future<AppFailure?> cancel() async {
    final result = await ref.read(bookingsRepositoryProvider).cancel(bookingId);
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
