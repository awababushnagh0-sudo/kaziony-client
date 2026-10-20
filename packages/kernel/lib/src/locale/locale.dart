import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// Arabic first (right to left), English as an option.
const supportedLocales = [Locale('ar'), Locale('en')];

/// The app language, remembered across restarts.
class LocaleController extends Notifier<Locale> {
  static const _key = 'settings.locale';

  @override
  Locale build() {
    unawaited(_load());
    return supportedLocales.first;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref.read(settingsStoreProvider).setString(_key, locale.languageCode);
  }

  Future<void> _load() async {
    final saved = await ref.read(settingsStoreProvider).getString(_key);
    final match = supportedLocales.where((l) => l.languageCode == saved);
    if (match.isNotEmpty && ref.mounted) state = match.first;
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
