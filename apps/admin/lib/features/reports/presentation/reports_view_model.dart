import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/customer_report.dart';

/// The reports list's search, state and page.
final reportsQueryProvider =
    NotifierProvider.autoDispose<ListController<ReportState>, ReportQuery>(
      ListController.new,
    );

/// The current page of reports.
final reportsPageProvider = FutureProvider.autoDispose<ReportPage>(
  (ref) => loadPage(
    ref.watch(reportRepositoryProvider).list,
    ref.watch(reportsQueryProvider),
  ),
);
