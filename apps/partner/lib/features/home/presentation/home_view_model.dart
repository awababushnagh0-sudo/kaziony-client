import 'package:kernel/kernel.dart';

import '../domain/store.dart';

class HomeData {
  const HomeData({required this.store, required this.membership});

  final Store store;
  final StoreMembership membership;
}

/// Loads the merchant's store. Null when the account has no store.
/// (Owners of several stores get a store picker in step 2.)
class HomeViewModel extends AsyncViewModel<HomeData?> {
  @override
  Future<HomeData?> build() async {
    final session = ref.watch(sessionProvider);
    final membership = switch (session) {
      SignedIn(:final user) => user.memberships.firstOrNull,
      _ => null,
    };
    if (membership == null) return null;

    final result = await ref
        .watch(storeRepositoryProvider)
        .getStore(membership.storeId);
    return switch (result) {
      Ok(:final value) => HomeData(store: value, membership: membership),
      Err(:final failure) => throw failure,
    };
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }
}

final homeViewModel =
    AsyncNotifierProvider.autoDispose<HomeViewModel, HomeData?>(
      HomeViewModel.new,
    );
