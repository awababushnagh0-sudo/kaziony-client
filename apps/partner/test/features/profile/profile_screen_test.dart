import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/profile/presentation/profile_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeAuthRepository auth;
  late MemorySettingsStore settings;

  Future<void> open(
    WidgetTester tester, {
    required List<StoreMembership> stores,
  }) async {
    auth = FakeAuthRepository();
    settings = MemorySettingsStore();
    await pumpPartnerPages(
      tester,
      initial: Routes.profile,
      settings: settings,
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        myStoresProvider.overrideWithValue(stores),
      ],
      routes: [
        GoRoute(path: Routes.profile, builder: (_, _) => const ProfileScreen()),
        stubPage(Routes.home, 'home page'),
        stubPage(Routes.storeInfo, 'store info page'),
      ],
    );
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the store and the member role', (tester) async {
    await open(tester, stores: [store('a', isOwner: false)]);

    expect(find.text('Store a'), findsOneWidget);
    expect(find.text('Staff'), findsOneWidget);
  });

  testWidgets('opens the store info', (tester) async {
    await open(tester, stores: [store('a')]);

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

  testWidgets('logs out', (tester) async {
    await open(tester, stores: [store('a')]);

    await tap(tester, 'Log out');
    expect(auth.logouts, 1);
  });

  testWidgets('members of one store have nothing to switch', (tester) async {
    await open(tester, stores: [store('a')]);

    expect(find.text('Switch store'), findsNothing);
  });

  testWidgets('switches store from a sheet, then shows home', (tester) async {
    await open(tester, stores: [store('a'), store('b')]);

    await tap(tester, 'Switch store');
    await tap(tester, 'Store b');

    expect(settings.values['store.chosen'], 'b');
    expect(find.text('home page'), findsOneWidget);
  });
}
