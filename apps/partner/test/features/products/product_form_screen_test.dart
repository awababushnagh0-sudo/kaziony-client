import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/products/presentation/product_form_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeProductRepository products;

  Future<void> open(WidgetTester tester, String location) async {
    products = FakeProductRepository([
      product('1', price: '4.500'),
      product('2', isArchived: true),
    ]);
    await pumpPartnerPages(
      tester,
      initial: Routes.products,
      overrides: [
        productRepositoryProvider.overrideWithValue(products),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        stubPage(Routes.products, 'products page'),
        GoRoute(
          path: Routes.newProduct,
          builder: (_, _) => const ProductFormScreen(),
        ),
        GoRoute(
          path: Routes.product(':id'),
          builder: (_, state) =>
              ProductFormScreen(productId: state.pathParameters['id']),
        ),
      ],
    );
    // Opened over the list, as from the app. The push completes when the
    // page closes.
    unawaited(
      GoRouter.of(tester.element(find.text('products page'))).push(location),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(STextInput, label);

  testWidgets('adds a product, writing the price as the API wants', (
    tester,
  ) async {
    await open(tester, Routes.newProduct);

    await tester.enterText(field('Name'), '  Caramel cake ');
    await tester.enterText(field('Regular price'), '٤٫٥');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final draft = products.created.single;
    expect(draft.title, 'Caramel cake');
    expect(draft.regularPrice, '4.500');
    expect(draft.description, isNull);
    expect(find.text('products page'), findsOneWidget);
  });

  testWidgets("doesn't save without a name or with a zero price", (
    tester,
  ) async {
    await open(tester, Routes.newProduct);

    await tester.enterText(field('Regular price'), '0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(products.created, isEmpty);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Enter a price above 0, e.g. 4.500'), findsOneWidget);
  });

  testWidgets('edits a product', (tester) async {
    await open(tester, Routes.product('1'));

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('4.500'), findsOneWidget);
    await tester.enterText(field('Regular price'), '5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, draft) = products.updated.single;
    expect(id, '1');
    expect(draft.regularPrice, '5.000');
  });

  testWidgets('archives a product', (tester) async {
    await open(tester, Routes.product('1'));

    await tester.ensureVisible(find.text('Archive'));
    await tester.tap(find.text('Archive'));
    await tester.pumpAndSettle();

    expect(products.archived.single, ('1', true));
    expect(find.text('products page'), findsOneWidget);
  });

  testWidgets('restores an archived product', (tester) async {
    await open(tester, Routes.product('2'));

    await tester.ensureVisible(find.text('Restore'));
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(products.archived.single, ('2', false));
  });
}
