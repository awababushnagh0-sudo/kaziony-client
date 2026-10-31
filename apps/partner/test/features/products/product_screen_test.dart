import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/products/presentation/product_form_screen.dart';
import 'package:partner/features/products/presentation/product_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeProductRepository products;

  Future<void> open(WidgetTester tester, String id) async {
    products = FakeProductRepository([
      product('1', price: '4.500'),
      product('2', isArchived: true),
    ]);
    await pumpPartnerPages(
      tester,
      initial: Routes.product(id),
      overrides: [
        productRepositoryProvider.overrideWithValue(products),
        currentStoreProvider.overrideWithValue(store('a')),
        photoPickerProvider.overrideWithValue(FakePhotoPicker()),
      ],
      routes: [
        GoRoute(
          path: Routes.product(':id'),
          builder: (_, state) =>
              ProductScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: Routes.editProduct(':id'),
          builder: (_, state) =>
              ProductFormScreen(productId: state.pathParameters['id']),
        ),
        stubPage(Routes.newOffer(':productId'), 'new offer page'),
      ],
    );
  }

  testWidgets('shows the product and posts an offer from it', (tester) async {
    await open(tester, '1');

    expect(find.text('Product 1'), findsOneWidget);
    // Under the name and in the details.
    expect(find.text('4.5 LD'), findsNWidgets(2));
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(find.text('new offer page'), findsOneWidget);
  });

  testWidgets('shows the edit when back from editing', (tester) async {
    await open(tester, '1');

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(STextInput, 'Regular price'),
      '5',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(products.updated.single.$1, '1');
    expect(find.text('5 LD'), findsNWidgets(2));
  });

  testWidgets('archives a product', (tester) async {
    await open(tester, '1');

    await tester.ensureVisible(find.text('Archive'));
    await tester.tap(find.text('Archive'));
    await tester.pumpAndSettle();

    expect(products.archived.single, ('1', true));
    expect(find.text('Restore'), findsOneWidget);
    expect(find.text('Post an offer'), findsNothing);
  });

  testWidgets('restores an archived product', (tester) async {
    await open(tester, '2');
    expect(find.text('Archived'), findsOneWidget);

    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(products.archived.single, ('2', false));
    expect(find.text('Post an offer'), findsOneWidget);
  });
}
