import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:partner/features/store/presentation/location_screen.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  const support = SupportContact(
    phone: '+218910000000',
    whatsapp: '218920000000',
    email: 'support@kaziony.ly',
    hoursAr: 'السبت إلى الخميس',
    hoursEn: 'Saturday to Thursday',
  );
  const nineToTen = OpeningShift(opens: 9 * 60, closes: 22 * 60);

  late FakeStoreRepository stores;
  late FakeLinkOpener links;

  Future<void> open(
    WidgetTester tester, {
    bool isOwner = true,
    OpeningHours hours = OpeningHours.none,
    List<SpecialHours> special = const [],
    bool linksOpen = true,
  }) async {
    stores = FakeStoreRepository()
      ..getResult = Ok(
        storeDetails(openingHours: hours, specialHours: special),
      );
    links = FakeLinkOpener(opens: linksOpen);
    // A tall phone, so the whole week is on screen.
    tester.view
      ..physicalSize = const Size(1200, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpPartnerPages(
      tester,
      initial: Routes.profile,
      overrides: [
        storeRepositoryProvider.overrideWithValue(stores),
        currentStoreProvider.overrideWithValue(store('a', isOwner: isOwner)),
        supportContactProvider.overrideWith((ref) async => support),
        linkOpenerProvider.overrideWithValue(links),
      ],
      routes: [
        stubPage(Routes.profile, 'profile page'),
        GoRoute(
          path: Routes.location,
          onExit: LeaveGuard.onExit,
          builder: (_, _) => const LocationScreen(),
        ),
      ],
    );
    // Opened over the profile, so there's a page to go back to.
    unawaited(
      GoRouter.of(tester.element(find.text('profile page')))
          .push(Routes.location),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// [hour]:[minute] as the page writes it in English.
  String time(int hour, [int minute = 0]) =>
      formatTime(libyaTime(2026, 1, 1, hour, minute), languageCode: 'en');

  String hours(int opens, int closes) => '${time(opens)} – ${time(closes)}';

  testWidgets('shows staff where the store is and when it opens, to read', (
    tester,
  ) async {
    await open(
      tester,
      isOwner: false,
      hours: const OpeningHours({
        Weekday.sat: [nineToTen],
        Weekday.fri: [],
      }),
    );

    expect(find.text('Tripoli'), findsOneWidget);
    expect(find.text('Hay Al Andalus'), findsOneWidget);
    expect(find.text('Jaraba Street'), findsOneWidget);
    expect(find.text('Saturday'), findsOneWidget);
    expect(find.text(hours(9, 22)), findsOneWidget);
    expect(find.text('Friday'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    // Sunday to Thursday.
    expect(find.text('Not set'), findsNWidgets(5));

    await tester.tap(find.text('Saturday'));
    await tester.pumpAndSettle();
    expect(find.text('Opens'), findsNothing);
    expect(find.text('Request a change'), findsNothing);
  });

  testWidgets('opens the way there in the maps', (tester) async {
    await open(tester);

    await tap(tester, find.text('Open in Maps'));

    expect(links.opened, [directionsLink(const GeoPoint(32.871, 13.115))]);
  });

  testWidgets('the owner changes a day and saves the week', (tester) async {
    await open(tester, hours: const OpeningHours({Weekday.fri: []}));

    await tap(tester, find.text('Saturday'));
    // A day not set yet starts open from 9 in the morning to 10 at night.
    expect(find.text(time(9)), findsOneWidget);
    expect(find.text(time(22)), findsOneWidget);
    await tap(tester, find.text('Opens'));
    await tap(tester, find.text(time(8, 30)));
    await tap(tester, find.text('Closes'));
    await tap(tester, find.text(time(23)));
    await tap(tester, find.text('Done'));

    expect(find.text('${time(8, 30)} – ${time(23)}'), findsOneWidget);
    await tap(tester, find.text('Save changes'));

    expect(
      stores.hours.single,
      const OpeningHours({
        Weekday.sat: [OpeningShift(opens: 8 * 60 + 30, closes: 23 * 60)],
        Weekday.fri: [],
      }),
    );
    expect(find.text('Saved.'), findsOneWidget);
    expect(find.text('Save changes'), findsNothing);
  });

  testWidgets('the same hours every day, with a break, then Friday closed', (
    tester,
  ) async {
    await open(tester);

    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Add hours after a break'));
    // An hour after the first closes, for four hours.
    expect(find.text('After a break'), findsOneWidget);
    expect(find.text(time(23)), findsOneWidget);
    expect(find.text(time(3)), findsOneWidget);
    await tap(tester, find.text('Same hours every day'));
    await tap(tester, find.text('Done'));
    final twice = '${hours(9, 22)}, ${hours(23, 3)}';
    expect(find.text(twice), findsNWidgets(7));

    await tap(tester, find.text('Friday'));
    await tap(tester, find.text('Closed'));
    await tap(tester, find.text('Done'));
    expect(find.text(twice), findsNWidgets(6));
    expect(find.text('Closed'), findsOneWidget);
    await tap(tester, find.text('Save changes'));

    final saved = stores.hours.single;
    expect(saved.days[Weekday.fri], isEmpty);
    expect(saved.days[Weekday.thu], const [
      nineToTen,
      OpeningShift(opens: 23 * 60, closes: 3 * 60),
    ]);
  });

  testWidgets('closing the sheet without "Done" changes nothing', (
    tester,
  ) async {
    await open(tester);

    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Closed'));
    await tap(tester, find.byTooltip('Close'));

    expect(find.text('Closed'), findsNothing);
    expect(find.text('Save changes'), findsNothing);
  });

  testWidgets('asks before leaving with hours not saved', (tester) async {
    await open(tester);
    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Done'));

    await tap(tester, find.byTooltip('Back'));
    expect(find.text('Discard your changes?'), findsOneWidget);
    await tap(tester, find.text('Discard'));
    expect(find.text('profile page'), findsOneWidget);
    expect(stores.hours, isEmpty);
  });

  testWidgets("keeps the hours when they weren't saved, and says why", (
    tester,
  ) async {
    await open(tester);
    stores.failNextHours = const NoConnectionFailure();
    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Done'));

    await tap(tester, find.text('Save changes'));
    expect(find.text('No internet connection'), findsOneWidget);
    expect(find.text(hours(9, 22)), findsOneWidget);

    await tap(tester, find.text('Save changes'));
    expect(stores.hours.single.days[Weekday.sat], const [nineToTen]);
  });

  testWidgets('says why a live store keeps a day with hours', (tester) async {
    await open(
      tester,
      hours: const OpeningHours({
        Weekday.sat: [nineToTen],
      }),
    );
    stores.failNextHours = const ConflictFailure(
      'A live store needs opening hours',
      'StoreNotReady',
    );
    // Its only day with hours, closed.
    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Closed'));
    await tap(tester, find.text('Done'));

    await tap(tester, find.text('Save changes'));

    expect(
      find.text(
        'Customers see your store, so every day needs its hours, with one '
        'day open at least.',
      ),
      findsOneWidget,
    );
    expect(find.text('A live store needs opening hours'), findsNothing);
  });

  testWidgets('asks before hours that would cancel bookings', (tester) async {
    await open(tester);
    stores.hoursCutBookings = true;
    await tap(tester, find.text('Saturday'));
    await tap(tester, find.text('Done'));

    await tap(tester, find.text('Save changes'));
    expect(find.text('Cancel the bookings these hours miss?'), findsOneWidget);
    await tap(tester, find.text('Cancel'));
    expect(stores.hours, isEmpty);
    // Said under the hours too, in the app's words.
    expect(
      find.text(
        'Some bookings are due after your new closing time. Saving cancels '
        "them, and their customers are told. It doesn't count against them.",
      ),
      findsOneWidget,
    );

    await tap(tester, find.text('Save changes'));
    await tap(tester, find.text('Save and cancel them'));
    expect(stores.hours, hasLength(1));
    expect(find.text('Saved.'), findsOneWidget);
  });

  testWidgets('the owner asks our team on WhatsApp for a change or a new '
      'place', (tester) async {
    await open(tester);

    expect(
      find.text(
        "Our team changes the store's name and location, and adds new "
        'branches.',
      ),
      findsOneWidget,
    );
    await tap(tester, find.text('Request a change'));

    final link = links.opened.single;
    expect('${link.origin}${link.path}', 'https://wa.me/218920000000');
    // Which store, by its name and area: a brand's places share the name.
    expect(
      link.queryParameters['text'],
      "Hello, I'd like to add a new branch or change the details of the "
      'store: Store a · Hay Al Andalus',
    );
  });

  testWidgets("says when the phone can't open WhatsApp", (tester) async {
    await open(tester, linksOpen: false);

    await tap(tester, find.text('Request a change'));

    expect(find.text("Couldn't open it on this phone."), findsOneWidget);
  });

  group('special days', () {
    final ramadan = SpecialHours(
      from: libyaTime(2027, 2, 8),
      to: libyaTime(2027, 3, 9),
      shifts: const [OpeningShift(opens: 20 * 60, closes: 2 * 60)],
    );
    final eid = SpecialHours(
      from: libyaTime(2027, 3, 10),
      to: libyaTime(2027, 3, 10),
      shifts: const [],
    );

    testWidgets('staff read them under the week', (tester) async {
      await open(tester, isOwner: false, special: [ramadan, eid]);

      expect(find.text('Special days'), findsOneWidget);
      expect(find.text('Feb 8 – Mar 9'), findsOneWidget);
      expect(find.text(hours(20, 2)), findsOneWidget);
      expect(find.text('Mar 10'), findsOneWidget);
      expect(find.text('Add special days'), findsNothing);
    });

    testWidgets('the owner closes them all day and saves', (tester) async {
      const week = OpeningHours({Weekday.fri: []});
      await open(tester, hours: week, special: [ramadan]);

      await tap(tester, find.text('Feb 8 – Mar 9'));
      expect(find.text('Days'), findsOneWidget);
      await tap(tester, find.text('Closed').last);
      await tap(tester, find.text('Done'));
      await tap(tester, find.text('Save changes'));

      expect(stores.special.single, [
        SpecialHours(from: ramadan.from, to: ramadan.to, shifts: const []),
      ]);
      // The week as it was.
      expect(stores.hours.single, week);
      expect(find.text('Saved.'), findsOneWidget);
    });

    testWidgets('the owner takes them away', (tester) async {
      await open(tester, special: [ramadan, eid]);

      await tap(tester, find.text('Mar 10'));
      await tap(tester, find.text('Remove these days'));
      expect(find.text('Mar 10'), findsNothing);
      await tap(tester, find.text('Save changes'));

      expect(stores.special.single, [ramadan]);
    });

    testWidgets('new ones start in the calendar', (tester) async {
      await open(tester);
      // Wide enough for the calendar's heading in the tests' square font.
      tester.view.physicalSize = const Size(1500, 4000);
      await tester.pumpAndSettle();

      await tap(tester, find.text('Add special days'));

      expect(find.text('Which days?'), findsOneWidget);
    });
  });
}
