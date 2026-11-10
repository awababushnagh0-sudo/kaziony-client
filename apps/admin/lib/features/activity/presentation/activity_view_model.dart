import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/activity_entry.dart';

/// The activity list's search, area and page.
final activityQueryProvider =
    NotifierProvider.autoDispose<ListController<ActivityArea>, ActivityQuery>(
      ListController.new,
    );

/// The current page of changes.
final activityPageProvider = FutureProvider.autoDispose<ActivityPage>(
  (ref) => loadPage(
    ref.watch(activityRepositoryProvider).list,
    ref.watch(activityQueryProvider),
  ),
);
