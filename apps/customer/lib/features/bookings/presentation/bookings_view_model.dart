import 'dart:async';

import 'package:kernel/kernel.dart';

import '../domain/booking.dart';

/// The customer's bookings, newest first. While one waits to be picked
/// up, loaded again now and then, so it moves to the past ones once the
/// store scans it, even with its pass closed.
class BookingsViewModel extends PagedListViewModel<Booking, String?> {
  /// Slower than the pass: the list only needs to catch up.
  static const checkEvery = Duration(seconds: 15);

  @override
  Future<PagedItems<Booking>> build() async {
    final page = await super.build();
    if (_waiting(page)) {
      final checks = Timer.periodic(checkEvery, (checks) {
        if (_waiting(state.value)) {
          refresh();
        } else {
          checks.cancel();
        }
      });
      ref.onDispose(checks.cancel);
    }
    return page;
  }

  /// Where the customer stands comes again with the list: a booking that
  /// ran out is a missed pickup, one picked up frees a place.
  @override
  Future<AppFailure?> refresh() {
    ref.invalidate(bookingStandingProvider);
    return super.refresh();
  }

  static bool _waiting(PagedItems<Booking>? page) =>
      page?.items.any((booking) => booking.underWay) ?? false;

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

/// Where the signed-in customer stands with booking, for the warnings on
/// the Bookings tab, the account and an offer's page (never home); null
/// for guests. Loaded again with the bookings, and after reserving or
/// cancelling. Failing, the warnings just don't show: the server still
/// says why when it refuses.
final bookingStandingProvider = FutureProvider.autoDispose<BookingStanding?>((
  ref,
) async {
  if (ref.watch(sessionProvider) is! SignedIn) return null;
  return switch (await ref.watch(bookingsRepositoryProvider).standing()) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
