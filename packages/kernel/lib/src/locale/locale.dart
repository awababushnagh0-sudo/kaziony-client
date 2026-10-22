import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// Arabic first (right to left), English as an option.
const supportedLocales = [Locale('ar'), Locale('en')];

/// The app language, remembered across restarts.
class LocaleController extends Notifier<Locale> {
  /// [saved] is the language [bootstrap] read before the first frame, so
  /// the app doesn't flash in Arabic first.
  LocaleController([this._saved]);

  static const _key = 'settings.locale';

  final Locale? _saved;

  /// The saved language, or Arabic.
  static Future<Locale> readSaved(SettingsStore store) async =>
      await _find(store) ?? supportedLocales.first;

  static Future<Locale?> _find(SettingsStore store) async {
    final saved = await store.getString(_key);
    return supportedLocales
        .where((locale) => locale.languageCode == saved)
        .firstOrNull;
  }

  @override
  Locale build() {
    if (_saved case final saved?) return saved;
    unawaited(_load());
    return supportedLocales.first;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref.read(settingsStoreProvider).setString(_key, locale.languageCode);
  }

  Future<void> _load() async {
    final saved = await _find(ref.read(settingsStoreProvider));
    if (saved != null && ref.mounted) state = saved;
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
