import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/product.dart';
import 'products_view_model.dart';

/// The Products tab (owners only): what the store sells, to post offers
/// from.
class ProductsScreen extends AppView {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final query = ref.watch(productQueryProvider);
    final queryController = ref.read(productQueryProvider.notifier);
    return SScaffold(
      title: s.productsTitle,
      // The rows run edge to edge; the search keeps the usual sides.
      padded: false,
      actions: [
        SButton.icon(
          icon: SIcons.add,
          tooltip: s.addProduct,
          onPressed: () => context.push(Routes.newProduct),
        ),
      ],
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
                    ),
                    SPill(
                      label: s.archivedProducts,
                      selected: query.archived,
                      onTap: () => queryController.setArchived(archived: true),
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
          itemCount: page.items.length,
          itemBuilder: (context, index) =>
              _ProductRow(product: page.items[index]),
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

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) => SListTile(
    leading: SImage(product.thumbUrl),
    title: product.title,
    subtitle: formatPrice(
      product.regularPrice,
      languageCode: Localizations.localeOf(context).languageCode,
    ),
    onTap: () => context.push(Routes.product(product.id)),
  );
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
