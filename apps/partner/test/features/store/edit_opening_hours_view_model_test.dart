import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/features/store/presentation/edit_opening_hours_view_model.dart';

void main() {
  final ramadan = SpecialHours(
    from: libyaTime(2027, 2, 8),
    to: libyaTime(2027, 3, 9),
    shifts: const [],
  );

  SpecialDaysProblem? problem(DateTime from, DateTime to, {int? index}) =>
      EditOpeningHoursState(
        hours: OpeningHours.none,
        special: [ramadan],
        draft: SpecialDaysDraft(
          index: index,
          from: from,
          to: to,
          open: false,
          shifts: const [],
        ),
      ).specialProblem;

  test('days that share one with others are refused', () {
    expect(
      problem(libyaTime(2027, 3, 9), libyaTime(2027, 3, 11)),
      SpecialDaysProblem.overlaps,
    );
    expect(problem(libyaTime(2027, 3, 10), libyaTime(2027, 3, 12)), isNull);
  });

  test('changing days, they may keep their own', () {
    expect(
      problem(libyaTime(2027, 2, 10), libyaTime(2027, 3, 9), index: 0),
      isNull,
    );
  });

  test('at most 40 days in one go', () {
    expect(problem(libyaTime(2027, 4, 1), libyaTime(2027, 5, 10)), isNull);
    expect(
      problem(libyaTime(2027, 4, 1), libyaTime(2027, 5, 11)),
      SpecialDaysProblem.tooLong,
    );
  });
}
