import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:partner/features/store/presentation/store_info_screen.dart';
import 'package:stellar/stellar.dart';

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
      initial: Routes.profile,
      overrides: [
        storeRepositoryProvider.overrideWithValue(stores),
        photoPickerProvider.overrideWithValue(photos),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
      ],
      routes: [
        stubPage(Routes.profile, 'profile page'),
        GoRoute(
          path: Routes.storeInfo,
          onExit: LeaveGuard.onExit,
          builder: (_, _) => const StoreInfoScreen(),
        ),
      ],
    );
    // Opened over the profile, so there's a page to go back to.
    unawaited(
      GoRouter.of(tester.element(find.text('profile page')))
          .push(Routes.storeInfo),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets("shows what our team sets, and fills in the owner's fields", (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Store a'), findsOneWidget);
    expect(find.text('Sweets'), findsOneWidget);
    expect(find.text('★ 4.5 · 37 ratings'), findsOneWidget);
    expect(find.text('Show your code at the cashier'), findsOneWidget);
    expect(find.text('0910000001'), findsOneWidget);
    // Nothing changed yet: nothing to save.
    expect(find.text('Save changes'), findsNothing);
  });

  testWidgets('says so before the first rating', (tester) async {
    await open(
      tester,
      loaded: Ok(storeDetails(ratingAverage: null, ratingCount: 0)),
    );

    expect(find.text('No ratings yet'), findsOneWidget);
  });

  testWidgets('staff can read it but not change it', (tester) async {
    await open(tester, isOwner: false);

    expect(find.text('Show your code at the cashier'), findsOneWidget);
    expect(find.text('Not set'), findsNWidgets(3));
    expect(find.bySubtype<STextInput>(), findsNothing);
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

  testWidgets('the owner edits it in place and saves the changes', (
    tester,
  ) async {
    await open(tester);

    await tester.enterText(textField('Email'), 'hello@store.ly');
    await tester.enterText(textField('Phone number'), '');
    await tester.enterText(
      textField('Pickup instructions'),
      '  Ask at the counter; bring a bag ',
    );
    await tester.pump();
    await tap(tester, find.text('Save changes'));

    final saved = stores.updates.single;
    expect(saved.email, 'hello@store.ly');
    expect(saved.phone, isNull);
    expect(saved.pickupInstructions, 'Ask at the counter; bring a bag');
    expect(find.text('Saved.'), findsOneWidget);
    // Saved: the values stay, with nothing left to save.
    expect(find.text('hello@store.ly'), findsOneWidget);
    expect(find.text('Save changes'), findsNothing);
  });

  testWidgets('putting a field back leaves nothing to save', (tester) async {
    await open(tester);

    await tester.enterText(textField('Email'), 'hello@store.ly');
    await tester.pump();
    expect(find.text('Save changes'), findsOneWidget);

    // Spaces alone aren't a change either.
    await tester.enterText(textField('Email'), '  ');
    await tester.pump();
    expect(find.text('Save changes'), findsNothing);
  });

  testWidgets("doesn't save a wrong email", (tester) async {
    await open(tester);

    await tester.enterText(textField('Email'), 'nope');
    await tester.pump();
    await tap(tester, find.text('Save changes'));

    expect(stores.updates, isEmpty);
    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('asks before leaving with changes, and stays if told to', (
    tester,
  ) async {
    await open(tester);
    await tester.enterText(textField('Email'), 'hello@store.ly');
    await tester.pump();

    await tap(tester, find.byTooltip('Back'));
    expect(find.text('Discard your changes?'), findsOneWidget);
    await tap(tester, find.text('Cancel'));
    expect(find.text('hello@store.ly'), findsOneWidget);

    await tap(tester, find.byTooltip('Back'));
    await tap(tester, find.text('Discard'));
    expect(find.text('profile page'), findsOneWidget);
    expect(stores.updates, isEmpty);
  });

  testWidgets('leaves without asking when nothing changed', (tester) async {
    await open(tester);

    await tap(tester, find.byTooltip('Back'));
    expect(find.text('Discard your changes?'), findsNothing);
    expect(find.text('profile page'), findsOneWidget);
  });

  testWidgets('offers to try again when loading fails', (tester) async {
    await open(tester, loaded: const Err(NoConnectionFailure()));
    expect(find.text('Save changes'), findsNothing);

    stores.getResult = Ok(storeDetails());
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Show your code at the cashier'), findsOneWidget);
  });
}
