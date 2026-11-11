import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../store/presentation/store_view_model.dart';
import 'products_view_model.dart';
import 'widgets/product_card.dart';
import 'widgets/product_cards_skeleton.dart';

/// The Products tab (owners only): what the store sells, as a grid of
/// photos, each with its offer to post in one tap.
class ProductsScreen extends AppView {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final query = ref.watch(productQueryProvider);
    final queryController = ref.read(productQueryProvider.notifier);
    final products = ref.watch(productsViewModel);
    // Not while loading: the empty list kept from the archived ones isn't
    // the store's first.
    final firstEmpty =
        query == const ProductQuery() &&
        !products.isLoading &&
        (products.value?.items.isEmpty ?? false);
    return SScaffold(
      title: s.productsTitle,
      // The cards keep their own sides; the search keeps the usual ones.
      padded: false,
      // In the bar, not floating over the photos: products are added now
      // and then, offers are posted from them every day. The first empty
      // list has its own button to add one.
      actions: [
        if (!firstEmpty)
          SButton.text(
            label: s.addProduct,
            icon: SIcons.add,
            onPressed: () => context.push(Routes.newProduct),
          ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // Plus the room the grid brings above its cards: the choice
            // stands apart from them.
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                SSearchField(
                  hint: s.searchProducts,
                  initialValue: query.search,
                  onChanged: queryController.setSearch,
                ),
                SSegmented<bool>.labels(
                  options: [
                    SelectOption(false, s.currentProducts),
                    SelectOption(true, s.archivedProducts),
                  ],
                  selected: query.archived,
                  onChanged: (archived) =>
                      queryController.setArchived(archived: archived),
                ),
              ],
            ),
          ),
          const Expanded(child: _ProductList()),
        ],
      ),
    );
  }
}

class _ProductList extends AppView {
  const _ProductList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(productsViewModel.notifier);
    final live = ref.watch(storeIsLiveProvider);
    return SAsyncView(
      value: ref.watch(productsViewModel),
      onRetry: () => ref.invalidate(productsViewModel),
      loading: const SSkeleton(
        child: Padding(
          // Where the grid's first cards will be.
          padding: EdgeInsets.only(top: Space.md),
          child: ProductCardsSkeleton(lines: 3),
        ),
      ),
      builder: (context, page) {
        if (page.items.isEmpty) {
          return _Empty(query: ref.watch(productQueryProvider));
        }
        return SPagedList(
          // Two across: photos are what tell products apart.
          columns: 2,
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final product = page.items[index];
            return ProductCard(
              product: product,
              onTap: () => context.push(Routes.product(product.id)),
              // Not while the store is off.
              onPostOffer: product.isArchived || !live
                  ? null
                  : () => context.push(Routes.newOffer(product.id)),
            );
          },
          onRefresh: () async {
            final failure = await viewModel.refresh();
            if (failure != null && context.mounted) {
              SSnack.error(context, failureMessage(context, failure));
            }
          },
          onLoadMore: viewModel.loadMore,
          hasMore: page.hasMore,
          loadingMore: page.loadingMore,
          moreFailure: page.moreFailure,
          placeholder: const ProductCardsSkeleton(),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.query});

  final ProductQuery query;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    if (query.search.isNotEmpty) {
      return SEmptyView(
        illustration: PartnerIllustrations.noResults,
        title: s.noProductsMatch,
      );
    }
    if (query.archived) {
      return SEmptyView(
        illustration: PartnerIllustrations.noArchived,
        title: s.noArchivedProducts,
      );
    }
    return SEmptyView(
      illustration: PartnerIllustrations.noProducts,
      title: s.noProductsTitle,
      message: s.noProductsMessage,
      actionLabel: s.addProduct,
      onAction: () => context.push(Routes.newProduct),
    );
  }
}
