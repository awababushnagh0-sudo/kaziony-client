import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/profile/presentation/about_screen.dart';
import 'package:partner/features/profile/presentation/profile_screen.dart';
import 'package:partner/features/profile/presentation/terms_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeAuthRepository auth;
  late MemorySettingsStore settings;
  late FakeStoreRepository storeRepository;

  Future<void> open(
    WidgetTester tester, {
    required List<StoreMembership> stores,
  }) async {
    auth = FakeAuthRepository();
    settings = MemorySettingsStore();
    storeRepository = FakeStoreRepository();
    await pumpPartnerPages(
      tester,
      initial: Routes.profile,
      settings: settings,
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        sessionProvider.overrideWith(
          () => SignedInSession(user(memberships: stores)),
        ),
        myStoresProvider.overrideWithValue(stores),
        storeRepositoryProvider.overrideWithValue(storeRepository),
      ],
      routes: [
        GoRoute(path: Routes.profile, builder: (_, _) => const ProfileScreen()),
        stubPage(Routes.home, 'home page'),
        stubPage(Routes.storeInfo, 'store info page'),
        stubPage(Routes.location, 'location page'),
        stubPage(Routes.team, 'team page'),
        GoRoute(path: Routes.about, builder: (_, _) => const AboutScreen()),
        GoRoute(path: Routes.terms, builder: (_, _) => const TermsScreen()),
      ],
    );
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the store, its category and area, and who is signed in', (
    tester,
  ) async {
    await open(tester, stores: [store('a')]);

    expect(find.text('Store a'), findsOneWidget);
    expect(find.text('Sweets · Hay Al Andalus'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Owner'), findsOneWidget);
  });

  testWidgets('pulling down loads the store again', (tester) async {
    await open(tester, stores: [store('a')]);
    storeRepository.getResult = Ok(storeDetails(area: 'Gargaresh'));

    await tester.fling(find.text('Store a'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Sweets · Gargaresh'), findsOneWidget);
    expect(find.text('Gargaresh'), findsOneWidget);
  });

  testWidgets('opens the store info', (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'Store info');
    expect(find.text('store info page'), findsOneWidget);
  });

  testWidgets('owners see how many members, and open the team', (tester) async {
    await open(tester, stores: [store('a')]);

    expect(find.text('2'), findsOneWidget);
    await tap(tester, 'Team');
    expect(find.text('team page'), findsOneWidget);
  });

  testWidgets('opens the location, with its area', (tester) async {
    await open(tester, stores: [store('a')]);

    expect(find.text('Hay Al Andalus'), findsOneWidget);
    await tap(tester, 'Location and hours');
    expect(find.text('location page'), findsOneWidget);
  });

  testWidgets('staff see the location, not the team', (tester) async {
    await open(tester, stores: [store('a', isOwner: false)]);

    expect(find.text('Staff'), findsOneWidget);
    expect(find.text('Team'), findsNothing);
    await tap(tester, 'Location and hours');
    expect(find.text('location page'), findsOneWidget);
  });

  testWidgets('staff open the store info too', (tester) async {
    await open(tester, stores: [store('a', isOwner: false)]);

    await tap(tester, 'Store info');
    expect(find.text('store info page'), findsOneWidget);
  });

  testWidgets('shows the language and changes it', (tester) async {
    await open(tester, stores: [store('a')]);

    // Arabic until another language is chosen.
    expect(find.text('العربية'), findsOneWidget);
    await tap(tester, 'Language');
    await tap(tester, 'English');
    expect(settings.values['settings.locale'], 'en');
  });

  testWidgets('shows the theme and changes it', (tester) async {
    await open(tester, stores: [store('a')]);

    // Light until another is chosen.
    expect(find.text('Light'), findsOneWidget);
    await tap(tester, 'Theme');
    await tap(tester, 'Dark');
    expect(settings.values['settings.theme'], 'dark');
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('about shows the version and opens the terms', (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'About the app');
    expect(find.text('1.0.0 (1)'), findsOneWidget);
    await tap(tester, 'Terms and conditions');
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('opens the terms', (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'Terms and conditions');
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('logs out once confirmed', (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'Log out');
    expect(find.text('Log out?'), findsOneWidget);
    expect(auth.logouts, 0);
    // The dialog's button, over the page's.
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();
    expect(auth.logouts, 1);
  });

  testWidgets("stays logged in when it's cancelled", (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'Log out');
    await tap(tester, 'Cancel');
    expect(auth.logouts, 0);
  });

  testWidgets('members of one store have nothing to switch', (tester) async {
    await open(tester, stores: [store('a')]);

    expect(find.text('Switch store'), findsNothing);
  });

  testWidgets('switches store from a sheet, then shows home', (tester) async {
    // A brand's two places: the area tells them apart.
    await open(
      tester,
      stores: [
        store('a', area: 'Hay Al Andalus'),
        store('b', area: 'Gargaresh'),
      ],
    );

    await tap(tester, 'Switch store');
    expect(find.text('Store a · Hay Al Andalus'), findsOneWidget);
    await tap(tester, 'Store b · Gargaresh');

    expect(settings.values['store.chosen'], 'b');
    expect(find.text('home page'), findsOneWidget);
  });
}
