import 'package:kernel/kernel.dart';

import '../domain/app_notification.dart';

/// The signed-in customer's notifications, the newest first.
final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) async {
    return switch (await ref.watch(notificationsRepositoryProvider).list()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  },
);
