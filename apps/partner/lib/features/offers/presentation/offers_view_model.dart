import 'package:kernel/kernel.dart';

import '../../home/presentation/home_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';

/// Which list the Offers tab shows: the current offers (false) or the
/// finished ones (true).
class EndedOffersController extends ViewModel<bool> {
  @override
  bool build() => false;

  void show({required bool ended}) => state = ended;
}

final showEndedOffersProvider =
    NotifierProvider.autoDispose<EndedOffersController, bool>(
      EndedOffersController.new,
    );

class OffersViewModel extends PagedListViewModel<Offer, (String?, bool)> {
  @override
  (String?, bool) watchQuery() => (
    ref.watch(currentStoreProvider)?.storeId,
    ref.watch(showEndedOffersProvider),
  );

  /// Shows a paused offer to customers again, from its card. Returns what
  /// went wrong, or null once the list shows it running.
  Future<AppFailure?> resume(String offerId) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    final result = await ref
        .read(offerRepositoryProvider)
        .resume(storeId, offerId);
    if (!ref.mounted) return null;
    if (result case Err(:final failure)) return failure;
    // Home lists the running offers too.
    ref.invalidate(homeViewModel);
    return refresh();
  }

  @override
  Future<Result<PageResult<Offer>>> fetch(
    (String?, bool) query, {
    required int page,
  }) async {
    final (storeId, ended) = query;
    // The tab only opens inside a store.
    if (storeId == null) return const Err(NotFoundFailure());
    return ref
        .read(offerRepositoryProvider)
        .list(
          storeId,
          page: page,
          pageSize: PagedListViewModel.pageSize,
          ended: ended,
        );
  }
}

final offersViewModel =
    AsyncNotifierProvider.autoDispose<OffersViewModel, PagedItems<Offer>>(
      OffersViewModel.new,
    );
