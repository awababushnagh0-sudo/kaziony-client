import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/providers/clock.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/counter/presentation/pickups_screen.dart';
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
    initial: Routes.pickups,
    overrides: [
      claimRepositoryProvider.overrideWithValue(FakeClaimRepository(claims)),
      currentStoreProvider.overrideWithValue(store('a')),
      // No ticking clock in tests: the page reads the time when it builds.
      minuteClockProvider.overrideWith((ref) => const Stream.empty()),
    ],
    routes: [
      GoRoute(path: Routes.pickups, builder: (_, _) => const PickupsScreen()),
      GoRoute(
        path: Routes.claim(':code'),
        builder: (_, state) => SText('claim ${state.pathParameters['code']}'),
      ),
    ],
  );

  testWidgets('lists who is coming and opens one', (tester) async {
    await open(tester, [
      claim('ABCD2345'),
      claim('WXYZ6789', customerName: null),
    ]);

    expect(find.text('Sara'), findsOneWidget);
    expect(find.text('A customer'), findsOneWidget);

    await tester.tap(find.text('A customer'));
    await tester.pumpAndSettle();
    expect(find.text('claim WXYZ6789'), findsOneWidget);
  });

  testWidgets('shows codes, how many are coming and until when each is held', (
    tester,
  ) async {
    await open(tester, [
      claim('R3TW8KQN', heldFor: const Duration(minutes: 12), quantity: 2),
      claim(
        'GONE2345',
        customerName: 'Late',
        heldFor: const Duration(minutes: -1),
      ),
    ]);

    expect(find.textContaining('R3TW 8KQN'), findsOneWidget);
    // Until when it's held; what was taken is on the page it opens.
    expect(find.textContaining('Until '), findsOneWidget);
    expect(find.textContaining('×2'), findsNothing);
    expect(find.text('12 min'), findsOneWidget);
    expect(find.text('Late'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(
      find.text(
        "Reservations stay here until they're picked up or their time runs out.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('says when no one is on their way', (tester) async {
    await open(tester, []);

    expect(find.text('No one is on their way'), findsOneWidget);
  });
}
