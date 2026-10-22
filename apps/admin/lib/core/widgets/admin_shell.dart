import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../l10n/generated/admin_localizations.dart';
import '../providers/access.dart';
import '../routes/routes.dart';
import '../utils/language.dart';

/// The side menu around every page after signing in.
class AdminShell extends AppView {
  const AdminShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final user = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };

    NavItemSpec item(String route, String label, SIcons icon) => NavItemSpec(
      label: label,
      icon: icon,
      selected: location == route || location.startsWith('$route/'),
      onTap: () => context.go(route),
    );

    return SShell(
      title: s.appTitle,
      subtitle: s.appSubtitle,
      items: [
        item(Routes.home, s.navHome, SIcons.home),
        item(Routes.stores, s.navStores, SIcons.store),
        if (ref.watch(isAdminProvider))
          item(Routes.users, s.navUsers, SIcons.users),
        item(Routes.offers, s.navOffers, SIcons.offers),
        item(Routes.categories, s.navCategories, SIcons.category),
      ],
      userName: user?.name ?? user?.email,
      userDetail: user?.name == null ? null : user?.email,
      userActions: [
        ShellMenuAction(
          label: s.switchLanguage,
          icon: SIcons.language,
          onTap: () => toggleLanguage(ref),
        ),
        ShellMenuAction(
          label: s.logout,
          icon: SIcons.logout,
          destructive: true,
          onTap: () => ref.read(authRepositoryProvider).logout(),
        ),
      ],
      body: child,
    );
  }
}
