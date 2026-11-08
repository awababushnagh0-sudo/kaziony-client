import 'package:customer/features/location/domain/saved_place.dart';
import 'package:customer/features/location/presentation/place_details_sheet.dart';
import 'package:customer/features/location/presentation/saved_places_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  const home = SavedPlace(
    id: '1',
    name: 'Home',
    point: GeoPoint(32.89, 13.18),
    note: 'Second floor',
  );

  late FakePlacesRepository places;
  bool? saved;

  setUp(() {
    places = FakePlacesRepository([home]);
    saved = null;
  });

  /// The sheet over a page that keeps the places, as the places page does.
  Future<void> open(
    WidgetTester tester,
    Future<void> Function(BuildContext context) show,
  ) async {
    await pumpCustomerPages(
      tester,
      initial: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => AppConsumer(
            builder: (context, ref) {
              ref.watch(savedPlacesViewModel);
              return SScaffold(
                body: SButton(label: 'open', onPressed: () => show(context)),
              );
            },
          ),
        ),
      ],
      overrides: [
        placesRepositoryProvider.overrideWithValue(places),
        sessionProvider.overrideWith(() => SignedInSession(customer())),
      ],
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> add(WidgetTester tester) => open(
    tester,
    (context) async => saved = await PlaceDetailsSheet.add(context, souqAlJuma),
  );

  /// The name's field, then the description's.
  Finder field(int index) =>
      find.byWidgetPredicate((w) => w is STextInput).at(index);

  testWidgets('asks for a name, then saves the new place', (tester) async {
    await add(tester);

    expect(find.text('Name this place'), findsOneWidget);
    expect(find.text('Spot on the map'), findsNothing);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Name this place'), findsOneWidget);

    await tester.enterText(field(0), 'Work');
    await tester.enterText(field(1), 'Third floor');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Name this place'), findsNothing);
    expect(find.text('Place saved'), findsOneWidget);
    expect(saved, isTrue);
    expect(
      (places.places.last.name, places.places.last.note),
      ('Work', 'Third floor'),
    );
  });

  testWidgets('stays open and says why when it could not be saved', (
    tester,
  ) async {
    places.failure = const NoConnectionFailure();
    await add(tester);

    await tester.enterText(field(0), 'Work');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Name this place'), findsOneWidget);
    expect(find.text('No internet connection'), findsOneWidget);
    expect(places.places, [home]);
  });

  testWidgets('saves a new name on a saved place', (tester) async {
    await open(tester, (context) => PlaceDetailsSheet.edit(context, home));

    expect(find.text('Edit place'), findsOneWidget);
    expect(find.text('Spot on the map'), findsOneWidget);
    await tester.enterText(field(0), 'Our house');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Edit place'), findsNothing);
    expect(find.text('Place updated'), findsOneWidget);
    final kept = places.places.single;
    expect((kept.name, kept.note), ('Our house', 'Second floor'));
  });
}
