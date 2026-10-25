import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show AppView, WidgetRef;

import '../../l10n/generated/stellar_localizations.dart';
import '../button/s_button.dart';
import '../icon/s_icon.dart';
import 's_language_sheet.dart';

/// A globe that opens a sheet to pick the app's language. The choice is
/// saved on the device.
class SLanguageButton extends AppView {
  const SLanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SButton.icon(
    icon: SIcons.language,
    tooltip: StellarLocalizations.of(context).language,
    onPressed: () => chooseLanguage(context, ref),
  );
}
