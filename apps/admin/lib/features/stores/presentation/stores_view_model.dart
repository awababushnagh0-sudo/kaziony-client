import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/store.dart';

/// The stores list's search, status filter and page.
final storeQueryProvider =
    NotifierProvider.autoDispose<ListController<StoreStatus>, StoreQuery>(
      ListController.new,
    );

/// The current page of stores.
final storePageProvider = FutureProvider.autoDispose<StorePage>(
  (ref) => loadPage(
    ref.watch(storeRepositoryProvider).list,
    ref.watch(storeQueryProvider),
  ),
);
