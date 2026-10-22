import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  late List<String> asked;
  late bool leave;

  Widget app({required bool active}) {
    final router = GoRouter(
      initialLocation: '/edit',
      routes: [
        GoRoute(
          path: '/edit',
          onExit: LeaveGuard.onExit,
          builder: (context, _) => LeaveGuard(
            active: active,
            confirm: (_) async {
              asked.add('leave?');
              return leave;
            },
            child: GestureDetector(
              onTap: () => context.go('/list'),
              child: const Text('edit page'),
            ),
          ),
        ),
        GoRoute(path: '/list', builder: (_, _) => const Text('list page')),
      ],
    );
    addTearDown(router.dispose);
    return WidgetsApp.router(
      routerConfig: router,
      color: const Color(0xFF000000),
    );
  }

  setUp(() {
    asked = [];
    leave = false;
  });

  testWidgets('leaves without asking when nothing is unsaved', (tester) async {
    await tester.pumpWidget(app(active: false));
    await tester.tap(find.text('edit page'));
    await tester.pumpAndSettle();

    expect(asked, isEmpty);
    expect(find.text('list page'), findsOneWidget);
  });

  testWidgets('stays when the user chooses to', (tester) async {
    await tester.pumpWidget(app(active: true));
    await tester.tap(find.text('edit page'));
    await tester.pumpAndSettle();

    expect(asked, ['leave?']);
    expect(find.text('edit page'), findsOneWidget);
  });

  testWidgets('leaves when the user lets the work go', (tester) async {
    leave = true;
    await tester.pumpWidget(app(active: true));
    await tester.tap(find.text('edit page'));
    await tester.pumpAndSettle();

    expect(asked, ['leave?']);
    expect(find.text('list page'), findsOneWidget);
  });
}
