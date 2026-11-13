import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../domain/customer_report.dart';
import 'report_dialog.dart';
import 'report_texts.dart';
import 'reports_view_model.dart';

/// Customers' reports of problems with their bookings: the open ones
/// first, oldest first, to answer in turn. Each opens to the booking, the
/// customer, and resolving it.
class ReportsScreen extends AppView {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SScaffold(
      title: s.reportsTitle,
      padded: false,
      body: PagedTable<CustomerReport, ReportState>(
        query: reportsQueryProvider,
        page: reportsPageProvider,
        searchHint: s.reportsSearch,
        filters: [
          (ReportState.open, s.filterOpen),
          (ReportState.resolved, s.filterResolved),
        ],
        totalLabel: s.reportsTotal,
        onOpen: (report) =>
            SDialog.show<void>(context, (_) => ReportDialog(report: report)),
        columns: [
          TableColumn(
            label: s.columnWhen,
            cell: (report) => SCellText(
              formatWhen(report.createdAt.toLocal(), languageCode: language),
            ),
          ),
          TableColumn(
            label: s.columnReason,
            flex: 2,
            cell: (report) =>
                SCellText(reportReasonText(s, report.reason), strong: true),
          ),
          TableColumn(
            label: s.columnCustomer,
            flex: 2,
            cell: (report) => SCellText(customerText(s, report.customer)),
          ),
          TableColumn(
            label: s.columnStore,
            flex: 2,
            minWidth: 640,
            cell: (report) => SCellText(report.store.name),
          ),
          TableColumn(
            label: s.columnStatus,
            cell: (report) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: report.open
                  ? SBadge(s.filterOpen, tone: BadgeTone.warning)
                  : SBadge(s.filterResolved, tone: BadgeTone.success),
            ),
          ),
        ],
        empty: SEmptyView(
          title: s.reportsEmpty,
          message: s.reportsEmptyMessage,
          icon: SIcons.chat,
        ),
      ),
    );
  }
}
