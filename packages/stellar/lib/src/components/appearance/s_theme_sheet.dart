import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart'
    show ThemeChoice, WidgetRef, themeChoiceProvider;

import '../../l10n/generated/stellar_localizations.dart';
import '../illustration/s_illustration_renderer.dart';
import '../list_tile/s_list_tile_renderer.dart';
import '../sheet/s_sheet.dart';

/// [choice] in the app's words ("Automatic", "Light", "Dark").
String themeName(BuildContext context, ThemeChoice choice) {
  final s = StellarLocalizations.of(context);
  return switch (choice) {
    ThemeChoice.system => s.themeSystem,
    ThemeChoice.light => s.themeLight,
    ThemeChoice.dark => s.themeDark,
  };
}

/// Opens a sheet to pick light, dark or the phone's own setting, and saves
/// the choice on the device. For the settings rows of the apps.
Future<void> chooseTheme(BuildContext context, WidgetRef ref) async {
  final s = StellarLocalizations.of(context);
  final chosen = await SSheet.choose(
    context,
    title: s.theme,
    subtitle: s.themeHint,
    illustration: SIllustrations.theme,
    selected: ref.read(themeChoiceProvider),
    options: [
      for (final choice in ThemeChoice.values)
        RadioOption(value: choice, label: themeName(context, choice)),
    ],
  );
  if (chosen != null) {
    await ref.read(themeChoiceProvider.notifier).set(chosen);
  }
}
