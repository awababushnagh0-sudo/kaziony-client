import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/providers/clock.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/counter/presentation/claim_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeClaimRepository claims;

  Future<void> open(
    WidgetTester tester, {
    String code = 'ABCD2345',
    Claim? shown,
    List<Branch>? branches,
    String? staffBranch,
    bool fromList = false,
  }) async {
    claims = FakeClaimRepository([shown ?? claim('ABCD2345')]);
    final stores = FakeStoreRepository()
      ..getResult = Ok(storeDetails(branches: branches));
    await pumpPartnerPages(
      tester,
      initial: Routes.claim(code, fromList: fromList),
      overrides: [
        claimRepositoryProvider.overrideWithValue(claims),
        // No ticking clock in tests: the page reads the time when it builds.
        minuteClockProvider.overrideWith((ref) => const Stream.empty()),
        storeRepositoryProvider.overrideWithValue(stores),
        currentStoreProvider.overrideWithValue(
          StoreMembership(
            storeId: 'a',
            storeName: 'Store a',
            storeLogoUrl: null,
            isOwner: staffBranch == null,
            branchId: staffBranch,
          ),
        ),
      ],
      routes: [
        GoRoute(
          path: Routes.claim(':code'),
          builder: (_, state) => ClaimScreen(
            code: state.pathParameters['code']!,
            fromList: state.uri.queryParameters['from'] == 'list',
          ),
        ),
      ],
    );
  }

  testWidgets('shows what to collect, then confirms the pickup', (
    tester,
  ) async {
    await open(tester);

    // The line and the total.
    expect(find.text('4.5 LD'), findsNWidgets(2));
    expect(find.text('4.5 LD each'), findsOneWidget);
    expect(find.text('Paid in cash'), findsOneWidget);
    // What it's paid, never what it would have cost.
    expect(find.text('9 LD'), findsNothing);
    expect(find.text('ABCD 2345'), findsOneWidget);
    expect(find.text('Sara'), findsOneWidget);
    expect(find.text('Caramel cake'), findsOneWidget);
    // The store's only branch is where it's picked up.
    expect(find.text('Branch'), findsOneWidget);

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    // The store's only branch.
    expect(claims.redeems.single, ('ABCD2345', 'b1'));
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('Collect from the customer'), findsOneWidget);
    expect(find.text('4.5 LD'), findsOneWidget);
  });

  testWidgets('says how many pieces to hand over and what they come to', (
    tester,
  ) async {
    await open(
      tester,
      shown: claim('ABCD2345', quantity: 3, totalPrice: '13.500'),
    );

    // On the line and as the total.
    expect(find.text('13.5 LD'), findsNWidgets(2));
    expect(find.text('4.5 LD each'), findsOneWidget);
    expect(find.textContaining('×3'), findsOneWidget);
  });

  testWidgets('says why a code was already used', (tester) async {
    await open(
      tester,
      shown: claim(
        'ABCD2345',
        status: ClaimStatus.redeemed,
        canRedeem: false,
        redeemedAt: DateTime.now(),
      ),
    );

    expect(find.textContaining('Already picked up: '), findsOneWidget);
    expect(find.textContaining("Don't hand it over again."), findsOneWidget);
    // No amount to collect for a used code.
    expect(find.text('To collect'), findsNothing);
    expect(find.text('Confirm pickup'), findsNothing);
  });

  testWidgets('says when no reservation has the code', (tester) async {
    await open(tester, code: 'WXYZ6789');

    expect(
      find.text('No reservation with this code at your store.'),
      findsOneWidget,
    );
  });

  testWidgets('shows why when it was picked up elsewhere meanwhile', (
    tester,
  ) async {
    await open(tester);
    claims
      ..claims[0] = claim(
        'ABCD2345',
        status: ClaimStatus.redeemed,
        canRedeem: false,
      )
      ..redeemFailure = const ConflictFailure();

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    expect(find.text('Already picked up.'), findsOneWidget);
    expect(find.text('Confirm pickup'), findsNothing);
  });

  testWidgets('asks an owner of several branches where they are, once', (
    tester,
  ) async {
    await open(
      tester,
      branches: [branch('b1', 'Andalus'), branch('b2', 'Gargaresh')],
    );

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();
    expect(find.text('Which branch are you at?'), findsOneWidget);
    await tester.tap(find.text('Gargaresh'));
    await tester.pumpAndSettle();

    expect(claims.redeems.single, ('ABCD2345', 'b2'));
    expect(find.text('Picked up'), findsOneWidget);
  });

  testWidgets("doesn't ask staff limited to a branch", (tester) async {
    await open(
      tester,
      branches: [branch('b1', 'Andalus'), branch('b2', 'Gargaresh')],
      staffBranch: 'b1',
    );

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    expect(claims.redeems.single, ('ABCD2345', null));
  });

  testWidgets('asks before confirming a customer picked from the list', (
    tester,
  ) async {
    await open(tester, fromList: true);

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();
    expect(find.text('Is it the right customer?'), findsOneWidget);
    expect(
      find.text(
        'Make sure you handed Caramel cake to Sara and collected 4.5 LD.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(claims.redeems, isEmpty);

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, picked up'));
    await tester.pumpAndSettle();
    expect(claims.redeems.single, ('ABCD2345', 'b1'));
    expect(find.text('Collect from the customer'), findsOneWidget);
  });

  testWidgets("doesn't ask after a scan: the code is the check", (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    expect(find.text('Is it the right customer?'), findsNothing);
    expect(claims.redeems, hasLength(1));
  });
}
