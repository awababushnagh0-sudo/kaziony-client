import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../auth/domain/auth_repository.dart';

/// A store account that isn't linked to a store, e.g. staff who were
/// removed. Our team links stores, so all they can do is ask us.
class NoStoreScreen extends AppView {
  const NoStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SAuthPage(
      title: s.noStoreTitle,
      subtitle: s.noStoreMessage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SButton(
            label: s.contactUs,
            icon: SIcons.chat,
            onPressed: () => context.push(Routes.contact),
          ),
          const Gap(Space.md),
          SButton.secondary(
            label: s.logout,
            icon: SIcons.logout,
            onPressed: () => ref.read(authRepositoryProvider).logout(),
          ),
        ],
      ),
    );
  }
}
