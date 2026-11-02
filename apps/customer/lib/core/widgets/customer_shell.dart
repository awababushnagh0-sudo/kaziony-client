import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';

/// The tabs, in the order of the router's branches.
enum CustomerTab { home, search, bookings, favorites, account }

/// The tabs around the app's pages. Each tab keeps its own history.
class CustomerShell extends AppView {
  const CustomerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SNavBar(
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
