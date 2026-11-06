import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import 'product_form_view_model.dart';
import 'product_photo_view_model.dart';
import 'product_view_model.dart';
import 'widgets/product_photo_field.dart';

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
        loading: const SSkeleton.page(),
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
            ProductPhotoField(productId: id, onRetry: id == null ? save : null),
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
