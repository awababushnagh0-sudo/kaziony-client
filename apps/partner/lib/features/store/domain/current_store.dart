import 'package:kernel/kernel.dart';

/// Where a signed-in member stands with their stores.
sealed class StoreAccess {
  const StoreAccess();
}

/// The store picked on this device is still being read.
final class StoreAccessLoading extends StoreAccess {
  const StoreAccessLoading();
}

/// The account isn't linked to any store (yet, or anymore).
final class NoStore extends StoreAccess {
  const NoStore();
}

/// Works at several stores and hasn't picked one here, or the one picked
/// is no longer theirs.
final class MustChooseStore extends StoreAccess {
  const MustChooseStore();
}

final class InStore extends StoreAccess {
  const InStore(this.store);

  final StoreMembership store;
}

/// [chosen] is the id of the store picked on this device, if any. Members
/// of one store never pick: they go straight in.
StoreAccess storeAccessFor(
  List<StoreMembership> memberships,
  AsyncValue<String?> chosen,
) {
  if (memberships.isEmpty) return const NoStore();
  if (memberships case [final only]) return InStore(only);
  if (chosen is AsyncLoading) return const StoreAccessLoading();
  final chosenId = switch (chosen) {
    AsyncData(:final value) => value,
    _ => null,
  };
  final store = memberships
      .where((membership) => membership.storeId == chosenId)
      .firstOrNull;
  return store == null ? const MustChooseStore() : InStore(store);
}

/// The store picked on this device, remembered across restarts.
class ChosenStoreController extends AsyncViewModel<String?> {
  static const _key = 'store.chosen';

  @override
  Future<String?> build() => ref.read(settingsStoreProvider).getString(_key);

  Future<void> choose(String storeId) async {
    state = AsyncData(storeId);
    await ref.read(settingsStoreProvider).setString(_key, storeId);
  }
}

final chosenStoreProvider =
    AsyncNotifierProvider<ChosenStoreController, String?>(
      ChosenStoreController.new,
    );

/// The stores the signed-in member works at.
final myStoresProvider = Provider<List<StoreMembership>>(
  (ref) => switch (ref.watch(sessionProvider)) {
    SignedIn(:final user) => user.memberships,
    _ => const [],
  },
);

/// The store the app works on. Null while signed out or before a store is
/// picked; the router keeps the tabs closed until then.
final currentStoreProvider = Provider<StoreMembership?>(
  (ref) => switch (storeAccessFor(
    ref.watch(myStoresProvider),
    ref.watch(chosenStoreProvider),
  )) {
    InStore(:final store) => store,
    _ => null,
  },
);
