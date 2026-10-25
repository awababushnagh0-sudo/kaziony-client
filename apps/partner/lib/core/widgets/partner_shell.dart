import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/partner_localizations.dart';

/// The tabs around the signed-in pages. Each tab keeps its own history.
class PartnerShell extends StatelessWidget {
  const PartnerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SNavBar(
      // The same order as the router's branches.
      items: [
        NavBarItem(label: s.homeTitle, icon: SIcons.home),
        NavBarItem(label: s.profileTitle, icon: SIcons.user),
      ],
      selected: shell.currentIndex,
      // Tapping the open tab goes back to its first page.
      onSelect: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      body: shell,
    );
  }
}
