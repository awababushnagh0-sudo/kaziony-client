import 'package:kernel/kernel.dart';
import 'package:offers_api/customer.dart' as api;
import 'package:offers_api/customer.dart' show NotificationsClient;

import '../../bookings/data/api_bookings_repository.dart';
import '../../bookings/domain/booking.dart';
import '../domain/app_notification.dart';

class ApiNotificationsRepository implements NotificationsRepository {
  ApiNotificationsRepository(this._api);

  /// The inbox shows this many, the newest: older ones are long settled.
  static const shown = 50;

  final Api _api;
  late final _notifications = _api.client(NotificationsClient.new);

  @override
  Future<Result<List<AppNotification>>> list() async {
    final result = await _api.guard(
      () => _notifications.list(page: 1, pageSize: shown),
    );
    return result.map(
      (list) => [for (final item in list.items) ?toNotification(item)],
    );
  }

  @override
  Future<Result<int>> unreadCount() async =>
      (await _api.guard(_notifications.unread)).map((u) => u.count.toInt());

  @override
  Future<Result<void>> markAllRead() => _api.guard(_notifications.markAllRead);
}

/// Null for a kind this version of the app doesn't know: it's left out.
AppNotification? toNotification(api.NotificationDto dto) => switch (dto.kind) {
  api.NotificationKind.bookingCancelled => switch (dto.booking) {
    final booking? => BookingCancelledNotification(
      id: dto.id,
      sentAt: dto.createdAt.toLocal(),
      read: dto.read,
      bookingId: booking.id,
      offerTitle: booking.offerTitle,
      storeName: booking.storeName,
      storeArea: booking.storeArea,
      reason: toCancelReason(booking.cancelReason) ?? CancelReason.other,
    ),
    null => null,
  },
  api.NotificationKind.$unknown => null,
};
