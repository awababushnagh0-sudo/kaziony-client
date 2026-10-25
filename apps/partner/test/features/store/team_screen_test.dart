import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/routes.dart';
import 'package:partner/features/store/domain/current_store.dart';
import 'package:partner/features/store/domain/store.dart';
import 'package:partner/features/store/presentation/team_screen.dart';

import '../../fakes.dart';
import '../../support/pump_app.dart';

void main() {
  testWidgets('shows each member with their role and branch', (tester) async {
    await pumpPartnerPages(
      tester,
      initial: Routes.team,
      overrides: [
        storeRepositoryProvider.overrideWithValue(FakeStoreRepository()),
        currentStoreProvider.overrideWithValue(store('a')),
      ],
      routes: [
        GoRoute(path: Routes.team, builder: (_, _) => const TeamScreen()),
      ],
    );

    expect(find.text('Owner One'), findsOneWidget);
    expect(find.text('Owner · 0910000001'), findsOneWidget);
    expect(find.text('Staff · Andalus · 0920000002'), findsOneWidget);
  });
}
