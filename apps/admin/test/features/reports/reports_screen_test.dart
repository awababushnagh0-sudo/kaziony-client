import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/core/routes/routes.dart';
import 'package:admin/features/reports/domain/customer_report.dart';
import 'package:admin/features/reports/presentation/reports_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/finders.dart';

Widget harness(FakeReportRepository reports) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    reportRepositoryProvider.overrideWithValue(reports),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const ReportsScreen()),
        GoRoute(
          path: '${Routes.stores}/:id',
          builder: (_, state) => SText('Store ${state.pathParameters['id']}'),
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

Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists reports with who, where and where they stand', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeReportRepository()));
    await tester.pumpAndSettle();

    expect(find.text('The store was closed'), findsOneWidget);
    expect(find.text('Something was wrong with it'), findsOneWidget);
    expect(find.text('Huda'), findsNWidgets(2));
    expect(find.text('Sweet Corner'), findsNWidgets(2));
    expect(find.text('2 reports'), findsOneWidget);
  });

  testWidgets('shows the resolved ones', (tester) async {
    setWindow(tester);
    final reports = FakeReportRepository();
    await tester.pumpWidget(harness(reports));
    await tester.pumpAndSettle();

    // The pill, then the badge.
    await tester.tap(find.text('Resolved').first);
    await tester.pumpAndSettle();

    expect(reports.queries.last.filter, ReportState.resolved);
    expect(find.text('The store was closed'), findsNothing);
    expect(find.text('Something was wrong with it'), findsOneWidget);
  });

  testWidgets('says when there are no reports', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeReportRepository()..reports = []));
    await tester.pumpAndSettle();

    expect(find.text('No reports'), findsOneWidget);
  });

  group('an open report', () {
    Future<FakeReportRepository> open(WidgetTester tester) async {
      setWindow(tester);
      final reports = FakeReportRepository();
      await tester.pumpWidget(harness(reports));
      await tester.pumpAndSettle();
      await tester.tap(find.text('The store was closed'));
      await tester.pumpAndSettle();
      return reports;
    }

    testWidgets('shows what was said, the booking and the customer', (
      tester,
    ) async {
      await open(tester);

      expect(find.text('What the customer said'), findsOneWidget);
      expect(find.text('The door was locked at 8:30'), findsOneWidget);
      expect(find.text('K7Q2'), findsOneWidget);
      expect(find.text('Kunafa box'), findsOneWidget);
      expect(find.text('Sweet Corner · Andalus'), findsOneWidget);
      expect(find.text('Missed'), findsOneWidget);
      expect(find.text('huda@example.com'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Booking paused until'), findsOneWidget);
    });

    testWidgets('takes back only what is ticked', (tester) async {
      final reports = await open(tester);

      expect(find.text('Stays'), findsOneWidget);
      await tapOn(tester, find.text("This booking's strike"));
      expect(
        find.text('Taken back: their missed pickups go down by one'),
        findsOneWidget,
      );
      await tester.enterText(
        textField('What you found'),
        'The store closed early',
      );
      await tapOn(tester, find.text('Resolve'));

      final (id, resolution) = reports.resolved.single;
      expect(id, 'r1');
      expect(resolution.removeStrike, isTrue);
      expect(resolution.endPause, isFalse);
      expect(resolution.note, 'The store closed early');
      expect(find.text('Report resolved'), findsOneWidget);
      expect(find.text('What the customer said'), findsNothing);
    });

    testWidgets('can end the pause too', (tester) async {
      final reports = await open(tester);

      await tapOn(tester, find.text("This booking's strike"));
      await tapOn(tester, find.text('Their pause in booking'));
      expect(find.text('Ended now: they can book again'), findsOneWidget);
      await tapOn(tester, find.text('Resolve'));

      final (_, resolution) = reports.resolved.single;
      expect(resolution.removeStrike, isTrue);
      expect(resolution.endPause, isTrue);
    });

    testWidgets('says when someone resolved it first', (tester) async {
      final reports = await open(tester);
      reports.resolveResult = const Err(
        ConflictFailure('This report was resolved already', 'AlreadyResolved'),
      );

      await tapOn(tester, find.text('Resolve'));

      expect(
        find.text('Someone on the team resolved this report first.'),
        findsOneWidget,
      );
      expect(find.text('What the customer said'), findsOneWidget);
    });

    testWidgets('opens its store', (tester) async {
      await open(tester);

      await tapOn(tester, find.text('Open the store'));

      expect(find.text('Store s1'), findsOneWidget);
    });
  });

  testWidgets('a resolved report shows what the team decided', (tester) async {
    setWindow(tester);
    await tester.pumpWidget(harness(FakeReportRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Something was wrong with it'));
    await tester.pumpAndSettle();

    expect(find.text('What the team decided'), findsOneWidget);
    expect(find.text('Sara'), findsOneWidget);
    expect(find.text('The strike'), findsOneWidget);
    expect(find.text('The store owned up'), findsOneWidget);
    expect(find.text('Resolve'), findsNothing);
    expect(find.text('What the customer said'), findsNothing);
  });
}
