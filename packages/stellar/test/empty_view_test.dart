import 'package:flutter/material.dart' show ButtonStyleButton, Icon;
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

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

/// The icons in the view's button.
final buttonIcons = find.descendant(
  of: find.bySubtype<ButtonStyleButton>(),
  matching: find.byType(Icon),
);

void main() {
  testWidgets('under an icon, the button has its icon too', (tester) async {
    await tester.pumpWidget(
      app(
        SEmptyView(title: 'Nothing', actionLabel: 'Try again', onAction: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(buttonIcons, findsOneWidget);
  });

  testWidgets('under a picture, the button has words alone', (tester) async {
    await tester.pumpWidget(
      app(
        SEmptyView(
          title: 'Nothing yet',
          illustration: SIllustrations.avatar,
          actionLabel: 'Add one',
          actionIcon: SIcons.add,
          onAction: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add one'), findsOneWidget);
    expect(buttonIcons, findsNothing);
  });
}
