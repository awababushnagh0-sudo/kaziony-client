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
    expect(hours.on(DateTime(2026, 11, 7, 10)), const [morning]);
    expect(hours.on(DateTime(2026, 11, 6, 10)), isEmpty);
    expect(hours.on(DateTime(2026, 11, 9, 10)), isNull);
    expect([
      for (var day = 7; day < 14; day++) Weekday.of(DateTime(2026, 11, day)),
    ], Weekday.values);
  });
}
