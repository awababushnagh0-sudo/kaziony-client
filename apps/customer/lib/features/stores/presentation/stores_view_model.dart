import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../domain/store.dart';

/// The closest stores, for a row that scrolls sideways.
final nearbyStoresProvider = FutureProvider.autoDispose
    .family<List<StoreSummary>, String?>((ref, categoryId) async {
      final around = ref.watch(browseLocationProvider)!.point;
      final result = await ref
          .watch(storesRepositoryProvider)
          .nearby(
            StoresQuery(around: around, categoryId: categoryId),
            page: 1,
            pageSize: nearbyRowSize,
          );
      return switch (result) {
        Ok(:final value) => value.items,
        Err(:final failure) => throw failure,
      };
    });

/// Enough to fill a row that scrolls sideways.
const nearbyRowSize = 12;

/// The stores the signed-in customer follows; empty for guests. Following
/// or unfollowing a store invalidates it.
final followedStoresProvider = FutureProvider.autoDispose<List<StoreSummary>>((
  ref,
) async {
  if (ref.watch(sessionProvider) is! SignedIn) return const [];
  return switch (await ref.watch(storesRepositoryProvider).followed()) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
