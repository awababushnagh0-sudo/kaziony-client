import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// Validation error key for a day's hours that can't be read.
const hoursError = 'hours';

/// How a day closed all day is shown: the same in both languages.
const closedDayText = '-';

/// A day's shifts as the admin types them: "08:00-13:00, 16:00-23:00",
/// [closedDayText] when closed, empty when the store hasn't said.
String hoursText(List<OpeningShift>? shifts) => switch (shifts) {
  null => '',
  [] => closedDayText,
  _ =>
    shifts
        .map(
          (shift) =>
              '${OpeningShift.clock(shift.opens)}-'
              '${OpeningShift.clock(shift.closes)}',
        )
        .join(', '),
};

/// What's typed for a day: null when nothing is (the day isn't said),
/// empty when it says closed ([closedDayText], "closed" or "مغلق"), else
/// its shifts. Read it once [hoursReadable] says it can be.
List<OpeningShift>? parseHours(String? text) => _read(text)?.shifts;

/// Whether [text] reads as a day's hours: nothing, closed, or times like
/// "08:00-23:00", at most [OpeningHours.maxShifts] of them. Forgiving of
/// how people type: "8-23", "8:30–13", Arabic digits, "،" between shifts,
/// and 24 for midnight.
bool hoursReadable(String? text) => _read(text) != null;

/// Checks a day's hours field with [hoursReadable].
final hoursValidator = Validators.delegate(
  (control) =>
      hoursReadable(control.value as String?) ? null : {hoursError: true},
);

/// Null when [text] can't be read; else what it says, its shifts null when
/// nothing is typed.
({List<OpeningShift>? shifts})? _read(String? text) {
  final western = (text ?? '').trim().replaceAllMapped(
    _easternDigits,
    (match) => '${match[0]!.codeUnitAt(0) - 0x0660}',
  );
  if (_closed.contains(western.toLowerCase())) return (shifts: const []);
  final parts = [
    for (final part in western.split(_between))
      if (part.trim().isNotEmpty) part.trim(),
  ];
  if (parts.isEmpty) return (shifts: null);
  if (parts.length > OpeningHours.maxShifts) return null;
  final shifts = <OpeningShift>[];
  for (final part in parts) {
    final match = _shift.firstMatch(part);
    if (match == null) return null;
    final opens = _minutes(match[1]!, match[2]);
    final closes = _minutes(match[3]!, match[4]);
    if (opens == null || closes == null) return null;
    shifts.add(OpeningShift(opens: opens, closes: closes));
  }
  return (shifts: shifts);
}

const _closed = {closedDayText, '–', '—', 'closed', 'مغلق'};
final _easternDigits = RegExp('[٠-٩]');
final _between = RegExp('[,،;]');
final _shift = RegExp(
  r'^(\d{1,2})(?::(\d{2}))?\s*[-–—]\s*(\d{1,2})(?::(\d{2}))?$',
);

/// Minutes after midnight, or null when [hours] and [minutes] aren't a
/// time of day.
int? _minutes(String hours, String? minutes) {
  final h = int.parse(hours);
  final m = int.parse(minutes ?? '0');
  if (m > 59 || h > 24 || (h == 24 && m > 0)) return null;
  return h % 24 * 60 + m;
}
