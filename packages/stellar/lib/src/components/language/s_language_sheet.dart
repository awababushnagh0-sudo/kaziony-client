import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart'
    show WidgetRef, localeProvider, supportedLocales;

import '../../l10n/generated/stellar_localizations.dart';
import '../illustration/s_illustration_renderer.dart';
import '../list_tile/s_list_tile_renderer.dart';
import '../sheet/s_sheet.dart';

/// Each language by its own name, so anyone can find theirs.
const _names = {'ar': 'العربية', 'en': 'English'};

/// [locale] by its own name ("العربية", "English").
String languageName(Locale locale) =>
    _names[locale.languageCode] ?? locale.languageCode;

/// Opens a sheet to pick the app's language, and saves the choice on the
/// device. Shared by [SLanguageButton] and the settings rows of the apps.
Future<void> chooseLanguage(BuildContext context, WidgetRef ref) async {
  final s = StellarLocalizations.of(context);
  final chosen = await SSheet.choose(
    context,
    title: s.language,
    subtitle: s.languageHint,
    illustration: SIllustrations.languages,
    selected: ref.read(localeProvider),
    options: [
      for (final locale in supportedLocales)
        RadioOption(value: locale, label: languageName(locale)),
    ],
  );
  if (chosen != null) {
    await ref.read(localeProvider.notifier).setLocale(chosen);
  }
}
