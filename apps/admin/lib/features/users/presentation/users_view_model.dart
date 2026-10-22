import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/dashboard_user.dart';

/// The users list's search, role filter and page.
final userQueryProvider =
    NotifierProvider.autoDispose<
      ListController<DashboardRole>,
      DashboardUserQuery
    >(ListController.new);

/// The current page of users.
final userPageProvider = FutureProvider.autoDispose<DashboardUserPage>(
  (ref) => loadPage(
    ref.watch(dashboardUserRepositoryProvider).list,
    ref.watch(userQueryProvider),
  ),
);
