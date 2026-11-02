import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/offer.dart';
import 'home_view_model.dart';
import 'offers_view_model.dart';
import 'widgets/offer_poster.dart';

/// Every offer around, searched, sorted and filtered by kind of store:
/// "See all" from the home page ([initial] its sort), and the Search tab
/// ([searching]).
class OffersScreen extends AppView {
  const OffersScreen({
    this.initial = const OffersFilter(),
    this.searching = false,
    super.key,
  });

  final OffersFilter initial;

  /// Opens the keyboard at once, for the Search tab.
  final bool searching;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final filter = ref.watch(offersFilterProvider(initial));
    final controller = ref.read(offersFilterProvider(initial).notifier);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    Future<void> chooseSort() async {
      final sort = await SSheet.choose<OfferSort>(
        context,
        title: s.sortTitle,
        selected: filter.sort,
        options: [
          for (final sort in OfferSort.values)
            RadioOption(value: sort, label: sortName(s, sort)),
        ],
      );
      if (sort != null) controller.setSort(sort);
    }

    return SScaffold(
      title: searching ? s.searchTitle : s.offersTitle,
      padded: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.md,
            ),
            child: SSearchField(
              hint: s.searchHint,
              initialValue: filter.search,
              autofocus: searching,
              onChanged: controller.setSearch,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: Row(
              spacing: Space.sm,
              children: [
                SPill(
                  label: sortName(s, filter.sort),
                  icon: SIcons.sortable,
                  selected: true,
                  activeColor: SColor.text,
                  onTap: chooseSort,
                ),
                SPill(
                  label: s.allCategories,
                  selected: filter.categoryId == null,
                  onTap: () => controller.setCategory(null),
                ),
                for (final category in categories)
                  SPill(
                    label: category.name(language),
                    selected: filter.categoryId == category.id,
                    onTap: () => controller.setCategory(category.id),
                  ),
              ],
            ),
          ),
          const Gap(Space.md),
          Expanded(child: _List(initial: initial)),
        ],
      ),
    );
  }
}

String sortName(CustomerLocalizations s, OfferSort sort) => switch (sort) {
  OfferSort.nearest => s.sortNearest,
  OfferSort.endingSoon => s.sortEndingSoon,
  OfferSort.newest => s.sortNewest,
  OfferSort.biggestDiscount => s.sortBiggestDiscount,
};

class _List extends AppView {
  const _List({required this.initial});

  final OffersFilter initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = offersViewModel(initial);
    final viewModel = ref.read(provider.notifier);
    return SAsyncView(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      builder: (context, page) {
        if (page.items.isEmpty) {
          return SEmptyView(
            icon: SIcons.noResults,
            title: s.noResultsTitle,
            message: s.noResultsMessage,
          );
        }
        return SPagedList(
          // The offers are cards, apart from each other.
          divided: false,
          itemCount: page.items.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: OfferPoster(page.items[index]),
          ),
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
