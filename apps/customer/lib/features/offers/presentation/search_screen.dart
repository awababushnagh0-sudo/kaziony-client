import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../stores/domain/store.dart';
import '../../stores/presentation/stores_view_model.dart';
import '../../stores/presentation/widgets/store_tile.dart';
import '../../stores/presentation/widgets/store_tile_skeleton.dart';
import '../domain/offer.dart';
import '../domain/recent_searches.dart';
import 'home_view_model.dart';
import 'offers_layout.dart';
import 'offers_view_model.dart';
import 'search_view_model.dart';
import 'widgets/offer_card_skeleton.dart';
import 'widgets/offers_layout_switch.dart';
import 'widgets/offers_list.dart';

/// The Search tab. Before searching: the kinds of store as pictures, the
/// customer's recent searches and the stores near them. Once words are
/// typed or a kind is chosen: the stores that match, then the offers, with
/// their sort and layout.
class SearchScreen extends AppStatefulView {
  const SearchScreen({super.key});

  @override
  AppViewState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends AppViewState<SearchScreen> {
  final _words = TextEditingController();

  @override
  void dispose() {
    _words.dispose();
    super.dispose();
  }

  void _submit(String words) {
    ref.read(searchFilterProvider.notifier).searchNow(words);
    ref.read(recentSearchesProvider.notifier).add(words);
  }

  void _searchAgain(String words) {
    FocusScope.of(context).unfocus();
    _words.text = words;
    _submit(words);
  }

  void _chooseCategory(String categoryId) {
    FocusScope.of(context).unfocus();
    ref.read(searchFilterProvider.notifier).setCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final filter = ref.watch(searchFilterProvider);
    // Kept while the tab is, not only while the recent searches show:
    // searching adds to them.
    ref.listen(recentSearchesProvider, (_, _) {});
    return SScaffold(
      title: s.searchTitle,
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
              controller: _words,
              autofocus: true,
              onChanged: ref.read(searchFilterProvider.notifier).setSearch,
              onSubmitted: _submit,
            ),
          ),
          Expanded(
            child: isSearching(filter)
                ? _Results(filter: filter)
                : _Ideas(onSearch: _searchAgain, onCategory: _chooseCategory),
          ),
        ],
      ),
    );
  }
}

/// Before searching: what to search for.
class _Ideas extends AppView {
  const _Ideas({required this.onSearch, required this.onCategory});

  final ValueChanged<String> onSearch;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final recents = ref.watch(recentSearchesProvider);
    final recentsController = ref.read(recentSearchesProvider.notifier);
    final nearby = ref.watch(nearbyStoresProvider(null));
    final stores = nearby.value ?? const [];
    return SSliverView(
      slivers: [
        const SliverToBoxAdapter(child: Gap(Space.sm)),
        if (categories.isNotEmpty)
          _section(
            SSectionHeader(s.searchCraving),
            SCategoryStrip(
              choices: [
                for (final category in categories)
                  CategoryChoice(
                    label: category.name(language),
                    illustration: CustomerIllustrations.forCategory(
                      category.slug,
                    ),
                    imageUrl: category.iconUrl,
                  ),
              ],
              // None is chosen yet: choosing one searches it.
              selected: -1,
              onSelected: (i) => onCategory(categories[i].id),
            ),
            padded: false,
          ),
        if (recents.isNotEmpty)
          _section(
            SSectionHeader(
              s.searchRecent,
              actionLabel: s.searchClearRecent,
              onAction: recentsController.clear,
            ),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final search in recents)
                  SChip(
                    label: search,
                    onTap: () => onSearch(search),
                    onRemove: () => recentsController.remove(search),
                  ),
              ],
            ),
          ),
        if (stores.isNotEmpty)
          _section(
            SSectionHeader(s.searchStoresNear),
            _StoreTiles(stores.take(nearbyStoresShown).toList()),
          )
        else if (nearby.isLoading)
          _section(
            SSectionHeader(s.searchStoresNear),
            const StoreTilesSkeleton(),
          ),
      ],
    );
  }

  /// A part of the page: its [header] over its [body], the [body] at the
  /// page's sides unless it scrolls sideways to the edges itself.
  static Widget _section(Widget header, Widget body, {bool padded = true}) =>
      SliverPadding(
        padding: const EdgeInsets.only(bottom: Space.xl),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.sm,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                child: header,
              ),
              if (padded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                  child: body,
                )
              else
                body,
            ],
          ),
        ),
      );
}

