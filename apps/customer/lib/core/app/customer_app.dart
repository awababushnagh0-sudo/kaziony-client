import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';
import '../routes/router.dart';

class CustomerApp extends AppView {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SApp(
    routerConfig: ref.watch(routerProvider),
    locale: ref.watch(localeProvider),
    theme: ref.watch(themeChoiceProvider),
    onGenerateTitle: (context) => CustomerLocalizations.of(context).appTitle,
    localizationsDelegates: const [CustomerLocalizations.delegate],
  );
}
