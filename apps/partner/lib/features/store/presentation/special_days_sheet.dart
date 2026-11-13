import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'edit_opening_hours_view_model.dart';
import 'widgets/opening_hours_labels.dart';
import 'widgets/shifts_editor.dart';

/// New special days (Ramadan, Eid, a holiday): picks them in the calendar,
/// then their times in a sheet, as [editSpecialDays] does.
Future<void> addSpecialDays(BuildContext context, WidgetRef ref) async {
  final s = PartnerLocalizations.of(context);
  final today = _today();
  final days = await SCalendar.pickDays(
    context,
    firstDate: today,
    lastDate: _lastDay(today),
    title: s.specialDaysPickTitle,
  );
  if (days == null || !context.mounted) return;
  ref
      .read(editOpeningHoursViewModel.notifier)
      .addSpecial(_libyaDay(days.first), _libyaDay(days.last));
  await _show(context);
}

/// Changes the special days at [index] in a sheet: which days, and open or
/// closed and when, as a weekday's sheet does; or takes them away. "Done"
/// puts them on the page, to save with the rest; closing the sheet leaves
/// the page as it was.
Future<void> editSpecialDays(
  BuildContext context,
  WidgetRef ref,
  int index,
) async {
  ref.read(editOpeningHoursViewModel.notifier).openSpecial(index);
  await _show(context);
}

Future<void> _show(BuildContext context) => SSheet.show<void>(
  context,
  title: PartnerLocalizations.of(context).specialDaysTitle,
  builder: (_) => const _SpecialEditor(),
);

/// Today in Libya, as the phone's calendar takes a day.
DateTime _today() => _calendarDay(ServerClock.now());

/// [day]'s date in Libya, as the phone's calendar takes a day.
DateTime _calendarDay(DateTime day) {
  final clock = libyaClock(day);
  return DateTime(clock.year, clock.month, clock.day);
}

/// A day the phone's calendar picked, as a day in Libya.
DateTime _libyaDay(DateTime picked) =>
    libyaTime(picked.year, picked.month, picked.day);

/// A year ahead: Ramadan and Eid can be set as soon as they're known.
DateTime _lastDay(DateTime today) =>
    DateTime(today.year + 1, today.month, today.day);

class _SpecialEditor extends AppView {
  const _SpecialEditor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final edit = ref.watch(editOpeningHoursViewModel);
    final draft = edit.draft;
    if (draft is! SpecialDaysDraft) return const SizedBox.shrink();
    final viewModel = ref.read(editOpeningHoursViewModel.notifier);
    final problem = edit.specialProblem;

    Future<void> pickDays() async {
      final today = _today();
      final (from, to) = (_calendarDay(draft.from), _calendarDay(draft.to));
      // Days that already started stay pickable.
      final first = from.isBefore(today) ? from : today;
      final days = await SCalendar.pickDays(
        context,
        firstDate: first,
        lastDate: _lastDay(today),
        initial: (first: from, last: to),
        title: s.specialDaysPickTitle,
      );
      if (days != null) {
        viewModel.setDays(_libyaDay(days.first), _libyaDay(days.last));
      }
    }

    final index = draft.index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SListGroup(
          children: [
            SListTile(
              icon: SIcons.calendar,
              title: s.specialDaysLabel,
              value: daysLabel(context, draft.range),
              onTap: pickDays,
            ),
          ],
        ),
        const ShiftsEditor(),
        if (problem != null)
          SText(switch (problem) {
            SpecialDaysProblem.overlaps => s.specialDaysOverlap,
            SpecialDaysProblem.tooLong => s.specialDaysTooLong(
              SpecialHours.maxDays,
            ),
          }, color: SColor.danger),
        SButton(
          label: s.done,
          expand: true,
          onPressed: problem != null
              ? null
              : () {
                  viewModel.applyDraft();
                  Navigator.of(context).pop();
                },
        ),
        if (index != null)
          SButton.text(
            label: s.removeSpecialDays,
            icon: SIcons.delete,
            onPressed: () {
              viewModel.removeSpecial(index);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
