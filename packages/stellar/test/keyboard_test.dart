import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// A phone's screen and its keyboard's height (an iPhone Air's).
const _screen = Size(420, 912);
const _keyboard = 336.0;

Widget _app(Widget page) => SApp(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => SScaffold(scrollable: true, body: page),
      ),
    ],
  ),
  style: StellarStyle.app,
  locale: const Locale('en'),
  onGenerateTitle: (_) => 'test',
);

void main() {
  /// Lays the page out on a phone; returns where the keyboard will start.
  double usePhone(WidgetTester tester) {
    tester.view.physicalSize = _screen * tester.view.devicePixelRatio;
    addTearDown(tester.view.reset);
    return _screen.height - _keyboard;
  }

  /// Taps a field and opens the keyboard over the page.
  Future<void> typeIn(WidgetTester tester, Finder field) async {
    await tester.tap(field);
    tester.view.viewInsets = FakeViewPadding(
      bottom: _keyboard * tester.view.devicePixelRatio,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the keyboard lifts the next field and the button into view', (
    tester,
  ) async {
    final keyboardTop = usePhone(tester);
    final form = FormGroup({
      'phone': FormControl<String>(),
      'password': FormControl<String>(),
    });
    await tester.pumpWidget(
      _app(
        SForm(
          form: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // What's above the form: its first field ends just over the
              // keyboard, as on the sign-in page.
              const SizedBox(height: 400),
              const STextInput(controlName: 'phone', label: 'Phone'),
              const Gap(Space.lg),
              const STextInput(controlName: 'password', label: 'Password'),
              const Gap(Space.xl),
              SButton(label: 'Log in', onPressed: () {}, expand: true),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final fields = find.byType(EditableText);

    await typeIn(tester, fields.first);
    expect(
      tester.getBottomLeft(fields.last).dy,
      lessThanOrEqualTo(keyboardTop),
      reason: 'the next field stays above the keyboard',
    );

    await tester.tap(fields.last);
    await tester.pumpAndSettle();
    expect(
      tester.getBottomLeft(find.text('Log in')).dy,
      lessThanOrEqualTo(keyboardTop),
      reason: 'the button stays above the keyboard',
    );
  });

  testWidgets('the keyboard lifts the button under a code into view', (
    tester,
  ) async {
    final keyboardTop = usePhone(tester);
    final form = FormGroup({'code': FormControl<String>()});
    await tester.pumpWidget(
      _app(
        SForm(
          form: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 420),
              SCodeInput(
                controlName: 'code',
                label: 'Code',
                length: 8,
                characters: RegExp('[A-Z0-9]'),
              ),
              const Gap(Space.xl),
              SButton(label: 'Check', onPressed: () {}, expand: true),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await typeIn(tester, find.byType(EditableText));

    expect(
      tester.getBottomLeft(find.text('Check')).dy,
      lessThanOrEqualTo(keyboardTop),
    );
  });
}
