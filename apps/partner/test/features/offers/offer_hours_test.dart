import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/features/offers/domain/offer_hours.dart';

void main() {
  /// Open 9:00 to 22:00 every day.
  final hours = StoreSchedule(
    weekly: OpeningHours({
      for (final day in Weekday.values)
        day: const [OpeningShift(opens: 9 * 60, closes: 22 * 60)],
    }),
  );

  /// [hour] on Monday 2 November 2026, in Libya; [day] days later.
  DateTime at(int hour, {int minute = 0, int day = 0}) =>
      libyaTime(2026, 11, 2 + day, hour, minute);

  OfferHours? of(DateTime now, DateTime endsAt) =>
      OfferHours.of(hours, now: now, endsAt: endsAt);

  test('says nothing while the store is open the whole time', () {
    expect(of(at(12), at(21)), isNull);
    // The nights between don't matter: it's open when it ends.
    expect(of(at(12), at(20, day: 2)), isNull);
  });

  test('says when the store closes before the offer ends', () {
    expect(
      of(at(12), at(23)),
      isA<OutsideHours>()
          .having((h) => h.closesAt, 'closesAt', at(22))
          .having((h) => h.opensAt, 'opensAt', isNull),
    );
  });

  test('says when the store opens, posted while it is closed', () {
    expect(
      of(at(7), at(21)),
      isA<OutsideHours>()
          .having((h) => h.opensAt, 'opensAt', at(9))
          .having((h) => h.closesAt, 'closesAt', isNull),
    );
    expect(
      of(at(7), at(23)),
      isA<OutsideHours>()
          .having((h) => h.opensAt, 'opensAt', at(9))
          .having((h) => h.closesAt, 'closesAt', at(22)),
    );
  });

  test('says when the store is closed for all of the offer', () {
    expect(
      of(at(22, minute: 30), at(23, minute: 30)),
      isA<ClosedThroughOffer>().having(
        (h) => h.opensAt,
        'opensAt',
        at(9, day: 1),
      ),
    );
  });

  test("says nothing when the store's hours don't say", () {
    expect(
      OfferHours.of(StoreSchedule.none, now: at(7), endsAt: at(23)),
      isNull,
    );
  });
}
