import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../bookings/presentation/booking_texts.dart';
import '../domain/app_notification.dart';
import 'notifications_view_model.dart';

/// What the app told the customer, the newest first, opened from the bell
/// on home; each opens what it's about. With none, a picture and the way to
/// look again; signed out, the way to sign in.
class NotificationsScreen extends AppView {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (ref.watch(sessionProvider) is! SignedIn) {
      return SScaffold(
        title: s.notificationsTitle,
        body: SignInPrompt(
          title: s.notificationsSignInTitle,
          message: s.notificationsSignInMessage,
        ),
      );
    }
    return SScaffold(
      title: s.notificationsTitle,
      padded: false,
      body: const _Notifications(),
    );
  }
}

class _Notifications extends AppView {
  const _Notifications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SAsyncView(
      value: ref.watch(notificationsProvider),
      onRetry: () => ref.invalidate(notificationsProvider),
      loading: const SSkeleton.list(),
      builder: (context, notifications) {
        if (notifications.isEmpty) {
          return SEmptyView(
            illustration: CustomerIllustrations.notifications,
            title: s.notificationsEmptyTitle,
            message: s.notificationsEmptyMessage,
            actionLabel: s.refresh,
            onAction: () => ref.invalidate(notificationsProvider),
          );
        }
        return SSliverView(
          onRefresh: () => ref.refresh(notificationsProvider.future),
          slivers: [
            SliverList.separated(
              itemCount: notifications.length,
              itemBuilder: (_, i) => _Notification(
                notifications[i],
                sent: formatWhen(
                  notifications[i].sentAt,
                  languageCode: language,
                ),
              ),
              separatorBuilder: (_, _) => const SDivider(inset: true),
            ),
          ],
        );
      },
    );
  }
}

class _Notification extends StatelessWidget {
  const _Notification(this.notification, {required this.sent});

  final AppNotification notification;
  final String sent;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return switch (notification) {
      final BookingCancelledNotification n => SListTile(
        icon: SIcons.notifications,
        title: s.notificationBookingCancelled(
          [n.storeName, n.storeArea].join(' · '),
        ),
        subtitle: s.notificationAbout(
          n.offerTitle,
          cancelledFor(s, n.reason).message,
        ),
        value: sent,
        onTap: () => context.push(Routes.booking(n.bookingId)),
      ),
    };
  }
}
