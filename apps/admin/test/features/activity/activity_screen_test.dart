import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/activity/domain/activity_entry.dart';
import 'package:admin/features/activity/presentation/activity_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeActivityRepository activity) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    activityRepositoryProvider.overrideWithValue(activity),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const ActivityScreen())],
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

void main() {
  testWidgets('lists who changed what, in words', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeActivityRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Edited a store'), findsOneWidget);
    expect(find.text('Sara'), findsOneWidget);
    expect(find.text('Pizza Corner'), findsOneWidget);
    expect(find.text('name, phone'), findsOneWidget);
    expect(find.text('Ran a job by hand'), findsOneWidget);
    expect(find.text('A removed account'), findsOneWidget);
    expect(find.text('2 changes'), findsOneWidget);
  });

  testWidgets('shows one area', (tester) async {
    setWindow(tester);
    final activity = FakeActivityRepository();
    await tester.pumpWidget(harness(activity));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jobs'));
    await tester.pumpAndSettle();

    expect(activity.queries.last.filter, ActivityArea.jobs);
    expect(find.text('Edited a store'), findsNothing);
    expect(find.text('Ran a job by hand'), findsOneWidget);
  });

  testWidgets('opens a change to everything that was sent', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeActivityRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edited a store'));
    await tester.pumpAndSettle();

    expect(find.text('What was sent'), findsOneWidget);
    expect(find.text('phone'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
    expect(find.text('req-42'), findsOneWidget);
  });

  testWidgets('says when nothing has changed yet', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeActivityRepository()..entries = []));
    await tester.pumpAndSettle();

    expect(find.text('No changes yet'), findsOneWidget);
  });
}
