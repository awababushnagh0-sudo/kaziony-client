import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/users/domain/dashboard_user.dart';
import 'package:admin/features/users/presentation/user_details_screen.dart';
import 'package:admin/features/users/presentation/users_screen.dart';
import 'package:flutter/material.dart' show TextField;
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

/// The users list with a user's page on top of it, as in the app, signed
/// in as [signedInAs].
Widget harness(
  FakeDashboardUserRepository users, {
  String at = '/users/user-2',
  String signedInAs = 'u1',
}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    dashboardUserRepositoryProvider.overrideWithValue(users),
    sessionProvider.overrideWith(() => FakeSession(user(id: signedInAs))),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      initialLocation: at,
      routes: [
        GoRoute(
          path: '/users',
          builder: (_, _) => const UsersScreen(),
          routes: [
            GoRoute(
              path: ':id',
              onExit: LeaveGuard.onExit,
              builder: (_, state) =>
                  UserDetailsScreen(userId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1400, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Finder field(String label) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is STextInput && widget.label == label,
  ),
  matching: find.byType(EditableText),
);

Future<void> chooseAction(WidgetTester tester, String action) async {
  await tester.tap(find.text('Actions'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(action));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens a user from the list', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users, at: '/users'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('User 2'));
    await tester.pumpAndSettle();

    expect(users.opened, ['user-2']);
    expect(find.byType(UserDetailsScreen), findsOneWidget);
  });

  testWidgets('shows the user under "Users", with their status and role', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeDashboardUserRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('user2@offers.ly'), findsOneWidget);
    expect(find.text('Editor'), findsWidgets);
    expect(find.text('Never'), findsOneWidget);
  });

  testWidgets('resets the password and shows the new one once', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Reset password');
    expect(find.text("Reset User 2's password?"), findsOneWidget);
    await tester.tap(find.text('Reset password').last);
    await tester.pumpAndSettle();

    expect(users.resets, ['user-2']);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Tmp-5521-hw'), findsOneWidget);
  });

  testWidgets('enables and disables the user', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();

    await chooseAction(tester, 'Enable user');
    expect(users.activeChanges, [('user-2', true)]);
    expect(find.text('Active'), findsOneWidget);

    await chooseAction(tester, 'Disable user');
    expect(find.text('Disable User 2?'), findsOneWidget);
    await tester.tap(find.text('Disable user').last);
    await tester.pumpAndSettle();
    expect(users.activeChanges.last, ('user-2', false));
    expect(find.text('User disabled'), findsOneWidget);
  });

  testWidgets('renames the user and changes their role', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();

    await tester.enterText(field('Name'), 'Sara');
    await tester.tap(find.byType(SSelectInput<DashboardRole>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final (id, edited) = users.updates.single;
    expect(id, 'user-2');
    expect(edited.name, 'Sara');
    expect(edited.role, DashboardRole.admin);
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets(
    "on your own page you can't disable yourself or change your role",
    (tester) async {
      setWindow(tester);
      final users = FakeDashboardUserRepository();
      await tester.pumpWidget(
        harness(users, at: '/users/user-1', signedInAs: 'user-1'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      expect(find.text('Reset password'), findsOneWidget);
      expect(find.text('Disable user'), findsNothing);
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      final email = tester.widget<TextField>(
        find.ancestor(of: field('Email'), matching: find.byType(TextField)),
      );
      expect(email.enabled, isFalse);
      await tester.tap(find.byType(SSelectInput<DashboardRole>));
      await tester.pumpAndSettle();
      expect(find.text('Editor'), findsNothing, reason: 'no menu opened');
    },
  );
}
