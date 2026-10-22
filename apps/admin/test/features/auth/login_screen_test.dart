import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:admin/features/auth/presentation/login/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeAuthRepository auth, {Locale locale = const Locale('ar')}) =>
    AppScope(
      overrides: [
        ...testOverrides(kind: AppKind.admin),
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: SApp(
        routerConfig: GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => const LoginScreen())],
        ),
        locale: locale,
        density: StellarDensity.compact,
        onGenerateTitle: (_) => 'test',
        localizationsDelegates: const [AdminLocalizations.delegate],
      ),
    );

Future<void> fillIn(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byType(EditableText).first, email);
  await tester.enterText(find.byType(EditableText).last, password);
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('is in Arabic, right to left, by default', (tester) async {
    await tester.pumpWidget(harness(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    final direction = Directionality.of(
      tester.element(find.text('تسجيل الدخول')),
    );
    expect(direction, TextDirection.rtl);
  });

  testWidgets('checks the form before sending it', (tester) async {
    final auth = FakeAuthRepository();
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsNWidgets(2));

    await fillIn(tester, 'not-an-email', 'x');
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(auth.logins, isEmpty);
  });

  testWidgets('sends the email trimmed and in lower case', (tester) async {
    final auth = FakeAuthRepository();
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await fillIn(tester, ' Admin@Offers.Local ', 'Admin12345!');
    expect(auth.logins, [('admin@offers.local', 'Admin12345!')]);
  });

  testWidgets('shows a message for wrong details', (tester) async {
    final auth = FakeAuthRepository()
      ..loginResult = const Err(UnauthorizedFailure());
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await fillIn(tester, 'admin@offers.local', 'wrong');
    expect(find.text('Wrong email or password.'), findsOneWidget);
  });

  testWidgets('keeps the password ready to fix after wrong details', (
    tester,
  ) async {
    final auth = FakeAuthRepository()
      ..loginResult = const Err(UnauthorizedFailure());
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();
    bool passwordFocused() => tester
        .widget<EditableText>(find.byType(EditableText).last)
        .focusNode
        .hasFocus;

    // Pressing Enter in the password field.
    await tester.enterText(find.byType(EditableText).first, 'a@offers.local');
    await tester.enterText(find.byType(EditableText).last, 'wrong');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(auth.logins, hasLength(1));
    expect(passwordFocused(), isTrue);

    // Pressing the button.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(auth.logins, hasLength(2));
    expect(passwordFocused(), isTrue);
  });

  testWidgets('email and password start on the right in Arabic', (
    tester,
  ) async {
    Future<List<(TextDirection?, TextAlign)>> fields(Locale locale) async {
      await tester.pumpWidget(harness(FakeAuthRepository(), locale: locale));
      await tester.pumpAndSettle();
      return [
        for (final field in tester.widgetList<EditableText>(
          find.byType(EditableText),
        ))
          (field.textDirection, field.textAlign),
      ];
    }

    // Typed left to right in both languages (so "Admin12345!" keeps its
    // "!" at the end), but lined up with the page's start edge.
    expect(await fields(const Locale('ar')), [
      (TextDirection.ltr, TextAlign.right),
      (TextDirection.ltr, TextAlign.right),
    ]);
    expect(await fields(const Locale('en')), [
      (TextDirection.ltr, TextAlign.left),
      (TextDirection.ltr, TextAlign.left),
    ]);
  });

  testWidgets('turns away store accounts and signs them out', (tester) async {
    final auth = FakeAuthRepository()
      ..loginResult = Ok(user(role: AccountRole.merchant));
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await fillIn(tester, 'owner@example.com', 'Merchant123!');
    expect(
      find.text("This dashboard is for our team's accounts only."),
      findsOneWidget,
    );
    expect(auth.logouts, 1);
  });

  testWidgets('lets editors in', (tester) async {
    final auth = FakeAuthRepository()
      ..loginResult = Ok(user(role: AccountRole.editor));
    await tester.pumpWidget(harness(auth, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await fillIn(tester, 'editor@offers.local', 'Editor12345!');
    expect(auth.logins, [('editor@offers.local', 'Editor12345!')]);
    expect(auth.logouts, 0);
  });
}
