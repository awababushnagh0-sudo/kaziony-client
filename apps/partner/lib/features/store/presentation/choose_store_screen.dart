import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../auth/domain/auth_repository.dart';
import '../domain/current_store.dart';

/// After login, for members of several stores. They switch later from
/// Profile.
class ChooseStoreScreen extends AppView {
  const ChooseStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SAuthPage(
      title: s.chooseStoreTitle,
      subtitle: s.chooseStoreSubtitle,
      footer: [
        SButton.text(
          label: s.logout,
          onPressed: () => ref.read(authRepositoryProvider).logout(),
        ),
      ],
      child: Column(
        spacing: Space.sm,
        children: [
          for (final store in ref.watch(myStoresProvider))
            SCard(
              padded: false,
              child: SListTile(
                title: store.storeName,
                subtitle: store.isOwner ? s.ownerRole : s.staffRole,
                icon: SIcons.store,
                // The router opens the tabs once a store is chosen.
                onTap: () => ref
                    .read(chosenStoreProvider.notifier)
                    .choose(store.storeId),
              ),
            ),
        ],
      ),
    );
  }
}
