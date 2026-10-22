import 'package:flutter_test/flutter_test.dart';
import 'package:stellar/stellar.dart';

void main() {
  Map<String, dynamic>? email(String? value) =>
      SValidators.email.validate(FormControl<String>(value: value));
  Map<String, dynamic>? url(String? value) =>
      SValidators.url.validate(FormControl<String>(value: value));

  test('email accepts addresses with spaces around them', () {
    expect(email('admin@offers.local'), isNull);
    expect(email('  Admin@Offers.Local '), isNull);
  });

  test('email rejects anything that is not an address', () {
    for (final value in ['admin', 'admin@', '@offers.ly', 'a b@c.ly']) {
      expect(email(value), isNotNull, reason: value);
    }
  });

  test('email leaves empty values to the required validator', () {
    expect(email(null), isNull);
    expect(email('  '), isNull);
  });

  test('url accepts web links, with spaces around them', () {
    expect(url('https://instagram.com/sweetcoast'), isNull);
    expect(url(' http://facebook.com/x?id=1 '), isNull);
  });

  test('url rejects anything that is not a web link', () {
    for (final value in [
      'instagram',
      'instagram.com/x',
      'ftp://a.ly',
      'https://a.',
      'https://',
    ]) {
      expect(url(value), {SValidators.urlKey: true}, reason: value);
    }
  });

  test('url leaves empty values to the required validator', () {
    expect(url(null), isNull);
    expect(url('  '), isNull);
  });
}
