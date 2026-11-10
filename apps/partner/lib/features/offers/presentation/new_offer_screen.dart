import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../products/presentation/product_view_model.dart';
import 'new_offer_view_model.dart';
import 'offer_view_model.dart';
import 'widgets/offer_fields.dart';
import 'widgets/post_offer_bar.dart';

/// Posts an offer from [productId], or posts [fromOfferId] again.
class NewOfferScreen extends AppView {
  const NewOfferScreen({required this.productId, this.fromOfferId, super.key});

  final String productId;
  final String? fromOfferId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productViewModel(productId));
    final fromId = fromOfferId;
    final from = fromId == null ? null : ref.watch(offerViewModel(fromId));
    if (product.hasValue && (from == null || from.hasValue)) {
      return _NewOfferForm(args: (productId: productId, fromOfferId: fromId));
    }
    // Whichever is still loading or failed.
    final waiting = product.hasValue ? from! : product;
    return SScaffold(
      title: PartnerLocalizations.of(context).newOfferTitle,
      body: SAsyncView(
        value: waiting,
        onRetry: () {
          ref.invalidate(productViewModel(productId));
          if (fromId != null) ref.invalidate(offerViewModel(fromId));
        },
        loading: const SSkeleton.groups(),
        builder: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _NewOfferForm extends AppView {
  const _NewOfferForm({required this.args});

  final NewOfferArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final provider = newOfferViewModel(args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final product = viewModel.product;

    Future<void> post() async {
      final offer = await viewModel.post();
      if (offer == null || !context.mounted) return;
      SSnack.success(context, s.offerPosted);
      context.pushReplacement(Routes.offer(offer.id));
    }

    return SScaffold(
      title: s.newOfferTitle,
      scrollable: true,
      bottom: PostOfferBar(state: state, onPost: post, loading: state.posting),
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.xl,
          children: [
            SListGroup(
              children: [
                SListTile(
                  leading: SImage(product.thumbUrl),
                  title: product.title,
                  subtitle: s.regularPriceIs(
                    formatPrice(product.regularPrice, languageCode: language),
                  ),
                ),
              ],
            ),
            OfferFields(viewModel: viewModel, state: state),
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
          ],
        ),
      ),
    );
  }
}
