import 'package:kernel/kernel.dart';

import '../../bookings/domain/booking.dart';

/// Something the app told the customer. Each kind carries what it's about,
/// and the app words it in the customer's language.
sealed class AppNotification {
  const AppNotification({
    required this.id,
    required this.sentAt,
    required this.read,
  });

  final String id;
  final DateTime sentAt;

  /// Seen in the inbox already.
  final bool read;
}

/// A booking cancelled by our team, not by the customer: it doesn't count
/// against them.
class BookingCancelledNotification extends AppNotification {
  const BookingCancelledNotification({
    required super.id,
    required super.sentAt,
    required super.read,
    required this.bookingId,
    required this.offerTitle,
    required this.storeName,
    required this.storeArea,
    required this.reason,
  });

  final String bookingId;
  final String offerTitle;
  final String storeName;

  /// The neighbourhood, which tells a brand's places apart.
  final String storeArea;
  final CancelReason reason;
}

/// The signed-in customer's notifications.
abstract interface class NotificationsRepository {
  /// The newest first.
  Future<Result<List<AppNotification>>> list();

  /// How many the customer hasn't seen, for the bell.
  Future<Result<int>> unreadCount();

  /// Once the inbox is open.
  Future<Result<void>> markAllRead();
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
