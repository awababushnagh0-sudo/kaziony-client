import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/business_localizations.dart';

/// Switches between Arabic and English (shows the other language's name).
class LanguageButton extends AppView {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return SButton.text(
      label: BusinessLocalizations.of(context).switchLanguage,
      onPressed: () => ref
          .read(localeProvider.notifier)
          .setLocale(
            current.languageCode == 'ar'
                ? const Locale('en')
                : const Locale('ar'),
          ),
    );
  }
}
