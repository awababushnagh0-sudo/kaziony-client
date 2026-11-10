import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/store/domain/store.dart';
import '../../features/store/presentation/store_image_view_model.dart';
import '../l10n/generated/partner_localizations.dart';

/// The store's logo or cover photo. Owners tap it to change it; it
/// uploads right away. The logo is round and the cover as wide as the
/// page, unless [shape] says otherwise (the cover as a banner over the
/// profile).
class StoreImageField extends AppView {
  const StoreImageField({
    required this.image,
    required this.url,
    required this.editable,
    this.shape,
    super.key,
  });

  final StoreImage image;
  final String? url;
  final bool editable;
  final PhotoFieldShape? shape;

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
      shape: shape ?? (logo ? PhotoFieldShape.round : PhotoFieldShape.wide),
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
