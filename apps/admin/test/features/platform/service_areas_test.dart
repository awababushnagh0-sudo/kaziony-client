import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/platform/domain/platform_settings.dart';
import 'package:admin/features/platform/domain/service_area.dart';
import 'package:admin/features/platform/presentation/platform_settings_screen.dart';
import 'package:admin/features/platform/presentation/service_area_dialog_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';
import '../../support/finders.dart';

void main() {
  late FakeServiceAreaRepository areas;

  setUp(() => areas = FakeServiceAreaRepository());

  /// The platform page, on its service areas tab.
  Future<void> open(
    WidgetTester tester, {
    AccountRole role = AccountRole.admin,
  }) async {
    tester.view
      ..physicalSize = const Size(1400, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      AppScope(
        overrides: [
          ...testOverrides(kind: AppKind.admin),
          platformSettingsRepositoryProvider.overrideWithValue(
            FakePlatformSettingsRepository(),
          ),
          serviceAreaRepositoryProvider.overrideWithValue(areas),
          sessionProvider.overrideWith(() => FakeSession(user(role: role))),
          localeProvider.overrideWith(EnglishLocale.new),
        ],
        child: SApp(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => const PlatformSettingsScreen(),
              ),
            ],
          ),
          locale: const Locale('en'),
          style: StellarStyle.dashboard,
          onGenerateTitle: (_) => 'test',
          localizationsDelegates: const [AdminLocalizations.delegate],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Service areas').first);
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.descendant(
    of: textField(label),
    matching: find.byType(EditableText),
  );

  test('reads coordinates as Google Maps copies them', () {
    expect(parseCoordinates('32.85062, 13.18015'), (32.85062, 13.18015));
    expect(parseCoordinates(' 32.85 ,13.18 '), (32.85, 13.18));
    expect(parseCoordinates('32.85'), isNull);
    expect(parseCoordinates('north, south'), isNull);
    expect(parseCoordinates('95, 13'), isNull);
    expect(parseCoordinates(null), isNull);
  });

  testWidgets('admins add an area', (tester) async {
    await open(tester);
    expect(find.text('Tripoli'), findsOneWidget);

    await tester.tap(find.text('Add area'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Name in Arabic'), 'بنغازي');
    await tester.enterText(field('Name in English'), 'Benghazi');
    await tester.enterText(field('Center'), '32.1167, 20.0667');
    await tester.enterText(field('Radius (km)'), '25');
    await tester.tap(find.text('Add area').last);
    await tester.pumpAndSettle();

    final draft = areas.created.single;
    expect(
      (draft.nameEn, draft.latitude, draft.longitude),
      ('Benghazi', 32.1167, 20.0667),
    );
    expect((draft.radiusKm, draft.isActive), (25, true));
    expect(find.text('Benghazi'), findsOneWidget);
  });

  testWidgets('a center that is not two numbers is not sent', (tester) async {
    await open(tester);

    await tester.tap(find.text('Add area'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Name in Arabic'), 'بنغازي');
    await tester.enterText(field('Name in English'), 'Benghazi');
    await tester.enterText(field('Center'), 'Benghazi center');
    await tester.enterText(field('Radius (km)'), '25');
    await tester.tap(find.text('Add area').last);
    await tester.pumpAndSettle();

    expect(areas.created, isEmpty);
    expect(
      find.text('Enter latitude then longitude, like 32.85, 13.18'),
      findsOneWidget,
    );
  });

  testWidgets('admins change and delete an area', (tester) async {
    await open(tester);

    await tester.tap(find.text('Tripoli'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Radius (km)'), '35');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();
    expect(areas.updated.single.$2.radiusKm, 35);

    await tester.tap(find.text('Tripoli'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete area'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete area').last);
    await tester.pumpAndSettle();

    expect(areas.deleted, ['a1']);
    expect(find.text('Tripoli'), findsNothing);
  });

  testWidgets('editors see the areas but cannot change them', (tester) async {
    await open(tester, role: AccountRole.editor);

    expect(find.text('Tripoli'), findsOneWidget);
    expect(find.text('Add area'), findsNothing);
    await tester.tap(find.text('Tripoli'));
    await tester.pumpAndSettle();
    expect(find.text('Edit service area'), findsNothing);
  });
}
