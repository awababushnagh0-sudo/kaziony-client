import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import 'booking_texts.dart';
import 'bookings_view_model.dart';

/// The Bookings tab: the customer's reservations, newest first, the ones
/// to pick up with their code. Signed out, the way to sign in.
class BookingsScreen extends AppView {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (ref.watch(sessionProvider) is! SignedIn) {
      return SScaffold(
        title: s.bookingsTitle,
        body: SignInPrompt(
          title: s.bookingsSignedOutTitle,
          message: s.bookingsSignedOutMessage,
        ),
      );
    }
    return SScaffold(
      title: s.bookingsTitle,
      padded: false,
      body: const _List(),
    );
  }
}

class _List extends AppView {
  const _List();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final viewModel = ref.read(bookingsViewModel.notifier);
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    return SAsyncView(
      value: ref.watch(bookingsViewModel),
      onRetry: () => ref.invalidate(bookingsViewModel),
      builder: (context, page) {
        if (page.items.isEmpty) {
          return SEmptyView(
            icon: SIcons.bookings,
            title: s.bookingsEmptyTitle,
            message: s.bookingsEmptyMessage,
            actionLabel: s.browseOffers,
            actionIcon: SIcons.offers,
            onAction: () => context.go(Routes.home),
          );
        }
        return SPagedList(
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final booking = page.items[index];
            final (status, _) = bookingStatus(s, booking, now);
            return SListTile(
              leading: SImage(booking.thumbUrl),
              title: booking.offerTitle,
              subtitle: '${booking.storeName} · $status',
              // The code only while it can still be picked up.
              code: booking.isActiveAt(now)
                  ? formatPickupCode(booking.code)
                  : null,
              onTap: () => context.push(Routes.booking(booking.id)),
            );
          },
          onRefresh: () async {
            final failure = await viewModel.refresh();
            if (failure != null && context.mounted) {
              SSnack.error(context, failureMessage(context, failure));
            }
          },
          onLoadMore: viewModel.loadMore,
          hasMore: page.hasMore,
          loadingMore: page.loadingMore,
          moreFailure: page.moreFailure,
        );
      },
    );
  }
}
