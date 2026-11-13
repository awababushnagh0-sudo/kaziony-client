import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/routes/routes.dart';
import 'package:admin/features/customers/domain/customer.dart';
import 'package:admin/features/customers/presentation/customer_details_screen.dart';
import 'package:admin/features/customers/presentation/customers_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeCustomerRepository customers) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    customerRepositoryProvider.overrideWithValue(customers),
    sessionProvider.overrideWith(() => FakeSession(user())),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      initialLocation: Routes.customers,
      routes: [
        GoRoute(
          path: Routes.customers,
          builder: (_, _) => const CustomersScreen(),
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

void main() {
  testWidgets('lists customers with how to reach them and where they stand', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeCustomerRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Customer 1'), findsOneWidget);
    expect(find.text('customer1@example.com'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Booking paused'), findsWidgets);
    // Someone who deleted their account has no name or email left.
    expect(find.text('Deleted account'), findsOneWidget);
    expect(find.text('3 customers'), findsOneWidget);
  });

  testWidgets('filters by where they stand', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    // The pill comes before the badge in the table.
    await tester.tap(find.text('Booking paused').first);
    await tester.pumpAndSettle();

    expect(customers.queries.last.filter, CustomerStanding.paused);
    expect(find.text('Customer 1'), findsNothing);
    expect(find.text('Customer 2'), findsOneWidget);
  });

  testWidgets('opens a customer from the list', (tester) async {
    setWindow(tester);
    final customers = FakeCustomerRepository();
    await tester.pumpWidget(harness(customers));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Customer 2'));
    await tester.pumpAndSettle();

    expect(customers.opened, ['customer-2']);
    expect(find.byType(CustomerDetailsScreen), findsOneWidget);
  });
}
