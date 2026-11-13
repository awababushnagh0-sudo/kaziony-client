import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/providers/access.dart';
import '../../../core/routes/routes.dart';
import '../domain/customer.dart';
import 'customer_bookings_tab.dart';
import 'customer_details_view_model.dart';
import 'customer_texts.dart';

/// One customer, ERPNext-style: "Customers / name" with where they stand
/// and an actions menu (end a pause; admins disable or enable), an
/// overview of their bookings and strikes, every booking, and a side panel
/// with how to reach them. Nothing here is edited: customers keep their
/// own details.
class CustomerDetailsScreen extends AppStatefulView {
  const CustomerDetailsScreen({required this.customerId, super.key});

  final String customerId;

  @override
  AppViewState<CustomerDetailsScreen> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends AppViewState<CustomerDetailsScreen> {
  /// An action is on its way; the others wait for it.
  var _busy = false;

  CustomerDetailsViewModel get _viewModel =>
      ref.read(customerDetailsViewModel(widget.customerId).notifier);

  Future<void> _endPause(CustomerDetails customer) async {
    final s = AdminLocalizations.of(context);
    final confirmed = await SDialog.confirm(
      context,
      title: s.endPauseTitle(customerName(s, customer.customer)),
      message: s.endPauseMessage,
      confirmLabel: s.endPause,
    );
    if (!confirmed || !mounted) return;
    await _run(_viewModel.endPause(), done: s.pauseEndedDone);
  }

  Future<void> _takeBackStrike(CustomerStrike strike) async {
    final s = AdminLocalizations.of(context);
    final confirmed = await SDialog.confirm(
      context,
      title: s.takeBackStrikeTitle,
      message: s.takeBackStrikeMessage,
      confirmLabel: s.takeBackStrike,
    );
    if (!confirmed || !mounted) return;
    await _run(
      _viewModel.takeBackStrike(strike.id),
      done: s.strikeTakenBackDone,
    );
  }

  Future<void> _setActive(
    CustomerDetails customer, {
    required bool active,
  }) async {
    final s = AdminLocalizations.of(context);
    if (!active) {
      final confirmed = await SDialog.confirm(
        context,
        title: s.disableUserTitle(customerName(s, customer.customer)),
        message: s.disableCustomerMessage,
        confirmLabel: s.disableCustomer,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
    }
    await _run(
      _viewModel.setActive(active: active),
      done: active ? s.customerEnabledDone : s.customerDisabledDone,
    );
  }

  Future<void> _run(
    Future<Result<Object?>> action, {
    required String done,
  }) async {
    setState(() => _busy = true);
    final result = await action;
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        SSnack.success(context, done);
      case Err(:final failure):
        SSnack.error(context, _explain(failure));
        // Someone else got there first: show the page as it is now.
        if (failure is ConflictFailure || failure is NotFoundFailure) {
          ref.invalidate(customerDetailsViewModel(widget.customerId));
        }
    }
  }

  String _explain(AppFailure failure) {
    final s = AdminLocalizations.of(context);
    return switch (failure) {
      ConflictFailure(code: CustomerCodes.notPaused) => s.reportPauseOver,
      NotFoundFailure() => s.reportStrikeGone,
      _ => failureMessage(context, failure),
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final provider = customerDetailsViewModel(widget.customerId);
    final loaded = ref.watch(provider);
    final customer = loaded.value;
    final admin = ref.watch(isAdminProvider);

    final entries = <MenuEntry?>[
      if (customer?.customer.standing == CustomerStanding.paused)
        MenuEntry(
          label: s.endPause,
          description: s.endPauseHint,
          icon: SIcons.resume,
          onTap: () => _endPause(customer!),
        ),
      // Disabling is for admins, and a deleted account is gone for good.
      if (customer != null &&
          admin &&
          customer.customer.standing != CustomerStanding.deleted) ...[
        if (customer.customer.standing == CustomerStanding.paused) null,
        if (customer.customer.standing == CustomerStanding.disabled)
          MenuEntry(
            label: s.enableCustomer,
            icon: SIcons.enable,
            onTap: () => _setActive(customer, active: true),
          )
        else
          MenuEntry(
            label: s.disableCustomer,
            description: s.disableCustomerHint,
            icon: SIcons.disable,
            destructive: true,
            onTap: () => _setActive(customer, active: false),
          ),
      ],
    ];

    return SScaffold(
      title: customer == null ? '' : customerName(s, customer.customer),
      parent: ScaffoldParent(
        label: s.customersTitle,
        onTap: () => context.go(Routes.customers),
      ),
      status: customer == null
          ? null
          : customerStandingBadge(s, customer.customer.standing),
      actions: [
        if (entries.isNotEmpty)
          SMenuButton(
            width: 280,
            entries: entries,
            builder: (context, toggle) => SButton.menu(
              label: s.actions,
              onPressed: _busy ? null : toggle,
            ),
          ),
      ],
      padded: false,
      body: SAsyncView(
        value: loaded,
        onRetry: () => ref.invalidate(provider),
        loading: const Padding(
          padding: EdgeInsets.all(Space.lg),
          child: SSkeleton.groups(),
        ),
        builder: (context, customer) => SRecordPage(
          tabs: [
            RecordTab(
              label: s.tabOverview,
              child: _Overview(
                customer: customer,
                onTakeBack: _busy ? null : _takeBackStrike,
              ),
            ),
            RecordTab(
              label: s.tabBookings,
              child: CustomerBookingsTab(customerId: widget.customerId),
            ),
          ],
          sidebar: _sidebar(context, customer),
        ),
      ),
    );
  }

  List<Widget> _sidebar(BuildContext context, CustomerDetails details) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final customer = details.customer;
    final phone = customer.contactPhone;
    final lastLogin = customer.lastLoginAt;
    final lastBooked = customer.lastBookedAt;
    final lastPause = details.lastPauseEndedAt;
    String date(DateTime date) => formatDate(date, languageCode: language);

    return [
      SRecordProfile(
        title: customerName(s, customer),
        subtitle: customer.name == null ? null : customerContact(customer),
      ),
      SRecordFacts([
        if (customer.email case final email?) RecordFact(s.columnEmail, email),
        if (phone != null) RecordFact(s.reportPhone, formatLibyanPhone(phone)),
        if (details.signsInWith.isNotEmpty)
          RecordFact(
            s.customerSignsInWith,
            details.signsInWith.map(_signInName).join(' · '),
          ),
        RecordFact(s.reportMissedPickups, '${customer.missedPickups}'),
        if (lastPause != null && customer.standing != CustomerStanding.paused)
          RecordFact(s.customerLastPause, date(lastPause)),
        RecordFact(s.customerFollowing, s.storesTotal(details.following)),
        RecordFact(s.customerRatings, s.storesTotal(details.ratings)),
        if (details.openReports > 0)
          RecordFact(s.customerOpenReports, '${details.openReports}'),
      ]),
      SRecordFacts([
        RecordFact(s.columnJoined, date(customer.createdAt)),
        RecordFact(
          s.columnLastLogin,
          lastLogin == null ? s.neverLoggedIn : date(lastLogin),
        ),
        RecordFact(
          s.columnLastBooked,
          lastBooked == null ? s.customerNeverBooked : date(lastBooked),
        ),
      ]),
    ];
  }

  /// Brand names, the same in every language.
  static String _signInName(SignInMethod method) => switch (method) {
    SignInMethod.google => 'Google',
    SignInMethod.apple => 'Apple',
  };
}

/// Where they stand and why, their bookings in numbers, and their strikes.
class _Overview extends StatelessWidget {
  const _Overview({required this.customer, required this.onTakeBack});

