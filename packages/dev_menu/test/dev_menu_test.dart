import 'package:dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

Widget harness(DevLog log) => AppScope(
  overrides: [...testOverrides(), devLogProvider.overrideWithValue(log)],
  child: MaterialApp(
    builder: (context, child) => DevMenu(child: child!),
    home: const Scaffold(body: Text('The app')),
  ),
);

void main() {
  testWidgets('the bug button opens the dev menu with the request log', (
    tester,
  ) async {
    final log = DevLog();
    final entry = log.startRequest(
      method: 'POST',
      url: 'http://test.invalid/api/v1/auth/login',
      headers: {'Authorization': 'Bearer secret'},
      body: {'identifier': '0910000001', 'password': 'Merchant123!'},
    );
    log.finishRequest(entry, status: 401, responseBody: {'message': 'Wrong'});

    await tester.pumpWidget(harness(log));
    expect(find.text('The app'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bug_report_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Dev menu · DEV'), findsOneWidget);

    await tester.tap(find.text('Network'));
    await tester.pumpAndSettle();
    expect(find.text('POST /api/v1/auth/login'), findsOneWidget);
    expect(find.text('401'), findsOneWidget);

    await tester.tap(find.text('POST /api/v1/auth/login'));
    await tester.pumpAndSettle();
    expect(find.textContaining('0910000001'), findsOneWidget);
    expect(find.textContaining('Merchant123!'), findsNothing);
    expect(find.textContaining('Bearer secret'), findsNothing);
  });

  testWidgets('closes back to the app', (tester) async {
    await tester.pumpWidget(harness(DevLog()));
    await tester.tap(find.byIcon(Icons.bug_report_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Dev menu · DEV'), findsNothing);
    expect(find.text('The app'), findsOneWidget);
  });
}
