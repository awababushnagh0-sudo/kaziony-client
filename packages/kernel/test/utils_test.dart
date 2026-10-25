import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kernel/kernel.dart';

void main() {
  group('normalizeLibyanPhone', () {
    for (final input in [
      '0912345678',
      '912345678',
      '+218912345678',
      '00218912345678',
      '+218 91 234 5678',
      '091-234-5678',
      '٠٩١٢٣٤٥٦٧٨',
    ]) {
      test('normalizes $input', () {
        expect(normalizeLibyanPhone(input), '+218912345678');
      });
    }

    for (final input in ['', '12345', '0212345678', '09123456789']) {
      test(
        'rejects "$input"',
        () => expect(normalizeLibyanPhone(input), isNull),
      );
    }

    test('formats for display', () {
      expect(formatLibyanPhone('+218912345678'), '0912345678');
    });
  });

  test('formatPrice drops trailing zero dirhams', () {
    expect(formatPrice('4.000', languageCode: 'ar'), '4 د.ل');
    expect(formatPrice('4.500', languageCode: 'ar'), '4.5 د.ل');
    expect(formatPrice('12.250', languageCode: 'en'), '12.25 LD');
  });

  test('compareVersions compares numerically', () {
    expect(compareVersions('1.2.10', '1.10.0'), lessThan(0));
    expect(compareVersions('1.0.0', '1.0.0'), 0);
    expect(compareVersions('2.0.0+5', '1.9.9'), greaterThan(0));
    expect(compareVersions('1.0', '1.0.1'), lessThan(0));
  });

  test('Result helpers', () {
    const Result<int> ok = Ok(2);
    const Result<int> err = Err(NotFoundFailure());
    expect(ok.map((v) => v * 2).valueOrNull, 4);
    expect(err.map((v) => v * 2).failureOrNull, isA<NotFoundFailure>());
    expect(ok.fold(ok: (v) => 'ok $v', err: (_) => 'err'), 'ok 2');
  });

  test('formatDate writes the day in the given language', () async {
    await initializeDateFormatting('ar');
    final day = DateTime(2026, 10, 19, 12);
    expect(formatDate(day, languageCode: 'en'), 'Oct 19, 2026');
    expect(formatDate(day, languageCode: 'ar'), '19 أكتوبر 2026');
    expect(
      formatDateTime(day, languageCode: 'ar'),
      'الاثنين، 19 أكتوبر 12:00 م',
    );
  });

  group('parsePrice', () {
    test('writes prices with 3 decimals', () {
      expect(parsePrice('4'), '4.000');
      expect(parsePrice('4.5'), '4.500');
      expect(parsePrice('4.'), '4.000');
      expect(parsePrice(' 12.345 '), '12.345');
      expect(parsePrice('007.25'), '7.250');
      expect(parsePrice('0.5'), '0.500');
    });

    test('reads Arabic digits and the Arabic decimal sign', () {
      expect(parsePrice('٤٫٥'), '4.500');
    });

    test('refuses what the backend would refuse', () {
      expect(parsePrice(''), isNull);
      expect(parsePrice('0'), isNull);
      expect(parsePrice('0.000'), isNull);
      expect(parsePrice('4.5555'), isNull);
      expect(parsePrice('-4'), isNull);
      expect(parsePrice('12345678'), isNull);
      expect(parsePrice('4,5'), isNull);
      expect(parsePrice('abc'), isNull);
    });
  });

  test('dirhamsOf and discountPercent compare prices exactly', () {
    expect(dirhamsOf('4.500'), 4500);
    expect(dirhamsOf('12.000'), 12000);
    expect(dirhamsOf('0.050'), 50);
    expect(discountPercent(original: '8.000', offer: '4.000'), 50);
    expect(discountPercent(original: '3.000', offer: '2.000'), 33);
    expect(discountPercent(original: '9.000', offer: '1.000'), 89);
  });
}
