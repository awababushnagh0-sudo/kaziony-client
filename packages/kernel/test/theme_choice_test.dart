import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

void main() {
  late MemorySettingsStore settings;
  late ProviderContainer container;

  ProviderContainer start() {
    final container = ProviderContainer(
      overrides: [settingsStoreProvider.overrideWithValue(settings)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    settings = MemorySettingsStore();
    container = start();
  });

  test('is light until the user chooses', () async {
    expect(container.read(themeChoiceProvider), ThemeChoice.light);
    await pumpEventQueue();
    expect(container.read(themeChoiceProvider), ThemeChoice.light);
  });

  test('remembers the choice across restarts', () async {
    await container.read(themeChoiceProvider.notifier).set(ThemeChoice.dark);
    expect(container.read(themeChoiceProvider), ThemeChoice.dark);

    final restarted = start();
    restarted.read(themeChoiceProvider);
    await pumpEventQueue();
    expect(restarted.read(themeChoiceProvider), ThemeChoice.dark);
  });

  test('starts in the choice read before the first frame', () async {
    await settings.setString('settings.theme', 'dark');
    expect(await ThemeChoiceController.readSaved(settings), ThemeChoice.dark);

    final opened = ProviderContainer(
      overrides: [
        settingsStoreProvider.overrideWithValue(settings),
        themeChoiceProvider.overrideWith(
          () => ThemeChoiceController(ThemeChoice.dark),
        ),
      ],
    );
    addTearDown(opened.dispose);
    // No light frame first.
    expect(opened.read(themeChoiceProvider), ThemeChoice.dark);
  });
}
