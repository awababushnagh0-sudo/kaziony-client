import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/bookings/domain/booking.dart';
import '../../features/bookings/presentation/booking_texts.dart';
import '../../features/bookings/presentation/bookings_view_model.dart';
import '../l10n/generated/customer_localizations.dart';
import '../routes/routes.dart';

/// The tabs, in the order of the router's branches.
enum CustomerTab { home, search, bookings, favorites, account }

/// The tabs around the app's pages. Each tab keeps its own history. A
/// booking to pick up floats above them, on every tab but Bookings, and
/// the Bookings tab counts them.
class CustomerShell extends AppView {
  const CustomerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    // To the minute is enough to know which bookings are still on; the
    // bar counts the seconds itself.
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final toPickUp = toPickUpAt(
      ref.watch(bookingsViewModel).value?.items ?? const [],
      now,
    );
    final onBookings = shell.currentIndex == CustomerTab.bookings.index;
    return SNavBar(
      banner: toPickUp.isEmpty || onBookings
          ? null
          : _BookingBar(booking: toPickUp.first),
      items: [
        for (final tab in CustomerTab.values)
          switch (tab) {
            CustomerTab.home => NavBarItem(
              label: s.homeTitle,
              icon: SIcons.home,
            ),
            CustomerTab.search => NavBarItem(
              label: s.searchTitle,
              icon: SIcons.search,
            ),
            CustomerTab.bookings => NavBarItem(
              label: s.bookingsTitle,
              icon: SIcons.bookings,
              count: toPickUp.length,
            ),
            CustomerTab.favorites => NavBarItem(
              label: s.favoritesTitle,
              icon: SIcons.favorites,
            ),
            CustomerTab.account => NavBarItem(
              label: s.accountTitle,
              icon: SIcons.user,
            ),
          },
      ],
      selected: shell.currentIndex,
      // Tapping the open tab goes back to its first page.
      onSelect: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      body: shell,
    );
  }
}

/// The booking soonest to run out, above the tabs: the store's logo, what
/// it is, and the time left, counting down; opens its pass.
class _BookingBar extends AppView {
  const _BookingBar({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final now = ref.watch(secondClockProvider).value ?? DateTime.now();
    return SOngoingBar(
      title: s.bookingReadyBanner,
      subtitle: '${booking.offerTitle} · ${booking.storeName}',
      imageUrl: booking.storeLogoUrl,
      trailing: booking.limited
          ? countdown(booking.expiresAt.difference(now))
          : null,
      onTap: () => context.push(Routes.booking(booking.id)),
    );
  }
}
