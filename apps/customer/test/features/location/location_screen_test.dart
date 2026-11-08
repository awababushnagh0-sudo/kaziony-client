import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/location/presentation/location_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeLocationFinder finder;
  late FakeServiceAreaRepository areas;
  late MemorySettingsStore settings;
  late int done;

  setUp(() {
    settings = MemorySettingsStore();
    finder = FakeLocationFinder();
    areas = FakeServiceAreaRepository();
    done = 0;
  });

  /// [mapAnswer] is what the map page closes with; [purpose] why the page
  /// asks, the welcome pages' first place unless said.
  Future<void> open(
    WidgetTester tester, {
    GeoPoint? mapAnswer,
    LocationPurpose purpose = LocationPurpose.welcome,
    bool signedIn = false,
  }) => pumpCustomerPages(
    tester,
    initial: Routes.welcomeLocation,
    locationFinder: finder,
    settings: settings,
    routes: [
      GoRoute(
        path: Routes.welcomeLocation,
        builder: (_, _) => LocationScreen(
          mapRoute: Routes.welcomeMap,
          purpose: purpose,
          onDone: () => done++,
        ),
      ),
      GoRoute(
        path: Routes.welcomeMap,
        builder: (context, state) => Column(
          children: [
            SText('from ${state.extra}'),
            SButton(
              label: 'close map',
              onPressed: () => context.pop(mapAnswer),
            ),
          ],
        ),
      ),
    ],
    overrides: [
      serviceAreaRepositoryProvider.overrideWithValue(areas),
      if (signedIn)
        sessionProvider.overrideWith(() => SignedInSession(customer())),
    ],
  );

  Future<BrowseLocation?> kept() =>
      BrowseLocationController.readSaved(settings);

  testWidgets('moves on once the phone\'s location is found', (tester) async {
    await open(tester);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();

    expect(finder.asked, 1);
    expect(done, 1);
    expect((await kept())?.pinned, isFalse);
  });

  testWidgets('says where Kaziony works when the phone is elsewhere', (
    tester,
  ) async {
    finder.next = const LocationFound(zawiya);
    await open(tester);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();

    expect(find.text('Kaziony is only in Tripoli for now.'), findsOneWidget);
    expect(done, 0);
  });

  testWidgets('says to set it on the map when location is not allowed', (
    tester,
  ) async {
    finder.next = const LocationDenied(forever: false);
    await open(tester);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Location wasn't allowed. You can set your place on the map instead.",
      ),
      findsOneWidget,
    );
    expect(find.text('Open Settings'), findsNothing);
    expect(done, 0);
  });

  testWidgets('offers the settings when only they can fix it', (tester) async {
    finder.next = const LocationOff();
    await open(tester);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();

    expect(finder.locationSettingsOpened, 1);
  });

  testWidgets('moves on once a place is set on the map', (tester) async {
    await open(tester, mapAnswer: souqAlJuma);

    await tester.tap(find.text('Set it on the map'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('close map'));
    await tester.pumpAndSettle();

    expect(done, 1);
    expect(finder.asked, 0);
    final location = await kept();
    expect(location?.point, souqAlJuma);
    expect(location?.pinned, isTrue);
  });

  testWidgets('a place added is left to the map to name and save', (
    tester,
  ) async {
    await open(tester, mapAnswer: souqAlJuma, purpose: LocationPurpose.add);

    expect(find.text('Add a place'), findsOneWidget);
    await tester.tap(find.text('Set it on the map'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('close map'));
    await tester.pumpAndSettle();

    expect(done, 1);
    expect(await kept(), isNull);
  });

  testWidgets('adding from the phone opens the map where it is', (
    tester,
  ) async {
    await open(tester, purpose: LocationPurpose.add);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();

    expect(find.text('from ${const GeoPoint(32.88, 13.19)}'), findsOneWidget);
    await tester.tap(find.text('close map'));
    await tester.pumpAndSettle();

    // Closed without saving: still adding.
    expect(done, 0);
    expect(await kept(), isNull);
  });

  group('with no saved place to switch to', () {
    testWidgets('uses where the phone is, and can go back', (tester) async {
      await open(tester, purpose: LocationPurpose.change, signedIn: true);

      expect(find.byTooltip('Back'), findsOneWidget);
      await tester.tap(find.text('Use my location'));
      await tester.pumpAndSettle();

      expect(done, 1);
      expect((await kept())?.pinned, isFalse);
    });

    testWidgets('signed in, leaves the spot to the map to save', (
      tester,
    ) async {
      await open(
        tester,
        mapAnswer: souqAlJuma,
        purpose: LocationPurpose.change,
        signedIn: true,
      );

      await tester.tap(find.text('Set it on the map'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('close map'));
      await tester.pumpAndSettle();

      expect(done, 1);
      expect(await kept(), isNull);
    });

    testWidgets('a guest shows offers from the spot', (tester) async {
      await open(
        tester,
        mapAnswer: souqAlJuma,
        purpose: LocationPurpose.change,
      );

      await tester.tap(find.text('Set it on the map'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('close map'));
      await tester.pumpAndSettle();

      expect(done, 1);
      expect((await kept())?.pinned, isTrue);
    });
  });
}
