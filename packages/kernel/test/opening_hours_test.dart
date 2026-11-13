import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  const morning = OpeningShift(opens: 8 * 60, closes: 13 * 60);
  const evening = OpeningShift(opens: 16 * 60, closes: 23 * 60);

  group('OpeningHours.withDay', () {
    test('sets one day and keeps the others as they were', () {
      const hours = OpeningHours({
        Weekday.sat: [morning],
        Weekday.fri: [],
      });

      expect(
        hours.withDay(Weekday.sun, const [morning, evening]),
        const OpeningHours({
          Weekday.sat: [morning],
          Weekday.sun: [morning, evening],
          Weekday.fri: [],
        }),
      );
    });

    test('sets every day at once, closed ones too', () {
      final hours = OpeningHours.none.withDay(
        Weekday.mon,
        const [],
        everyDay: true,
      );

      expect(hours.days.keys, Weekday.values);
      expect(hours.days.values, everyElement(isEmpty));
    });
  });

  test('hours are equal when every day has the same shifts', () {
    expect(
      const OpeningHours({
        Weekday.sat: [morning, evening],
      }),
      const OpeningHours({
        Weekday.sat: [morning, evening],
      }),
    );
    // A day not said isn't a day closed.
    expect(const OpeningHours({Weekday.sat: []}), isNot(OpeningHours.none));
    expect(
      const OpeningHours({
        Weekday.sat: [evening, morning],
      }),
      isNot(
        const OpeningHours({
          Weekday.sat: [morning, evening],
        }),
      ),
    );
  });
  group('from and to the backend', () {
    test('reads the days and their shifts, a break splitting a day', () {
      final hours = OpeningHours.fromJson({
        'sat': [
          {'open': '08:00', 'close': '13:00'},
          {'open': '16:00', 'close': '23:00'},
        ],
        'fri': <Object?>[],
      });

      expect(
        hours,
        const OpeningHours({
          Weekday.sat: [morning, evening],
          Weekday.fri: [],
        }),
      );
    });

    test('a close earlier than the open is kept: past midnight', () {
      final hours = OpeningHours.fromJson({
        'thu': [
          {'open': '18:00', 'close': '02:00'},
        ],
      });

      expect(hours.days[Weekday.thu], const [
        OpeningShift(opens: 18 * 60, closes: 2 * 60),
      ]);
    });

    test('a day it cannot read all of is left out, not shown wrong', () {
      final hours = OpeningHours.fromJson({
        'sat': [
          {'open': '8am', 'close': '23:00'},
          {'open': '10:00', 'close': '12:00'},
        ],
        'sun': [
          {'open': '09:00'},
        ],
        'someday': [
          {'open': '08:00', 'close': '23:00'},
        ],
        'tue': 'all day',
        'mon': [
          {'open': '08:00', 'close': '13:00'},
        ],
      });

      expect(
        hours,
        const OpeningHours({
          Weekday.mon: [morning],
        }),
      );
    });

    test('none when the store never said', () {
      expect(OpeningHours.fromJson(null), OpeningHours.none);
      expect(OpeningHours.fromJson('08:00-23:00'), OpeningHours.none);
      expect(OpeningHours.none.isEmpty, isTrue);
    });

    test('written back as read, closed days included', () {
      final json = {
        'sat': [
          {'open': '08:00', 'close': '13:00'},
          {'open': '16:30', 'close': '00:00'},
        ],
        'fri': <Object?>[],
      };

      expect(OpeningHours.fromJson(json).toJson(), json);
      expect(OpeningHours.none.toJson(), isEmpty);
    });
  });

  test('the shifts on a date: by its day, closed or not said', () {
    const hours = OpeningHours({
      Weekday.sat: [morning],
      Weekday.fri: [],
    });

    // November 7, 2026 is a Saturday; the 6th a Friday; the 9th a Monday.
    expect(hours.on(libyaTime(2026, 11, 7, 10)), const [morning]);
    expect(hours.on(libyaTime(2026, 11, 6, 10)), isEmpty);
    expect(hours.on(libyaTime(2026, 11, 9, 10)), isNull);
    expect([
      for (var day = 7; day < 14; day++) Weekday.of(libyaTime(2026, 11, day)),
    ], Weekday.values);
  });

  group('open and closed', () {
    // Saturday 14 November 2026, in the phone's time.
    DateTime sat(int hour, [int minute = 0]) =>
        libyaTime(2026, 11, 14, hour, minute);
    const split = StoreSchedule(
      weekly: OpeningHours({
        Weekday.sat: [
          OpeningShift(opens: 9 * 60, closes: 13 * 60),
          OpeningShift(opens: 16 * 60, closes: 22 * 60),
        ],
        Weekday.fri: [],
      }),
    );

    test('is open during a shift, up to its close', () {
      expect(split.openAt(sat(9)), isTrue);
      expect(split.openAt(sat(12, 59)), isTrue);
      expect(split.openAt(sat(13)), isFalse);
      expect(split.openAt(sat(23)), isFalse);
      expect(split.openAt(libyaTime(2026, 11, 13, 12)), isFalse);
    });

    test("doesn't know on a day it didn't say", () {
      expect(split.openAt(libyaTime(2026, 11, 15, 12)), isNull);
      expect(StoreSchedule.none.openAt(sat(12)), isNull);
    });

    test('runs a shift past midnight into the next day', () {
      const late = StoreSchedule(
        weekly: OpeningHours({
          Weekday.fri: [OpeningShift(opens: 20 * 60, closes: 2 * 60)],
        }),
      );
      expect(late.openAt(sat(1, 59)), isTrue);
      expect(late.closesAfter(libyaTime(2026, 11, 13, 23)), sat(2));
      expect(late.lastClosing(sat(1), sat(3)), sat(2));
    });

    test('says when it closes, past a shift to midnight and one from it', () {
      expect(split.closesAfter(sat(17)), sat(22));
      expect(split.closesAfter(sat(14)), isNull);
      const late = StoreSchedule(
        weekly: OpeningHours({
          Weekday.sat: [OpeningShift(opens: 18 * 60, closes: 0)],
          Weekday.sun: [OpeningShift(opens: 0, closes: 2 * 60)],
        }),
      );
      expect(late.closesAfter(sat(23)), libyaTime(2026, 11, 15, 2));
      expect(
        late.lastClosing(sat(23), libyaTime(2026, 11, 15, 3)),
        libyaTime(2026, 11, 15, 2),
      );
    });

    test('takes the same open and close as the whole day', () {
      final allDay = StoreSchedule(
        weekly: OpeningHours.none.withDay(Weekday.sat, const [
          OpeningShift(opens: 0, closes: 0),
        ], everyDay: true),
      );
      expect(allDay.openAt(sat(23, 59)), isTrue);
      expect(allDay.closesAfter(sat(12)), isNull);
    });

    test('says when it opens next', () {
      expect(split.opensAfter(sat(14)), sat(16));
      expect(split.opensAfter(sat(8)), sat(9));
      // Saturday's next: Friday is closed, the others aren't said.
      expect(split.opensAfter(sat(23)), libyaTime(2026, 11, 21, 9));
      expect(StoreSchedule.none.opensAfter(sat(12)), isNull);
    });

    test('finds the last close in a time', () {
      expect(split.lastClosing(sat(12, 30), sat(14, 30)), sat(13));
      expect(split.lastClosing(sat(12, 30), sat(23)), sat(22));
      expect(split.lastClosing(sat(12), sat(12, 59)), isNull);
    });

    test('knows a time it closes at', () {
      expect(split.closesAt(sat(22)), isTrue);
      expect(split.closesAt(sat(22).toUtc()), isTrue);
      expect(split.closesAt(sat(21, 59)), isFalse);
      expect(split.closesAt(sat(12)), isFalse);
    });
  });

  group('special hours and a pause', () {
    // Saturday 14 November 2026, in the phone's time.
    DateTime sat(int hour, [int minute = 0]) =>
        libyaTime(2026, 11, 14, hour, minute);
    const weekly = OpeningHours({
      Weekday.sat: [OpeningShift(opens: 9 * 60, closes: 22 * 60)],
    });
    final ramadan = StoreSchedule(
      weekly: weekly,
      special: [
        SpecialHours(
          from: libyaTime(2026, 11, 14),
          to: libyaTime(2026, 11, 20),
          shifts: const [OpeningShift(opens: 20 * 60, closes: 2 * 60)],
        ),
        SpecialHours(
          from: libyaTime(2026, 11, 21),
          to: libyaTime(2026, 11, 21),
          shifts: const [],
        ),
      ],
    );

    test('takes the special hours on their dates', () {
      expect(ramadan.on(sat(12)), [
        const OpeningShift(opens: 20 * 60, closes: 2 * 60),
      ]);
      expect(ramadan.openAt(sat(10)), isFalse);
      expect(ramadan.openAt(sat(21)), isTrue);
      expect(ramadan.opensAfter(sat(10)), sat(20));
      // Eid: closed, though Saturdays open; then the weekly hours again.
      expect(ramadan.openAt(libyaTime(2026, 11, 21, 10)), isFalse);
      expect(ramadan.openAt(libyaTime(2026, 11, 28, 10)), isTrue);
    });

    test('reads them from the backend, leaving out what it cannot', () {
      expect(
        SpecialHours.listFromJson([
          {
            'from': '2026-11-14',
            'to': '2026-11-20',
            'shifts': [
              {'open': '20:00', 'close': '02:00'},
            ],
          },
          {'from': '2026-11-21', 'to': '2026-11-21', 'shifts': <Object>[]},
          {'from': '21/11/2026', 'to': '2026-11-22', 'shifts': <Object>[]},
          {
            'from': '2026-11-23',
            'to': '2026-11-23',
            'shifts': [
              {'open': '9am', 'close': '5pm'},
            ],
          },
        ]),
        ramadan.special,
      );
      expect(ramadan.special.first.toJson(), {
        'from': '2026-11-14',
        'to': '2026-11-20',
        'shifts': [
          {'open': '20:00', 'close': '02:00'},
        ],
      });
    });

    test('is closed while paused, and opens when the pause ends', () {
      final paused = StoreSchedule(weekly: weekly, pausedUntil: sat(10, 30));
      expect(paused.pausedAt(sat(10)), isTrue);
      expect(paused.openAt(sat(10)), isFalse);
      expect(paused.closesAfter(sat(10)), isNull);
      expect(paused.opensAfter(sat(10)), sat(10, 30));
      expect(paused.openAt(sat(10, 30)), isTrue);
    });

    test('paused past closing, opens with its next shift', () {
      final paused = StoreSchedule(weekly: weekly, pausedUntil: sat(23));
      expect(paused.opensAfter(sat(21)), libyaTime(2026, 11, 21, 9));
    });

    test('counts its days, and tells when two share one', () {
      final [first, eid] = ramadan.special;
      expect(first.days, 7);
      expect(eid.days, 1);
      expect(first.overlaps(eid), isFalse);
      final lastWeek = SpecialHours(
        from: libyaTime(2026, 11, 20),
        to: libyaTime(2026, 11, 25),
        shifts: const [],
      );
      expect(lastWeek.overlaps(first), isTrue);
      expect(eid.overlaps(lastWeek), isTrue);
    });
  });
}
