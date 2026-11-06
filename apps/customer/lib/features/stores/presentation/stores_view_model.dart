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

/// The stores the signed-in customer saved to their favorites, the last
/// saved first; empty for guests. Saving or removing a store on its page
/// invalidates it.
class FavoriteStoresViewModel extends AsyncViewModel<List<StoreSummary>> {
  @override
  Future<List<StoreSummary>> build() async {
    if (ref.watch(sessionProvider) is! SignedIn) return const [];
    return switch (await ref.watch(storesRepositoryProvider).followed()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Takes [storeId] out of the favorites: gone from the list at once,
  /// back in its place if the server refuses, with why.
  Future<AppFailure?> remove(String storeId) async {
    final stores = state.value;
    final index = stores?.indexWhere((store) => store.id == storeId) ?? -1;
    if (stores == null || index < 0) return null;
    final removed = stores[index];
    state = AsyncData([...stores]..removeAt(index));
    final result = await ref.read(storesRepositoryProvider).unfollow(storeId);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok():
        return null;
      case Err(:final failure):
        // Only this one comes back: others may have gone meanwhile.
        final now = [...?state.value];
        now.insert(index.clamp(0, now.length), removed);
        state = AsyncData(now);
        return failure;
    }
  }
}

final favoriteStoresViewModel =
    AsyncNotifierProvider.autoDispose<
      FavoriteStoresViewModel,
      List<StoreSummary>
    >(FavoriteStoresViewModel.new);
