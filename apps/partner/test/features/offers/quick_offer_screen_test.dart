import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/offers/domain/offer.dart';
import 'package:partner/features/offers/presentation/quick_offer_screen.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/store/domain/current_store.dart';

import '../../fakes.dart';
import '../../support/finders.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeOfferRepository offers;
  late FakeProductRepository products;
  late FakePhotoPicker photos;

  Future<void> open(WidgetTester tester) async {
    offers = FakeOfferRepository([]);
    products = FakeProductRepository([]);
    photos = FakePhotoPicker();
    // A tall phone, so the whole form is on screen.
    tester.view
      ..physicalSize = const Size(1200, 7000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpPartnerPages(
      tester,
      initial: Routes.quickOffer,
      overrides: [
        offerRepositoryProvider.overrideWithValue(offers),
        productRepositoryProvider.overrideWithValue(products),
        photoPickerProvider.overrideWithValue(photos),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        GoRoute(
          path: Routes.quickOffer,
          builder: (_, _) => const QuickOfferScreen(),
        ),
        stubPage(Routes.offer(':id'), 'offer page'),
      ],
    );
  }

  Finder field(String label) => textField(label);

  Future<void> fill(WidgetTester tester) async {
    await tester.enterText(field('Name'), 'Caramel cake');
    await tester.enterText(field('Regular price'), '8');
    await tester.enterText(field('Offer price'), '5');
    await tester.enterText(field('How many pieces'), '3');
    await tester.pump();
  }

  testWidgets('saves it as a product, then posts its offer', (tester) async {
    await open(tester);
    await fill(tester);
    expect(find.text('38% off the regular price'), findsOneWidget);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    final saved = products.created.single;
    expect(saved.title, 'Caramel cake');
    expect(saved.regularPrice, '8.000');
    final posted = offers.created.single;
    expect(posted.productId, 'created');
    expect(posted.offerPrice, '5.000');
    expect(posted.totalQuantity, 3);
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('checks the offer price against the typed regular one', (
    tester,
  ) async {
    await open(tester);
    await fill(tester);
    await tester.enterText(field('Offer price'), '9');
    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    expect(
      find.text('Must be lower than the regular price (8 LD)'),
      findsOneWidget,
    );
    expect(products.created, isEmpty);
    expect(offers.created, isEmpty);
  });

  testWidgets('trying again posts the offer without a second product', (
    tester,
  ) async {
    await open(tester);
    await fill(tester);
    offers.failNextCreate = const NoConnectionFailure();

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(products.created, hasLength(1));
    expect(offers.created, isEmpty);
    expect(find.text('offer page'), findsNothing);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();
    expect(products.created, hasLength(1));
    expect(offers.created.single.productId, 'created');
    expect(find.text('offer page'), findsOneWidget);
  });

  testWidgets('sends the photo to the new product before posting', (
    tester,
  ) async {
    await open(tester);
    photos.next = PhotoReady(
      PreparedPhoto(
        fullPath: 'full.jpg',
        thumbPath: 'thumb.jpg',
        // A real 1×1 picture, so the preview can be drawn.
        preview: base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwAD'
          'hgGAWjR9awAAAABJRU5ErkJggg==',
        ),
      ),
    );
    await tester.tap(find.text('Add a photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();
    await fill(tester);

    await tester.tap(find.text('Post an offer'));
    await tester.pumpAndSettle();

    expect(products.photos.single.$1, 'created');
    expect(offers.created.single.productId, 'created');
  });
}
