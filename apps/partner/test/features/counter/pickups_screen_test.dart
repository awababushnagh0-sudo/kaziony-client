import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
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

  testWidgets('says when no one is on their way', (tester) async {
    await open(tester, []);

    expect(find.text('No one is on their way'), findsOneWidget);
  });
}
