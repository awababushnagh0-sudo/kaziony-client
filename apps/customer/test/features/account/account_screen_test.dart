import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/account/presentation/account_screen.dart';
import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() => auth = FakeAuthRepository());

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
      stubPage(Routes.location, 'location page'),
      stubPage(Routes.terms, 'terms page'),
    ],
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
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

  testWidgets('shows a pinned place and changes it', (tester) async {
    await open(tester, place: const BrowseLocation(souqAlJuma, pinned: true));

    expect(find.text('A place on the map'), findsOneWidget);
    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();

    expect(find.text('location page'), findsOneWidget);
  });

  testWidgets('shows when offers are around the phone', (tester) async {
    await open(
      tester,
      place: const BrowseLocation(GeoPoint(32.9, 13.2), pinned: false),
    );

    expect(find.text('My current location'), findsOneWidget);
  });

  testWidgets('signed in, it shows who and logs out', (tester) async {
    await open(tester, user: customer());

    expect(find.text('Ahmed'), findsOneWidget);
    expect(find.text('a@gmail.com'), findsOneWidget);

    await tester.ensureVisible(find.text('Log out'));
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(auth.signOuts, 1);
  });
}
