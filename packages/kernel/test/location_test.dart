import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  test('measures straight-line distances in km', () {
    const martyrsSquare = GeoPoint(32.8955, 13.1801);
    const zawiya = GeoPoint(32.757, 12.727);

    expect(martyrsSquare.distanceKmTo(martyrsSquare), 0);
    expect(martyrsSquare.distanceKmTo(zawiya), closeTo(45, 1));
    expect(zawiya.distanceKmTo(martyrsSquare), closeTo(45, 1));
  });
}
