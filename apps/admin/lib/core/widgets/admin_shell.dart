import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../l10n/generated/admin_localizations.dart';
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

    NavItemSpec item(String route, String label, AppIcon icon) => NavItemSpec(
      label: label,
      icon: icon,
      selected: location == route || location.startsWith('$route/'),
      onTap: () => context.go(route),
    );

    return AppShell(
      title: s.appTitle,
      subtitle: s.appSubtitle,
      items: [
        item(Routes.home, s.navHome, AppIcon.home),
        item(Routes.stores, s.navStores, AppIcon.store),
        item(Routes.users, s.navUsers, AppIcon.users),
        item(Routes.offers, s.navOffers, AppIcon.offers),
        item(Routes.categories, s.navCategories, AppIcon.category),
      ],
      userName: user?.name ?? user?.email,
      userDetail: user?.name == null ? null : user?.email,
      userActions: [
        ShellMenuAction(
          label: s.switchLanguage,
          icon: AppIcon.language,
          onTap: () => toggleLanguage(ref),
        ),
        ShellMenuAction(
          label: s.logout,
          icon: AppIcon.logout,
          destructive: true,
          onTap: () => ref.read(authRepositoryProvider).logout(),
        ),
      ],
      body: child,
    );
  }
}
