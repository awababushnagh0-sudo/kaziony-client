import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/terms_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/bookings/presentation/booking_screen.dart';
import '../../features/bookings/presentation/bookings_screen.dart';
import '../../features/bookings/presentation/ratings_screen.dart';
import '../../features/location/domain/browse_location.dart';
import '../../features/location/presentation/location_screen.dart';
import '../../features/location/presentation/map_picker_screen.dart';
import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/home_screen.dart';
import '../../features/offers/presentation/offer_screen.dart';
import '../../features/offers/presentation/search_screen.dart';
import '../../features/offers/presentation/section_offers_screen.dart';
import '../../features/stores/presentation/favorites_screen.dart';
import '../../features/stores/presentation/store_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
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
        path: Routes.offers,
        builder: (_, state) => SectionOffersScreen(
          sort:
              OfferSort.values.asNameMap()[state.uri.queryParameters['sort']] ??
              OfferSort.nearest,
          categoryId: state.uri.queryParameters['category'],
        ),
      ),
      GoRoute(
        path: Routes.storePattern,
        builder: (_, state) =>
            StoreScreen(storeId: state.pathParameters['storeId']!),
      ),
      GoRoute(
        path: Routes.offerPattern,
        builder: (_, state) =>
            OfferScreen(offerId: state.pathParameters['offerId']!),
      ),
      GoRoute(
        path: Routes.favorites,
        builder: (_, _) => const FavoritesScreen(),
      ),
      GoRoute(path: Routes.ratings, builder: (_, _) => const RatingsScreen()),
      GoRoute(
        path: Routes.bookingPattern,
        builder: (_, state) =>
            BookingScreen(bookingId: state.pathParameters['bookingId']!),
      ),
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
          _tab(Routes.home, const HomeScreen()),
          _tab(Routes.search, const SearchScreen()),
          _tab(Routes.bookings, const BookingsScreen()),
          _tab(Routes.account, const AccountScreen()),
        ],
      ),
    ],
  );
});

/// Under both location pages: [Routes.welcomeMap], [Routes.locationMap].
final _map = GoRoute(path: 'map', builder: (_, _) => const MapPickerScreen());

StatefulShellBranch _tab(String path, Widget page) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (_, _) => page)],
);