  final CustomerDetails customer;

  /// Null while another action is on its way.
  final ValueChanged<CustomerStrike>? onTakeBack;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final counts = customer.bookingCounts;
    final strikes = customer.strikeHistory;
    final standing = switch (customer.customer) {
      Customer(standing: CustomerStanding.paused, :final pausedUntil?) =>
        SAlert.warning(
          title: s.customerPausedTitle(
            formatDateTime(pausedUntil, languageCode: language),
          ),
          message: s.customerPausedMessage,
        ),
      Customer(standing: CustomerStanding.disabled) => SAlert(
        title: s.customerDisabledTitle,
        message: s.customerDisabledMessage,
      ),
      Customer(standing: CustomerStanding.deleted) => SAlert.warning(
        title: s.customerDeletedTitle(
          formatDate(
            customer.deletedAt ?? customer.customer.createdAt,
            languageCode: language,
          ),
        ),
      ),
      _ => null,
    };

    Figure figure(int value, String label) =>
        Figure(value: '$value', label: label, quiet: value == 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (standing != null) ...[standing, const Gap(Space.xl)],
        SFormSection(
          title: s.tabBookings,
          child: SFigures([
            figure(counts.waiting, s.bookingWaiting),
            figure(counts.outForDelivery, s.bookingOutForDelivery),
            figure(counts.pickedUp, s.bookingPickedUp),
            figure(counts.missed, s.bookingMissed),
            figure(counts.cancelled, s.bookingCancelled),
          ]),
        ),
        SFormSection(
          title: s.columnStrikes,
          note: strikes.isEmpty
              ? null
              : s.customerStrikesNote(
                  customer.customer.strikes,
                  customer.strikesBeforePause,
                ),
          divider: false,
          child: strikes.isEmpty
              ? SText.caption(s.customerNoStrikes)
              : STable<CustomerStrike>.box(
                  rows: strikes,
                  totalLabel: s.strikesTotal(strikes.length),
                  columns: _strikeColumns(context),
                ),
        ),
      ],
    );
  }

  List<TableColumn<CustomerStrike>> _strikeColumns(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return [
      TableColumn(
        label: s.columnWhen,
        cell: (strike) =>
            SCellText(formatDate(strike.createdAt, languageCode: language)),
      ),
      TableColumn(
        label: s.columnOffer,
        flex: 3,
        cell: (strike) => SCellText(
          strike.booking?.offerTitle ?? s.strikeOldBooking,
          strong: true,
        ),
      ),
      TableColumn(
        label: s.columnStore,
        flex: 3,
        minWidth: 620,
        cell: (strike) => SCellText(switch (strike.booking) {
          final booking? => '${booking.storeName} · ${booking.storeArea}',
          null => '–',
        }),
      ),
      TableColumn(
        label: s.columnCode,
        flex: 1,
        minWidth: 720,
        cell: (strike) => SCellText(strike.booking?.code ?? '–', ltr: true),
      ),
      TableColumn(
        label: s.columnStatus,
        flex: 3,
        cell: (strike) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: strike.counts
              ? SBadge(s.strikeCounts, tone: BadgeTone.warning)
              : SBadge(s.strikeNoLongerCounts),
        ),
      ),
      // The button says it all.
      TableColumn(
        label: '',
        cell: (strike) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: SButton.text(
            label: s.takeBackStrike,
            onPressed: switch (onTakeBack) {
              final take? => () => take(strike),
              null => null,
            },
          ),
        ),
      ),
    ];
  }
}
