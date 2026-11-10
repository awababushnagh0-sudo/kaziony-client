import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../product_photo_view_model.dart';
import '../product_view_model.dart';

/// The product's photo: tap to take or pick one, which uploads right away,
/// or for a new product ([productId] null) once it's saved.
class ProductPhotoField extends AppView {
  const ProductPhotoField({
    required this.productId,
    this.onRetry,
    this.hint,
    super.key,
  });

  final String? productId;

  /// Under "Add a photo" while there's none, instead of the usual tip.
  final String? hint;

  /// After a failed upload, instead of sending the photo again alone.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = productPhotoViewModel(productId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final id = productId;
    final url = id == null
        ? null
        : ref.watch(productViewModel(id)).requireValue.imageUrl;

    Future<void> choose() async {
      final source = await SPhoto.chooseSource(context);
      if (source == null || !context.mounted) return;
      final pick = await viewModel.choose(
        source,
        cropTitle: StellarLocalizations.of(context).photo,
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
      url: url,
      preview: state.photo?.preview,
      progress: state.progress,
      failed: state.failed,
      hint: hint,
      onTap: state.failed ? onRetry ?? viewModel.retry : choose,
    );
  }
}
