import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../../core/widgets/no_offers_view.dart';
import '../../location/domain/browse_location.dart';
import '../../stores/domain/store.dart';
import '../../stores/presentation/stores_view_model.dart';
import '../../stores/presentation/widgets/store_logo_row.dart';
import '../../stores/presentation/widgets/store_logo_row_skeleton.dart';
import '../domain/offer.dart';
import 'home_view_model.dart';
import 'offer_texts.dart';
import 'widgets/offer_card.dart';
import 'widgets/offer_card_skeleton.dart';

/// The Home tab: where offers are shown from, search, the kinds of store,
/// a few words about the app, then rows of offers around (ending soon,
/// nearest, biggest discount) with the stores near you between them, your
/// favorite stores under them, and the way to every offer.
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
      body: SSliverView(
        onRefresh: feed.hasValue
            ? () async {
                ref
                  ..invalidate(categoriesProvider)
                  ..invalidate(nearbyStoresProvider)
                  ..invalidate(favoriteStoresViewModel);
                final failure = await ref
                    .read(homeFeedProvider.notifier)
                    .refresh();
                if (failure != null && context.mounted) {
                  SSnack.error(context, failureMessage(context, failure));
                }
              }
            : null,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            sliver: SliverToBoxAdapter(
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
          ),
          switch (ref.watch(categoriesProvider)) {
            AsyncValue(value: final categories?) when categories.isNotEmpty =>
              SliverPadding(
                padding: const EdgeInsets.only(top: Space.lg),
                sliver: SliverToBoxAdapter(
                  child: _Categories(
                    categories: categories,
                    selected: categoryId,
                  ),
                ),
              ),
            AsyncValue(isLoading: true, hasValue: false) => const SliverPadding(
              padding: EdgeInsets.only(top: Space.lg),
              sliver: SliverToBoxAdapter(child: _CategoriesSkeleton()),
            ),
            _ => const SliverToBoxAdapter(),
          },
          const SliverPadding(
            padding: EdgeInsets.only(top: Space.lg),
            sliver: SliverToBoxAdapter(child: _AboutBanners()),
          ),
          switch (feed) {
            // Loading the first time, or again for another kind of store
            // (the old rows are for the kind just left). Pulling down to
            // refresh keeps the rows instead.
            AsyncLoading() => const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: Space.xl),
              sliver: SliverToBoxAdapter(child: _SectionsSkeleton()),
            ),
            AsyncData(:final value) when !value.isEmpty => SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: Space.xl),
              sliver: _Sections(feed: value, categoryId: categoryId),
            ),
            _ => SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: Space.xl),
                child: SAsyncView(
                  value: feed,
                  onRetry: () => ref.invalidate(homeFeedProvider),
                  builder: (_, _) => const NoOffersView(),
                ),
              ),
            ),
          },
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

/// The kinds of store while they load: their pictures and names, in the
/// middle.
class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  /// About what a phone shows across.
  static const _count = 4;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < _count; i++)
          const Column(
            spacing: Space.xs,
            children: [
              SBone.image(size: SImageSize.deal),
              SBone.badge(),
            ],
          ),
      ],
    ),
  );
}

/// How the app works, in a few banners. A plain list, so ads from the
/// server can take their place.
class _AboutBanners extends StatelessWidget {
  const _AboutBanners();

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return SPromoCarousel(
      banners: [
        PromoBanner(
          title: s.homeBannerRescueTitle,
          message: s.homeBannerRescueMessage,
          illustration: CustomerIllustrations.bagSleep,
        ),
        PromoBanner(
          title: s.homeBannerPickupTitle,
          message: s.homeBannerPickupMessage,
          illustration: CustomerIllustrations.location,
          tone: PromoTone.green,
        ),
        PromoBanner(
          title: s.homeBannerCashTitle,
          message: s.homeBannerCashMessage,
          illustration: CustomerIllustrations.guest,
          tone: PromoTone.orange,
        ),
      ],
    );
  }
}

/// The rows of offers with the stores near the customer between them
/// (the stores follow the category too), their favorite stores under the
/// last row, and the way to every offer at the end. A row with nothing in
/// it is left out.
class _Sections extends AppView {
  const _Sections({required this.feed, required this.categoryId});

