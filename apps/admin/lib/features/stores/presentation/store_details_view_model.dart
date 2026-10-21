import 'package:kernel/kernel.dart';

import '../domain/store.dart';

/// One store's details, by id.
final storeDetailsProvider = FutureProvider.autoDispose
    .family<StoreDetails, String>((ref, id) async {
      final result = await ref.watch(storeRepositoryProvider).get(id);
      return switch (result) {
        Ok(:final value) => value,
        Err(:final failure) => throw failure,
      };
    });
