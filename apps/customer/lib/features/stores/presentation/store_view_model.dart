import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../domain/store.dart';
import 'stores_view_model.dart';

/// One store, for its page, and following it. Signing in or out loads it
/// again: whether the customer follows it comes with it.
class StoreViewModel extends AsyncViewModel<StoreDetail> {
  StoreViewModel(this.storeId);

  final String storeId;
  var _sending = false;

  @override
  Future<StoreDetail> build() async {
    ref.watch(sessionProvider);
    final around = ref.watch(browseLocationProvider)?.point;
    return switch (await ref
        .watch(storesRepositoryProvider)
        .get(storeId, around: around)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Follows the store, or stops. The page shows the change at once and
  /// puts it back when refused; the failure says why. Null when it went
  /// through, or while the last tap is still on its way.
  Future<AppFailure?> toggleFollow() async {
    final store = state.value;
    final following = store?.isFollowing;
    if (store == null || following == null || _sending) return null;
    _sending = true;
    state = AsyncData(_following(store, !following));
    final repository = ref.read(storesRepositoryProvider);
    final result = following
        ? await repository.unfollow(storeId)
        : await repository.follow(storeId);
    _sending = false;
    if (!ref.mounted) return null;
    switch (result) {
      case Ok():
        ref.invalidate(followedStoresProvider);
        return null;
      case Err(:final failure):
        state = AsyncData(store);
        return failure;
    }
  }
}

/// [store] with [following] set, and its followers counted again.
StoreDetail _following(StoreDetail store, bool following) => StoreDetail(
  id: store.id,
  name: store.name,
  description: store.description,
  logoUrl: store.logoUrl,
  coverUrl: store.coverUrl,
  phone: store.phone,
  pickupInstructions: store.pickupInstructions,
  rating: store.rating,
  category: store.category,
  branches: store.branches,
  followerCount: store.followerCount + (following ? 1 : -1),
  isFollowing: following,
  offers: store.offers,
);

final storeViewModel = AsyncNotifierProvider.autoDispose
    .family<StoreViewModel, StoreDetail, String>(StoreViewModel.new);
