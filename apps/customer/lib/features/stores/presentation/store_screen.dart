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
import '../domain/store.dart';
import 'store_view_model.dart';

/// A store's page: its cover and logo, its name, rating, kind and
/// followers with the way to follow it, what it says about itself, its
/// offers live now, its branches with the way there, and what it asks of
/// customers picking up.
class StoreScreen extends AppView {
  const StoreScreen({required this.storeId, super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final store = ref.watch(storeViewModel(storeId));
    final shown = store.value;
    final tiles = ref.watch(offersLayoutProvider) == OffersLayout.list;
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
              imageUrl: store.coverUrl,
              logo: PhotoHeaderLogo(store.logoUrl, storeName: store.name),
              onBack: context.pop,
            ),
            SliverToBoxAdapter(child: _About(store: store)),
            SliverToBoxAdapter(
              child: PageSection(
                title: s.storeOffersNow,
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
                              // Cards have no box around them, so they need
                              // more room apart than tiles do.
                              padding: EdgeInsets.fromLTRB(
                                Space.lg,
                                0,
                                Space.lg,
                                tiles ? Space.sm : Space.md,
                              ),
                              child: OfferCard(
                                offer,
                                shape: tiles
                                    ? OfferCardShape.tile
                                    : OfferCardShape.card,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            if (store.branches.isNotEmpty)
              SliverToBoxAdapter(
                child: PageSection(
                  title: s.storeBranches,
                  child: BranchDirections(branches: store.branches),
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

/// The page while the store loads: its cover, logo and name, a few
/// lines about it, and its first offers in the layout picked.
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
                    SBone.text(
                      variant: TextVariant.title,
                      length: BoneLength.long,
                    ),
                    SBone.text(
                      variant: TextVariant.caption,
                      length: BoneLength.medium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(Space.sm),
          const SBone.text(),
          const SBone.text(length: BoneLength.long),
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

/// The store's name, rating, kind and followers beside the way to follow
/// it, and what it says about itself when it has.
class _About extends StatelessWidget {
  const _About({required this.store});

  final StoreDetail store;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final description = store.description;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    SText.display(store.name),
                    Wrap(
                      spacing: Space.md,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (store.rating case final rating?)
                          SRating(
                            average: rating.average,
                            count: rating.count,
                            label: s.rating(rating),
                          ),
                        SText(
                          [
                            store.category.name(language),
                            s.storeFollowers(store.followerCount),
                          ].join(' · '),
                          color: SColor.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _FollowButton(store: store),
            ],
          ),
          if (description != null && description.isNotEmpty)
            SText(description, color: SColor.textMuted),
        ],
      ),
    );
  }
}

/// Follow, or Following to stop; a guest is asked to sign in first.
class _FollowButton extends AppView {
  const _FollowButton({required this.store});

  final StoreDetail store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final signedIn = ref.watch(sessionProvider) is SignedIn;
    Future<void> toggle() async {
      final failure = await ref
          .read(storeViewModel(store.id).notifier)
          .toggleFollow();
      if (failure != null && context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    if (!signedIn || store.isFollowing == null) {
      return SButton(
        label: s.storeFollow,
        icon: SIcons.add,
        onPressed: () => SignInPrompt.show(
          context,
          title: s.storeFollowSignInTitle,
          message: s.storeFollowSignInMessage,
        ),
      );
    }
    return store.isFollowing == true
        ? SButton.secondary(
            label: s.storeFollowing,
            icon: SIcons.check,
            onPressed: toggle,
          )
        : SButton(label: s.storeFollow, icon: SIcons.add, onPressed: toggle);
  }
}
