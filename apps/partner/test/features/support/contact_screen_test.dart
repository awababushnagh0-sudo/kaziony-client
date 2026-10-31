import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/support/presentation/contact_screen.dart';

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
      initial: Routes.contact,
      overrides: [
        supportContactProvider.overrideWith((ref) async => support),
        linkOpenerProvider.overrideWithValue(links),
      ],
      routes: [
        GoRoute(path: Routes.contact, builder: (_, _) => const ContactScreen()),
      ],
    );
    return links;
  }

  testWidgets('calls, chats and emails our team', (tester) async {
    final links = await open(tester);

    expect(find.text('0910000000'), findsOneWidget);
    expect(find.text('0920000000'), findsOneWidget);
    expect(find.text('Saturday to Thursday'), findsOneWidget);

    await tester.tap(find.text('Call'));
    await tester.tap(find.text('WhatsApp'));
    await tester.tap(find.text('Email'));
    await tester.pump();

    expect(links.opened.map((link) => '$link'), [
      'tel:+218910000000',
      'https://wa.me/218920000000',
      'mailto:support@kaziony.ly',
    ]);
  });

  testWidgets("says when the phone can't open it", (tester) async {
    await open(tester, opens: false);

    await tester.tap(find.text('Call'));
    await tester.pump();

    expect(find.text("Couldn't open it on this phone."), findsOneWidget);
  });
}
