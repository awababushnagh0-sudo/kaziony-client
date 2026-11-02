import 'package:customer/core/l10n/generated/customer_localizations_en.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/booking_texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

void main() {
  group('countdown', () {
    test('minutes and seconds under an hour', () {
      expect(countdown(const Duration(minutes: 4, seconds: 7)), '04:07');
    });

    test('hours when there are some', () {
      expect(
        countdown(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
    });

    test('never below zero', () {
      expect(countdown(const Duration(seconds: -5)), '00:00');
    });
  });

  group('bookingStatus', () {
    final s = CustomerLocalizationsEn();

    test('waiting while it can be picked up', () {
      expect(bookingStatus(s, booking(), now), (
        'Waiting for pickup',
        BadgeTone.accent,
      ));
    });

    test('expired once its time is up, before the server says so', () {
      final late = booking(left: const Duration(minutes: -1));
      expect(bookingStatus(s, late, now).$1, s.statusExpired);
    });

    test('picked up and cancelled say so', () {
      expect(
        bookingStatus(s, booking(status: BookingStatus.pickedUp), now).$2,
        BadgeTone.success,
      );
      expect(
        bookingStatus(s, booking(status: BookingStatus.cancelled), now).$1,
        s.statusCancelled,
      );
    });
  });
}
