import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/products/domain/product.dart';
import 'package:partner/features/products/presentation/product_form_screen.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeProductRepository products;
  late FakePhotoPicker photos;

  Future<void> open(WidgetTester tester, String location) async {
    photos = FakePhotoPicker();
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
        photoPickerProvider.overrideWithValue(photos),
      ],
      routes: [
        stubPage(Routes.products, 'products page'),
        GoRoute(
          path: Routes.newProduct,
          builder: (_, _) => const ProductFormScreen(),
        ),
        stubPage(Routes.product(':id'), 'product page'),
        GoRoute(
          path: Routes.editProduct(':id'),
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
    // Without a photo, nothing to upload: on to its page.
    expect(products.photos, isEmpty);
    expect(find.text('product page'), findsOneWidget);
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
    await open(tester, Routes.editProduct('1'));

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('4.500'), findsOneWidget);
    await tester.enterText(field('Regular price'), '5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, draft) = products.updated.single;
    expect(id, '1');
    expect(draft.regularPrice, '5.000');
  });

  group('photo', () {
    // A real 1×1 picture, so the preview can be drawn.
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwAD'
      'hgGAWjR9awAAAABJRU5ErkJggg==',
    );
    final ready = PhotoReady(
      PreparedPhoto(fullPath: 'full.jpg', thumbPath: 'thumb.jpg', preview: png),
    );

    Future<void> pickFromGallery(WidgetTester tester) async {
      await tester.tap(find.text('Add a photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
    }

    Future<void> fillNewProduct(WidgetTester tester) async {
      await open(tester, Routes.newProduct);
      await tester.enterText(field('Name'), 'Caramel cake');
      await tester.enterText(field('Regular price'), '4.5');
    }

    testWidgets('a new product sends its photo once saved', (tester) async {
      await fillNewProduct(tester);
      photos.next = ready;

      await pickFromGallery(tester);
      // Nowhere to send it yet.
      expect(products.photos, isEmpty);
      expect(find.text('Change the photo'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(products.created, hasLength(1));
      final (id, photo) = products.photos.single;
      expect(id, 'created');
      expect(photo.fullPath, 'full.jpg');
      expect(find.text('product page'), findsOneWidget);
    });

    testWidgets('a new product stays saved when its photo fails', (
      tester,
    ) async {
      await fillNewProduct(tester);
      photos.next = ready;
      products.failNextPhoto = const NoConnectionFailure();

      await pickFromGallery(tester);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(products.created, hasLength(1));
      expect(find.text('product page'), findsNothing);
      expect(
        find.text("Saved. The photo didn't upload: tap it to try again."),
        findsOneWidget,
      );

      await tester.tap(find.text("The photo didn't upload. Tap to try again."));
      await tester.pumpAndSettle();

      // Saved again as the same product, not a second one.
      expect(products.created, hasLength(1));
      expect(products.updated.single.$1, 'created');
      expect(products.photos, hasLength(2));
      expect(find.text('product page'), findsOneWidget);
    });

    testWidgets('uploads the picked photo', (tester) async {
      await open(tester, Routes.editProduct('1'));
      photos.next = ready;

      await pickFromGallery(tester);

      expect(photos.picks, [PhotoSource.gallery]);
      final (id, photo) = products.photos.single;
      expect(id, '1');
      expect(photo.fullPath, 'full.jpg');
      expect(find.text('Change the photo'), findsOneWidget);
    });

    testWidgets('offers to try again when the upload fails', (tester) async {
      await open(tester, Routes.editProduct('1'));
      photos.next = ready;
      products.failNextPhoto = const NoConnectionFailure();

      await pickFromGallery(tester);
      expect(
        find.text("The photo didn't upload. Tap to try again."),
        findsOneWidget,
      );

      await tester.tap(find.text("The photo didn't upload. Tap to try again."));
      await tester.pumpAndSettle();
      expect(products.photos, hasLength(2));
      // The same photo, without picking it again.
      expect(photos.picks, hasLength(1));
      expect(find.text('Change the photo'), findsOneWidget);
    });

    testWidgets('offers the settings when the camera is off', (tester) async {
      await open(tester, Routes.editProduct('1'));
      photos.next = const PhotoAccessDenied();

      await tester.tap(find.text('Add a photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take a photo'));
      await tester.pumpAndSettle();

      expect(find.text('The camera is off'), findsOneWidget);
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(photos.settingsOpened, 1);
      expect(products.photos, isEmpty);
    });

    testWidgets('says when a photo can\'t be used', (tester) async {
      await open(tester, Routes.editProduct('1'));
      photos.next = const PhotoFailed('unreadable');

      await pickFromGallery(tester);

      expect(
        find.text("Couldn't use this photo. Try another one."),
        findsOneWidget,
      );
      expect(products.photos, isEmpty);
    });
  });
}
