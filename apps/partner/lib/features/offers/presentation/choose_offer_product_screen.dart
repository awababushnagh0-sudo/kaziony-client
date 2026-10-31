import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/list/paged_list_view_model.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../products/domain/product.dart';
import '../../products/presentation/products_view_model.dart';
import '../../products/presentation/widgets/product_tile.dart';
import '../../store/domain/current_store.dart';

/// Its own search, so the Products tab keeps what was typed there.
final offerProductQueryProvider =
    NotifierProvider.autoDispose<ProductQueryController, ProductQuery>(
      ProductQueryController.new,
    );

/// The current products, to post an offer from.
class OfferProductsViewModel extends ProductsViewModel {
  @override
  (String?, ProductQuery) watchQuery() => (
    ref.watch(currentStoreProvider)?.storeId,
    ref.watch(offerProductQueryProvider),
  );
}

final offerProductsViewModel =
    AsyncNotifierProvider.autoDispose<
      OfferProductsViewModel,
      PagedItems<Product>
    >(OfferProductsViewModel.new);

/// The first step of posting an offer: which product it's for.
class ChooseOfferProductScreen extends AppView {
  const ChooseOfferProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(offerProductsViewModel.notifier);
    return SScaffold(
      title: s.chooseProductTitle,
      padded: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.sm,
            ),
            child: SSearchField(
              hint: s.searchProducts,
              onChanged: ref.read(offerProductQueryProvider.notifier).setSearch,
            ),
          ),
          Expanded(
            child: SAsyncView(
              value: ref.watch(offerProductsViewModel),
              onRetry: () => ref.invalidate(offerProductsViewModel),
              builder: (context, page) {
                if (page.items.isEmpty) {
                  if (ref.watch(offerProductQueryProvider).search.isNotEmpty) {
                    return SEmptyView(
                      illustration: PartnerIllustrations.noResults,
                      title: s.noProductsMatch,
                    );
                  }
                  return SEmptyView(
                    illustration: PartnerIllustrations.noProducts,
                    title: s.noProductsTitle,
                    message: s.noProductsForOffer,
                    actionLabel: s.addProduct,
                    actionIcon: SIcons.add,
                    onAction: () => context.push(Routes.newProduct),
                  );
                }
                return SPagedList(
                  itemCount: page.items.length,
                  itemBuilder: (context, index) {
                    final product = page.items[index];
                    return ProductTile(
                      product: product,
                      onTap: () =>
                          context.pushReplacement(Routes.newOffer(product.id)),
                    );
                  },
                  onRefresh: () async {
                    await viewModel.refresh();
                  },
                  onLoadMore: viewModel.loadMore,
                  hasMore: page.hasMore,
                  loadingMore: page.loadingMore,
                  moreFailure: page.moreFailure,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
