import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  const support = SupportContact(
    phone: '+218910000000',
    whatsapp: '218910000000',
    email: 'support@kaziony.ly',
    hoursAr: 'السبت إلى الخميس',
    hoursEn: 'Saturday to Thursday',
  );

  test('links open a call, a WhatsApp chat and an email', () {
    expect(support.callLink.toString(), 'tel:+218910000000');
    expect(support.whatsappLink.toString(), 'https://wa.me/218910000000');
    expect(support.emailLink.toString(), 'mailto:support@kaziony.ly');
  });

  test('hours in the app language', () {
    expect(support.hoursIn(const Locale('ar')), 'السبت إلى الخميس');
    expect(support.hoursIn(const Locale('en')), 'Saturday to Thursday');
  });
}
