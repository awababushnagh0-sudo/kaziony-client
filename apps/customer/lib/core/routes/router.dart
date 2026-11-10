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
import '../../features/location/presentation/places_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
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
            routes: [
              GoRoute(path: 'map', builder: (_, _) => const MapPickerScreen()),
            ],
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
        path: Routes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.bookingPattern,
        builder: (_, state) =>
            BookingScreen(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        path: Routes.location,
        builder: (context, _) => LocationScreen(
          purpose: LocationPurpose.change,
          mapRoute: Routes.locationMap,
          onDone: () => context.pop(),
        ),
        routes: [
          GoRoute(
            path: 'map',
            // Signed in, the spot is named and saved as a place.
            builder: (_, _) =>
                MapPickerScreen(adding: ref.read(sessionProvider) is SignedIn),
          ),
        ],
      ),
      GoRoute(
        path: Routes.places,
        builder: (_, _) => const PlacesScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, _) => LocationScreen(
              purpose: LocationPurpose.add,
              mapRoute: Routes.addPlaceMap,
              onDone: () => context.pop(),
            ),
            routes: [
              GoRoute(
                path: 'map',
                builder: (_, state) => MapPickerScreen(
                  start: state.extra as GeoPoint?,
                  adding: true,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'map',
            builder: (_, state) =>
                MapPickerScreen(start: state.extra as GeoPoint?),
          ),
        ],
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

StatefulShellBranch _tab(String path, Widget page) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (_, _) => page)],
);
