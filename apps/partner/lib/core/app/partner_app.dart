import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/partner_localizations.dart';
import '../routes/router.dart';
import 'failure_wording.dart';

class PartnerApp extends AppView {
  const PartnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SApp(
    routerConfig: ref.watch(routerProvider),
    locale: ref.watch(localeProvider),
    theme: ref.watch(themeChoiceProvider),
    onGenerateTitle: (context) => PartnerLocalizations.of(context).appTitle,
    failureWording: partnerFailureWording,
    localizationsDelegates: const [PartnerLocalizations.delegate],
  );
}
