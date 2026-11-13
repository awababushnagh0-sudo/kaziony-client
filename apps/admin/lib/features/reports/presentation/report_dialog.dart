import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/customer_report.dart';
import 'report_dialog_view_model.dart';
import 'report_texts.dart';

/// One report: what the customer said, the booking, the store and the
/// customer. While it's open, resolving it, taking back the booking's
/// strike or the customer's pause only when ticked; once resolved, what
/// the team decided, first.
class ReportDialog extends AppView {
  const ReportDialog({required this.report, super.key});

  final CustomerReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final provider = reportDialogViewModel(this.report);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final report = state.report;
    final note = report.note;

    Future<void> resolve() async {
      if (await viewModel.resolve() && context.mounted) {
        SSnack.success(context, s.reportResolvedDone);
        Navigator.pop(context);
      }
    }

    void openStore() {
      final router = GoRouter.of(context);
      Navigator.pop(context);
      router.go(Routes.store(report.store.id));
    }

    return SDialog(
      title: reportReasonText(s, report.reason),
      width: 560,
      primaryLabel: report.open ? s.reportResolve : null,
      onPrimary: resolve,
      busy: state.saving,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.lg,
        children: [
          if (note != null)
            SListGroup(
              title: s.reportCustomerSaid,
              children: [SListTile(title: note)],
            ),
          // Resolved, what the team decided is what's looked for.
          if (!report.open) _Decision(report: report),
          _Booking(report: report),
          _Customer(customer: report.customer),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SButton.text(
              label: s.reportOpenStore,
              icon: SIcons.store,
              onPressed: openStore,
            ),
          ),
          if (report.open) _Resolve(state: state, viewModel: viewModel),
        ],
      ),
    );
  }
}

class _Booking extends StatelessWidget {
  const _Booking({required this.report});

  final CustomerReport report;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final booking = report.booking;
    final status = bookingStatusText(s, booking.status);
    String when(DateTime at) =>
        formatDateTime(at.toLocal(), languageCode: language);
    return SListGroup(
      title: s.reportBooking,
      children: [
        SFactTile(label: s.reportCode, value: booking.code),
        SFactTile(label: s.reportOffer, value: booking.offerTitle),
        SFactTile(
          label: s.columnStore,
          value: '${report.store.name} · ${report.store.area}',
        ),
        SFactTile(
          label: s.reportPiecesLabel,
          value: s.reportPieces(
            booking.quantity,
            formatPrice(booking.totalPrice, languageCode: language),
          ),
        ),
        if (status != null)
          SFactTile(label: s.reportBookingStatus, value: status),
        SFactTile(label: s.reportBooked, value: when(booking.createdAt)),
        SFactTile(label: s.reportPickUpBy, value: when(booking.expiresAt)),
      ],
    );
  }
}

class _Customer extends StatelessWidget {
  const _Customer({required this.customer});

  final ReportCustomer customer;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final email = customer.email;
    final phone = customer.contactPhone;
    final pausedUntil = customer.pausedUntil;
    return SListGroup(
      title: s.reportCustomer,
      children: [
        SFactTile(label: s.columnName, value: customerText(s, customer)),
        if (email != null && customer.name != null)
          SFactTile(label: s.emailLabel, value: email),
        if (phone != null)
          SFactTile(label: s.reportPhone, value: formatLibyanPhone(phone)),
        SFactTile(
          label: s.reportMissedPickups,
          value: '${customer.missedPickups}',
        ),
        if (pausedUntil != null)
          SFactTile(
            label: s.reportPausedUntil,
            value: formatDateTime(
              pausedUntil.toLocal(),
              languageCode: language,
            ),
          ),
      ],
    );
  }
}

/// What to take back, ticked by hand, and what the team found.
class _Resolve extends StatelessWidget {
  const _Resolve({required this.state, required this.viewModel});

  final ReportDialogState state;
  final ReportDialogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final report = state.report;
    final pausedUntil = report.customer.pausedUntil;
    final failure = state.failure;
    return SForm(
      form: viewModel.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.lg,
        children: [
          if (report.hasStrike || pausedUntil != null)
            SListGroup(
              title: s.reportTakeBack,
              children: [
                if (report.hasStrike)
                  SCheckTile(
                    title: s.reportRemoveStrike,
                    subtitle: state.removeStrike
                        ? s.reportRemoveStrikeOn
                        : s.reportRemoveStrikeOff,
                    checked: state.removeStrike,
                    onChanged: viewModel.setRemoveStrike,
                  ),
                if (pausedUntil != null)
                  SCheckTile(
                    title: s.reportEndPause,
                    subtitle: state.endPause
                        ? s.reportEndPauseOn
                        : s.reportEndPauseOff(
                            formatDateTime(
                              pausedUntil.toLocal(),
                              languageCode: language,
                            ),
                          ),
                    checked: state.endPause,
                    onChanged: viewModel.setEndPause,
                  ),
              ],
            )
          else
            SText.caption(s.reportNothingToTakeBack),
          if (!report.hasStrike && pausedUntil != null)
            SText.caption(s.reportNoStrike),
          STextInput(
            controlName: 'resolution',
            label: s.reportResolution,
            hint: s.reportResolutionHint,
            kind: TextInputKind.multiline,
            maxLength: ReportDialogViewModel.resolutionMaxLength,
          ),
          if (failure != null)
            SText(_failureMessage(context, failure), color: SColor.danger),
        ],
      ),
    );
  }
}

/// Who resolved it and when, what they took back, and what they found.
class _Decision extends StatelessWidget {
  const _Decision({required this.report});

  final CustomerReport report;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final resolvedAt = report.resolvedAt;
    final resolution = report.resolution;
    return SListGroup(
      title: s.reportDecision,
      children: [
        SFactTile(
          label: s.reportResolvedBy,
          value: report.resolverName ?? s.activityRemovedAccount,
        ),
        if (resolvedAt != null)
          SFactTile(
            label: s.columnWhen,
            value: formatDateTime(resolvedAt.toLocal(), languageCode: language),
          ),
        SFactTile(label: s.reportTakenBack, value: takenBackText(s, report)),
        if (resolution != null)
          SFactTile(label: s.reportResolution, value: resolution),
      ],
    );
  }
}

String _failureMessage(BuildContext context, AppFailure failure) {
  final s = AdminLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: ReportCodes.alreadyResolved) =>
      s.reportAlreadyResolved,
    ConflictFailure(code: ReportCodes.noStrike) => s.reportStrikeGone,
    ConflictFailure(code: ReportCodes.notPaused) => s.reportPauseOver,
    _ => failureMessage(context, failure),
  };
}
