import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../domain/store.dart';
import 'take_break_view_model.dart';

/// Takes the store offline in a sheet, for owners and staff: for how long
/// (a break, or until the hours open again), then either stopping new
/// bookings, with those made standing, or, for a sudden closing, cancelling
/// those too, after asking. Says what happened once it's done.
Future<void> takeBreak(
  BuildContext context,
  WidgetRef ref,
  StorePause pause,
) async {
  final s = PartnerLocalizations.of(context);
  ref.read(takeBreakViewModel.notifier).choose(BreakLength.minutes30);
  final done = await SSheet.show<StorePaused>(
    context,
    title: s.takeBreakTitle,
    subtitle: s.takeBreakSubtitle,
    builder: (_) => _BreakPicker(pause),
  );
  if (done == null || !context.mounted) return;
  final language = Localizations.localeOf(context).languageCode;
  SSnack.success(
    context,
    done.cancelled > 0
        ? s.storeClosedDone(done.cancelled)
        : s.offlineDone(switch (done.pause.pausedUntil) {
            final until? => formatWhen(until, languageCode: language),
            null => '',
          }),
  );
}

class _BreakPicker extends AppView {
  const _BreakPicker(this.pause);

  final StorePause pause;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final state = ref.watch(takeBreakViewModel);
    final viewModel = ref.read(takeBreakViewModel.notifier);
    final failure = state.failure;
    final busy = state.sending != null;

    Future<void> send({required bool cancelBookings}) async {
      final done = await viewModel.pause(cancelBookings: cancelBookings);
      if (done != null && context.mounted) Navigator.of(context).pop(done);
    }

    Future<void> close() async {
      final sure = await SDialog.confirm(
        context,
        title: s.closeAndCancelTitle(pause.waitingBookings),
        message: s.closeAndCancelMessage,
        confirmLabel: s.closeAndCancelConfirm,
        cancelLabel: s.keepBookings,
        destructive: true,
      );
      if (sure && context.mounted) await send(cancelBookings: true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SRadioGroup<BreakLength>(
          value: state.length,
          onChanged: busy ? (_) {} : viewModel.choose,
          options: [
            RadioOption(
              value: BreakLength.minutes15,
              label: s.breakMinutes(15),
            ),
            RadioOption(
              value: BreakLength.minutes30,
              label: s.breakMinutes(30),
            ),
            RadioOption(value: BreakLength.hour, label: s.breakHour),
            // Only when the hours say when that is.
            if (pause.nextOpening case final opens?)
              RadioOption(
                value: BreakLength.untilOpen,
                label: s.breakUntilOpen,
                subtitle: formatWhen(opens, languageCode: language),
              ),
          ],
        ),
        if (failure != null)
          SText(switch (failure) {
            ConflictFailure(code: 'NoOpeningAhead') => s.noOpeningAhead,
            _ => failureMessage(context, failure),
          }, color: SColor.danger),
        SButton(
          label: s.stopBookings,
          expand: true,
          loading: state.sending == BreakAction.stop,
          onPressed: busy ? null : () => send(cancelBookings: false),
        ),
        // Nothing to cancel: stopping new bookings is all there is.
        if (pause.waitingBookings > 0)
          SButton.dangerSoft(
            label: s.closeAndCancel,
            expand: true,
            loading: state.sending == BreakAction.close,
            onPressed: busy ? null : close,
          ),
      ],
    );
  }
}
