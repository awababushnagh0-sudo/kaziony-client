import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_image_view_model.dart';
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
        loading: const SSkeleton.groups(groups: 3),
        builder: (context, store) {
          final profile = store.profile;
          String shown(String? value) =>
              value == null || value.isEmpty ? s.notSet : value;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isOwner || store.logoUrl != null || store.coverUrl != null)
                  SCoverWithLogo(
                    cover: _StoreImageField(
                      image: StoreImage.cover,
                      url: store.coverUrl,
                      editable: isOwner,
                    ),
                    logo: _StoreImageField(
                      image: StoreImage.logo,
                      url: store.logoUrl,
                      editable: isOwner,
                    ),
                  ),
                if (isOwner) ...[
                  const Gap(Space.sm),
                  SText.caption(s.storeImagesHint),
                ],
                const Gap(Space.xl),
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
                    SFactTile(
                      label: s.ratingLabel,
                      value: switch (store.ratingAverage) {
                        final average? when store.ratingCount > 0 =>
                          s.ratingSummary(average, store.ratingCount),
                        _ => s.noRatingsYet,
                      },
                    ),
                  ],
                ),
                const Gap(Space.xl),
                SListGroup(
                  children: [
                    SListTile(
                      title: s.pickupInstructionsLabel,
                      subtitle: shown(profile.pickupInstructions),
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

/// The store's logo or cover photo. Owners tap it to change it; it
/// uploads right away.
class _StoreImageField extends AppView {
  const _StoreImageField({
    required this.image,
    required this.url,
    required this.editable,
  });

  final StoreImage image;
  final String? url;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final provider = storeImageViewModel(image);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final logo = image == StoreImage.logo;

    Future<void> choose() async {
      final source = await SPhoto.chooseSource(context);
      if (source == null || !context.mounted) return;
      final pick = await viewModel.choose(
        source,
        cropTitle: logo ? s.storeLogo : s.storeCover,
      );
      if (!context.mounted) return;
      switch (pick) {
        case PhotoAccessDenied():
          if (await SPhoto.askToOpenSettings(context)) {
            await viewModel.openSettings();
          }
        case PhotoFailed():
          SSnack.error(context, StellarLocalizations.of(context).photoFailed);
        case PhotoReady() || PhotoCancelled():
          break;
      }
    }

    return SPhotoField(
      shape: logo ? PhotoFieldShape.round : PhotoFieldShape.wide,
      url: url,
      preview: state.photo?.preview,
      progress: state.progress,
      failed: state.failed,
      addLabel: logo ? s.addLogo : s.addCover,
      hint: logo ? null : s.coverHint,
      onTap: !editable
          ? null
          : state.failed
          ? viewModel.retry
          : choose,
    );
  }
}
