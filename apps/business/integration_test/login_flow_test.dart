// Runs the real app against a real backend:
//   flutter test integration_test -d <device> \
//     --dart-define=API_BASE_URL=http://localhost:3000
// Needs the backend's seed data (demo owner 0910000001 / Merchant123!).
import 'package:business/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kernel/kernel.dart';

Future<void> pumpUntil(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('demo owner logs in and sees their store', (tester) async {
    app.main();
    await pumpUntil(tester, find.text('دخول المتجر'));

    await tester.enterText(find.byType(EditableText).first, '091 000 0001');
    await tester.enterText(find.byType(EditableText).last, 'Merchant123!');
    await tester.tap(find.text('دخول').last);

    await pumpUntil(tester, find.text('الفروع'));
    expect(find.text('حلويات تجريبية'), findsWidgets);
    expect(find.text('حي الأندلس'), findsOneWidget);
    expect(find.text('مالك'), findsOneWidget);

    // Gives the screenshot script time to capture the home screen.
    // ignore: avoid_print
    print('HOME_VISIBLE');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 8)),
    );

    // Log out again so the next run starts at the login screen.
    await tester.tap(find.text('تسجيل الخروج'));
    await pumpUntil(tester, find.text('دخول المتجر'));
  });
}
