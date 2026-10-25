import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';
import 'package:partner/features/store/domain/current_store.dart';

import '../../fakes.dart';

void main() {
  group('storeAccessFor', () {
    final a = store('a');
    final b = store('b');

    test('no store when the account has none', () {
      expect(storeAccessFor(const [], const AsyncData(null)), isA<NoStore>());
    });

    test('members of one store go straight in, without waiting', () {
      final access = storeAccessFor([a], const AsyncLoading());
      expect(access, isA<InStore>());
      expect((access as InStore).store, a);
    });

    test('members of several stores use the one picked here', () {
      expect(
        storeAccessFor([a, b], const AsyncLoading()),
        isA<StoreAccessLoading>(),
      );
      expect(
        storeAccessFor([a, b], const AsyncData(null)),
        isA<MustChooseStore>(),
      );
      expect(
        storeAccessFor([a, b], const AsyncData('gone')),
        isA<MustChooseStore>(),
      );
      final access = storeAccessFor([a, b], const AsyncData('b'));
      expect((access as InStore).store, b);
    });
  });

  test('remembers the chosen store on the device', () async {
    final settings = MemorySettingsStore();
    ProviderContainer open() {
      final container = ProviderContainer(
        overrides: [settingsStoreProvider.overrideWithValue(settings)],
      );
      addTearDown(container.dispose);
      return container;
    }

    final first = open();
    expect(await first.read(chosenStoreProvider.future), isNull);
    await first.read(chosenStoreProvider.notifier).choose('b');

    expect(await open().read(chosenStoreProvider.future), 'b');
  });
}
