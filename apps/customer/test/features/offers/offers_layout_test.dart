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
    expect(
      open().read(offersLayoutProvider(OffersPlace.lists)),
      OffersLayout.cards,
    );
  });

  test("a store's offers show as tiles until the customer picks", () {
    expect(
      open().read(offersLayoutProvider(OffersPlace.store)),
      OffersLayout.list,
    );
  });

  test('the layout picked is kept on the phone for next time', () async {
    const lists = OffersPlace.lists;
    await open()
        .read(offersLayoutProvider(lists).notifier)
        .set(OffersLayout.list);

    final next = open();
    next.read(offersLayoutProvider(lists));
    await pumpEventQueue();
    expect(next.read(offersLayoutProvider(lists)), OffersLayout.list);
    // A store's page keeps its own.
    expect(
      next.read(offersLayoutProvider(OffersPlace.store)),
      OffersLayout.list,
    );
  });

  test("a store's layout is kept apart from the other lists", () async {
    const store = OffersPlace.store;
    await open()
        .read(offersLayoutProvider(store).notifier)
        .set(OffersLayout.cards);

    final next = open();
    next.read(offersLayoutProvider(store));
    next.read(offersLayoutProvider(OffersPlace.lists));
    await pumpEventQueue();
    expect(next.read(offersLayoutProvider(store)), OffersLayout.cards);
    expect(
      next.read(offersLayoutProvider(OffersPlace.lists)),
      OffersLayout.cards,
    );
  });
}
