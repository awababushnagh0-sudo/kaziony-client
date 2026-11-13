import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/list_query.dart';
import '../../bookings/domain/booking_status.dart';
import '../../bookings/presentation/booking_texts.dart';
import '../domain/customer.dart';
import 'customer_details_view_model.dart';

/// A customer's bookings, the latest first: filtered by status, a page at a
/// time.
class CustomerBookingsTab extends AppView {
  const CustomerBookingsTab({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final queryProvider = customerBookingQueryProvider(customerId);
    final pageProvider = customerBookingPageProvider(customerId);
    final query = ref.watch(queryProvider);
    final controller = ref.read(queryProvider.notifier);
    final result = ref.watch(pageProvider);
    final page = result.value;
    final pages = page?.pageCount(query.pageSize) ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            for (final (status, label) in <(BookingStatus?, String)>[
              (null, s.filterAll),
              for (final status in BookingStatus.values)
                (status, bookingStatusText(s, status)!),
            ])
              SPill(
                label: label,
                selected: query.filter == status,
                onTap: () => controller.setFilter(status),
              ),
          ],
        ),
        switch (result) {
          _ when page != null && page.items.isNotEmpty => STable.box(
            rows: page.items,
            totalLabel: s.bookingsTotal(page.total),
            columns: _columns(context),
          ),
          AsyncError(:final error) when page == null => SErrorView(
            failure: error is AppFailure ? error : UnknownFailure(error),
            onRetry: () => ref.invalidate(pageProvider),
          ),
          _ when page == null => const SSkeleton.list(leading: false),
          _ => SText.caption(
            query.hasFilters ? s.listNoResults : s.customerNoBookings,
          ),
        },
        if (page != null && pages > 1)
          SPager(
            pageLabel: s.pageOf(query.page, pages),
            pageSize: query.pageSize,
            pageSizes: ListQuery.pageSizes,
            onPageSize: controller.setPageSize,
            onPrevious: query.page > 1 ? controller.previousPage : null,
            onNext: query.page < pages ? controller.nextPage : null,
            previousLabel: s.previousPage,
            nextLabel: s.nextPage,
          ),
      ],
    );
  }

  List<TableColumn<CustomerBooking>> _columns(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return [
      TableColumn(
        label: s.reportBooked,
        flex: 3,
        cell: (booking) =>
            SCellText(formatWhen(booking.createdAt, languageCode: language)),
      ),
      TableColumn(
        label: s.columnOffer,
        flex: 3,
        cell: (booking) => SCellText(booking.offerTitle, strong: true),
      ),
      TableColumn(
        label: s.columnStore,
        flex: 3,
        minWidth: 620,
        cell: (booking) =>
            SCellText('${booking.storeName} · ${booking.storeArea}'),
      ),
      TableColumn(
        label: s.columnCode,
        flex: 1,
        minWidth: 720,
        cell: (booking) => SCellText(booking.code, ltr: true),
      ),
      TableColumn(
        label: s.columnTotal,
        flex: 1,
        minWidth: 820,
        cell: (booking) =>
            SCellText(formatPrice(booking.totalPrice, languageCode: language)),
      ),
      TableColumn(
        label: s.columnStatus,
        cell: (booking) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: _statusBadge(s, booking),
        ),
      ),
    ];
  }

  /// A cancelled booking says who cancelled it: only the customer's own
  /// cancelling is theirs.
  static SBadge? _statusBadge(AdminLocalizations s, CustomerBooking booking) =>
      switch ((booking.status, cancelReasonText(s, booking.cancelReason))) {
        (BookingStatus.cancelled, final reason?) => SBadge(reason),
        (final status, _) => bookingStatusBadge(s, status),
      };
}
