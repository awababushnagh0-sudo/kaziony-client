import 'package:admin/features/stores/presentation/hours_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  const morning = OpeningShift(opens: 8 * 60, closes: 13 * 60);
  const evening = OpeningShift(opens: 16 * 60, closes: 23 * 60);

  test('reads shifts as people type them', () {
    expect(parseHours('08:00-23:00'), const [
      OpeningShift(opens: 8 * 60, closes: 23 * 60),
    ]);
    expect(parseHours(' 8 - 13 , 16:30–23 '), const [
      morning,
      OpeningShift(opens: 16 * 60 + 30, closes: 23 * 60),
    ]);
    expect(parseHours('٨-١٣، ١٦-٢٣'), const [morning, evening]);
  });

  test('a close earlier than the open is past midnight; 24 is midnight', () {
    expect(parseHours('18:00-02:00'), const [
      OpeningShift(opens: 18 * 60, closes: 2 * 60),
    ]);
    expect(parseHours('16-24'), const [
      OpeningShift(opens: 16 * 60, closes: 0),
    ]);
  });

  test('nothing typed says nothing; "-" or the word says closed', () {
    for (final text in [null, '', '  ', ' , ']) {
      expect(hoursReadable(text), isTrue, reason: text);
      expect(parseHours(text), isNull, reason: text);
    }
    for (final text in ['-', ' – ', 'Closed', 'مغلق']) {
      expect(hoursReadable(text), isTrue, reason: text);
      expect(parseHours(text), isEmpty, reason: text);
    }
  });

  test("refuses what isn't times, or more than 4 a day", () {
    for (final text in [
      'all day',
      '08:00',
      '8-',
      '25-26',
      '08:60-09:00',
      '24:30-02:00',
      '8-9-10',
      '8-9, 10-11, 12-13, 14-15, 16-17',
    ]) {
      expect(hoursReadable(text), isFalse, reason: text);
    }
  });

  test('shows a day the way it reads it', () {
    expect(hoursText(const [morning, evening]), '08:00-13:00, 16:00-23:00');
    expect(parseHours(hoursText(const [morning, evening])), [morning, evening]);
    expect(hoursText(const []), '-');
    expect(parseHours(hoursText(const [])), isEmpty);
    expect(hoursText(null), '');
  });
}
