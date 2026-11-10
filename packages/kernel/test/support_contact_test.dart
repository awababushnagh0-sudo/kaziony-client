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

  test('a WhatsApp chat can open with a message typed in', () {
    final link = support.whatsappMessage('أريد إضافة فرع: حلويات · حي الأندلس');
    expect(link.host, 'wa.me');
    expect(link.path, '/218910000000');
    expect(link.queryParameters['text'], 'أريد إضافة فرع: حلويات · حي الأندلس');
  });

  test('hours in the app language', () {
    expect(support.hoursIn(const Locale('ar')), 'السبت إلى الخميس');
    expect(support.hoursIn(const Locale('en')), 'Saturday to Thursday');
  });
}
