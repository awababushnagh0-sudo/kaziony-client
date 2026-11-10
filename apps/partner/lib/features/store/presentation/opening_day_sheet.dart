import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'edit_opening_hours_view_model.dart';
import 'widgets/opening_hours_labels.dart';

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
    if (draft == null) return const SizedBox.shrink();
    final viewModel = ref.read(editOpeningHoursViewModel.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SSegmented.labels(
          options: [
            SelectOption(true, s.openDay),
            SelectOption(false, s.closedAllDay),
          ],
          selected: draft.open,
          onChanged: (open) => viewModel.setOpen(open: open),
        ),
        if (draft.open) ...[
          for (final (index, shift) in draft.shifts.indexed)
            _Shift(index: index, shift: shift),
          if (draft.shifts.length < OpeningHours.maxShifts)
            SButton.text(
              label: s.addShift,
              icon: SIcons.add,
              onPressed: viewModel.addShift,
            ),
        ],
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
            viewModel.applyDay();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

/// One stretch of the day: when it opens and when it closes, each a row
/// that picks the time. The ones after a break can be taken away.
class _Shift extends AppView {
  const _Shift({required this.index, required this.shift});

  final int index;
  final OpeningShift shift;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(editOpeningHoursViewModel.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xs,
      children: [
        SListGroup(
          title: index == 0 ? null : s.afterBreak,
          children: [
            SListTile(
              title: s.opensAt,
              value: clockLabel(context, shift.opens),
              onTap: () async {
                final opens = await _pickTime(context, s.opensAt, shift.opens);
                if (opens != null) viewModel.setTime(index, opens: opens);
              },
            ),
            SListTile(
              title: s.closesAt,
              value: clockLabel(context, shift.closes),
              onTap: () async {
                final closes = await _pickTime(
                  context,
                  s.closesAt,
                  shift.closes,
                );
                if (closes != null) viewModel.setTime(index, closes: closes);
              },
            ),
          ],
        ),
        if (index > 0)
          SButton.text(
            label: s.removeShift,
            icon: SIcons.delete,
            onPressed: () => viewModel.removeShift(index),
          ),
      ],
    );
  }
}

/// A time of day, picked from a list; null when the sheet is closed.
Future<int?> _pickTime(BuildContext context, String title, int current) =>
    SSheet.choose<int>(
      context,
      title: title,
      selected: current,
      options: [
        for (final minutes in _times(current))
          RadioOption(value: minutes, label: clockLabel(context, minutes)),
      ],
    );

/// Every half hour from 6 in the morning round to 5:30 the next (shops
/// open in the morning, and closing past midnight comes last), with
/// [current] in its place when it's another time.
List<int> _times(int current) {
  const step = 30;
  const start = 6 * 60;
  const day = 24 * 60;
  int sinceStart(int minutes) => (minutes - start) % day;
  return {
    for (var minutes = start; minutes < start + day; minutes += step)
      minutes % day,
    current,
  }.toList()..sort((a, b) => sinceStart(a).compareTo(sinceStart(b)));
}
