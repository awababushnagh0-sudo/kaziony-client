import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// A page that scrolls on its own, as a record page's tab does.
Widget app(Widget table, {double width = 900}) => SApp(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => SScaffold(
          scrollable: true,
          body: Center(
            child: SizedBox(width: width, child: table),
          ),
        ),
      ),
    ],
  ),
  locale: const Locale('en'),
  style: StellarStyle.dashboard,
  onGenerateTitle: (_) => 'test',
);

final _columns = [
  const TableColumn<String>(label: 'Name', cell: SCellText.new),
  TableColumn<String>(
    label: 'Wide only',
    minWidth: 700,
    cell: (row) => SCellText('$row, wide'),
  ),
];

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1200, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('a boxed table lays out its rows inside a scrolling page', (
    tester,
  ) async {
    setWindow(tester);
    final opened = <String>[];
    await tester.pumpWidget(
      app(
        STable<String>.box(
          rows: const ['Huda', 'Sara'],
          columns: _columns,
          totalLabel: '2 people',
          onOpen: opened.add,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('2 people'), findsOneWidget);
    expect(find.text('Sara, wide'), findsOneWidget);

    await tester.tap(find.text('Sara'));
    expect(opened, ['Sara']);
  });

  testWidgets('a narrow boxed table hides the columns that need room', (
    tester,
  ) async {
    setWindow(tester);
    await tester.pumpWidget(
      app(
        STable<String>.box(
          rows: const ['Huda'],
          columns: _columns,
          totalLabel: '1 person',
        ),
        width: 500,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Huda'), findsOneWidget);
    expect(find.text('Wide only'), findsNothing);
    expect(find.text('Huda, wide'), findsNothing);
  });
}
