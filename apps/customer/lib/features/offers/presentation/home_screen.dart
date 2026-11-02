import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../location/domain/browse_location.dart';
import '../domain/offer.dart';
import 'home_view_model.dart';
import 'widgets/offer_poster.dart';

/// The Home tab: where offers are shown from, search, the kinds of store,
/// then rows of offers around (nearest, ending soon, biggest discount).
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final pinned = ref.watch(browseLocationProvider)?.pinned ?? false;
    final categoryId = ref.watch(homeCategoryProvider);
    final feed = ref.watch(homeFeedProvider);
    return SScaffold(
      showAppBar: false,
      padded: false,
      scrollable: true,
      onRefresh: feed.hasValue
          ? () async {
              ref.invalidate(categoriesProvider);
              final failure = await ref
                  .read(homeFeedProvider.notifier)
                  .refresh();
              if (failure != null && context.mounted) {
                SSnack.error(context, failureMessage(context, failure));
              }
            }
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                SPlaceHeader(
                  caption: s.offersNear,
                  place: pinned ? s.pinnedLocation : s.myLocation,
                  onTap: () => context.push(Routes.location),
                ),
                SSearchField.button(
                  hint: s.searchHint,
                  onTap: () => context.go(Routes.search),
                ),
              ],
            ),
          ),
          const Gap(Space.lg),
          if (ref.watch(categoriesProvider).value case final categories?
              when categories.isNotEmpty)
            _Categories(categories: categories, selected: categoryId),
          const Gap(Space.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: SPromoBanner(
              title: s.bannerTitle,
              message: s.bannerMessage,
              tag: s.bannerTag,
            ),
          ),
          const Gap(Space.xl),
          SAsyncView(
            value: feed,
            onRetry: () => ref.invalidate(homeFeedProvider),
            builder: (context, feed) => feed.isEmpty
                ? SEmptyView(
                    icon: SIcons.offers,
                    title: s.noOffersTitle,
                    message: s.noOffersMessage,
                    actionLabel: s.changePlace,
                    actionIcon: SIcons.location,
                    onAction: () => context.push(Routes.location),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: Space.xl,
                    children: [
                      _Row(
                        title: s.sectionEndingSoon,
                        sort: OfferSort.endingSoon,
                        categoryId: categoryId,
                        offers: feed.endingSoon,
                      ),
                      _Row(
                        title: s.sectionNearby,
                        sort: OfferSort.nearest,
                        categoryId: categoryId,
                        offers: feed.nearby,
                      ),
                      _Row(
                        title: s.sectionBiggestDiscount,
                        sort: OfferSort.biggestDiscount,
                        categoryId: categoryId,
                        offers: feed.biggestDiscount,
                      ),
                    ],
                  ),
          ),
          const Gap(Space.xl),
        ],
      ),
    );
  }
}

/// Every offer, then each kind of store, with the app's pictures for the
/// ones it knows.
class _Categories extends AppView {
  const _Categories({required this.categories, required this.selected});

  final List<Category> categories;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final index = categories.indexWhere((c) => c.id == selected);
    return SCategoryStrip(
      choices: [
        CategoryChoice(
          label: s.allCategories,
          illustration: CustomerIllustrations.categoryAll,
        ),
        for (final category in categories)
          CategoryChoice(
            label: category.name(language),
            illustration: switch (category.slug) {
              'bakery' => CustomerIllustrations.categoryBakery,
              'sweet' => CustomerIllustrations.categorySweets,
              'cafe' => CustomerIllustrations.categoryCafe,
              _ => null,
            },
            imageUrl: category.iconUrl,
          ),
      ],
      selected: index + 1,
      onSelected: (i) => ref
          .read(homeCategoryProvider.notifier)
          .select(i == 0 ? null : categories[i - 1].id),
    );
  }
}

/// One sort of the offers, in a row that scrolls sideways, with the way to
/// all of them.
class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.sort,
    required this.categoryId,
    required this.offers,
  });

  final String title;
  final OfferSort sort;
  final String? categoryId;
  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox.shrink();
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: SSectionHeader(
            title,
            actionLabel: s.seeAll,
            onAction: () => context.push(
              Routes.offersQuery(sort: sort.name, categoryId: categoryId),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.md,
            children: [
              for (final offer in offers) OfferPoster(offer, inRow: true),
            ],
          ),
        ),
      ],
    );
  }
}
