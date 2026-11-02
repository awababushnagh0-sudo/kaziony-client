import 'dart:async';

import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/auth/presentation/sign_in_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() => auth = FakeAuthRepository());

  /// The sign-in page at the end of the welcome pages, or opened over the
  /// account page.
  Future<void> open(WidgetTester tester, {required bool onboarding}) async {
    await pumpCustomerPages(
      tester,
      initial: onboarding ? Routes.welcomeSignIn : Routes.account,
      routes: [
        stubPage(Routes.home, 'home page'),
        GoRoute(
          path: Routes.welcomeSignIn,
          builder: (_, _) => const SignInScreen(onboarding: true),
        ),
        stubPage(Routes.account, 'account page'),
        GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
        stubPage(Routes.terms, 'terms page'),
      ],
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
    );
    if (!onboarding) {
      final context = tester.element(find.text('account page'));
      unawaited(GoRouter.of(context).push(Routes.signIn));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('after the welcome pages, signing in goes home', (tester) async {
    await open(tester, onboarding: true);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(auth.signIns, 1);
    expect(find.text('home page'), findsOneWidget);
  });

  testWidgets('after the welcome pages, a guest goes home', (tester) async {
    await open(tester, onboarding: true);

    expect(find.byTooltip('Back'), findsNothing);
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    expect(auth.signIns, 0);
    expect(find.text('home page'), findsOneWidget);
  });

  testWidgets('from elsewhere, signing in goes back there', (tester) async {
    await open(tester, onboarding: false);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('account page'), findsOneWidget);
  });

  testWidgets('from elsewhere, a guest goes back there', (tester) async {
    await open(tester, onboarding: false);

    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    expect(find.text('account page'), findsOneWidget);
    expect(auth.signIns, 0);
  });

  testWidgets('from elsewhere, back leaves without signing in', (tester) async {
    await open(tester, onboarding: false);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('account page'), findsOneWidget);
    expect(auth.signIns, 0);
  });

  testWidgets('closing Google\'s sheet stays on the page', (tester) async {
    auth.signInResult = const Ok(null);
    await open(tester, onboarding: true);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('home page'), findsNothing);
  });

  testWidgets('says why signing in failed', (tester) async {
    auth.signInResult = const Err(NoConnectionFailure());
    await open(tester, onboarding: true);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsOneWidget);
  });

  testWidgets('Apple says it is coming', (tester) async {
    await open(tester, onboarding: true);

    await tester.tap(find.text('Continue with Apple'));
    await tester.pump();

    expect(find.text('Sign in with Apple is coming soon.'), findsOneWidget);
    expect(auth.signIns, 0);
  });

  testWidgets('the terms open from under the buttons', (tester) async {
    // A phone's width, where the sentence wraps before the link.
    tester.view.physicalSize = const Size(390, 844) * 3;
    addTearDown(tester.view.resetPhysicalSize);
    await open(tester, onboarding: true);

    await tester.tapOnText(
      find.textRange.ofSubstring('Terms and Privacy Policy'),
    );
    await tester.pumpAndSettle();

    expect(find.text('terms page'), findsOneWidget);
  });
}
