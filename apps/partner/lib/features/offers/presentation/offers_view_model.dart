import 'package:kernel/kernel.dart';

import '../../../core/list/paged_list_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';

/// Which offers the list shows: all (null), active, paused or ended.
class OfferFilterController extends ViewModel<OfferStatus?> {
  @override
  OfferStatus? build() => null;

  void show(OfferStatus? status) => state = status;
}

final offerFilterProvider =
    NotifierProvider.autoDispose<OfferFilterController, OfferStatus?>(
      OfferFilterController.new,
    );

class OffersViewModel
    extends PagedListViewModel<Offer, (String?, OfferStatus?)> {
  @override
  (String?, OfferStatus?) watchQuery() => (
    ref.watch(currentStoreProvider)?.storeId,
    ref.watch(offerFilterProvider),
  );

  @override
  Future<Result<PageResult<Offer>>> fetch(
    (String?, OfferStatus?) query, {
    required int page,
  }) async {
    final (storeId, status) = query;
    // The tab only opens inside a store.
    if (storeId == null) return const Err(NotFoundFailure());
    return ref
        .read(offerRepositoryProvider)
        .list(
          storeId,
          page: page,
          pageSize: PagedListViewModel.pageSize,
          status: status,
        );
  }
}

final offersViewModel =
    AsyncNotifierProvider.autoDispose<OffersViewModel, PagedItems<Offer>>(
      OffersViewModel.new,
    );
