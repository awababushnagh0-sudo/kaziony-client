import 'dart:async';

import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../domain/offer.dart';

/// What the list of offers shows: a sort, a kind of store and a search.
class OffersFilter {
  const OffersFilter({
    this.sort = OfferSort.nearest,
    this.categoryId,
    this.search = '',
  });

  final OfferSort sort;
  final String? categoryId;
  final String search;

  OffersFilter copyWith({
    OfferSort? sort,
    String? Function()? categoryId,
    String? search,
  }) => OffersFilter(
    sort: sort ?? this.sort,
    categoryId: categoryId == null ? this.categoryId : categoryId(),
    search: search ?? this.search,
  );

  @override
  bool operator ==(Object other) =>
      other is OffersFilter &&
      other.sort == sort &&
      other.categoryId == categoryId &&
      other.search == search;

  @override
  int get hashCode => Object.hash(sort, categoryId, search);
}

/// The filter of one list, starting from [initial] (what "See all" or the
/// Search tab opened it with).
class OffersFilterController extends ViewModel<OffersFilter> {
  OffersFilterController(this.initial);

  final OffersFilter initial;

  static const searchDelay = Duration(milliseconds: 300);

  Timer? _debounce;

  @override
  OffersFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return initial;
  }

  /// Waits for a pause in typing before searching; an emptied field shows
  /// everything again at once.
  void setSearch(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) return searchNow(value);
    _debounce = Timer(searchDelay, () => searchNow(value));
  }

  /// Searches without waiting: the keyboard's search key, a recent search.
  void searchNow(String value) {
    _debounce?.cancel();
    final search = value.trim();
    if (search != state.search) state = state.copyWith(search: search);
  }

  void setSort(OfferSort sort) => state = state.copyWith(sort: sort);

  void setCategory(String? categoryId) =>
      state = state.copyWith(categoryId: () => categoryId);
}

final offersFilterProvider = NotifierProvider.autoDispose
    .family<OffersFilterController, OffersFilter, OffersFilter>(
      OffersFilterController.new,
    );

/// The offers that match [filter]: a list's own `offersFilterProvider`, or
/// the Search tab's.
class OffersViewModel extends PagedListViewModel<Offer, OffersQuery> {
  OffersViewModel(this.filter);

  final ProviderListenable<OffersFilter> filter;

  @override
  OffersQuery watchQuery() {
    final filter = ref.watch(this.filter);
    return OffersQuery(
      // The redirect keeps the app on the welcome pages until there's a
      // place.
      around: ref.watch(browseLocationProvider)!.point,
      sort: filter.sort,
      categoryId: filter.categoryId,
      search: filter.search,
    );
  }

  @override
  Future<Result<PageResult<Offer>>> fetch(
    OffersQuery query, {
    required int page,
  }) => ref
      .read(offersRepositoryProvider)
      .browse(query, page: page, pageSize: PagedListViewModel.pageSize);
}

final offersViewModel = AsyncNotifierProvider.autoDispose
    .family<OffersViewModel, PagedItems<Offer>, OffersFilter>(
      (initial) => OffersViewModel(offersFilterProvider(initial)),
    );
