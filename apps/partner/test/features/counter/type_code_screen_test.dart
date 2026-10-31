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
    await tester.pump();
    for (final character in 'ABCD2345'.split('')) {
      expect(find.text(character), findsOneWidget);
    }
    await tester.tap(find.text('Check the code'));
    await tester.pumpAndSettle();

    expect(find.text('claim ABCD2345'), findsOneWidget);
  });

  testWidgets('takes no look-alikes, and checks only a whole code', (
    tester,
  ) async {
    await open(tester);

    await tester.enterText(find.byType(EditableText), 'AB-0O1I-CD');
    await tester.pump();
    expect(find.text('0'), findsNothing);
    await tester.tap(find.text('Check the code'));
    await tester.pumpAndSettle();
    expect(find.byType(TypeCodeScreen), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'ABCD2345');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(find.text('claim ABCD2345'), findsOneWidget);
  });
}
