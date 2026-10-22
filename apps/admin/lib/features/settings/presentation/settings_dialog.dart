import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';

/// The dashboard's settings on this device, as in the MIA portal: its
/// theme and its language, each chosen from cards picturing it.
class SettingsDialog extends AppView {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final theme = ref.watch(themeChoiceProvider);
    final language = ref.watch(localeProvider).languageCode;

    return SSettingsDialog(
      title: s.settings,
      pages: [
        SettingsPage(
          label: s.settingsAppearance,
          icon: SIcons.appearance,
          hint: s.settingsAppearanceHint,
          children: [
            SSettingsGroup(
              title: s.settingsTheme,
              hint: s.settingsThemeHint,
              child: SOptionGrid(
                children: [
                  for (final (choice, label, preview) in [
                    (
                      ThemeChoice.system,
                      s.themeSystem,
                      WindowPreview.lightAndDark,
                    ),
                    (ThemeChoice.light, s.themeLight, WindowPreview.light),
                    (ThemeChoice.dark, s.themeDark, WindowPreview.dark),
                  ])
                    SOptionCard(
                      label: label,
                      preview: preview,
                      selected: theme == choice,
                      onTap: () =>
                          ref.read(themeChoiceProvider.notifier).set(choice),
                    ),
                ],
              ),
            ),
          ],
        ),
        SettingsPage(
          label: s.settingsLanguage,
          icon: SIcons.language,
          hint: s.settingsLanguageHint,
          children: [
            SOptionGrid(
              children: [
                // Each language in its own script, with the side menu on
                // the side it puts it.
                for (final (code, label, direction) in [
                  ('ar', s.languageArabic, TextDirection.rtl),
                  ('en', s.languageEnglish, TextDirection.ltr),
                ])
                  SOptionCard(
                    label: label,
                    preview: WindowPreview.light,
                    direction: direction,
                    selected: language == code,
                    onTap: () => ref
                        .read(localeProvider.notifier)
                        .setLocale(Locale(code)),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
