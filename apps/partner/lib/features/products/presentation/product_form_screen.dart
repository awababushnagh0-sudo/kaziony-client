import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import 'product_form_view_model.dart';
import 'product_photo_view_model.dart';
import 'product_view_model.dart';

/// Adds a product with its photo ([productId] null), or edits one.
class ProductFormScreen extends AppView {
  const ProductFormScreen({this.productId, super.key});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = productId;
    if (id == null) return const _ProductForm(productId: null);
    final product = ref.watch(productViewModel(id));
    if (product.hasValue) return _ProductForm(productId: id);
    return SScaffold(
      title: PartnerLocalizations.of(context).editProductTitle,
      body: SAsyncView(
        value: product,
        onRetry: () => ref.invalidate(productViewModel(id)),
        builder: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _ProductForm extends AppView {
  const _ProductForm({required this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final provider = productFormViewModel(productId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final id = productId;
    // A new product's photo goes up as part of saving it.
    final uploading =
        id == null && ref.watch(productPhotoViewModel(null)).progress != null;

    Future<void> save() async {
      final saved = await viewModel.save();
      if (saved == null || !context.mounted) return;
      if (id != null) {
        SSnack.success(context, s.saved);
        context.pop();
        return;
      }
      // The photo had nowhere to go until the product was saved.
      final sent = await ref
          .read(productPhotoViewModel(null).notifier)
          .uploadTo(saved.id);
      if (!context.mounted) return;
      if (!sent) {
        // Saved, so nothing typed is lost; the photo shows how to retry.
        SSnack.error(context, s.productSavedPhotoFailed);
        return;
      }
      SSnack.success(context, s.saved);
      context.pushReplacement(Routes.product(saved.id));
    }

    return SScaffold(
      title: id == null ? s.newProductTitle : s.editProductTitle,
      scrollable: true,
      bottom: SButton(
        label: s.save,
        onPressed: save,
        loading: state.saving || uploading,
        expand: true,
      ),
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            // Retrying a new product's photo saves it again, then goes
            // on to its page.
            _Photo(productId: id, onRetry: id == null ? save : null),
            SFormSection(
              title: s.productBasicsSection,
              note: s.productBasicsNote,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Space.lg,
                children: [
                  STextInput(
                    controlName: 'title',
                    label: s.productTitleLabel,
                    hint: s.productTitleHint,
                  ),
                  STextInput(
                    controlName: 'description',
                    label: s.descriptionLabel,
                    hint: s.descriptionHint,
                    kind: TextInputKind.multiline,
                    maxLength: 1000,
                  ),
                ],
              ),
            ),
            SFormSection(
              title: s.priceSection,
              note: s.regularPriceHelper,
              child: STextInput(
                controlName: 'price',
                label: s.regularPriceLabel,
                kind: TextInputKind.price,
              ),
            ),
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
          ],
        ),
      ),
    );
  }
}

/// The product's photo: tap to take or pick one, which uploads right away,
/// or for a new product ([productId] null) once it's saved.
class _Photo extends AppView {
  const _Photo({required this.productId, this.onRetry});

  final String? productId;

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
      onTap: state.failed ? onRetry ?? viewModel.retry : choose,
    );
  }
}
