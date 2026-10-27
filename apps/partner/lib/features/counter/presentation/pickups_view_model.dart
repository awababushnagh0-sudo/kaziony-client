import 'package:kernel/kernel.dart';

import '../../../core/list/paged_list_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/claim.dart';

/// Customers on their way: reservations not picked up yet, soonest to
/// expire first.
class PickupsViewModel extends PagedListViewModel<Claim, String?> {
  @override
  String? watchQuery() => ref.watch(currentStoreProvider)?.storeId;

  @override
  Future<Result<PageResult<Claim>>> fetch(
    String? storeId, {
    required int page,
  }) async {
    // The page only opens inside a store.
    if (storeId == null) return const Err(NotFoundFailure());
    return ref
        .read(claimRepositoryProvider)
        .upcoming(storeId, page: page, pageSize: PagedListViewModel.pageSize);
  }
}

final pickupsViewModel =
    AsyncNotifierProvider.autoDispose<PickupsViewModel, PagedItems<Claim>>(
      PickupsViewModel.new,
    );
