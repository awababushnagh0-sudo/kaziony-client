import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// Light or dark colors, or [system] to follow the device.
enum ThemeChoice { system, light, dark }

/// The theme the user chose, remembered across restarts. Light until they
/// choose another.
class ThemeChoiceController extends Notifier<ThemeChoice> {
  /// [saved] is the choice [bootstrap] read before the first frame, so a
  /// dark dashboard doesn't flash light while it loads.
  ThemeChoiceController([this._saved]);

  static const _key = 'settings.theme';

  final ThemeChoice? _saved;

  /// The saved choice, or light.
  static Future<ThemeChoice> readSaved(SettingsStore store) async =>
      await _find(store) ?? ThemeChoice.light;

  static Future<ThemeChoice?> _find(SettingsStore store) async {
    final saved = await store.getString(_key);
    return ThemeChoice.values
        .where((choice) => choice.name == saved)
        .firstOrNull;
  }

  @override
  ThemeChoice build() {
    if (_saved case final saved?) return saved;
    unawaited(_load());
    return ThemeChoice.light;
  }

  Future<void> set(ThemeChoice choice) async {
    state = choice;
    await ref.read(settingsStoreProvider).setString(_key, choice.name);
  }

  Future<void> _load() async {
    final saved = await _find(ref.read(settingsStoreProvider));
    if (saved != null && ref.mounted) state = saved;
  }
}

final themeChoiceProvider =
    NotifierProvider<ThemeChoiceController, ThemeChoice>(
      ThemeChoiceController.new,
    );
