import 'package:flutter/material.dart' show EditableText, TextField;
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

void main() {
  testWidgets('the page keeps its state when the floating button goes', (
    tester,
  ) async {
    late StateSetter setState;
    var floating = true;
    await tester.pumpWidget(
      SApp(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => StatefulBuilder(
                builder: (context, set) {
                  setState = set;
                  return SScaffold(
                    floating: floating
                        ? SButton(label: 'Add', onPressed: () {})
                        : null,
                    body: SSearchField(hint: 'Search', onChanged: (_) {}),
                  );
                },
              ),
            ),
          ],
        ),
        locale: const Locale('en'),
        onGenerateTitle: (_) => 'test',
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'kunafa');

    setState(() => floating = false);
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'kunafa',
    );
  });
}
