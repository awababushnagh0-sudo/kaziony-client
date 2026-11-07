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

  static bool _waiting(PagedItems<Booking>? page) =>
      page?.items.any((booking) => booking.status == BookingStatus.reserved) ??
      false;

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
