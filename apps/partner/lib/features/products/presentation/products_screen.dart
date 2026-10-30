import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import 'products_view_model.dart';
import 'widgets/product_tile.dart';

/// The Products tab (owners only): what the store sells, to post offers
/// from.
class ProductsScreen extends AppView {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final query = ref.watch(productQueryProvider);
    final queryController = ref.read(productQueryProvider.notifier);
    final firstEmpty =
        query == const ProductQuery() &&
        (ref.watch(productsViewModel).value?.items.isEmpty ?? false);
    return SScaffold(
      title: s.productsTitle,
      // The cards keep their own sides; the search keeps the usual ones.
      padded: false,
      // The first empty list has its own button to add one.
      floating: firstEmpty
          ? null
          : SButton(
              label: s.addProduct,
              icon: SIcons.add,
              onPressed: () => context.push(Routes.newProduct),
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                SSearchField(
                  hint: s.searchProducts,
                  initialValue: query.search,
                  onChanged: queryController.setSearch,
                ),
                Row(
                  spacing: Space.sm,
                  children: [
                    SPill(
                      label: s.currentProducts,
                      selected: !query.archived,
                      onTap: () => queryController.setArchived(archived: false),
                      activeColor: SColor.text,
                    ),
                    SPill(
                      label: s.archivedProducts,
                      selected: query.archived,
                      onTap: () => queryController.setArchived(archived: true),
                      activeColor: SColor.text,
                    ),
                  ],
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
    return SAsyncView(
      value: ref.watch(productsViewModel),
      onRetry: () => ref.invalidate(productsViewModel),
      builder: (context, page) {
        if (page.items.isEmpty) {
          return _Empty(query: ref.watch(productQueryProvider));
        }
        return SPagedList(
          // The products are cards, apart from each other.
          divided: false,
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final product = page.items[index];
            return ProductTile(
              product: product,
              onTap: () => context.push(Routes.product(product.id)),
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
      return SEmptyView(icon: SIcons.noResults, title: s.noProductsMatch);
    }
    if (query.archived) {
      return SEmptyView(icon: SIcons.archive, title: s.noArchivedProducts);
    }
    return SEmptyView(
      icon: SIcons.products,
      title: s.noProductsTitle,
      message: s.noProductsMessage,
      actionLabel: s.addProduct,
      actionIcon: SIcons.add,
      onAction: () => context.push(Routes.newProduct),
    );
  }
}
