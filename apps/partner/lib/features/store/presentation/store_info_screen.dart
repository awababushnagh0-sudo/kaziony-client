import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/current_store.dart';
import 'store_view_model.dart';

/// The store as customers see it. Owners can edit it.
class StoreInfoScreen extends AppView {
  const StoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final store = ref.watch(storeViewModel);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    return SScaffold(
      title: s.storeInfoTitle,
      actions: [
        if (isOwner && store.hasValue)
          SButton.icon(
            icon: SIcons.edit,
            tooltip: s.edit,
            onPressed: () => context.push(Routes.editStoreInfo),
          ),
      ],
      body: SAsyncView(
        value: store,
        onRetry: ref.read(storeViewModel.notifier).reload,
        builder: (context, store) {
          final profile = store.profile;
          String shown(String? value) =>
              value == null || value.isEmpty ? s.notSet : value;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SListGroup(
                  children: [
                    SListTile(
                      icon: SIcons.store,
                      title: store.name,
                      subtitle: store.category.name(
                        Localizations.localeOf(context),
                      ),
                    ),
                  ],
                ),
                const Gap(Space.xl),
                SListGroup(
                  children: [
                    SListTile(
                      title: s.descriptionLabel,
                      subtitle: shown(profile.description),
                    ),
                    SListTile(
                      title: s.phoneLabel,
                      subtitle: shown(
                        profile.phone == null
                            ? null
                            : formatLibyanPhone(profile.phone!),
                      ),
                    ),
                    SListTile(
                      title: s.emailLabel,
                      subtitle: shown(profile.email),
                    ),
                    SListTile(
                      title: s.facebookLabel,
                      subtitle: shown(profile.facebookUrl),
                    ),
                    SListTile(
                      title: s.instagramLabel,
                      subtitle: shown(profile.instagramUrl),
                    ),
                  ],
                ),
                const Gap(Space.sm),
                SText.caption(s.storeInfoHint),
              ],
            ),
          );
        },
      ),
    );
  }
}
