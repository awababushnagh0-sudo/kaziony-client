import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/core/l10n/generated/partner_localizations.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/presentation/choose_store_screen.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

void main() {
  testWidgets('lists the stores and remembers the one tapped', (tester) async {
    final settings = MemorySettingsStore();
    await tester.pumpWidget(
      AppScope(
        overrides: [
          ...testOverrides(settings: settings),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          myStoresProvider.overrideWithValue([
            store('a'),
            store('b', isOwner: false),
          ]),
        ],
        child: SApp(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const ChooseStoreScreen()),
            ],
          ),
          locale: const Locale('en'),
          onGenerateTitle: (_) => 'test',
          localizationsDelegates: const [PartnerLocalizations.delegate],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Owner'), findsOneWidget);
    expect(find.text('Staff'), findsOneWidget);

    await tester.tap(find.text('Store b'));
    await tester.pumpAndSettle();
    expect(settings.values.values, ['b']);
  });
}
