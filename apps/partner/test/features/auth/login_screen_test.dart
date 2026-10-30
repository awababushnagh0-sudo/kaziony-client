import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/l10n/generated/partner_localizations.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/auth/presentation/login/login_screen.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeAuthRepository auth, {Locale locale = const Locale('ar')}) =>
    AppScope(
      overrides: [
        ...testOverrides(),
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: SApp(
        routerConfig: GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => const LoginScreen())],
        ),
        locale: locale,
        onGenerateTitle: (_) => 'test',
        localizationsDelegates: const [PartnerLocalizations.delegate],
      ),
    );

void main() {
  testWidgets('is in Arabic, right to left, by default', (tester) async {
    await tester.pumpWidget(harness(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('أهلًا بك في متجرك'), findsOneWidget);
    expect(find.text('رقم الهاتف'), findsOneWidget);
    final direction = Directionality.of(
      tester.element(find.text('أهلًا بك في متجرك')),
    );
    expect(direction, TextDirection.rtl);
  });

  testWidgets('shows validation errors instead of sending an empty form', (
    tester,
  ) async {
    final auth = FakeAuthRepository();
    await tester.pumpWidget(harness(auth));
    await tester.pumpAndSettle();

    // The form is under the brand's picture, below the test window's fold.
    await tester.ensureVisible(find.text('دخول').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('دخول').last);
    await tester.pumpAndSettle();

    expect(find.text('مطلوب'), findsNWidgets(2));
    expect(auth.logins, isEmpty);
  });

  testWidgets('shows a translated message for wrong details', (tester) async {
    final auth = FakeAuthRepository()
      ..loginResult = const Err(UnauthorizedFailure());
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).first, '0910000001');
    await tester.enterText(find.byType(EditableText).last, 'wrong');
    await tester.ensureVisible(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Wrong phone number or password.'), findsOneWidget);
  });
}
