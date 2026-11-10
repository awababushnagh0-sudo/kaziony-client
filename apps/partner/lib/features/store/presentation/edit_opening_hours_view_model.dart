import 'package:kernel/kernel.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

/// A day's times while its sheet is open, before they're put on the page.
class OpeningDayDraft {
  const OpeningDayDraft({
    required this.day,
    required this.open,
    required this.shifts,
    this.everyDay = false,
  });

  final Weekday day;

  /// Closed all day when false; [shifts] are kept for opening it again.
  final bool open;
  final List<OpeningShift> shifts;

  /// The same times go on every day of the week.
  final bool everyDay;

  OpeningDayDraft _with({
    bool? open,
    List<OpeningShift>? shifts,
    bool? everyDay,
  }) => OpeningDayDraft(
    day: day,
    open: open ?? this.open,
    shifts: shifts ?? this.shifts,
    everyDay: everyDay ?? this.everyDay,
  );
}

class EditOpeningHoursState {
  const EditOpeningHoursState({
    required this.hours,
    this.draft,
    this.changed = false,
    this.saving = false,
    this.failure,
  });

  /// The saved hours, with the owner's changes on them.
  final OpeningHours hours;

  /// The day being changed in its sheet, if any.
  final OpeningDayDraft? draft;

  /// [hours] differ from the saved ones: there's something to save, and
  /// leaving asks first.
  final bool changed;
  final bool saving;
  final AppFailure? failure;
}

/// The owner's opening hours, changed a day at a time on the location
/// page: a day's sheet edits [EditOpeningHoursState.draft], [applyDay]
/// puts it on the page, and [save] sends the week. They fill from the
/// saved store (and again when it reloads, unless something changed).
class EditOpeningHoursViewModel extends ViewModel<EditOpeningHoursState> {
  /// A day that isn't set yet starts open from 09:00 to 22:00.
  static const _firstShift = OpeningShift(opens: 9 * 60, closes: 22 * 60);
  static const _minutesInDay = 24 * 60;

  OpeningHours _saved = OpeningHours.none;

  @override
  EditOpeningHoursState build() {
    ref.listen(storeViewModel, (_, next) {
      if (next.value case final saved? when !state.changed) {
        _saved = saved.openingHours;
        state = EditOpeningHoursState(hours: _saved);
      }
    });
    _saved = ref.read(storeViewModel).value?.openingHours ?? OpeningHours.none;
    return EditOpeningHoursState(hours: _saved);
  }

  /// Starts changing [day], from what it's set to now.
  void openDay(Weekday day) {
    final shifts = state.hours.days[day];
    _setDraft(
      OpeningDayDraft(
        day: day,
        open: shifts == null || shifts.isNotEmpty,
        shifts: shifts == null || shifts.isEmpty ? [_firstShift] : shifts,
      ),
    );
  }

  void setOpen({required bool open}) =>
      _changeDraft((draft) => draft._with(open: open));

  void setEveryDay({required bool everyDay}) =>
      _changeDraft((draft) => draft._with(everyDay: everyDay));

  /// Changes when the shift at [index] opens or closes.
  void setTime(int index, {int? opens, int? closes}) => _changeDraft((draft) {
    final shifts = [...draft.shifts];
    final shift = shifts[index];
    shifts[index] = OpeningShift(
      opens: opens ?? shift.opens,
      closes: closes ?? shift.closes,
    );
    return draft._with(shifts: shifts);
  });

  /// Opens again later the same day, after a break: an hour after the last
  /// shift closes, for four hours, to change from there.
  void addShift() => _changeDraft((draft) {
    if (draft.shifts.length >= OpeningHours.maxShifts) return draft;
    final opens = (draft.shifts.last.closes + 60) % _minutesInDay;
    return draft._with(
      shifts: [
        ...draft.shifts,
        OpeningShift(opens: opens, closes: (opens + 4 * 60) % _minutesInDay),
      ],
    );
  });

  void removeShift(int index) => _changeDraft(
    (draft) => draft.shifts.length < 2
        ? draft
        : draft._with(shifts: [...draft.shifts]..removeAt(index)),
  );

  /// Puts the day's times on the page (on every day, when asked), to save
  /// with the rest.
  void applyDay() {
    final draft = state.draft;
    if (draft == null) return;
    final hours = state.hours.withDay(
      draft.day,
      draft.open ? draft.shifts : const [],
      everyDay: draft.everyDay,
    );
    state = EditOpeningHoursState(
      hours: hours,
      changed: hours != _saved,
      failure: state.failure,
    );
  }

  /// Returns true when the hours were saved.
  Future<bool> save() async {
    if (state.saving) return false;
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return false;
    final hours = state.hours;
    state = EditOpeningHoursState(hours: hours, changed: true, saving: true);

    final result = await ref
        .read(storeRepositoryProvider)
        .setOpeningHours(storeId, hours);
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        _saved = value.openingHours;
        state = EditOpeningHoursState(hours: _saved);
        ref.read(storeViewModel.notifier).replace(value);
      case Err(:final failure):
        state = EditOpeningHoursState(
          hours: hours,
          changed: true,
          failure: failure,
        );
    }
    return result.isOk;
  }

  void _changeDraft(OpeningDayDraft Function(OpeningDayDraft draft) change) {
    if (state.draft case final draft?) _setDraft(change(draft));
  }

  void _setDraft(OpeningDayDraft draft) => state = EditOpeningHoursState(
    hours: state.hours,
    draft: draft,
    changed: state.changed,
    saving: state.saving,
    failure: state.failure,
  );
}

final editOpeningHoursViewModel =
    NotifierProvider.autoDispose<
      EditOpeningHoursViewModel,
      EditOpeningHoursState
    >(EditOpeningHoursViewModel.new);
