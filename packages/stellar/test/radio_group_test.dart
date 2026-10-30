import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// Keeps the chosen value, as a screen does.
class _Picker extends StatefulWidget {
  const _Picker();

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  String? size;

  @override
  Widget build(BuildContext context) => SRadioGroup<String>(
    value: size,
    onChanged: (value) => setState(() => size = value),
    options: const [
      RadioOption(value: 'small', label: 'Small', subtitle: '250 ml'),
      RadioOption(value: 'large', label: 'Large', mark: 'L'),
    ],
  );
}

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

Matcher chosen(bool yes) =>
    isSemantics(isChecked: yes, isInMutuallyExclusiveGroup: true);

void main() {
  testWidgets('keeps one choice, the last one tapped', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(app(const _Picker()));
    await tester.pumpAndSettle();

    // Nothing chosen yet.
    expect(find.text('250 ml'), findsOneWidget);
    expect(tester.getSemantics(find.text('Small')), chosen(false));
    expect(tester.getSemantics(find.text('Large')), chosen(false));

    await tester.tap(find.text('Small'));
    await tester.pumpAndSettle();
    expect(tester.getSemantics(find.text('Small')), chosen(true));
    expect(tester.getSemantics(find.text('Large')), chosen(false));

    await tester.tap(find.text('Large'));
    await tester.pumpAndSettle();
    expect(tester.getSemantics(find.text('Small')), chosen(false));
    expect(tester.getSemantics(find.text('Large')), chosen(true));
    semantics.dispose();
  });
}
