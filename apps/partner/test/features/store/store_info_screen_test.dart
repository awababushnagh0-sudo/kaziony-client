import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:partner/features/store/presentation/edit_store_info_screen.dart';
import 'package:partner/features/store/presentation/store_info_screen.dart';

import '../../fakes.dart';
import '../../support/finders.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeStoreRepository stores;
  late FakePhotoPicker photos;

  Future<void> open(
    WidgetTester tester, {
    bool isOwner = true,
    Result<Store>? loaded,
  }) async {
    stores = FakeStoreRepository();
    photos = FakePhotoPicker();
    if (loaded != null) stores.getResult = loaded;
    await pumpPartnerPages(
      tester,
      initial: Routes.storeInfo,
      overrides: [
        storeRepositoryProvider.overrideWithValue(stores),
        photoPickerProvider.overrideWithValue(photos),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
      ],
      routes: [
        GoRoute(
          path: Routes.storeInfo,
          builder: (_, _) => const StoreInfoScreen(),
        ),
        GoRoute(
          path: Routes.editStoreInfo,
          builder: (_, _) => const EditStoreInfoScreen(),
        ),
      ],
    );
  }

  testWidgets('shows what customers see', (tester) async {
    await open(tester);

    expect(find.text('Store a'), findsOneWidget);
    expect(find.text('Sweets'), findsOneWidget);
    expect(find.text('Fresh every morning'), findsOneWidget);
    expect(find.text('0910000001'), findsOneWidget);
    expect(find.text('Not set'), findsNWidgets(3));
  });

  testWidgets('staff can see it but not edit it', (tester) async {
    await open(tester, isOwner: false);

    expect(find.text('Fresh every morning'), findsOneWidget);
    expect(find.byTooltip('Edit'), findsNothing);
    expect(find.text('Add your logo'), findsNothing);
  });

  testWidgets('the owner adds the logo, cropped round, and the cover, wide', (
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

    await tester.tap(find.text('Add your logo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add a cover photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();

    expect(photos.shapes, [PhotoShape.round, PhotoShape.wide]);
    expect(stores.images, [StoreImage.logo, StoreImage.cover]);
    // The logo the server returned is shown: nothing left to add.
    expect(find.text('Add your logo'), findsNothing);
  });

  testWidgets('the owner edits it and sees the saved info', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(textField('Email'), 'hello@store.ly');
    await tester.enterText(textField('Phone number'), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = stores.updates.single;
    expect(saved.email, 'hello@store.ly');
    expect(saved.phone, isNull);
    expect(saved.description, 'Fresh every morning');
    // Back on the info page, with the saved values.
    expect(find.text('hello@store.ly'), findsOneWidget);
  });

  testWidgets("doesn't save a wrong email", (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(textField('Email'), 'nope');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(stores.updates, isEmpty);
    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('offers to try again when loading fails', (tester) async {
    await open(tester, loaded: const Err(NoConnectionFailure()));
    expect(find.byTooltip('Edit'), findsNothing);

    stores.getResult = Ok(storeDetails());
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Fresh every morning'), findsOneWidget);
  });
}
