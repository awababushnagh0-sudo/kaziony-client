import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/notifications/data/api_notifications_repository.dart';
import 'package:customer/features/notifications/domain/app_notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offers_api/customer.dart' as api;

void main() {
  api.NotificationDto dto({
    String kind = 'BOOKING_CANCELLED',
    String? reason = 'STORE_OFF',
    bool withBooking = true,
  }) => api.NotificationDto.fromJson({
    'id': 'n1',
    'kind': kind,
    'booking': withBooking
        ? {
            'id': 'k1',
            'offerTitle': 'Kunafa box',
            'storeName': 'Sweet shop',
            'storeArea': 'Andalus',
            'cancelReason': reason,
          }
        : null,
    'read': false,
    'createdAt': '2026-11-12T10:00:00.000Z',
  });

  test('a cancelled booking carries what to say and what to open', () {
    final notification = toNotification(dto());

    expect(notification, isA<BookingCancelledNotification>());
    notification as BookingCancelledNotification;
    expect(notification.bookingId, 'k1');
    expect(notification.storeArea, 'Andalus');
    expect(notification.reason, CancelReason.storeOff);
    expect(notification.read, isFalse);
  });

  test('a reason this version does not know still says it was not theirs', () {
    final notification =
        toNotification(dto(reason: 'SOMETHING_NEW'))!
            as BookingCancelledNotification;

    expect(notification.reason, CancelReason.other);
  });

  test('a kind this version does not know is left out', () {
    expect(toNotification(dto(kind: 'SOMETHING_NEW')), isNull);
    expect(toNotification(dto(withBooking: false)), isNull);
  });
}
