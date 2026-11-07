import 'package:kernel/kernel.dart';

import '../domain/booking.dart';

/// The pickups the signed-in customer rated, the latest rating first.
class RatingsViewModel extends PagedListViewModel<Booking, String?> {
  /// Whose ratings: another sign-in starts the list over.
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
    // Only signed in customers reach the page, from their account.
    if (userId == null) return const Ok(PageResult(items: [], total: 0));
    return ref
        .read(bookingsRepositoryProvider)
        .list(page: page, pageSize: PagedListViewModel.pageSize, rated: true);
  }
}

final ratingsViewModel =
    AsyncNotifierProvider.autoDispose<RatingsViewModel, PagedItems<Booking>>(
      RatingsViewModel.new,
    );
