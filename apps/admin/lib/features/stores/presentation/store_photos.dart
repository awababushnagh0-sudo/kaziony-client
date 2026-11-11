import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/store.dart';
import 'store_photo_view_model.dart';

/// A store's Photos tab: its cover with the logo over it, as customers see
/// them. Clicking one picks a photo from the computer, uploaded right away;
/// the buttons under them remove them. A live store keeps its logo.
class StorePhotos extends StatelessWidget {
  const StorePhotos({required this.store, super.key});

  final StoreDetails store;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final keepsLogo = store.isActive && store.logoUrl != null;
    final removable = [
      if (store.logoUrl != null && !keepsLogo) StoreImage.logo,
      if (store.coverUrl != null) StoreImage.cover,
    ];
    return SFormSection(
      title: s.tabPhotos,
      note: s.storePhotosNote,
      divider: false,
      // Half the page: about as wide as a phone shows the cover.
      child: SFieldGrid(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SCoverWithLogo(
                cover: _PhotoField(store: store, image: StoreImage.cover),
                logo: _PhotoField(store: store, image: StoreImage.logo),
              ),
              // Kept apart from the photos: removing one can't be undone.
              if (removable.isNotEmpty) ...[
                const Gap(Space.xl),
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.md,
                  children: [
                    for (final image in removable)
                      _RemoveButton(store: store, image: image),
                  ],
                ),
              ],
              if (keepsLogo) ...[
                Gap(removable.isEmpty ? Space.xl : Space.md),
                SText.caption(s.liveStoreKeepsLogo),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The logo or the cover: shows the photo, and picks a new one.
class _PhotoField extends AppView {
  const _PhotoField({required this.store, required this.image});

  final StoreDetails store;
  final StoreImage image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final provider = storePhotoViewModel((store.id, image));
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final logo = image == StoreImage.logo;

    Future<void> choose() async {
      final pick = await viewModel.choose(
        title: logo ? s.storeLogo : s.storeCover,
      );
      if (!context.mounted) return;
      if (pick case PhotoFailed(:final error)) {
        SSnack.error(
          context,
          error is PhotoTooLarge
              ? s.photoTooLarge
              : StellarLocalizations.of(context).photoFailed,
        );
      }
    }

    return SPhotoField(
      shape: logo ? PhotoFieldShape.round : PhotoFieldShape.wide,
      url: logo ? store.logoUrl : store.coverUrl,
      preview: state.photo?.preview,
      progress: state.progress,
      failed: state.failed,
      addLabel: logo ? s.addLogo : s.addCover,
      hint: logo ? null : s.coverHint,
      onTap: state.removing
          ? null
          : state.failed
          ? viewModel.retry
          : choose,
    );
  }
}

/// Removes the logo or the cover, once the admin confirms.
class _RemoveButton extends AppView {
  const _RemoveButton({required this.store, required this.image});

  final StoreDetails store;
  final StoreImage image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final provider = storePhotoViewModel((store.id, image));
    final state = ref.watch(provider);
    final logo = image == StoreImage.logo;

    Future<void> remove() async {
      final confirmed = await SDialog.confirm(
        context,
        title: logo
            ? s.removeLogoTitle(store.label)
            : s.removeCoverTitle(store.label),
        message: s.removePhotoMessage,
        confirmLabel: logo ? s.removeLogo : s.removeCover,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      final result = await ref.read(provider.notifier).remove();
      if (!context.mounted) return;
      switch (result) {
        case null:
          return;
        case Ok():
          SSnack.success(context, s.photoRemovedDone);
        case Err(:final failure):
          SSnack.error(
            context,
            failure is ConflictFailure && failure.code == StoreCodes.notReady
                ? s.liveStoreKeepsLogo
                : failureMessage(context, failure),
          );
      }
    }

    return SButton.dangerSoft(
      label: logo ? s.removeLogo : s.removeCover,
      icon: SIcons.delete,
      loading: state.removing,
      // Not while a new one uploads.
      onPressed: state.progress == null ? remove : null,
    );
  }
}
