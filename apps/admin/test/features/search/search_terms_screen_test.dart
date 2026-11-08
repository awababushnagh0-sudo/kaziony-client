import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/search/domain/search_term.dart';
import 'package:admin/features/search/presentation/search_terms_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

Widget harness(FakeSearchTermRepository terms) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    searchTermRepositoryProvider.overrideWithValue(terms),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SearchTermsScreen()),
      ],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

void main() {
  testWidgets('lists what customers search for, and what they found', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(1400, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(harness(FakeSearchTermRepository()));
    await tester.pumpAndSettle();

    expect(find.text('كيك'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('4 offers'), findsOneWidget);
    expect(find.text('بازين'), findsOneWidget);
    expect(find.text('Nothing'), findsOneWidget);
    expect(find.text('2 searches'), findsOneWidget);
  });

  testWidgets('shows only what found nothing', (tester) async {
    tester.view
      ..physicalSize = const Size(1400, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final terms = FakeSearchTermRepository();
    await tester.pumpWidget(harness(terms));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Found nothing'));
    await tester.pumpAndSettle();

    expect(terms.queries.last.filter, SearchTermFilter.nothingFound);
    expect(find.text('كيك'), findsNothing);
    expect(find.text('بازين'), findsOneWidget);
  });
}
