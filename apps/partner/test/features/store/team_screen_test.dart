import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:partner/features/store/presentation/team_screen.dart';

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

  Future<FakeLinkOpener> open(WidgetTester tester, {bool opens = true}) async {
    final links = FakeLinkOpener(opens: opens);
    await pumpPartnerPages(
      tester,
      initial: Routes.team,
      overrides: [
        storeRepositoryProvider.overrideWithValue(FakeStoreRepository()),
        currentStoreProvider.overrideWithValue(store('a')),
        supportContactProvider.overrideWith((ref) async => support),
        linkOpenerProvider.overrideWithValue(links),
      ],
      routes: [
        GoRoute(path: Routes.team, builder: (_, _) => const TeamScreen()),
      ],
    );
    return links;
  }

  testWidgets('shows each member with their role', (tester) async {
    await open(tester);

    expect(find.text('Owner One'), findsOneWidget);
    expect(find.text('Owner · 0910000001'), findsOneWidget);
    expect(find.text('Staff · 0920000002'), findsOneWidget);
  });

  testWidgets('asks our team on WhatsApp to add or remove someone', (
    tester,
  ) async {
    final links = await open(tester);

    await tester.tap(find.text('Request a change'));
    await tester.pumpAndSettle();

    final link = links.opened.single;
    expect('${link.origin}${link.path}', 'https://wa.me/218920000000');
    // Which store, by its name and area: a brand's places share the name.
    expect(
      link.queryParameters['text'],
      "Hello, I'd like to add or remove staff at the store: "
      'Store a · Hay Al Andalus',
    );
  });

  testWidgets("says when the phone can't open WhatsApp", (tester) async {
    await open(tester, opens: false);

    await tester.tap(find.text('Request a change'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open it on this phone."), findsOneWidget);
  });
}
