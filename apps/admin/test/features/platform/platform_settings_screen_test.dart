import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/platform/domain/platform_settings.dart';
import 'package:admin/features/platform/domain/service_area.dart';
import 'package:admin/features/platform/presentation/platform_settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/finders.dart';

Widget harness(
  FakePlatformSettingsRepository settings, {
  AccountRole role = AccountRole.admin,
}) => AppScope(
  overrides: [
    ...testOverrides(kind: AppKind.admin),
    platformSettingsRepositoryProvider.overrideWithValue(settings),
    serviceAreaRepositoryProvider.overrideWithValue(
      FakeServiceAreaRepository(),
    ),
    sessionProvider.overrideWith(() => FakeSession(user(role: role))),
    localeProvider.overrideWith(EnglishLocale.new),
  ],
  child: SApp(
    routerConfig: GoRouter(
      routes: [
        GoRoute(
          path: '/',
          onExit: LeaveGuard.onExit,
          builder: (_, _) => const PlatformSettingsScreen(),
        ),
      ],
    ),
    locale: const Locale('en'),
    style: StellarStyle.dashboard,
    onGenerateTitle: (_) => 'test',
    localizationsDelegates: const [AdminLocalizations.delegate],
  ),
);

void setWindow(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1400, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Finder get radiusField => find.descendant(
  of: textField('Offer radius (km)'),
  matching: find.byType(EditableText),
);

void main() {
  testWidgets('admins change the radius', (tester) async {
    setWindow(tester);
    final settings = FakePlatformSettingsRepository();
    await tester.pumpWidget(harness(settings));
    await tester.pumpAndSettle();

    expect(find.text('25'), findsOneWidget);
    await tester.enterText(radiusField, '15');
    await tester.pumpAndSettle();
    expect(find.text('Not saved'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(settings.updates.map((s) => s.browseRadiusKm), [15]);
    expect(find.text('Not saved'), findsNothing);
  });

  testWidgets('a radius out of range is not sent', (tester) async {
    setWindow(tester);
    final settings = FakePlatformSettingsRepository();
    await tester.pumpWidget(harness(settings));
    await tester.pumpAndSettle();

    await tester.enterText(radiusField, '500');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(settings.updates, isEmpty);
  });

  testWidgets('editors see the radius but cannot change it', (tester) async {
    setWindow(tester);
    final settings = FakePlatformSettingsRepository();
    await tester.pumpWidget(harness(settings, role: AccountRole.editor));
    await tester.pumpAndSettle();

    expect(find.text('25'), findsOneWidget);
    expect(find.textContaining('Only admins change it'), findsOneWidget);
    expect(tester.widget<EditableText>(radiusField).readOnly, isTrue);
  });
}
