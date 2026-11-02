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
  late int done;

  setUp(() {
    finder = FakeLocationFinder();
    areas = FakeServiceAreaRepository();
    done = 0;
  });

  /// [mapAnswer] is what the map page closes with.
  Future<void> open(WidgetTester tester, {bool? mapAnswer}) =>
      pumpCustomerPages(
        tester,
        initial: Routes.welcomeLocation,
        locationFinder: finder,
        routes: [
          GoRoute(
            path: Routes.welcomeLocation,
            builder: (_, _) => LocationScreen(
              mapRoute: Routes.welcomeMap,
              onDone: () => done++,
            ),
          ),
          GoRoute(
            path: Routes.welcomeMap,
            builder: (context, _) => SButton(
              label: 'close map',
              onPressed: () => context.pop(mapAnswer),
            ),
          ),
        ],
        overrides: [serviceAreaRepositoryProvider.overrideWithValue(areas)],
      );

  testWidgets('moves on once the phone\'s location is found', (tester) async {
    await open(tester);

    await tester.tap(find.text('Use my location'));
    await tester.pumpAndSettle();

    expect(finder.asked, 1);
    expect(done, 1);
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
    await open(tester, mapAnswer: true);

    await tester.tap(find.text('Set it on the map'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('close map'));
    await tester.pumpAndSettle();

    expect(done, 1);
    expect(finder.asked, 0);
  });

  testWidgets('stays when the map closes without a place', (tester) async {
    await open(tester);

    await tester.tap(find.text('Set it on the map'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('close map'));
    await tester.pumpAndSettle();

    expect(done, 0);
    expect(find.text('Use my location'), findsOneWidget);
  });
}
