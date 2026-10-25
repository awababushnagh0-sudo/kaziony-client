import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/store/domain/current_store.dart';
import '../l10n/generated/partner_localizations.dart';

/// The tabs, in the order of the router's branches.
enum PartnerTab { home, offers, products, profile }

/// The tabs around the signed-in pages. Each tab keeps its own history.
/// Staff don't get Products: only owners manage them.
class PartnerShell extends AppView {
  const PartnerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final tabs = [
      PartnerTab.home,
      PartnerTab.offers,
      if (isOwner) PartnerTab.products,
      PartnerTab.profile,
    ];
    final current = PartnerTab.values[shell.currentIndex];
    return SNavBar(
      items: [
        for (final tab in tabs)
          switch (tab) {
            PartnerTab.home => NavBarItem(
              label: s.homeTitle,
              icon: SIcons.home,
            ),
            PartnerTab.offers => NavBarItem(
              label: s.offersTitle,
              icon: SIcons.offers,
            ),
            PartnerTab.products => NavBarItem(
              label: s.productsTitle,
              icon: SIcons.products,
            ),
            PartnerTab.profile => NavBarItem(
              label: s.profileTitle,
              icon: SIcons.user,
            ),
          },
      ],
      selected: tabs.contains(current) ? tabs.indexOf(current) : 0,
      // Tapping the open tab goes back to its first page.
      onSelect: (index) => shell.goBranch(
        tabs[index].index,
        initialLocation: tabs[index] == current,
      ),
      body: shell,
    );
  }
}
