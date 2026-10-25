import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'product_form_view_model.dart';

/// Adds a product ([productId] null), or edits and archives one.
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
    final archived =
        id != null && ref.watch(productViewModel(id)).requireValue.isArchived;

    Future<void> save() async {
      if (await viewModel.save() && context.mounted) {
        SSnack.success(context, s.saved);
        context.pop();
      }
    }

    Future<void> setArchived() async {
      if (await viewModel.setArchived(archived: !archived) && context.mounted) {
        SSnack.success(
          context,
          archived ? s.productRestored : s.productArchived,
        );
        context.pop();
      }
    }

    return SScaffold(
      title: id == null ? s.newProductTitle : s.editProductTitle,
      scrollable: true,
      bottom: SButton(
        label: s.save,
        onPressed: save,
        loading: state.saving,
        expand: true,
      ),
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            STextInput(controlName: 'title', label: s.productTitleLabel),
            STextInput(
              controlName: 'price',
              label: s.regularPriceLabel,
              kind: TextInputKind.price,
              helper: s.regularPriceHelper,
            ),
            STextInput(
              controlName: 'description',
              label: s.descriptionLabel,
              kind: TextInputKind.multiline,
              maxLength: 1000,
            ),
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
            if (id != null)
              SButton.secondary(
                label: archived ? s.restoreProduct : s.archiveProduct,
                icon: archived ? SIcons.restore : SIcons.archive,
                onPressed: setArchived,
                loading: state.archiving,
              ),
          ],
        ),
      ),
    );
  }
}
