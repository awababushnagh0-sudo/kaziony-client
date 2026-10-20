import 'package:flutter_test/flutter_test.dart';
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
}
