import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/counter/presentation/claim_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeClaimRepository claims;

  /// [over]: opened from a list page, which it goes back to.
  Future<void> open(
    WidgetTester tester, {
    String code = 'ABCD2345',
    Claim? shown,
    bool isOwner = true,
    bool fromList = false,
    bool over = false,
  }) async {
    claims = FakeClaimRepository([shown ?? claim('ABCD2345')]);
    final page = Routes.claim(code, fromList: fromList);
    await pumpPartnerPages(
      tester,
      initial: over ? Routes.deliveries : page,
      overrides: [
        claimRepositoryProvider.overrideWithValue(claims),
        // No ticking clock in tests: the page reads the time when it builds.
        minuteClockProvider.overrideWith((ref) => const Stream.empty()),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
      ],
      routes: [
        // With a scaffold, to show what the page says on its way back.
        GoRoute(
          path: Routes.deliveries,
          builder: (_, _) =>
              const SScaffold(title: 'list page', body: SizedBox.shrink()),
        ),
        GoRoute(
          path: Routes.claim(':code'),
          builder: (_, state) => ClaimScreen(
            code: state.pathParameters['code']!,
            fromList: state.uri.queryParameters['from'] == 'list',
          ),
        ),
      ],
    );
    if (over) {
      unawaited(tester.element(find.text('list page')).push(page));
      await tester.pumpAndSettle();
    }
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

  testWidgets('says who cancelled a reservation', (tester) async {
    Future<void> showCancelled(CancelledBy? by) => open(
      tester,
      shown: claim(
        'ABCD2345',
        status: ClaimStatus.cancelled,
        canRedeem: false,
        cancelledBy: by,
      ),
    );

    await showCancelled(CancelledBy.customer);
    expect(
      find.text('The customer cancelled this reservation.'),
      findsOneWidget,
    );
    await showCancelled(CancelledBy.team);
    expect(find.text('Our team cancelled this reservation.'), findsOneWidget);
    await showCancelled(CancelledBy.store);
    expect(find.text('Your store cancelled this reservation.'), findsOneWidget);
    await showCancelled(null);
    expect(find.text('This reservation was cancelled.'), findsOneWidget);
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

  group('at a store that delivers', () {
    testWidgets('sends a booking with the driver, who collects it', (
      tester,
    ) async {
      await open(tester, shown: claim('ABCD2345', canSendForDelivery: true));

      expect(find.text('Confirm pickup'), findsOneWidget);
      await tester.tap(find.text('Send for delivery'));
      await tester.pumpAndSettle();

      expect(claims.deliverySteps.single, ('send', 'ABCD2345'));
      expect(find.text('With your driver'), findsOneWidget);
      expect(find.text('For the driver to collect'), findsOneWidget);
      expect(find.text('4.5 LD'), findsOneWidget);
    });

    testWidgets('asks before sending a customer picked from the list', (
      tester,
    ) async {
      await open(
        tester,
        shown: claim('ABCD2345', canSendForDelivery: true),
        fromList: true,
      );

      await tester.tap(find.text('Send for delivery'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Your driver takes Caramel cake to Sara, and collects 4.5 LD.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(claims.deliverySteps, isEmpty);
    });

    testWidgets("doesn't offer it when the store doesn't deliver", (
      tester,
    ) async {
      await open(tester);

      expect(find.text('Confirm pickup'), findsOneWidget);
      expect(find.text('Send for delivery'), findsNothing);
    });

    testWidgets('closes a delivery as delivered', (tester) async {
      await open(tester, shown: outForDelivery('ABCD2345'));

      expect(find.textContaining('With your driver since'), findsOneWidget);
      expect(find.text('Out for delivery'), findsNothing);
      // No pickup at the counter: the driver has it.
      expect(find.text('Confirm pickup'), findsNothing);
      expect(find.text('Send for delivery'), findsNothing);

      await tester.tap(find.text('Delivered'));
      await tester.pumpAndSettle();

      expect(claims.deliverySteps.single, ('delivered', 'c-ABCD2345'));
      expect(find.text('Delivered'), findsOneWidget);
      expect(find.text('Paid on delivery'), findsOneWidget);
    });

    testWidgets("says a delivery didn't happen, after asking", (tester) async {
      await open(tester, shown: outForDelivery('ABCD2345'), over: true);

      await tester.tap(find.text("Didn't happen"));
      await tester.pumpAndSettle();
      expect(find.text("The delivery didn't happen?"), findsOneWidget);
      expect(
        find.text(
          'The booking is cancelled and its pieces go back on sale. Sara is '
          "told, and it doesn't count against them.",
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();
      expect(claims.deliverySteps, isEmpty);

      await tester.tap(find.text("Didn't happen"));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel the booking'));
      await tester.pumpAndSettle();

      expect(claims.deliverySteps.single, ('notDelivered', 'c-ABCD2345'));
      // Back on the list, which says so.
      expect(find.text('list page'), findsOneWidget);
      expect(
        find.text('Booking cancelled. Its pieces are back on sale.'),
        findsOneWidget,
      );
    });

    testWidgets("says why when closing a delivery didn't go", (tester) async {
      await open(tester, shown: outForDelivery('ABCD2345'));
      claims.deliveryFailure = const NoConnectionFailure();

      await tester.tap(find.text('Delivered'));
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsOneWidget);
      expect(find.text('Paid on delivery'), findsNothing);
    });
  });
}
