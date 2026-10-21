import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/presentation/change_password/change_password_screen.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/stores/presentation/stores_screen.dart';
import '../l10n/generated/admin_localizations.dart';
import '../widgets/admin_shell.dart';
import '../widgets/coming_soon_screen.dart';
import 'redirect.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref, [sessionProvider, versionGateProvider]);
  ref.onDispose(refresh.dispose);

  // Dashboard pages switch instantly, like a website.
  GoRoute page(String path, Widget Function(BuildContext context) build) =>
      GoRoute(
        path: path,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: build(context)),
      );

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(
      session: ref.read(sessionProvider),
      update: ref.read(versionGateProvider),
      uri: state.uri,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) =>
            const SScaffold(showAppBar: false, body: SLoadingView()),
      ),
      GoRoute(
        path: Routes.update,
        builder: (_, _) =>
            const SScaffold(showAppBar: false, body: SUpdateRequiredView()),
      ),
      page(Routes.login, (_) => const LoginScreen()),
      page(Routes.changePassword, (_) => const ChangePasswordScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          page(Routes.home, (_) => const DashboardScreen()),
          page(Routes.stores, (_) => const StoresScreen()),
          page(
            Routes.users,
            (context) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navUsers,
            ),
          ),
          page(
            Routes.offers,
            (context) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navOffers,
            ),
          ),
          page(
            Routes.categories,
            (context) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navCategories,
            ),
          ),
        ],
      ),
    ],
  );
});
