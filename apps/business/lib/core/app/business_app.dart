import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/business_localizations.dart';
import '../routes/router.dart';

class BusinessApp extends AppView {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => StellarApp(
    routerConfig: ref.watch(routerProvider),
    locale: ref.watch(localeProvider),
    onGenerateTitle: (context) => BusinessLocalizations.of(context).appTitle,
    localizationsDelegates: const [BusinessLocalizations.delegate],
  );
}
