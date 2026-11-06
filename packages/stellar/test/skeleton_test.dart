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

void main() {
  testWidgets('a list longer than the screen is cut, not overflowing', (
    tester,
  ) async {
    await tester.pumpWidget(app(const SSkeleton.list(rows: 40)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.takeException(), isNull);
  });

  testWidgets('screen readers hear one "Loading", even nested', (tester) async {
    await tester.pumpWidget(
      app(
        const SSkeleton(
          child: Column(
            children: [
              SBone.text(),
              SSkeleton(child: SBone.wide()),
              SBone.button(),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Loading…'), findsOneWidget);
  });

  testWidgets('async view shows the skeleton it is given while loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        SAsyncView<int>(
          value: const AsyncLoading(),
          loading: const SSkeleton.page(),
          builder: (_, _) => const SText('done'),
        ),
      ),
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Loading…'), findsOneWidget);
    expect(find.text('done'), findsNothing);
  });
}
