import 'package:customer/features/offers/domain/booking_window.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  // Saturday 14 November 2026, at noon.
  final now = DateTime(2026, 11, 14, 12);
  DateTime at(int hour, [int minute = 0]) =>
      DateTime(2026, 11, 14, hour, minute);
  const hours = OpeningHours({
    Weekday.sat: [
      OpeningShift(opens: 9 * 60, closes: 13 * 60),
      OpeningShift(opens: 13 * 60 + 30, closes: 22 * 60),
    ],
  });

  BookingWindow window(
    DateTime now, {
    OpeningHours hours = hours,
    DateTime? endsAt,
  }) => BookingWindow.at(
    now,
    hours: hours,
    holdMinutes: 120,
    endsAt: endsAt ?? now.add(const Duration(days: 1)),
    lastBookingMinutes: 20,
  );

  test('held for the whole time while the store is open then', () {
    expect(
      window(at(10)),
      isA<BookingHeld>()
          .having((w) => w.until, 'until', at(12))
          .having((w) => w.minutes, 'minutes', 120)
          .having((w) => w.short, 'short', isFalse),
    );
  });

  test('held over a break the store is back from', () {
    expect(
      window(now),
      isA<BookingHeld>().having((w) => w.short, 'short', isFalse),
    );
  });

  test('held until the store closes, when that comes first', () {
    expect(
      window(at(21)),
      isA<BookingHeld>()
          .having((w) => w.until, 'until', at(22))
          .having((w) => w.end, 'end', HeldEnd.storeCloses)
          .having((w) => w.minutes, 'minutes', 60),
    );
  });

  test('held until the offer ends, when that comes first', () {
    expect(
      window(at(10), endsAt: at(10, 45)),
      isA<BookingHeld>()
          .having((w) => w.end, 'end', HeldEnd.offerEnds)
          .having((w) => w.minutes, 'minutes', 45),
    );
  });

  test('not while the store is closed: it says when it opens', () {
    expect(
      window(at(8)),
      isA<BookingClosed>().having((w) => w.opensAt, 'opensAt', at(9)),
    );
    expect(
      window(at(13, 10)),
      isA<BookingClosed>().having((w) => w.opensAt, 'opensAt', at(13, 30)),
    );
  });

  test('not in the last minutes before it closes', () {
    expect(
      window(at(21, 41)),
      isA<BookingTooLate>().having((w) => w.closesAt, 'closesAt', at(22)),
    );
    expect(window(at(21, 40)), isA<BookingHeld>());
  });

  test("hours a store didn't say limit nothing", () {
    expect(
      window(at(23), hours: OpeningHours.none),
      isA<BookingHeld>().having((w) => w.short, 'short', isFalse),
    );
  });
}
