import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart'
    show WidgetRef, localeProvider, supportedLocales;

import '../../l10n/generated/stellar_localizations.dart';
import '../sheet/s_sheet.dart';
import '../sheet/s_sheet_renderer.dart';

/// Each language by its own name, so anyone can find theirs.
const _names = {'ar': 'العربية', 'en': 'English'};

/// [locale] by its own name ("العربية", "English").
String languageName(Locale locale) =>
    _names[locale.languageCode] ?? locale.languageCode;

/// Opens a sheet to pick the app's language, and saves the choice on the
/// device. Shared by [SLanguageButton] and the settings rows of the apps.
Future<void> chooseLanguage(BuildContext context, WidgetRef ref) async {
  final chosen = await SSheet.choose(
    context,
    title: StellarLocalizations.of(context).language,
    selected: ref.read(localeProvider),
    options: [
      for (final locale in supportedLocales)
        SheetOption(value: locale, label: languageName(locale)),
    ],
  );
  if (chosen != null) {
    await ref.read(localeProvider.notifier).setLocale(chosen);
  }
}