  final HomeFeed feed;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    // Stores add to the offers: while they load, or if they fail, the
    // page goes on without them.
    final nearbyStores =
        ref.watch(nearbyStoresProvider(categoryId)).value ??
        const <StoreSummary>[];
    final followedStores =
        ref.watch(favoriteStoresViewModel).value ?? const <StoreSummary>[];
    final sections = [
      if (feed.endingSoon.isNotEmpty)
        _OfferRow(
          sort: OfferSort.endingSoon,
          categoryId: categoryId,
          offers: feed.endingSoon,
        ),
      if (nearbyStores.isNotEmpty)
        StoreLogoRow(title: s.homeStoresNearby, stores: nearbyStores),
      _OfferRow(
        sort: OfferSort.nearest,
        categoryId: categoryId,
        offers: feed.nearby,
      ),
      if (feed.biggestDiscount.isNotEmpty)
        _OfferRow(
          sort: OfferSort.biggestDiscount,
          categoryId: categoryId,
          offers: feed.biggestDiscount,
        ),
      // The customer's own stores close the page, where they look once
      // the offers run out.
      if (followedStores.isNotEmpty)
        StoreLogoRow(title: s.homeFavoriteStores, stores: followedStores),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        child: _AllOffers(total: feed.total, categoryId: categoryId),
      ),
    ];
    return SliverList.separated(
      itemCount: sections.length,
      itemBuilder: (_, i) => sections[i],
      separatorBuilder: (_, _) => const Gap(Space.xl),
    );
  }
}

/// The rows while the offers load: two rows of offers with a row of
/// stores between them.
class _SectionsSkeleton extends StatelessWidget {
  const _SectionsSkeleton();

  @override
  Widget build(BuildContext context) => const SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        _OfferRowSkeleton(),
        StoreLogoRowSkeleton(),
        _OfferRowSkeleton(),
      ],
    ),
  );
}

class _OfferRowSkeleton extends StatelessWidget {
  const _OfferRowSkeleton();

  /// More than a phone shows across.
  static const _count = 3;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Space.md,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: Space.lg),
        child: SBone.text(
          variant: TextVariant.subtitle,
          length: BoneLength.medium,
        ),
      ),
      SCarousel(
        children: [
          for (var i = 0; i < _count; i++)
            const OfferCardSkeleton(shape: OfferCardShape.card),
        ],
      ),
    ],
  );
}

/// One sort of the offers, in a row that scrolls sideways, with the way
/// to all of them.
class _OfferRow extends StatelessWidget {
  const _OfferRow({
    required this.sort,
    required this.categoryId,
    required this.offers,
  });

  final OfferSort sort;
  final String? categoryId;
  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: SSectionHeader(
            s.section(sort),
            actionLabel: s.seeAll,
            onAction: () => context.push(
              Routes.offersQuery(sort: sort.name, categoryId: categoryId),
            ),
          ),
        ),
        SCarousel(
          children: [
            for (final offer in offers)
              OfferCard(offer, shape: OfferCardShape.card),
          ],
        ),
      ],
    );
  }
}

/// The way to every offer around, newest first: a picture and how many
/// there are, instead of a long list down the page.
class _AllOffers extends StatelessWidget {
  const _AllOffers({required this.total, required this.categoryId});

  final int total;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return SCard(
      onTap: () => context.push(
        Routes.offersQuery(sort: OfferSort.newest.name, categoryId: categoryId),
      ),
      child: Row(
        spacing: Space.md,
        children: [
          const SIllustration(CustomerIllustrations.kraftBag),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xs,
              children: [
                SText(
                  s.homeAllOffersTitle,
                  variant: TextVariant.subtitle,
                  weight: SFontWeight.bold,
                ),
                SText(
                  s.homeAllOffersCount(total),
                  variant: TextVariant.caption,
                  color: SColor.textMuted,
                ),
              ],
            ),
          ),
          const SIcon(
            SIcons.chevron,
            size: SIconSize.sm,
            color: SColor.textSubtle,
          ),
        ],
      ),
    );
  }
}
