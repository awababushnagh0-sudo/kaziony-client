import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/users/domain/dashboard_user.dart';
import 'package:admin/features/users/presentation/users_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeDashboardUserRepository users) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    dashboardUserRepositoryProvider.overrideWithValue(users),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const UsersScreen())],
    ),
    locale: const Locale('en'),
    density: StellarDensity.compact,
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

/// A text field of the add-user dialog, by its label.
Finder field(String label) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is STextInput && widget.label == label,
  ),
  matching: find.byType(EditableText),
);

Future<void> openAddUser(WidgetTester tester) async {
  await tester.tap(find.text('Add user'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the team with roles, status and last login', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeDashboardUserRepository()));
    await tester.pumpAndSettle();

    expect(find.text('User 1'), findsOneWidget);
    expect(find.text('user2@offers.ly'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Editor'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('Oct 20, 2026'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
    expect(find.text('2 users'), findsOneWidget);
  });

  testWidgets('filters by role', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Editors'));
    await tester.pumpAndSettle();

    expect(users.queries.last.filter, DashboardRole.editor);
    expect(find.text('User 1'), findsNothing);
    expect(find.text('User 2'), findsOneWidget);
  });

  testWidgets('adds an editor and shows their login once', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();
    await openAddUser(tester);

    // Nothing is sent while required fields are empty.
    await tester.tap(find.text('Add user').last);
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets);
    expect(users.created, isEmpty);

    await tester.enterText(field('Name'), ' Sara ');
    await tester.enterText(field('Email'), ' Sara@Offers.LY ');
    await tester.tap(find.text('Add user').last);
    await tester.pumpAndSettle();

    final added = users.created.single;
    expect(added.name, 'Sara');
    expect(added.email, 'sara@offers.ly');
    expect(added.role, DashboardRole.editor);
    expect(find.text('User added'), findsOneWidget);
    expect(find.text('sara@offers.ly'), findsOneWidget);
    expect(find.text('Tmp-7310-qz'), findsOneWidget);
    expect(users.queries, hasLength(2), reason: 'the list reloads');
  });

  testWidgets('adds an admin when chosen', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository();
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();
    await openAddUser(tester);

    await tester.enterText(field('Name'), 'Omar');
    await tester.enterText(field('Email'), 'omar@offers.ly');
    await tester.tap(find.byType(SSelectInput<DashboardRole>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add user').last);
    await tester.pumpAndSettle();

    expect(users.created.single.role, DashboardRole.admin);
  });

  testWidgets('says when the email already has an account', (tester) async {
    setWindow(tester);
    final users = FakeDashboardUserRepository()
      ..createResult = const Err(ConflictFailure('taken'));
    await tester.pumpWidget(harness(users));
    await tester.pumpAndSettle();
    await openAddUser(tester);

    await tester.enterText(field('Name'), 'Sara');
    await tester.enterText(field('Email'), 'user1@offers.ly');
    await tester.tap(find.text('Add user').last);
    await tester.pumpAndSettle();

    expect(find.text('This email already has an account.'), findsOneWidget);
    expect(find.text('Add a user'), findsOneWidget);
  });
}
