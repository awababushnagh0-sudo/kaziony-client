import 'package:kernel/kernel.dart';

import '../domain/app_notification.dart';

/// The signed-in customer's notifications, the newest first. Once they're
/// shown, they're seen: the bell's count goes.
final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) async {
    final repository = ref.watch(notificationsRepositoryProvider);
    final notifications = switch (await repository.list()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    if (notifications.any((n) => !n.read)) {
      // Sent once; if it doesn't get through, the count stays until the
      // inbox is opened again.
      if ((await repository.markAllRead()).isOk && ref.mounted) {
        ref.invalidate(unreadNotificationsProvider);
      }
    }
    return notifications;
  },
);

/// For the bell: how many the customer hasn't seen. None signed out, or
/// when it can't be read.
final unreadNotificationsProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  if (ref.watch(sessionProvider) is! SignedIn) return 0;
  final result = await ref.watch(notificationsRepositoryProvider).unreadCount();
  return result.valueOrNull ?? 0;
});
