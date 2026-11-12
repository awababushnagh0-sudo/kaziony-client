import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/counter/presentation/deliveries_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  Future<void> open(
    WidgetTester tester,
    List<Claim> claims,
  ) => pumpPartnerPages(
    tester,
    initial: Routes.deliveries,
    overrides: [
      claimRepositoryProvider.overrideWithValue(FakeClaimRepository(claims)),
      currentStoreProvider.overrideWithValue(store('a')),
      // No ticking clock in tests: the page reads the time when it builds.
      minuteClockProvider.overrideWith((ref) => const Stream.empty()),
    ],
    routes: [
      GoRoute(
        path: Routes.deliveries,
        builder: (_, _) => const DeliveriesScreen(),
      ),
      GoRoute(
        path: Routes.claim(':code'),
        builder: (_, state) => SText(
          'claim ${state.pathParameters['code']} '
          '${state.uri.queryParameters['from']}',
        ),
      ),
    ],
  );

  testWidgets(
    'lists the deliveries out, how long each has been, and opens one',
    (tester) async {
      await open(tester, [
        outForDelivery('ABCD2345', out: const Duration(hours: 3)),
        outForDelivery(
          'WXYZ6789',
          customerName: 'Huda',
          out: const Duration(minutes: 20),
        ),
        // Waiting at the counter: not here.
        claim('R3TW8KQN', customerName: 'Ali'),
      ]);

      expect(find.text('Sara'), findsOneWidget);
      expect(find.text('Huda'), findsOneWidget);
      expect(find.text('Ali'), findsNothing);
      expect(find.text('3 h'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('Huda'));
      await tester.pumpAndSettle();
      // Opened by name: the page asks before closing it.
      expect(find.text('claim WXYZ6789 list'), findsOneWidget);
    },
  );

  testWidgets('says when none are out', (tester) async {
    await open(tester, [claim('ABCD2345')]);

    expect(find.text('No deliveries out'), findsOneWidget);
  });
}
