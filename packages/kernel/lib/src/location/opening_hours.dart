import 'package:flutter/foundation.dart';

/// The days of the week as Libya counts them, Saturday first, named as the
/// backend names them.
enum Weekday {
  sat,
  sun,
  mon,
  tue,
  wed,
  thu,
  fri;

  /// The day [date] falls on, in the phone's time.
  static Weekday of(DateTime date) =>
      // DateTime counts Monday as 1 and Sunday as 7.
      values[(date.toLocal().weekday + 1) % values.length];
}

/// One stretch of a day a store is open, in minutes after midnight. A close
/// earlier than the open is past midnight; the same as it, a whole day.
@immutable
class OpeningShift {
  const OpeningShift({required this.opens, required this.closes});

  final int opens;
  final int closes;

  /// [minutes] after midnight as the backend writes it: "08:30".
  static String clock(int minutes) {
    String two(int number) => '$number'.padLeft(2, '0');
    return '${two(minutes ~/ 60)}:${two(minutes % 60)}';
  }

  /// "08:30" as 510 minutes after midnight; null when it isn't a time.
  static int? minutesOf(Object? clock) {
    if (clock is! String) return null;
    final match = _clock.firstMatch(clock);
    if (match == null) return null;
    return int.parse(match[1]!) * 60 + int.parse(match[2]!);
  }

  static final _clock = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

  @override
  bool operator ==(Object other) =>
      other is OpeningShift && other.opens == opens && other.closes == closes;

  @override
  int get hashCode => Object.hash(opens, closes);

  @override
  String toString() => '${clock(opens)}-${clock(closes)}';
}

/// When a store is open, day by day, as it said. A day that isn't in
/// [days] isn't said; one with no shifts is closed all day.
@immutable
class OpeningHours {
  const OpeningHours(this.days);

  /// The backend's `{"sat": [{"open": "08:00", "close": "23:00"}]}`. A day
  /// this version can't read all of (a time or a day written another way)
  /// is left out as not said, rather than shown wrong or failing the page.
  factory OpeningHours.fromJson(Object? json) {
    if (json is! Map) return none;
    final days = <Weekday, List<OpeningShift>>{};
    for (final day in Weekday.values) {
      final shifts = json[day.name];
      if (shifts is! List) continue;
      final read = [
        for (final shift in shifts)
          if (shift is Map)
            if ((
                  OpeningShift.minutesOf(shift['open']),
                  OpeningShift.minutesOf(shift['close']),
                )
                case (final opens?, final closes?))
              OpeningShift(opens: opens, closes: closes),
      ];
      if (read.length == shifts.length) days[day] = List.unmodifiable(read);
    }
    return OpeningHours(days);
  }

  /// Nothing said about any day.
  static const none = OpeningHours({});

  /// A break (for prayer or lunch) splits a day: at most this many shifts,
  /// as the backend takes them.
  static const maxShifts = 4;

  final Map<Weekday, List<OpeningShift>> days;

  /// No day said.
  bool get isEmpty => days.isEmpty;

  /// The shifts on [date]'s day: empty when the store is closed that day,
  /// null when it hasn't said.
  List<OpeningShift>? on(DateTime date) => days[Weekday.of(date)];

  /// Whether the store is open at [at], in the phone's time (a shift
  /// runs [OpeningShift.opens] up to, not at, [OpeningShift.closes]); null
  /// when the hours don't say that day, and no shift from the day before
  /// runs into it. As the backend reads them to hold a booking.
  bool? openAt(DateTime at) {
    final local = at.toLocal();
    if (_shiftAt(local) != null) return true;
    return days.containsKey(Weekday.of(local)) ? false : null;
  }

  /// When the store closes, open at [at]: the end of the shift it's in,
  /// or of the next when one starts as it ends (to midnight and from it).
  /// Null when it isn't open then, or doesn't close within a week.
  DateTime? closesAfter(DateTime at) {
    var shift = _shiftAt(at.toLocal());
    for (var i = 0; shift != null && i < _week; i++) {
      final next = _shiftAt(shift.closes);
      if (next == null) return shift.closes;
      shift = next;
    }
    return null;
  }

  /// When the store next opens after [at], within a week; null when the
  /// hours don't say.
  DateTime? opensAfter(DateTime at) {
    final local = at.toLocal();
    DateTime? first;
    for (var day = 0; day <= _week; day++) {
      final date = DateTime(local.year, local.month, local.day + day);
      for (final shift in _timesOn(date) ?? const <_Times>[]) {
        if (shift.opens.isAfter(local) &&
            (first == null || shift.opens.isBefore(first))) {
          first = shift.opens;
        }
      }
      if (first != null) return first;
    }
    return null;
  }

  /// The last time in ([after], [until]] the store closes, and isn't open
  /// again right away; null when it doesn't close in that time.
  DateTime? lastClosing(DateTime after, DateTime until) {
    final from = after.toLocal();
    final to = until.toLocal();
    DateTime? last;
    // From the day before: its shift past midnight can close after [from].
    for (
      var date = DateTime(from.year, from.month, from.day - 1);
      !date.isAfter(to);
      date = DateTime(date.year, date.month, date.day + 1)
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
    return last;
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

  /// The shift the store is open in at [at]: today's, or yesterday's past
  /// midnight.
  _Times? _shiftAt(DateTime at) {
    final today = DateTime(at.year, at.month, at.day);
    for (final date in [
      DateTime(today.year, today.month, today.day - 1),
      today,
    ]) {
      for (final shift in _timesOn(date) ?? const <_Times>[]) {
        if (!shift.opens.isAfter(at) && at.isBefore(shift.closes)) {
          return shift;
        }
      }
    }
    return null;
  }

  /// [date]'s shifts as times on it (a close at or before the open is the
  /// next day's); null when the hours don't say that day.
  List<_Times>? _timesOn(DateTime date) => days[Weekday.of(date)]
      ?.map(
        (shift) => (
          opens: DateTime(date.year, date.month, date.day, 0, shift.opens),
          closes: DateTime(
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

  /// These hours with [day] set to [shifts] (empty: closed); with every
  /// day set to them when [everyDay].
  OpeningHours withDay(
    Weekday day,
    List<OpeningShift> shifts, {
    bool everyDay = false,
  }) => OpeningHours({
    for (final weekday in Weekday.values)
      if (everyDay || weekday == day)
        weekday: List.unmodifiable(shifts)
      else
        weekday: ?days[weekday],
  });

  /// As the backend takes them. An empty map says no day, which clears
  /// them.
  Map<String, Object?> toJson() => {
    for (final day in Weekday.values)
      if (days[day] case final shifts?)
        day.name: [
          for (final shift in shifts)
            {
              'open': OpeningShift.clock(shift.opens),
              'close': OpeningShift.clock(shift.closes),
            },
        ],
  };

  @override
  bool operator ==(Object other) {
    if (other is! OpeningHours || other.days.length != days.length) {
      return false;
    }
    for (final MapEntry(key: day, value: shifts) in days.entries) {
      final theirs = other.days[day];
      if (theirs == null || !listEquals(theirs, shifts)) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAllUnordered([
    for (final MapEntry(key: day, value: shifts) in days.entries)
      Object.hash(day, Object.hashAll(shifts)),
  ]);

  @override
  String toString() => 'OpeningHours($days)';
}

/// A shift on a given day.
typedef _Times = ({DateTime opens, DateTime closes});
