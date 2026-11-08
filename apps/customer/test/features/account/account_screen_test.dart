import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/account/presentation/account_screen.dart';
import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/domain/saved_place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeAuthRepository auth;
  late FakeBookingsRepository bookings;

  setUp(() {
    auth = FakeAuthRepository();
    bookings = FakeBookingsRepository();
  });

  Future<void> open(
    WidgetTester tester, {
    SessionUser? user,
    BrowseLocation? place,
  }) => pumpCustomerPages(
    tester,
    initial: Routes.account,
    routes: [
      GoRoute(path: Routes.account, builder: (_, _) => const AccountScreen()),
      stubPage(Routes.signIn, 'sign-in page'),
      stubPage(Routes.terms, 'terms page'),
      stubPage(Routes.bookings, 'bookings page'),
      stubPage(Routes.favorites, 'favorites page'),
      stubPage(Routes.ratings, 'ratings page'),
      stubPage(Routes.places, 'places page'),
    ],
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      bookingsRepositoryProvider.overrideWithValue(bookings),
      minuteClockProvider.overrideWith((ref) => Stream.value(now)),
      browseLocationProvider.overrideWith(
        () => BrowseLocationController(place),
      ),
      if (user != null)
        sessionProvider.overrideWith(() => SignedInSession(user)),
    ],
  );

  testWidgets('signed out, it opens the sign-in page', (tester) async {
    await open(tester);

    expect(find.text('Welcome, dear guest!'), findsOneWidget);
    expect(find.text('Log out'), findsNothing);
    await tester.tap(find.text('Sign in').last);
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
  });

  testWidgets('shows a pinned place and opens the places to change it', (
    tester,
  ) async {
    await open(tester, place: const BrowseLocation(souqAlJuma, pinned: true));

    expect(find.text('A place on the map'), findsOneWidget);
    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();

    expect(find.text('places page'), findsOneWidget);
  });

  testWidgets('names the saved place offers are shown from', (tester) async {
    const home = SavedPlace(id: '1', name: 'Home', point: souqAlJuma);
    await open(tester, place: BrowseLocation.of(home));

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('shows when offers are around the phone', (tester) async {
    await open(
      tester,
      place: const BrowseLocation(GeoPoint(32.9, 13.2), pinned: false),
    );

    expect(find.text('My current location'), findsOneWidget);
  });

  testWidgets('signed in, it greets by the first name and logs out', (
    tester,
  ) async {
    await open(tester, user: customer(name: 'Ahmed Ali'));

    // At noon.
    expect(find.text('Good evening,'), findsOneWidget);
    expect(find.text('Ahmed'), findsOneWidget);
    expect(find.text('a@gmail.com'), findsOneWidget);

    await tester.ensureVisible(find.text('Log out'));
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(auth.signOuts, 1);
  });

  testWidgets('leads to the bookings, counting the waiting one', (
    tester,
  ) async {
    await open(tester, user: customer());

    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.text('My bookings'));
    await tester.pumpAndSettle();
    expect(find.text('bookings page'), findsOneWidget);
  });

  testWidgets('leads to the favorites', (tester) async {
    await open(tester, user: customer());

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('favorites page'), findsOneWidget);
  });

  testWidgets('leads to the ratings given', (tester) async {
    await open(tester, user: customer());

    await tester.tap(find.text('My ratings'));
    await tester.pumpAndSettle();
    expect(find.text('ratings page'), findsOneWidget);
  });
}
