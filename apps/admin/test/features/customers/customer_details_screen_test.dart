import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/routes/routes.dart';
import 'package:admin/features/bookings/domain/booking_status.dart';
import 'package:admin/features/customers/domain/customer.dart';
import 'package:admin/features/customers/presentation/customer_bookings_tab.dart';
import 'package:admin/features/customers/presentation/customer_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

const _id = 'customer-9';

Widget harness(
  FakeCustomerRepository customers, {
  AccountRole role = AccountRole.admin,
}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    customerRepositoryProvider.overrideWithValue(customers),
    sessionProvider.overrideWith(() => FakeSession(user(role: role))),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      initialLocation: Routes.customer(_id),
      routes: [
        GoRoute(
          path: Routes.customers,
          builder: (_, _) => const SText('Customers list'),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) => CustomerDetailsScreen(
                customerId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1400, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> chooseAction(WidgetTester tester, String action) async {
  await tester.tap(find.text('Actions'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(action));
  await tester.pumpAndSettle();
}

/// Says yes in the dialog that asks first: its button is the last [label].
Future<void> confirm(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows where they stand and why, under "Customers"', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeCustomerRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Huda'), findsWidgets);
    expect(find.text('Booking paused'), findsOneWidget);
    expect(find.textContaining('Booking paused until'), findsOneWidget);
    // Their strikes, with the booking each was for.
    expect(
      find.text(
        '2 of 3 count toward a pause now: those from the last 30 days, after '
        'their last pause.',
      ),
      findsOneWidget,
    );
    expect(find.text('Dinner box'), findsOneWidget);
    expect(find.text('Pastry bag'), findsOneWidget);
    expect(find.text('An older booking'), findsOneWidget);
    expect(find.text('Counts'), findsNWidgets(2));
    expect(find.text('No longer counts'), findsOneWidget);
    expect(find.text('3 strikes'), findsOneWidget);
    // How to reach them, and what else they do.
    expect(find.text('huda@example.com'), findsWidgets);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('4 stores'), findsOneWidget);
    expect(find.text('Open reports'), findsOneWidget);
  });

  testWidgets('editors end a pause after asking, and only that', (
    tester,
  ) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    await tester.pumpWidget(harness(customers, role: AccountRole.editor));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    expect(find.text('Disable account'), findsNothing);
    await tester.tap(find.text('End the pause'));
    await tester.pumpAndSettle();
    expect(find.text("End Huda's pause?"), findsOneWidget);
    await confirm(tester, 'End the pause');

    expect(customers.pausesEnded, [_id]);
    expect(find.text('Pause ended: they can book again'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    // Nothing is left for an editor to do.
    expect(find.text('Actions'), findsNothing);
  });

  testWidgets('says so when the pause was over already', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository()
      ..actionFailure = const ConflictFailure(
        'Not paused',
        CustomerCodes.notPaused,
      );
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'End the pause');
    await confirm(tester, 'End the pause');

    expect(
      find.text("The customer's pause has already ended."),
      findsOneWidget,
    );
    // The page is read again, to show it as it is.
    expect(customers.opened, [_id, _id]);
  });

  testWidgets('takes back a strike after asking', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Take back').first);
    await tester.pumpAndSettle();
    expect(find.text('Take back this strike?'), findsOneWidget);
    await confirm(tester, 'Take back');

    expect(customers.strikesTakenBack, [(_id, 'strike-1')]);
    expect(find.text('Strike taken back'), findsOneWidget);
    expect(find.text('Dinner box'), findsNothing);
    expect(find.text('2 strikes'), findsOneWidget);
  });

  testWidgets('says so when the strike was taken back already', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository()
      ..actionFailure = const NotFoundFailure();
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Take back').first);
    await tester.pumpAndSettle();
    await confirm(tester, 'Take back');

    expect(
      find.text("This booking's strike was already taken back."),
      findsOneWidget,
    );
    expect(customers.opened, [_id, _id]);
  });

  testWidgets('admins disable an account after asking, and enable it', (
    tester,
  ) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    customers.details[_id] = sampleCustomerDetails(
      _id,
      standing: CustomerStanding.active,
    );
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Disable account');
    expect(find.text('Disable Huda?'), findsOneWidget);
    await confirm(tester, 'Disable account');

    expect(customers.activeChanges, [(_id, false)]);
    expect(find.text('Account disabled'), findsOneWidget);
    expect(find.text('We disabled this account'), findsOneWidget);

    await chooseAction(tester, 'Enable account');

    expect(customers.activeChanges, [(_id, false), (_id, true)]);
    expect(find.text('We disabled this account'), findsNothing);
  });

  testWidgets('a deleted account has nothing left to do', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    customers.details[_id] = sampleCustomerDetails(
      _id,
      standing: CustomerStanding.deleted,
    );
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    expect(find.textContaining('They deleted their account'), findsOneWidget);
    expect(find.text('Actions'), findsNothing);
  });

  testWidgets('lists their bookings, filtered by status', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bookings').first);
    await tester.pumpAndSettle();

    expect(find.text('Offer b1'), findsOneWidget);
    // A cancelled booking says who cancelled it.
    expect(find.text('The store closed'), findsOneWidget);
    expect(find.text('3 bookings'), findsOneWidget);

    await tester.tap(
      find
          .descendant(
            of: find.byType(CustomerBookingsTab),
            matching: find.text('Missed'),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(customers.bookingQueries.last, (
      _id,
      const CustomerBookingQuery(filter: BookingStatus.missed),
    ));
    expect(find.text('Offer b1'), findsNothing);
    expect(find.text('Offer b2'), findsOneWidget);
  });
}
