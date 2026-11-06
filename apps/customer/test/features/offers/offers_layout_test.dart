import 'package:customer/features/offers/presentation/offers_layout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

void main() {
  late MemorySettingsStore settings;

  ProviderContainer open() {
    final container = ProviderContainer(
      overrides: testOverrides(kind: AppKind.customer, settings: settings),
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => settings = MemorySettingsStore());

  test('offers show as cards until the customer picks', () {
    expect(open().read(offersLayoutProvider), OffersLayout.cards);
  });

  test('the layout picked is kept on the phone for next time', () async {
    await open().read(offersLayoutProvider.notifier).set(OffersLayout.list);

    final next = open();
    next.read(offersLayoutProvider);
    await pumpEventQueue();
    expect(next.read(offersLayoutProvider), OffersLayout.list);
  });
}
