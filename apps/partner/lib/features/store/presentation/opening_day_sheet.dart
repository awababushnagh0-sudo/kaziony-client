import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'edit_opening_hours_view_model.dart';
import 'widgets/opening_hours_labels.dart';
import 'widgets/shifts_editor.dart';

/// Changes [day]'s opening times in a sheet: open or closed, when it opens
/// and closes (again after a break, when there's one), and whether every
/// day is the same. "Done" puts them on the page, to save with the rest;
/// closing the sheet leaves the page as it was.
Future<void> editOpeningDay(
  BuildContext context,
  WidgetRef ref,
  Weekday day,
) async {
  ref.read(editOpeningHoursViewModel.notifier).openDay(day);
  await SSheet.show<void>(
    context,
    title: weekdayName(context, day),
    builder: (_) => const _DayEditor(),
  );
}

class _DayEditor extends AppView {
  const _DayEditor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final draft = ref.watch(editOpeningHoursViewModel).draft;
    if (draft is! OpeningDayDraft) return const SizedBox.shrink();
    final viewModel = ref.read(editOpeningHoursViewModel.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        const ShiftsEditor(),
        SListGroup(
          children: [
            SCheckTile(
              title: s.sameEveryDay,
              checked: draft.everyDay,
              onChanged: (everyDay) =>
                  viewModel.setEveryDay(everyDay: everyDay),
            ),
          ],
        ),
        SButton(
          label: s.done,
          expand: true,
          onPressed: () {
            viewModel.applyDraft();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
