import 'package:kernel/kernel.dart';

import '../domain/booking.dart';

/// The customer's bookings, newest first.
class BookingsViewModel extends PagedListViewModel<Booking, String?> {
  /// Whose bookings: another sign-in starts the list over.
  @override
  String? watchQuery() => switch (ref.watch(sessionProvider)) {
    SignedIn(:final user) => user.id,
    _ => null,
  };

  @override
  Future<Result<PageResult<Booking>>> fetch(
    String? userId, {
    required int page,
  }) async {
    // The tab asks guests to sign in instead of listing.
    if (userId == null) return const Ok(PageResult(items: [], total: 0));
    return ref
        .read(bookingsRepositoryProvider)
        .list(page: page, pageSize: PagedListViewModel.pageSize);
  }
}

final bookingsViewModel =
    AsyncNotifierProvider.autoDispose<BookingsViewModel, PagedItems<Booking>>(
      BookingsViewModel.new,
    );
