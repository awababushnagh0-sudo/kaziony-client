import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../../../core/routes/routes.dart';
import '../domain/customer.dart';
import 'customer_texts.dart';
import 'customers_view_model.dart';

/// Everyone who books in the app, the newest first: found by name, email
/// or phone, and filtered by where they stand. Each opens to their page.
class CustomersScreen extends AppView {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    return SScaffold(
      title: s.customersTitle,
      padded: false,
      body: PagedTable<Customer, CustomerStanding>(
        query: customerQueryProvider,
        page: customerPageProvider,
        searchHint: s.customersSearch,
        filters: [
          (CustomerStanding.active, s.customersFilterActive),
          (CustomerStanding.paused, s.customersFilterPaused),
          (CustomerStanding.disabled, s.customersFilterDisabled),
          (CustomerStanding.deleted, s.customersFilterDeleted),
        ],
        totalLabel: s.customersTotal,
        columns: _columns(context),
        onOpen: (customer) => context.go(Routes.customer(customer.id)),
        empty: SEmptyView(
          title: s.customersEmpty,
          message: s.customersEmptyMessage,
          icon: SIcons.users,
        ),
      ),
    );
  }

  List<TableColumn<Customer>> _columns(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String date(DateTime? date) =>
        date == null ? '–' : formatDate(date, languageCode: language);
    return [
      TableColumn(
        label: s.columnName,
        flex: 3,
        cell: (customer) => SCellText(customerName(s, customer), strong: true),
      ),
      TableColumn(
        label: s.columnContact,
        flex: 3,
        minWidth: 560,
        cell: (customer) =>
            SCellText(customerContact(customer) ?? '–', ltr: true),
      ),
      TableColumn(
        label: s.columnStatus,
        cell: (customer) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: customerStandingBadge(s, customer.standing),
        ),
      ),
      TableColumn(
        label: s.columnBookings,
        flex: 1,
        minWidth: 760,
        cell: (customer) => SCellText('${customer.bookings}'),
      ),
      TableColumn(
        label: s.columnPickedUp,
        flex: 1,
        minWidth: 860,
        cell: (customer) => SCellText('${customer.pickedUp}'),
      ),
      TableColumn(
        label: s.columnStrikes,
        flex: 1,
        minWidth: 640,
        cell: (customer) => SCellText('${customer.strikes}'),
      ),
      TableColumn(
        label: s.columnLastBooked,
        minWidth: 960,
        cell: (customer) => SCellText(date(customer.lastBookedAt)),
      ),
      TableColumn(
        label: s.columnJoined,
        minWidth: 1060,
        cell: (customer) => SCellText(date(customer.createdAt)),
      ),
    ];
  }
}
