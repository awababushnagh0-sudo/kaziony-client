import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../domain/offer.dart';

/// The kinds of store to filter by, in the admins' order.
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((
  ref,
) async {
  return switch (await ref.watch(offersRepositoryProvider).categories()) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// The category the home page shows; null for all of them.
class HomeCategory extends ViewModel<String?> {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

final homeCategoryProvider = NotifierProvider<HomeCategory, String?>(
  HomeCategory.new,
);

/// The home page's rows, each a different sort of the offers around, and
/// how many there are in all.
class HomeFeed {
  const HomeFeed({
    required this.nearby,
    required this.endingSoon,
    required this.biggestDiscount,
    required this.total,
  });

  final List<Offer> nearby;
  final List<Offer> endingSoon;
  final List<Offer> biggestDiscount;

  /// Every offer in reach, for the way to all of them.
  final int total;

  /// [nearby] holds every offer in reach, so empty means none at all.
  bool get isEmpty => nearby.isEmpty;
}

class HomeViewModel extends AsyncViewModel<HomeFeed> {
  /// Enough to fill a row that scrolls sideways; "See all" has the rest.
  static const rowSize = 10;

  @override
  Future<HomeFeed> build() {
    // The redirect keeps the app on the welcome pages until there's a
    // place.
    final around = ref.watch(browseLocationProvider)!.point;
    final categoryId = ref.watch(homeCategoryProvider);
    return _load(around, categoryId);
  }

  /// Loads the rows again, keeping these on screen meanwhile. Returns what
  /// went wrong, for the page to say over the old rows.
  Future<AppFailure?> refresh() async {
    try {
      final feed = await _load(
        ref.read(browseLocationProvider)!.point,
        ref.read(homeCategoryProvider),
      );
      if (ref.mounted) state = AsyncData(feed);
      return null;
    } on AppFailure catch (failure) {
      return failure;
    }
  }

  Future<HomeFeed> _load(GeoPoint around, String? categoryId) async {
    final repository = ref.read(offersRepositoryProvider);
    Future<PageResult<Offer>> row(OfferSort sort) async {
      final result = await repository.browse(
        OffersQuery(around: around, sort: sort, categoryId: categoryId),
        page: 1,
        pageSize: rowSize,
      );
      return switch (result) {
        Ok(:final value) => value,
        Err(:final failure) => throw failure,
      };
    }

    // Future.wait passes the first failure on as it is, for the page to
    // explain.
    final rows = await Future.wait([
      row(OfferSort.nearest),
      row(OfferSort.endingSoon),
      row(OfferSort.biggestDiscount),
    ]);
    return HomeFeed(
      nearby: rows[0].items,
      endingSoon: rows[1].items,
      biggestDiscount: rows[2].items,
      total: rows[0].total,
    );
  }
}

final homeFeedProvider =
    AsyncNotifierProvider.autoDispose<HomeViewModel, HomeFeed>(
      HomeViewModel.new,
    );
