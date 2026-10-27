import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/presentation/scan_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeQrScanner scanner;
  late FakeStoreRepository stores;
  late MemorySettingsStore settings;

  Future<void> open(
    WidgetTester tester, {
    ScannerState camera = const ScannerState(ScannerStatus.scanning),
    List<Branch>? branches,
  }) async {
    scanner = FakeQrScanner(camera);
    stores = FakeStoreRepository()
      ..getResult = Ok(storeDetails(branches: branches));
    settings = MemorySettingsStore();
    await pumpPartnerPages(
      tester,
      initial: Routes.scan,
      settings: settings,
      overrides: [
        qrScannerProvider.overrideWithValue(scanner),
        storeRepositoryProvider.overrideWithValue(stores),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        GoRoute(path: Routes.scan, builder: (_, _) => const ScanScreen()),
        GoRoute(
          path: Routes.claim(':code'),
          builder: (context, state) => SButton(
            label: 'claim ${state.pathParameters['code']}',
            onPressed: context.pop,
          ),
        ),
        stubPage(Routes.typeCode, 'type code page'),
        stubPage(Routes.pickups, 'pickups page'),
      ],
    );
  }

  testWidgets('opens a scanned code', (tester) async {
    await open(tester);

    scanner.read('abcd-2345');
    await tester.pumpAndSettle();

    expect(find.text('claim ABCD2345'), findsOneWidget);
  });

  testWidgets("doesn't open the same code again right after coming back", (
    tester,
  ) async {
    await open(tester);
    scanner.read('ABCD2345');
    await tester.pumpAndSettle();
    await tester.tap(find.text('claim ABCD2345'));
    await tester.pumpAndSettle();

    // The customer still holds it up.
    scanner.read('ABCD2345');
    await tester.pumpAndSettle();
    expect(find.text('claim ABCD2345'), findsNothing);

    scanner.read('WXYZ6789');
    await tester.pumpAndSettle();
    expect(find.text('claim WXYZ6789'), findsOneWidget);
  });

  testWidgets('says once when a QR code is not a reservation', (tester) async {
    await open(tester);

    scanner
      ..read('https://example.com')
      ..read('https://example.com');
    await tester.pump();

    expect(find.text("This QR code isn't a reservation."), findsOneWidget);
  });

  testWidgets('offers the settings when the camera is off', (tester) async {
    await open(tester, camera: const ScannerState(ScannerStatus.denied));

    expect(find.text('The camera is off'), findsOneWidget);
    await tester.tap(find.text('Open Settings'));
    expect(scanner.settingsOpened, 1);
  });

  testWidgets('switches the light', (tester) async {
    await open(
      tester,
      camera: const ScannerState(ScannerStatus.scanning, hasTorch: true),
    );

    await tester.tap(find.byTooltip('Turn the light on'));
    await tester.pump();

    expect(scanner.torch, isTrue);
  });

  testWidgets('opens typing the code by hand', (tester) async {
    await open(tester);

    await tester.tap(find.text('Type the code'));
    await tester.pumpAndSettle();
    expect(find.text('type code page'), findsOneWidget);
  });

  testWidgets('picks the branch once in a store with several', (tester) async {
    await open(
      tester,
      branches: [branch('b1', 'Andalus'), branch('b2', 'Gargaresh')],
    );

    expect(find.text('Your branch'), findsOneWidget);
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gargaresh'));
    await tester.pumpAndSettle();

    expect(find.text('Gargaresh'), findsOneWidget);
    expect(await settings.getString('counter.branch.a'), 'b2');
  });

  testWidgets('has nothing to pick in a store with one branch', (tester) async {
    await open(tester);

    expect(find.text('Your branch'), findsNothing);
  });
}
