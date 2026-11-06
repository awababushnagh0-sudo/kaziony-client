import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  test('directions lead to the place in Google Maps', () {
    expect(
      directionsLink(const GeoPoint(32.9, 13.22)).toString(),
      'https://www.google.com/maps/dir/?api=1&destination=32.9,13.22',
    );
  });
}
