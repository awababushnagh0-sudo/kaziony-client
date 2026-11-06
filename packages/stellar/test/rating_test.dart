import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

Widget app(Widget page) => SApp(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => SScaffold(body: page),
      ),
    ],
  ),
  locale: const Locale('en'),
  onGenerateTitle: (_) => 'test',
);

String stars(int count) => count == 1 ? '1 star' : '$count stars';

void main() {
  testWidgets('a rating reads its average and how many rated', (tester) async {
    await tester.pumpWidget(
      app(const SRating(average: 4.25, count: 37, label: 'Rated 4.3')),
    );
    await tester.pumpAndSettle();

    expect(find.text('4.3'), findsOneWidget);
    expect(find.text('(37)'), findsOneWidget);
  });

  testWidgets('each star picks its number', (tester) async {
    final picked = <int>[];
    await tester.pumpWidget(
      app(SStarInput(value: 0, starLabel: stars, onChanged: picked.add)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('1 star'));
    await tester.tap(find.byTooltip('4 stars'));

    expect(picked, [1, 4]);
  });

  testWidgets('read-only, the stars only show the rating', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(app(const SStarInput(value: 3, starLabel: stars)));
    await tester.pumpAndSettle();

    expect(find.byTooltip('3 stars'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('3 stars')), findsOneWidget);
    semantics.dispose();
  });
}
