import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../../store/domain/store.dart';
import '../../store/presentation/store_view_model.dart';

/// The branch picked on this phone for the counter, per store, remembered
/// across restarts.
class CounterBranchController extends AsyncViewModel<String?> {
  String? _storeId;

  String get _key => 'counter.branch.$_storeId';

  @override
  Future<String?> build() async {
    _storeId = ref.watch(currentStoreProvider)?.storeId;
    if (_storeId == null) return null;
    return ref.read(settingsStoreProvider).getString(_key);
  }

  Future<void> choose(String branchId) async {
    state = AsyncData(branchId);
    await ref.read(settingsStoreProvider).setString(_key, branchId);
  }
}

final counterBranchChoiceProvider =
    AsyncNotifierProvider<CounterBranchController, String?>(
      CounterBranchController.new,
    );

/// Where this phone's pickups are made.
class CounterBranches {
  const CounterBranches({required this.choices, required this.branchId});

  /// The branches to pick from; empty when there's nothing to pick.
  final List<Branch> choices;

  /// Sent with each pickup; null when the backend can tell, or while none is
  /// picked.
  final String? branchId;

  /// Several branches and none picked yet: ask before a pickup.
  bool get mustChoose => choices.isNotEmpty && branchId == null;

  Branch? get current =>
      choices.where((branch) => branch.id == branchId).firstOrNull;
}

/// Staff limited to a branch are always at theirs, and a store with one
/// branch is always there; otherwise the counter picks one, once.
final counterBranchesProvider = Provider.autoDispose<CounterBranches>((ref) {
  const known = CounterBranches(choices: [], branchId: null);
  final store = ref.watch(currentStoreProvider);
  if (store == null || store.branchId != null) return known;
  final branches = [
    for (final branch
        in ref.watch(storeViewModel).value?.branches ?? const <Branch>[])
      if (branch.isActive) branch,
  ];
  if (branches.length < 2) {
    return CounterBranches(
      choices: const [],
      branchId: branches.firstOrNull?.id,
    );
  }
  final chosen = ref.watch(counterBranchChoiceProvider).value;
  return CounterBranches(
    choices: branches,
    branchId: branches.any((branch) => branch.id == chosen) ? chosen : null,
  );
});
