import 'package:flutter_test/flutter_test.dart';
import 'package:stellar/stellar.dart';

void main() {
  Map<String, dynamic>? email(String? value) =>
      SValidators.email.validate(FormControl<String>(value: value));

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
}
