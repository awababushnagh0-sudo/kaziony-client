import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/system/domain/system_job.dart';
import 'package:admin/features/system/domain/system_overview.dart';
import 'package:admin/features/system/domain/system_repository.dart';
import 'package:admin/features/system/presentation/system_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeSystemRepository system) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    systemRepositoryProvider.overrideWithValue(system),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const SystemScreen())],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

Future<void> open(WidgetTester tester, FakeSystemRepository system) async {
  tester.view
    ..physicalSize = const Size(1400, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(harness(system));
  await tester.pumpAndSettle();
}

Future<void> openTab(WidgetTester tester, String tab) async {
  // The tab comes before the sidebar fact of the same name.
  await tester.tap(find.text(tab).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the last 5 minutes, the services and the instances', (
    tester,
  ) async {
    await open(tester, FakeSystemRepository());

    expect(find.text('Requests a minute'), findsOneWidget);
    expect(find.text('85 ms'), findsOneWidget);
    expect(find.text('Everything is running'), findsOneWidget);
    expect(find.text('Up'), findsNWidgets(2));
    expect(find.text('api-1'), findsOneWidget);
    expect(find.text('Version 1.4.0 · up 2 d 3 h'), findsOneWidget);
    expect(find.text('Answered'), findsOneWidget);
  });

  testWidgets('says what needs a look', (tester) async {
    final system = FakeSystemRepository()
      ..overviewResult = Ok(
        sampleOverview(redis: ServiceHealth.down, failingJobs: 1),
      );
    await open(tester, system);

    expect(find.text('Something needs a look'), findsOneWidget);
    expect(find.text('Connection refused'), findsOneWidget);
    expect(find.text('Down'), findsOneWidget);
    expect(find.text('1 job failing'), findsOneWidget);
  });

  testWidgets('shows an error with a retry when the overview fails', (
    tester,
  ) async {
    final system = FakeSystemRepository()
      ..overviewResult = const Err(NoConnectionFailure());
    await open(tester, system);
    expect(find.text('api-1'), findsNothing);

    system.overviewResult = Ok(sampleOverview());
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('api-1'), findsOneWidget);
  });

  testWidgets('shows traffic by route, for the window picked', (tester) async {
    final system = FakeSystemRepository();
    await open(tester, system);
    await openTab(tester, 'Traffic');

    expect(system.trafficWindows, [60]);
    expect(find.text('GET /api/v1/offers'), findsOneWidget);
    expect(find.text('520'), findsOneWidget);

    await tester.tap(find.text('15 min'));
    await tester.pumpAndSettle();
    expect(system.trafficWindows, [60, 15]);
  });

  testWidgets('lists the server errors', (tester) async {
    await open(tester, FakeSystemRepository());
    await openTab(tester, 'Errors');

    expect(
      find.text('TypeError: Cannot read properties of undefined'),
      findsOneWidget,
    );
    expect(find.text('500'), findsOneWidget);
  });

  testWidgets('lists the jobs and runs one now', (tester) async {
    final system = FakeSystemRepository();
    await open(tester, system);
    await openTab(tester, 'Jobs');

    expect(find.text('expire-claims'), findsOneWidget);
    expect(find.textContaining('Expires missed pickups'), findsOneWidget);
    expect(find.text('Succeeded'), findsOneWidget);
    expect(find.text('Not run yet'), findsOneWidget);
    expect(find.text('12 (0 failed)'), findsOneWidget);

    await tester.tap(find.text('Run now').first);
    await tester.pumpAndSettle();

    expect(system.ran, ['expire-claims']);
    expect(find.text('Done in 35 ms'), findsOneWidget);
    expect(find.text('13 (0 failed)'), findsOneWidget);
  });

  testWidgets('says when the job is already running', (tester) async {
    final system = FakeSystemRepository()
      ..runResult = const Err(ConflictFailure('Job is running', 'JobRunning'));
    await open(tester, system);
    await openTab(tester, 'Jobs');

    await tester.tap(find.text('Run now').first);
    await tester.pumpAndSettle();

    expect(find.text('This job is running right now.'), findsOneWidget);
  });

  testWidgets('says when the job ran and failed', (tester) async {
    final system = FakeSystemRepository()
      ..runResult = Ok(sampleJob(outcome: JobOutcome.failed));
    await open(tester, system);
    await openTab(tester, 'Jobs');

    await tester.tap(find.text('Run now').first);
    await tester.pumpAndSettle();

    expect(
      find.text('The job failed: its last error says why.'),
      findsOneWidget,
    );
    expect(find.text('Database went away'), findsOneWidget);
  });

  testWidgets('shows the database, and that query timings are off', (
    tester,
  ) async {
    await open(tester, FakeSystemRepository());
    await openTab(tester, 'Database');

    expect(find.text('48 MB'), findsOneWidget);
    expect(find.text('99.5%'), findsOneWidget);
    expect(find.text('Query timings are off'), findsOneWidget);
    expect(find.text('offers'), findsOneWidget);
  });
}
