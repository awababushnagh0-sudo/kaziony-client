import 'package:kernel/kernel.dart';

/// Something the app told the customer: a booking about to run out, a
/// favorite store's new offer.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime sentAt;
}

/// The signed-in customer's notifications.
abstract interface class NotificationsRepository {
  /// The newest first.
  Future<Result<List<AppNotification>>> list();
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
