import 'package:admin/features/stores/domain/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tripoli = (latitude: 32.8872, longitude: 13.1913);

  test('reads plain coordinates', () {
    expect(parseLocation('32.8872, 13.1913'), tripoli);
    expect(parseLocation('32.8872,13.1913'), tripoli);
    expect(parseLocation(' 32.8872 ، 13.1913 '), tripoli);
  });

  test('reads Google Maps links', () {
    for (final link in [
      'https://www.google.com/maps?q=32.8872,13.1913',
      'https://maps.google.com/?q=32.8872,13.1913&z=17',
      'https://www.google.com/maps/@32.8872,13.1913,17z',
      'https://www.google.com/maps/search/?api=1&query=32.8872%2C13.1913',
    ]) {
      expect(parseLocation(link), tripoli, reason: link);
    }
  });

  test('prefers the pin over the map center in place links', () {
    const link =
        'https://www.google.com/maps/place/Some+Cafe/@32.80,13.10,15z/'
        'data=!3m1!4b1!4m6!3m5!1s0x0:0x0!8m2!3d32.8872!4d13.1913';
    expect(parseLocation(link), tripoli);
  });

  test('gives up on anything else', () {
    for (final input in [
      '',
      'Hay Al Andalus',
      'https://maps.app.goo.gl/AbCdEf123',
      '132.5, 13.1',
      'حي الأندلس ١٠٠%',
    ]) {
      expect(parseLocation(input), isNull, reason: input);
    }
  });

  test('knows roughly where Libya is', () {
    expect(isInLibya(tripoli), isTrue);
    expect(isInLibya((latitude: 32.1167, longitude: 20.0667)), isTrue);
    // Latitude and longitude typed the wrong way round.
    expect(isInLibya((latitude: 13.1913, longitude: 32.8872)), isFalse);
    expect(isInLibya((latitude: 48.85, longitude: 2.35)), isFalse);
  });
}
