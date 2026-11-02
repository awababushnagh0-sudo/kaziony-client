import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// Opens a choice sheet and keeps what it completes with.
class _Page extends StatelessWidget {
  const _Page({required this.onResult});

  final ValueChanged<int?> onResult;

  @override
  Widget build(BuildContext context) => SScaffold(
    body: SButton(
      label: 'open',
      onPressed: () async => onResult(
        await SSheet.choose<int>(
          context,
          title: 'Sort',
          options: const [
            RadioOption(value: 1, label: 'Nearest'),
            RadioOption(value: 2, label: 'Ending soon'),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('the X closes the sheet with nothing chosen', (tester) async {
    int? result = -1;
    await tester.pumpWidget(
      SApp(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => _Page(onResult: (value) => result = value),
            ),
          ],
        ),
        locale: const Locale('en'),
        onGenerateTitle: (_) => 'test',
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Nearest'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Nearest'), findsNothing);
    expect(result, isNull);
  });
}
