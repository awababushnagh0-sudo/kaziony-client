import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/presentation/change_password/change_password_screen.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/stores/presentation/store_details_screen.dart';
import '../../features/stores/presentation/stores_screen.dart';
import '../l10n/generated/admin_localizations.dart';
import '../widgets/admin_shell.dart';
import '../widgets/coming_soon_screen.dart';
import 'redirect.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref, [sessionProvider, versionGateProvider]);
  ref.onDispose(refresh.dispose);

  // Dashboard pages switch instantly, like a website, and any of them can
  // ask before it's left with unsaved changes (LeaveGuard).
  GoRoute page(
    String path,
    Widget Function(BuildContext context, GoRouterState state) build, {
    List<GoRoute> routes = const [],
  }) => GoRoute(
    path: path,
    routes: routes,
    onExit: LeaveGuard.onExit,
    pageBuilder: (context, state) =>
        NoTransitionPage(key: state.pageKey, child: build(context, state)),
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
      page(Routes.login, (_, _) => const LoginScreen()),
      page(Routes.changePassword, (_, _) => const ChangePasswordScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          page(Routes.home, (_, _) => const DashboardScreen()),
          // A store opens on top of the list, so going back finds the
          // list's search, filter and page as they were.
          page(
            Routes.stores,
            (_, _) => const StoresScreen(),
            routes: [
              page(
                ':id',
                (_, state) =>
                    StoreDetailsScreen(storeId: state.pathParameters['id']!),
              ),
            ],
          ),
          page(
            Routes.users,
            (context, _) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navUsers,
            ),
          ),
          page(
            Routes.offers,
            (context, _) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navOffers,
            ),
          ),
          page(
            Routes.categories,
            (context, _) => ComingSoonScreen(
              title: AdminLocalizations.of(context).navCategories,
            ),
          ),
        ],
      ),
    ],
  );
});
