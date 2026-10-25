import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/products/presentation/products_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeProductRepository products;

  Future<void> open(WidgetTester tester, [List<Product>? items]) async {
    products = FakeProductRepository(items);
    await pumpPartnerPages(
      tester,
      initial: Routes.products,
      overrides: [
        productRepositoryProvider.overrideWithValue(products),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        GoRoute(
          path: Routes.products,
          builder: (_, _) => const ProductsScreen(),
        ),
        stubPage(Routes.newProduct, 'new product page'),
        stubPage(Routes.product(':id'), 'product page'),
      ],
    );
  }

  testWidgets('lists the products with their prices', (tester) async {
    await open(tester, [product('1', price: '4.500'), product('2')]);

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('4.5 LD'), findsOneWidget);
    expect(find.text('8 LD'), findsOneWidget);
  });

  testWidgets('opens a product', (tester) async {
    await open(tester);

    await tester.tap(find.text('Product 2'));
    await tester.pumpAndSettle();
    expect(find.text('product page'), findsOneWidget);
  });

  testWidgets('searches after a pause in typing', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(SSearchField), ' 2 ');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(products.listCalls.last.search, '2');
    expect(find.text('Product 1'), findsNothing);
    expect(find.text('Product 2'), findsOneWidget);
  });

  testWidgets('shows the archived products', (tester) async {
    await open(tester, [product('1'), product('2', isArchived: true)]);

    await tester.tap(find.text('Archived'));
    await tester.pumpAndSettle();

    expect(products.listCalls.last.archived, isTrue);
    expect(find.text('Product 1'), findsNothing);
    expect(find.text('Product 2'), findsOneWidget);
  });

  testWidgets('invites to add the first product', (tester) async {
    await open(tester, []);

    expect(find.text('No products yet'), findsOneWidget);
    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();
    expect(find.text('new product page'), findsOneWidget);
  });

  testWidgets('loads more products as the list scrolls', (tester) async {
    await open(tester, [for (var i = 0; i < 30; i++) product('$i')]);
    expect(products.listCalls.map((call) => call.page), [1]);

    await tester.drag(find.byType(SPagedList), const Offset(0, -3000));
    await tester.pumpAndSettle();

    expect(products.listCalls.map((call) => call.page), [1, 2]);
    await tester.dragUntilVisible(
      find.text('Product 29'),
      find.byType(SPagedList),
      const Offset(0, -500),
    );
    expect(find.text('Product 29'), findsOneWidget);
  });
}
