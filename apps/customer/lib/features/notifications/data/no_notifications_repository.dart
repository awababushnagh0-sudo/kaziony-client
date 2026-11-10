import 'package:kernel/kernel.dart';

import '../domain/app_notification.dart';

/// The backend sends no notifications yet, so there are none to list.
/// Replaced by one that asks the API once it has them.
class NoNotificationsRepository implements NotificationsRepository {
  const NoNotificationsRepository();

  @override
  Future<Result<List<AppNotification>>> list() async => const Ok([]);
}
