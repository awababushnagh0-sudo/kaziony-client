import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/branch_directions.dart';
import '../../../core/widgets/page_section.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../offers/presentation/offer_texts.dart';
import '../../offers/presentation/offers_layout.dart';
import '../../offers/presentation/widgets/offer_card.dart';
import '../../offers/presentation/widgets/offer_card_skeleton.dart';
import '../../offers/presentation/widgets/offers_layout_switch.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

/// A store's page: its cover with its logo, name, rating and kind on it
/// and the heart that saves it to the customer's favorites, its branches
/// with the way there, its offers live now, and what it asks of customers
/// picking up.
class StoreScreen extends AppView {
  const StoreScreen({required this.storeId, super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final store = ref.watch(storeViewModel(storeId));
    final shown = store.value;
    final tiles =
        ref.watch(offersLayoutProvider(OffersPlace.store)) == OffersLayout.list;
    return SScaffold(
      // Loaded, the page opens on the store's cover, whose bar stays
      // pinned with the back button; loading or failing, it keeps the app
      // bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      body: SAsyncView(
        value: store,
        onRetry: () => ref.invalidate(storeViewModel(storeId)),
        loading: _Skeleton(tiles: tiles),
        builder: (context, store) => CustomScrollView(
          slivers: [
            SPhotoHeader(
              title: store.name,
              subtitle: store.category.name(language),
              imageUrl: store.coverUrl,
              caption: _Caption(store: store),
              favorite: _favorite(context, ref, store),
              onBack: context.pop,
            ),
            // Where to go first, as on an offer's page: right under the
            // cover.
            if (store.branches.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.lg,
                    Space.lg,
                    0,
                  ),
                  child: BranchDirections(branches: store.branches),
                ),
              ),
            SliverToBoxAdapter(
              child: PageSection(
                title: s.storeOffersNow,
                trailing: store.offers.isEmpty
                    ? null
                    : const OffersLayoutSwitch(place: OffersPlace.store),
                child: store.offers.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.lg,
                        ),
                        child: SText(s.storeNoOffers, color: SColor.textMuted),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final offer in store.offers)
                            Padding(
                              // Cards and tiles alike are raised: room
                              // apart for their shadows.
                              padding: const EdgeInsets.fromLTRB(
                                Space.lg,
                                0,
                                Space.lg,
                                Space.md,
                              ),
                              child: OfferCard(
                                offer,
                                inStore: true,
                                shape: tiles
                                    ? OfferCardShape.tile
                                    : OfferCardShape.card,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            if (store.pickupInstructions case final instructions?)
              SliverToBoxAdapter(
                child: PageSection(
                  title: s.pickupInstructionsTitle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                    child: SText(instructions, color: SColor.textMuted),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: Gap(Space.xl)),
          ],
        ),
      ),
    );
  }
}

/// The page while the store loads: its cover, its closest branch, and its
/// first offers in the layout picked.
class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.tiles});

  final bool tiles;

  @override
  Widget build(BuildContext context) {
    final offer = OfferCardSkeleton(
      shape: tiles ? OfferCardShape.tile : OfferCardShape.card,
    );
    return SSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.sm,
        children: [
          const SBone.wide(),
          const Gap(Space.sm),
          const Row(
            spacing: Space.md,
            children: [
              SBone.image(size: SImageSize.logoOnPhoto),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    SBone.text(length: BoneLength.medium),
                    SBone.text(
                      variant: TextVariant.caption,
                      length: BoneLength.long,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(Space.lg),
          const SBone.text(
            variant: TextVariant.subtitle,
            length: BoneLength.medium,
          ),
          offer,
          offer,
        ],
      ),
    );
  }
}

/// On the cover's foot: the store's logo beside its name, and its rating
/// and kind under the name.
class _Caption extends StatelessWidget {
  const _Caption({required this.store});

  final StoreDetail store;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return Row(
      spacing: Space.md,
      children: [
        SLogo(store.logoUrl, storeName: store.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: Space.xxs,
            children: [
              SText.display(store.name, color: SColor.onScrim),
              Wrap(
                spacing: Space.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (store.rating case final rating?)
                    SRating(
                      average: rating.average,
                      count: rating.count,
                      label: s.rating(rating),
                      onPhoto: true,
                    ),
                  SText(store.category.name(language), color: SColor.onScrim),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The heart on the cover: saves the store to the customer's favorites,
/// or takes it out; a guest is asked to sign in first.
PhotoHeaderFavorite _favorite(
  BuildContext context,
  WidgetRef ref,
  StoreDetail store,
) {
  final s = CustomerLocalizations.of(context);
  final saved = store.isFollowing;
  if (ref.watch(sessionProvider) is! SignedIn || saved == null) {
    return PhotoHeaderFavorite(
      saved: false,
      tooltip: s.storeAddFavorite,
      onPressed: () => SignInPrompt.show(
        context,
        title: s.storeFavoriteSignInTitle,
        message: s.storeFavoriteSignInMessage,
      ),
    );
  }
  return PhotoHeaderFavorite(
    saved: saved,
    tooltip: saved ? s.storeRemoveFavorite : s.storeAddFavorite,
    onPressed: () async {
      final failure = await ref
          .read(storeViewModel(store.id).notifier)
          .toggleFollow();
      if (failure != null && context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    },
  );
}
