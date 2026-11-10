import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/counter/presentation/claim_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeClaimRepository claims;

  Future<void> open(
    WidgetTester tester, {
    String code = 'ABCD2345',
    Claim? shown,
    bool isOwner = true,
    bool fromList = false,
  }) async {
    claims = FakeClaimRepository([shown ?? claim('ABCD2345')]);
    await pumpPartnerPages(
      tester,
      initial: Routes.claim(code, fromList: fromList),
      overrides: [
        claimRepositoryProvider.overrideWithValue(claims),
        // No ticking clock in tests: the page reads the time when it builds.
        minuteClockProvider.overrideWith((ref) => const Stream.empty()),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
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

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    // Just the code, at the store the app is in: nothing to pick first.
    expect(claims.redeems.single, ('a', 'ABCD2345'));
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('Collect from the customer'), findsOneWidget);
    expect(find.text('4.5 LD'), findsOneWidget);
  });

  testWidgets('copies the code with a tap', (tester) async {
    String? copied;
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await open(tester);

    expect(find.text('Tap to copy'), findsOneWidget);
    await tester.tap(find.text('ABCD 2345'));
    await tester.pump();

    expect(copied, 'ABCD 2345');
    expect(find.text('Code copied'), findsOneWidget);
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
    // Another place of the brand's codes too: each is a store of its own.
    await open(tester, code: 'WXYZ6789');

    expect(
      find.text('No reservation with this code at your store.'),
      findsOneWidget,
    );
    expect(find.text('Confirm pickup'), findsNothing);
  });

  testWidgets('staff confirm a pickup the same way', (tester) async {
    await open(tester, isOwner: false);

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    expect(claims.redeems.single, ('a', 'ABCD2345'));
    expect(find.text('Collect from the customer'), findsOneWidget);
  });

  testWidgets("says why when the pickup didn't go", (tester) async {
    await open(tester);
    claims.redeemFailure = const NoConnectionFailure();

    await tester.tap(find.text('Confirm pickup'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsOneWidget);
    expect(find.text('Confirm pickup'), findsOneWidget);
    expect(find.text('Collect from the customer'), findsNothing);
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
    expect(claims.redeems.single, ('a', 'ABCD2345'));
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
