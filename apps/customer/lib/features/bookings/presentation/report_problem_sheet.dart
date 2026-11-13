import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/booking.dart';
import 'report_problem_view_model.dart';

/// Asks what went wrong with [booking] and sends it to our team, who may
/// take back a strike it gave. Said in a snack once sent.
Future<void> reportProblem(BuildContext context, Booking booking) async {
  final s = CustomerLocalizations.of(context);
  final sent = await SSheet.show<bool>(
    context,
    title: s.reportTitle,
    subtitle: s.reportSubtitle,
    builder: (_) => _ReportForm(bookingId: booking.id),
  );
  if (sent == true && context.mounted) SSnack.success(context, s.reportSent);
}

/// A row on the booking's page: the way to report a problem while it can
/// be, or, once reported, what came of it. Nothing otherwise.
class ReportRow extends StatelessWidget {
  const ReportRow({required this.booking, super.key});

  final Booking booking;

  /// Whether there's a row to show for [booking].
  static bool shows(Booking booking) =>
      booking.report != null || booking.canReport;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final report = booking.report;
    if (report == null) {
      return SListTile(
        icon: SIcons.chat,
        title: s.reportProblem,
        onTap: () => reportProblem(context, booking),
      );
    }
    return SListTile(
      icon: SIcons.chat,
      title: s.reportSentTitle,
      subtitle: switch (report) {
        BookingReport(resolved: false) => s.reportOpen,
        BookingReport(strikeRemoved: true) => s.reportResolvedStrikeRemoved,
        _ => s.reportResolved,
      },
    );
  }
}

class _ReportForm extends AppView {
  const _ReportForm({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = reportProblemViewModel(bookingId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final failure = state.failure;
    return SForm(
      form: viewModel.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.lg,
        children: [
          SRadioGroup<ReportReason>(
            value: state.reason,
            onChanged: viewModel.choose,
            options: [
              for (final reason in ReportReason.values)
                RadioOption(value: reason, label: _reasonLabel(s, reason)),
            ],
          ),
          STextInput(
            controlName: 'note',
            label: s.reportNoteLabel,
            hint: s.reportNoteHint,
            kind: TextInputKind.multiline,
            maxLength: ReportProblemViewModel.noteMaxLength,
            required: state.reason == ReportReason.other,
          ),
          if (failure != null) SAlert(title: _failureMessage(context, failure)),
          SButton(
            label: s.reportSend,
            expand: true,
            loading: state.sending,
            onPressed: state.reason == null
                ? null
                : () async {
                    if (await viewModel.send() && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

String _reasonLabel(CustomerLocalizations s, ReportReason reason) =>
    switch (reason) {
      ReportReason.storeClosed => s.reportReasonStoreClosed,
      ReportReason.notGiven => s.reportReasonNotGiven,
      ReportReason.priceDifferent => s.reportReasonPriceDifferent,
      ReportReason.quality => s.reportReasonQuality,
      ReportReason.other => s.reportReasonOther,
    };

/// Reported already (on another phone), or too long after it ended, in
/// the app's words.
String _failureMessage(BuildContext context, AppFailure failure) {
  final s = CustomerLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: 'AlreadyReported') => s.reportAlready,
    ConflictFailure(code: 'ReportTooLate') => s.reportTooLate,
    _ => failureMessage(context, failure),
  };
}
