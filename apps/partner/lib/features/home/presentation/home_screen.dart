import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../store/domain/current_store.dart';

/// The store's name on top; today's numbers come later.
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SScaffold(
    title: ref.watch(currentStoreProvider)?.storeName,
    centered: true,
    body: SText.title(PartnerLocalizations.of(context).homeTitle),
  );
}
