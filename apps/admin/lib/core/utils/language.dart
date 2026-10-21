import 'package:kernel/kernel.dart';

/// Switches between Arabic and English.
void toggleLanguage(WidgetRef ref) {
  final current = ref.read(localeProvider);
  ref
      .read(localeProvider.notifier)
      .setLocale(
        current.languageCode == 'ar' ? const Locale('en') : const Locale('ar'),
      );
}
