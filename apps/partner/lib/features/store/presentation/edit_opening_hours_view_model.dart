import 'package:kernel/kernel.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

/// Times being changed in a sheet, before they're put on the page: a
/// weekday's ([OpeningDayDraft]) or special days' ([SpecialDaysDraft]).
sealed class HoursDraft {
  const HoursDraft({required this.open, required this.shifts});

  /// Closed all day when false; [shifts] are kept for opening it again.
  final bool open;
  final List<OpeningShift> shifts;

  /// The times as the days keep them.
  List<OpeningShift> get times => open ? shifts : const [];

  HoursDraft _with({bool? open, List<OpeningShift>? shifts});
}

/// A weekday's times while its sheet is open.
class OpeningDayDraft extends HoursDraft {
  const OpeningDayDraft({
    required this.day,
    required super.open,
    required super.shifts,
    this.everyDay = false,
  });

  final Weekday day;

  /// The same times go on every day of the week.
  final bool everyDay;

  @override
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

/// Special days (Ramadan, Eid) while their sheet is open.
class SpecialDaysDraft extends HoursDraft {
  const SpecialDaysDraft({
    required this.index,
    required this.from,
    required this.to,
    required super.open,
    required super.shifts,
  });

  /// Which of the store's special days these are; null for new ones.
  final int? index;
  final DateTime from;
  final DateTime to;

  SpecialHours get range => SpecialHours(from: from, to: to, shifts: times);

  @override
  SpecialDaysDraft _with({
    bool? open,
    List<OpeningShift>? shifts,
    DateTime? from,
    DateTime? to,
  }) => SpecialDaysDraft(
    index: index,
    from: from ?? this.from,
    to: to ?? this.to,
    open: open ?? this.open,
    shifts: shifts ?? this.shifts,
  );
}

/// Why special days can't go on the page as they are.
enum SpecialDaysProblem {
  /// They share a day with others the store set.
  overlaps,

  /// More than [SpecialHours.maxDays] in one go.
  tooLong,
}

class EditOpeningHoursState {
  const EditOpeningHoursState({
    required this.hours,
    required this.special,
    this.draft,
    this.changed = false,
    this.saving = false,
    this.failure,
  });

  /// The saved hours, with the owner's changes on them.
  final OpeningHours hours;

  /// The saved special days, with the owner's changes, first first.
  final List<SpecialHours> special;

  /// The times being changed in their sheet, if any.
  final HoursDraft? draft;

  /// [hours] or [special] differ from the saved ones: there's something to
  /// save, and leaving asks first.
  final bool changed;
  final bool saving;
  final AppFailure? failure;

  /// Whether more special days can be added.
  bool get canAddSpecial => special.length < SpecialHours.maxRanges;

  /// What's wrong with the special days being changed; null when they can
  /// go on the page (or it's a weekday being changed).
  SpecialDaysProblem? get specialProblem {
    final draft = this.draft;
    if (draft is! SpecialDaysDraft) return null;
    final range = draft.range;
    if (range.days > SpecialHours.maxDays) return SpecialDaysProblem.tooLong;
    for (final (index, other) in special.indexed) {
      if (index != draft.index && range.overlaps(other)) {
        return SpecialDaysProblem.overlaps;
      }
    }
    return null;
  }
}

/// The owner's opening hours, changed on the location page: a weekday or
/// special days at a time in their sheet, which edits
/// [EditOpeningHoursState.draft]; [applyDraft] puts it on the page, and
/// [save] sends the week and the special days together. They fill from the
/// saved store (and again when it reloads, unless something changed).
class EditOpeningHoursViewModel extends ViewModel<EditOpeningHoursState> {
  /// A day that isn't set yet starts open from 09:00 to 22:00.
  static const _firstShift = OpeningShift(opens: 9 * 60, closes: 22 * 60);
  static const _minutesInDay = 24 * 60;

  OpeningHours _saved = OpeningHours.none;
  List<SpecialHours> _savedSpecial = const [];

