import 'package:flutter/material.dart' show MenuItemButton;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

void main() {
  late FormGroup form;

  Future<void> show(WidgetTester tester, {String? value}) async {
    form = FormGroup({
      'city': FormControl<String>(
        value: value,
        validators: [Validators.required],
      ),
      'name': FormControl<String>(),
    });
    await tester.pumpWidget(
      SApp(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => SScaffold(
                body: SForm(
                  form: form,
                  child: const SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        SSelectInput<String>(
                          controlName: 'city',
                          label: 'City',
                          hint: 'Choose a city',
                          required: true,
                          options: [
                            SelectOption('tripoli', 'Tripoli'),
                            SelectOption('misrata', 'Misrata'),
                          ],
                        ),
                        STextInput(controlName: 'name', label: 'Name'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        locale: const Locale('en'),
        density: StellarDensity.compact,
        onGenerateTitle: (_) => 'test',
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder select() => find.byType(SSelectInput<String>);

  testWidgets('is as tall as a text field', (tester) async {
    await show(tester);
    expect(
      tester.getSize(select()).height,
      tester.getSize(find.byType(STextInput)).height,
    );
  });

  testWidgets('chooses an option from its menu', (tester) async {
    await show(tester);
    expect(find.text('Choose a city'), findsOneWidget);

    await tester.tap(select());
    await tester.pumpAndSettle();
    // The menu is as wide as the field.
    expect(
      tester.getSize(find.widgetWithText(MenuItemButton, 'Misrata')).width,
      lessThanOrEqualTo(300),
    );
    await tester.tap(find.text('Misrata'));
    await tester.pumpAndSettle();

    expect(form.control('city').value, 'misrata');
    expect(find.text('Misrata'), findsOneWidget);
    expect(find.byType(MenuItemButton), findsNothing);
  });

  testWidgets('marks the chosen option and starts the keys from it', (
    tester,
  ) async {
    await show(tester, value: 'tripoli');
    await tester.tap(select());
    await tester.pumpAndSettle();
    final checked = find.byWidgetPredicate(
      (widget) => widget is MenuItemButton && widget.trailingIcon != null,
    );
    expect(
      find.descendant(of: checked, matching: find.text('Tripoli')),
      findsOneWidget,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(form.control('city').value, 'misrata');
  });

  testWidgets('says it is required when closed without a choice', (
    tester,
  ) async {
    await show(tester);
    await tester.tap(select());
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsOneWidget);
  });
}
