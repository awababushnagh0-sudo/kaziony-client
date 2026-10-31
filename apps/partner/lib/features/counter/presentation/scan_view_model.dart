import 'package:kernel/kernel.dart';

import '../../home/domain/store_stats.dart';
import '../../store/domain/current_store.dart';

/// How many customers are on their way, for the Scan tab's button to them.
/// Null until loaded or when it couldn't be: it's only a hint there.
final onTheWayCountProvider = FutureProvider.autoDispose<int?>((ref) async {
  final storeId = ref.watch(currentStoreProvider)?.storeId;
  if (storeId == null) return null;
  final stats = await ref.read(statsRepositoryProvider).get(storeId);
  return stats.valueOrNull?.onTheWay;
});
