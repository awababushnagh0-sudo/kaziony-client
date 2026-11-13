import 'package:flutter/foundation.dart';

import '../time/libya_time.dart';
import 'opening_hours.dart';

/// Dates a store keeps other hours than its week's (Ramadan, Eid, a
/// holiday): from [from] to [to], both days included, open for [shifts]
/// (none: closed).
@immutable
class SpecialHours {
  const SpecialHours({
    required this.from,
    required this.to,
    required this.shifts,
  });

  /// The backend's `[{"from": "2027-02-08", "to": "2027-03-09", "shifts":
  /// [{"open": "20:00", "close": "02:00"}]}]`. A range this version can't
  /// read all of is left out, rather than shown wrong.
  static List<SpecialHours> listFromJson(Object? json) => [
    if (json is List)
      for (final range in json)
        if (range is Map)
          if ((_dateOf(range['from']), _dateOf(range['to']), range['shifts'])
              case (final from?, final to?, final List<Object?> shifts))
            if (_shiftsOf(shifts) case final read?)
              SpecialHours(from: from, to: to, shifts: read),
  ];

  /// As many as a store keeps, as the backend takes them.
  static const maxRanges = 20;

  /// The most days one runs (Ramadan and the Eid after it).
  static const maxDays = 40;

  /// The first day: any time on it in Libya, its midnight ([libyaTime]) as
  /// they're read.
  final DateTime from;

  /// The last day, as [from].
  final DateTime to;
  final List<OpeningShift> shifts;

  /// How many days it runs, both ends counted.
  int get days => _midnight(to).difference(_midnight(from)).inDays + 1;

  /// Whether it shares a day with [other].
  bool overlaps(SpecialHours other) =>
      _key(to) >= _key(other.from) && _key(from) <= _key(other.to);

  /// Whether [date]'s day in Libya is one of these.
  bool covers(DateTime date) => _coversClock(libyaClock(date));

  /// Whether the day of [clock] (a [libyaClock] reading) is one of these.
  bool _coversClock(DateTime clock) {
    final day = _dayKey(clock);
    return day >= _key(from) && day <= _key(to);
  }

  /// As the backend takes them.
  Map<String, Object?> toJson() => {
    'from': _date(from),
    'to': _date(to),
    'shifts': [
      for (final shift in shifts)
        {
          'open': OpeningShift.clock(shift.opens),
          'close': OpeningShift.clock(shift.closes),
        },
    ],
  };

  /// [day]'s date in Libya, as a number that sorts: 20270208.
  static int _key(DateTime day) => _dayKey(libyaClock(day));

  static DateTime _midnight(DateTime day) {
    final clock = libyaClock(day);
    return DateTime.utc(clock.year, clock.month, clock.day);
  }

  static String _date(DateTime day) {
    final clock = libyaClock(day);
    String two(int number) => '$number'.padLeft(2, '0');
    return '${clock.year}-${two(clock.month)}-${two(clock.day)}';
  }

  static DateTime? _dateOf(Object? text) {
    if (text is! String) return null;
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
    if (match == null) return null;
    return libyaTime(
      int.parse(match[1]!),
      int.parse(match[2]!),
      int.parse(match[3]!),
    );
  }

  static List<OpeningShift>? _shiftsOf(List<Object?> json) {
    final shifts = [
      for (final shift in json)
        if (shift is Map)
          if ((
                OpeningShift.minutesOf(shift['open']),
                OpeningShift.minutesOf(shift['close']),
              )
              case (final opens?, final closes?))
            OpeningShift(opens: opens, closes: closes),
    ];
    return shifts.length == json.length ? List.unmodifiable(shifts) : null;
  }

  @override
  bool operator ==(Object other) =>
      other is SpecialHours &&
      _key(other.from) == _key(from) &&
      _key(other.to) == _key(to) &&
      listEquals(other.shifts, shifts);

  @override
  int get hashCode => Object.hash(_key(from), _key(to), Object.hashAll(shifts));

  @override
  String toString() => 'SpecialHours(${_date(from)}–${_date(to)}: $shifts)';
}

/// The date of a clock reading, as a number that sorts: 20270208.
int _dayKey(DateTime clock) =>
    clock.year * 10000 + clock.month * 100 + clock.day;

/// When a store is open, at any time: its [weekly] hours, the [special]
/// dates that differ, and a pause ([pausedUntil]) when it went offline for
/// a while. In Libya time, whatever zone the phone is set to, as the
/// backend reads them to hold a booking, which has the last word.
@immutable
class StoreSchedule {
  const StoreSchedule({
    this.weekly = OpeningHours.none,
    this.special = const [],
    this.pausedUntil,
  });

  /// From the backend's fields.
  factory StoreSchedule.fromJson({
    Object? openingHours,
    Object? specialHours,
    DateTime? pausedUntil,
  }) => StoreSchedule(
    weekly: OpeningHours.fromJson(openingHours),
    special: SpecialHours.listFromJson(specialHours),
    pausedUntil: pausedUntil?.toLocal(),
  );

  /// Nothing said.
  static const none = StoreSchedule();

  final OpeningHours weekly;
  final List<SpecialHours> special;

  /// Offline (closed, whatever the hours say) until then.
  final DateTime? pausedUntil;

  /// Whether it's offline at [at].
  bool pausedAt(DateTime at) => pausedUntil?.isAfter(at) ?? false;

