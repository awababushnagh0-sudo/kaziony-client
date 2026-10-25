import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/admin_localizations.dart';
import '../routes/router.dart';

class AdminApp extends AppView {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SApp(
    routerConfig: ref.watch(routerProvider),
    locale: ref.watch(localeProvider),
    theme: ref.watch(themeChoiceProvider),
    style: StellarStyle.dashboard,
    onGenerateTitle: (context) => AdminLocalizations.of(context).appTitle,
    localizationsDelegates: const [AdminLocalizations.delegate],
  );
}
