import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/terms_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/bookings/presentation/bookings_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/location/domain/browse_location.dart';
import '../../features/location/presentation/location_screen.dart';
import '../../features/location/presentation/map_picker_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../l10n/generated/customer_localizations.dart';
import '../widgets/coming_soon_screen.dart';
import '../widgets/customer_shell.dart';
import 'redirect.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref, [
    versionGateProvider,
    browseLocationProvider,
  ]);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(
      update: ref.read(versionGateProvider),
      hasLocation: ref.read(browseLocationProvider) != null,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.update,
        builder: (_, _) =>
            const SScaffold(showAppBar: false, body: SUpdateRequiredView()),
      ),
      GoRoute(path: Routes.terms, builder: (_, _) => const TermsScreen()),
      GoRoute(
        path: Routes.welcome,
        builder: (_, _) => const WelcomeScreen(),
        routes: [
          GoRoute(
            path: 'location',
            builder: (context, _) => LocationScreen(
              mapRoute: Routes.welcomeMap,
              onDone: () => context.go(Routes.welcomeSignIn),
            ),
            routes: [_map],
          ),
          GoRoute(
            path: 'sign-in',
            builder: (_, _) => const SignInScreen(onboarding: true),
          ),
        ],
      ),
      GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
      GoRoute(
        path: Routes.location,
        builder: (context, _) => LocationScreen(
          canGoBack: true,
          mapRoute: Routes.locationMap,
          onDone: () => context.pop(),
        ),
        routes: [_map],
      ),
      // One branch per [CustomerTab], in its order.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => CustomerShell(shell: shell),
        branches: [
          _tab(Routes.home, (_) => const HomeScreen()),
          _tab(Routes.search, (s) => ComingSoonScreen(title: s.searchTitle)),
          _tab(Routes.bookings, (_) => const BookingsScreen()),
          _tab(
            Routes.favorites,
            (s) => ComingSoonScreen(title: s.favoritesTitle),
          ),
          _tab(Routes.account, (_) => const AccountScreen()),
        ],
      ),
    ],
  );
});

/// Under both location pages: [Routes.welcomeMap], [Routes.locationMap].
final _map = GoRoute(path: 'map', builder: (_, _) => const MapPickerScreen());

StatefulShellBranch _tab(
  String path,
  Widget Function(CustomerLocalizations s) page,
) => StatefulShellBranch(
  routes: [
    GoRoute(
      path: path,
      builder: (context, _) => page(CustomerLocalizations.of(context)),
    ),
  ],
);