  /// The shifts on [date]'s day in Libya: its special hours when it has
  /// some, else its weekday's. Empty when the store is closed that day,
  /// null when it hasn't said.
  List<OpeningShift>? on(DateTime date) => _onDay(libyaClock(date));

  /// Whether the store is open at [at] (a shift runs [OpeningShift.opens]
  /// up to, not at, [OpeningShift.closes]): false while paused, null when
  /// the hours don't say that day and no shift from the day before runs
  /// into it.
  bool? openAt(DateTime at) {
    if (pausedAt(at)) return false;
    final clock = libyaClock(at);
    if (_shiftAt(clock) != null) return true;
    return _onDay(clock) == null ? null : false;
  }

  /// When the store closes, open at [at]: the end of the shift it's in,
  /// or of the next when one starts as it ends (to midnight and from it).
  /// Null when it isn't open then, or doesn't close within a week.
  DateTime? closesAfter(DateTime at) {
    if (pausedAt(at)) return null;
    var shift = _shiftAt(libyaClock(at));
    for (var i = 0; shift != null && i < _week; i++) {
      final next = _shiftAt(shift.closes);
      if (next == null) return _moment(shift.closes);
      shift = next;
    }
    return null;
  }

  /// When the store next opens after [at], within a week: when a pause
  /// ends, if it's open by its hours then. Null when the hours don't say.
  DateTime? opensAfter(DateTime at) {
    var from = libyaClock(at);
    if (pausedUntil case final until? when until.isAfter(at)) {
      from = libyaClock(until);
      if (_shiftAt(from) != null) return until;
    }
    DateTime? first;
    for (var day = 0; day <= _week; day++) {
      final date = DateTime.utc(from.year, from.month, from.day + day);
      for (final shift in _timesOn(date) ?? const <_Times>[]) {
        if (shift.opens.isAfter(from) &&
            (first == null || shift.opens.isBefore(first))) {
          first = shift.opens;
        }
      }
      if (first != null) return _moment(first);
    }
    return null;
  }

  /// The last time in ([after], [until]] the store closes, and isn't open
  /// again right away; null when it doesn't close in that time.
  DateTime? lastClosing(DateTime after, DateTime until) {
    final from = libyaClock(after);
    final to = libyaClock(until);
    DateTime? last;
    // From the day before: its shift past midnight can close after [from].
    for (
      var date = DateTime.utc(from.year, from.month, from.day - 1);
      !date.isAfter(to);
      date = DateTime.utc(date.year, date.month, date.day + 1)
    ) {
      for (final shift in _timesOn(date) ?? const <_Times>[]) {
        final closes = shift.closes;
        if (closes.isAfter(from) &&
            !closes.isAfter(to) &&
            (last == null || closes.isAfter(last)) &&
            _shiftAt(closes) == null) {
          last = closes;
        }
      }
    }
    return last == null ? null : _moment(last);
  }

  /// Whether the store closes at [at] exactly: the end of a booking held
  /// until it closes.
  bool closesAt(DateTime at) =>
      lastClosing(
        at.subtract(const Duration(minutes: 1)),
        at,
      )?.isAtSameMomentAs(at) ??
      false;

  static const _week = 7;

  /// The moment a clock reading ([libyaClock]) is, in the phone's time.
  static DateTime _moment(DateTime clock) =>
      clock.subtract(libyaOffset).toLocal();

  /// The shifts on the day of [clock] (a [libyaClock] reading).
  List<OpeningShift>? _onDay(DateTime clock) {
    for (final range in special) {
      if (range._coversClock(clock)) return range.shifts;
    }
    return weekly.days[Weekday.ofClock(clock)];
  }

  /// The shift the store is open in at [clock] (a [libyaClock] reading) by
  /// its hours: today's, or yesterday's past midnight.
  _Times? _shiftAt(DateTime clock) {
    final today = DateTime.utc(clock.year, clock.month, clock.day);
    for (final date in [
      DateTime.utc(today.year, today.month, today.day - 1),
      today,
    ]) {
      for (final shift in _timesOn(date) ?? const <_Times>[]) {
        if (!shift.opens.isAfter(clock) && clock.isBefore(shift.closes)) {
          return shift;
        }
      }
    }
    return null;
  }

  /// [date]'s shifts as clock readings on it (a close at or before the
  /// open is the next day's); null when the hours don't say that day.
  List<_Times>? _timesOn(DateTime date) => _onDay(date)
      ?.map(
        (shift) => (
          opens: DateTime.utc(date.year, date.month, date.day, 0, shift.opens),
          closes: DateTime.utc(
            date.year,
            date.month,
            date.day,
            0,
            shift.closes <= shift.opens
                ? shift.closes + Duration.minutesPerDay
                : shift.closes,
          ),
        ),
      )
      .toList();

  @override
  bool operator ==(Object other) =>
      other is StoreSchedule &&
      other.weekly == weekly &&
      listEquals(other.special, special) &&
      other.pausedUntil == pausedUntil;

  @override
  int get hashCode => Object.hash(weekly, Object.hashAll(special), pausedUntil);

  @override
  String toString() => 'StoreSchedule($weekly, $special, $pausedUntil)';
}

/// A shift on a given day, as clock readings ([libyaClock]).
typedef _Times = ({DateTime opens, DateTime closes});