/// What the search found: the stores first, then the offers.
class _Results extends AppView {
  const _Results({required this.filter});

  final OffersFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final stores = ref.watch(searchStoresProvider);
    return SAsyncView(
      value: ref.watch(searchOffersProvider),
      onRetry: () => ref.invalidate(searchOffersProvider),
      loading: const _ResultsSkeleton(),
      builder: (context, page) {
        final found = stores.value ?? const <StoreSummary>[];
        final offersFound = page.items.isNotEmpty;
        if (!offersFound && found.isEmpty) {
          if (stores.isLoading) return const _ResultsSkeleton();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Filters(filter: filter, offersFound: false),
              Expanded(
                child: SEmptyView(
                  icon: SIcons.noResults,
                  title: s.noResultsTitle,
                  message: s.noResultsMessage,
                ),
              ),
            ],
          );
        }
        // Typed words that found something worth opening are worth
        // keeping.
        void remember() {
          final words = ref.read(searchFilterProvider).search;
          if (words.isNotEmpty) {
            ref.read(recentSearchesProvider.notifier).add(words);
          }
        }

        return OffersPagedList(
          offers: searchOffersProvider,
          page: page,
          onOpen: remember,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.md,
            children: [
              _Filters(filter: filter, offersFound: offersFound),
              if (found.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                  child: SSectionHeader(s.searchStores),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                  child: _StoreTiles(found, onOpen: remember),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.md,
                    Space.lg,
                    0,
                  ),
                  child: offersFound
                      ? SSectionHeader(s.searchOffers)
                      : SText(s.searchNoOffers, color: SColor.textMuted),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// What the search finds while it looks: stores, then offers in the
/// layout picked.
class _ResultsSkeleton extends AppView {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: Space.lg),
          child: StoreTilesSkeleton(count: 2),
        ),
        OfferListSkeleton(
          tiles:
              ref.watch(offersLayoutProvider(OffersPlace.lists)) ==
              OffersLayout.list,
        ),
      ],
    ),
  );
}

/// The kind of store chosen, with the way back from it, and, once there
/// are offers, their sort and layout.
class _Filters extends AppView {
  const _Filters({required this.filter, required this.offersFound});

  final OffersFilter filter;
  final bool offersFound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final controller = ref.read(searchFilterProvider.notifier);
    final category = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.id == filter.categoryId)
        .firstOrNull;
    if (category == null && !offersFound) return const SizedBox.shrink();
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

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: Row(
              spacing: Space.sm,
              children: [
                // Chosen, with the way back to every kind.
                if (category != null)
                  SPill(
                    label: category.name(language),
                    icon: SIcons.close,
                    selected: true,
                    onTap: () => controller.setCategory(null),
                  ),
                if (offersFound)
                  SPill(
                    label: sortName(s, filter.sort),
                    icon: SIcons.sortable,
                    selected: true,
                    activeColor: SColor.text,
                    onTap: chooseSort,
                  ),
              ],
            ),
          ),
        ),
        if (offersFound)
          const Padding(
            padding: EdgeInsetsDirectional.only(end: Space.lg),
            child: OffersLayoutSwitch(),
          ),
      ],
    );
  }
}

/// Stores down the page, a little apart.
class _StoreTiles extends StatelessWidget {
  const _StoreTiles(this.stores, {this.onOpen});

  final List<StoreSummary> stores;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Space.sm,
    children: [for (final store in stores) StoreTile(store, onOpen: onOpen)],
  );
}

String sortName(CustomerLocalizations s, OfferSort sort) => switch (sort) {
  OfferSort.nearest => s.sortNearest,
  OfferSort.endingSoon => s.sortEndingSoon,
  OfferSort.newest => s.sortNewest,
  OfferSort.biggestDiscount => s.sortBiggestDiscount,
};
