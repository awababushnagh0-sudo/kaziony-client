import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/counter/presentation/type_code_screen.dart';
import 'package:stellar/stellar.dart';

import '../../support/pump_app.dart';

void main() {
  Future<void> open(WidgetTester tester) => pumpPartnerPages(
    tester,
    initial: Routes.typeCode,
    routes: [
      GoRoute(path: Routes.typeCode, builder: (_, _) => const TypeCodeScreen()),
      GoRoute(
        path: Routes.claim(':code'),
        builder: (_, state) => SText('claim ${state.pathParameters['code']}'),
      ),
    ],
  );

  testWidgets('checks a typed code in capitals', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(EditableText), 'abcd2345');
    await tester.tap(find.text('Check the code'));
    await tester.pumpAndSettle();

    expect(find.text('claim ABCD2345'), findsOneWidget);
  });

  testWidgets('refuses what cannot be a code', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(EditableText), 'ABCD0000');
    await tester.tap(find.text('Check the code'));
    await tester.pumpAndSettle();

    expect(
      find.text('A code is 8 letters and numbers, like ABCD2345.'),
      findsOneWidget,
    );
  });
}
