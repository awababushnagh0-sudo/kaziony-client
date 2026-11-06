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
  testWidgets('opens to show what it holds, and closes again', (tester) async {
    await tester.pumpWidget(
      app(const SExpandable(title: '2 more branches', child: SText('Dahra'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dahra'), findsNothing);

    await tester.tap(find.text('2 more branches'));
    await tester.pumpAndSettle();
    expect(find.text('Dahra'), findsOneWidget);

    await tester.tap(find.text('2 more branches'));
    await tester.pumpAndSettle();
    expect(find.text('Dahra'), findsNothing);
  });
}