  @override
  EditOpeningHoursState build() {
    ref.listen(storeViewModel, (_, next) {
      if (next.value case final saved? when !state.changed) {
        _fill(saved);
        state = EditOpeningHoursState(hours: _saved, special: _savedSpecial);
      }
    });
    if (ref.read(storeViewModel).value case final saved?) _fill(saved);
    return EditOpeningHoursState(hours: _saved, special: _savedSpecial);
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

  /// Starts new special days, [from] to [to], open from 09:00 to 22:00.
  void addSpecial(DateTime from, DateTime to) => _setDraft(
    SpecialDaysDraft(
      index: null,
      from: from,
      to: to,
      open: true,
      shifts: const [_firstShift],
    ),
  );

  /// Starts changing the special days at [index].
  void openSpecial(int index) {
    final range = state.special[index];
    _setDraft(
      SpecialDaysDraft(
        index: index,
        from: range.from,
        to: range.to,
        open: range.shifts.isNotEmpty,
        shifts: range.shifts.isEmpty ? const [_firstShift] : range.shifts,
      ),
    );
  }

  /// Moves the special days being changed to [from] to [to].
  void setDays(DateTime from, DateTime to) => _changeDraft(
    (draft) =>
        draft is SpecialDaysDraft ? draft._with(from: from, to: to) : draft,
  );

  void setOpen({required bool open}) =>
      _changeDraft((draft) => draft._with(open: open));

  void setEveryDay({required bool everyDay}) => _changeDraft(
    (draft) =>
        draft is OpeningDayDraft ? draft._with(everyDay: everyDay) : draft,
  );

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

  /// Puts the times being changed on the page (a weekday's on every day,
  /// when asked), to save with the rest. Returns false, leaving the page as
  /// it was, when special days can't go on it ([specialProblem]).
  bool applyDraft() {
    final draft = state.draft;
    if (draft == null || state.specialProblem != null) return false;
    switch (draft) {
      case OpeningDayDraft():
        _show(
          state.hours.withDay(draft.day, draft.times, everyDay: draft.everyDay),
          state.special,
        );
      case SpecialDaysDraft(:final index):
        final special = [...state.special];
        if (index == null) {
          special.add(draft.range);
        } else {
          special[index] = draft.range;
        }
        _show(state.hours, _sorted(special));
    }
    return true;
  }

  /// Takes the special days at [index] off the page, to save with the rest.
  void removeSpecial(int index) =>
      _show(state.hours, [...state.special]..removeAt(index));

  /// Returns true when the hours were saved.
  Future<bool> save() async {
    if (state.saving) return false;
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return false;
    final (hours, special) = (state.hours, state.special);
    state = EditOpeningHoursState(
      hours: hours,
      special: special,
      changed: true,
      saving: true,
    );

    final result = await ref
        .read(storeRepositoryProvider)
        .setHours(storeId, hours, special);
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        _fill(value);
        state = EditOpeningHoursState(hours: _saved, special: _savedSpecial);
        ref.read(storeViewModel.notifier).replace(value);
      case Err(:final failure):
        state = EditOpeningHoursState(
          hours: hours,
          special: special,
          changed: true,
          failure: failure,
        );
    }
    return result.isOk;
  }

  void _fill(Store saved) {
    _saved = saved.openingHours;
    _savedSpecial = _sorted(saved.specialHours);
  }

  /// [hours] and [special] on the page, with no sheet open.
  void _show(OpeningHours hours, List<SpecialHours> special) =>
      state = EditOpeningHoursState(
        hours: hours,
        special: special,
        changed: hours != _saved || !_same(special, _savedSpecial),
        failure: state.failure,
      );

  void _changeDraft(HoursDraft Function(HoursDraft draft) change) {
    if (state.draft case final draft?) _setDraft(change(draft));
  }

  void _setDraft(HoursDraft draft) => state = EditOpeningHoursState(
    hours: state.hours,
    special: state.special,
    draft: draft,
    changed: state.changed,
    saving: state.saving,
    failure: state.failure,
  );

  static bool _same(List<SpecialHours> a, List<SpecialHours> b) =>
      a.length == b.length &&
      [for (final (index, range) in a.indexed) range == b[index]]
          .every((same) => same);

  static List<SpecialHours> _sorted(List<SpecialHours> special) =>
      [...special]..sort((a, b) => a.from.compareTo(b.from));
}

final editOpeningHoursViewModel =
    NotifierProvider.autoDispose<
      EditOpeningHoursViewModel,
      EditOpeningHoursState
    >(EditOpeningHoursViewModel.new);
