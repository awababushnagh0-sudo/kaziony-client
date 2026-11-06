import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../../stores/domain/store.dart';
import '../domain/offer.dart';
import 'offers_view_model.dart';

/// What the Search tab searches: the words, a kind of store, and the sort
/// of the offers found. Its own, so a "See all" list never shares it.
final searchFilterProvider =
    NotifierProvider.autoDispose<OffersFilterController, OffersFilter>(
      () => OffersFilterController(const OffersFilter()),
    );

/// Whether [filter] asks for anything: before that, the tab shows ideas
/// instead of results.
bool isSearching(OffersFilter filter) =>
    filter.search.isNotEmpty || filter.categoryId != null;

/// The offers the Search tab found.
final searchOffersProvider =
    AsyncNotifierProvider.autoDispose<OffersViewModel, PagedItems<Offer>>(
      () => OffersViewModel(searchFilterProvider),
    );

/// The few closest stores whose name matches the search, of the kind
/// chosen, shown above the offers found.
final searchStoresProvider = FutureProvider.autoDispose<List<StoreSummary>>((
  ref,
) async {
  final filter = ref.watch(searchFilterProvider);
  final result = await ref
      .watch(storesRepositoryProvider)
      .nearby(
        StoresQuery(
          around: ref.watch(browseLocationProvider)!.point,
          categoryId: filter.categoryId,
          search: filter.search,
        ),
        page: 1,
        pageSize: searchStoresSize,
      );
  return switch (result) {
    Ok(:final value) => value.items,
    Err(:final failure) => throw failure,
  };
});

/// Stores above the offers found: the closest few, the offers stay in
/// sight.
const searchStoresSize = 3;

/// Stores near you, before searching: a short list, not a directory.
const nearbyStoresShown = 5;
