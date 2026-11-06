import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/branch_directions.dart';
import '../../../core/widgets/page_section.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../bookings/presentation/reserve_sheet.dart';
import '../../bookings/presentation/reserve_view_model.dart';
import '../domain/offer.dart';
import 'offer_texts.dart';
import 'offer_view_model.dart';

/// One offer: its photo with its name and prices on it, when to pick up
/// and how many are left, the store with its rating and how far, where to
/// pick up, what it is, how picking up works, and the way to reserve it, as many as
/// allowed.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(offerViewModel(offerId));
    final shown = detail.value;
    return SScaffold(
      // Loaded, the page opens on the offer's photo, whose bar stays
      // pinned with the back button; loading or failing, it keeps the app
      // bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      bottom: shown == null ? null : _Footer(detail: shown),
      body: SAsyncView(
        value: detail,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        loading: const _Skeleton(),
        builder: (context, detail) => CustomScrollView(
          slivers: [
            SPhotoHeader(
              title: detail.offer.title,
              subtitle: detail.offer.store.name,
              trailing: detail.offer.limited
                  ? _StockBadge(offer: detail.offer)
                  : null,
              imageUrl: detail.offer.imageUrl,
              caption: _Caption(offer: detail.offer),
              onBack: context.pop,
            ),
            SliverToBoxAdapter(child: _Body(detail: detail)),
          ],
        ),
      ),
    );
  }
}

/// How many are left, for the folded bar: orange once almost gone, red
/// once gone. Only for an offer that's counted.
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final left = offer.remaining ?? 0;
    return SBadge(
      left > 0 ? s.piecesLeft(left) : s.soldOut,
      tone: left < 1
          ? BadgeTone.danger
          : offer.almostGone
          ? BadgeTone.warning
          : BadgeTone.neutral,
    );
  }
}

/// The page while the offer loads: its photo, the two facts, the store's
/// box and the branches' box, then the first part about it.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) => const SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SBone.wide(),
        Row(
          spacing: Space.md,
          children: [
            Expanded(child: SBone.button()),
            Expanded(child: SBone.button()),
          ],
        ),
        _BoxBone(),
        _BoxBone(),
        Gap(Space.sm),
        SBone.text(variant: TextVariant.subtitle, length: BoneLength.medium),
        SBone.text(),
        SBone.text(length: BoneLength.long),
      ],
    ),
  );
}

/// A box's bones: its picture, and two lines beside it.
class _BoxBone extends StatelessWidget {
  const _BoxBone();

  @override
  Widget build(BuildContext context) => const Row(
    spacing: Space.md,
    children: [
      SBone.image(size: SImageSize.logoOnPhoto),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Space.xxs,
          children: [
            SBone.text(length: BoneLength.medium),
            SBone.text(variant: TextVariant.caption, length: BoneLength.long),
          ],
        ),
      ),
    ],
  );
}

class _Body extends AppView {
  const _Body({required this.detail});

  final OfferDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final offer = detail.offer;
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final description = offer.description?.trim() ?? '';
    final total = offer.total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The two things to plan around, side by side: when to come, and
        // how many are left.
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                Expanded(
                  child: _FactBox(
                    icon: SIcons.clock,
                    label: s.offerFactPickup,
                    value: s.cardPickup(context, offer, now),
                  ),
                ),
                if (offer.limited && total != null && total > 0)
                  Expanded(
                    child: _FactBox(
                      icon: SIcons.products,
                      label: s.offerFactLeft,
                      value: s.offerFactLeftValue(offer.remaining ?? 0, total),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
          child: _StoreCard(offer: offer),
        ),
        // Where to go, right under who: the first thing to know after the
        // offer itself.
        if (detail.branches.isNotEmpty) ...[
          const Gap(Space.md),
          BranchDirections(branches: detail.branches),
        ],
        if (description.isNotEmpty)
          PageSection(
            title: s.offerPageAbout,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: SText(description),
            ),
          ),
        PageSection(
          title: s.offerPageGoodToKnow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (offer.limited)
                SListTile(
                  icon: SIcons.hourglass,
                  title: s.holdTitle(offer.claimWindowMinutes),
                  subtitle: s.holdMessage,
                )
              else
                SListTile(
                  icon: SIcons.hourglass,
                  title: s.untilEndTitle,
                  subtitle: s.untilEndMessage,
                ),
              SListTile(
                icon: SIcons.cash,
                title: s.payTitle,
                subtitle: s.payMessage,
              ),
              if (offer.maxPerUser case final most?)
                SListTile(icon: SIcons.user, title: s.limitPerCustomer(most)),
            ],
          ),
        ),
        PageSection(
          title: s.pickupInstructionsTitle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            // Paying is in Good to know: the default only says what
            // happens at the counter.
            child: SText(
              detail.pickupInstructions ?? s.pickupInstructionsDefault,
            ),
          ),
        ),
        const Gap(Space.xl),
      ],
    );
  }
}

/// On the photo's foot, in white over its shade: the offer's name, and
/// its price beside the regular one and the discount.
class _Caption extends StatelessWidget {
  const _Caption({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Space.xs,
      children: [
        SText.display(offer.title, color: SColor.onScrim),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SText(
              s.price(context, offer.offerPrice),
              variant: TextVariant.title,
              weight: SFontWeight.bold,
              color: SColor.onScrimBrand,
            ),
            SText(
              s.price(context, offer.originalPrice),
              color: SColor.onScrim,
              struck: true,
            ),
            SBadge(
              s.discountOff(offer.discountPercent),
              tone: BadgeTone.brand,
              size: BadgeSize.large,
            ),
          ],
        ),
      ],
    );
  }
}

/// One thing to plan around in an outlined box: its icon and what it is,
/// then the value, bold.
class _FactBox extends StatelessWidget {
  const _FactBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  final SIcons icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SCard(
    padded: false,
    child: Padding(
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Space.xs,
        children: [
          Row(
            spacing: Space.xs,
            children: [
              SIcon(icon, size: SIconSize.sm, color: SColor.textMuted),
              SText(
                label,
                variant: TextVariant.caption,
                color: SColor.textMuted,
              ),
            ],
          ),
          SText(value, weight: SFontWeight.bold),
        ],
      ),
    ),
  );
}

/// The store, as a row that opens its page.
/// The store: its logo, its name, then its rating, kind and how far its
/// nearest branch is; opens its page.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final store = offer.store;
    final rating = store.rating;
    final km = offer.nearestBranch.distanceKm;
    const dot = SText(
      '·',
      variant: TextVariant.caption,
      color: SColor.textSubtle,
    );
    return SCard(
      padded: false,
      onTap: () => context.push(Routes.store(store.id)),
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Row(
          spacing: Space.md,
          children: [
            SLogo(store.logoUrl, storeName: store.name),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Space.xxs,
                children: [
                  SText(store.name, weight: SFontWeight.bold, maxLines: 1),
                  Wrap(
                    spacing: Space.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (rating != null) ...[
                        SRating(
                          average: rating.average,
                          count: rating.count,
                          label: s.rating(rating),
                          small: true,
                        ),
                        dot,
                      ],
                      SText(
                        store.category.name(language),
                        variant: TextVariant.caption,
                        color: SColor.textMuted,
                      ),
                      if (km != null) ...[
                        dot,
                        SText(
                          s.distance(km),
                          variant: TextVariant.caption,
                          color: SColor.textMuted,
                        ),
                      ],
                    ],
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
      ),
    );
  }
}

/// The way to reserve, with how many beside it when more than one can be
/// taken: signing in first, or the pickup code once reserved.
class _Footer extends AppView {
  const _Footer({required this.detail});

  final OfferDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final offer = detail.offer;
    if (detail.myBookingId case final id?) {
      return SDealFooter(
        action: SButton(
          label: s.showMyCode,
          expand: true,
          onPressed: () => context.push(Routes.booking(id)),
        ),
      );
    }
    if (offer.maxReservable < 1) {
      return SDealFooter(
        action: SButton(label: s.soldOut, expand: true, onPressed: null),
      );
    }
    final signedIn = ref.watch(sessionProvider) is SignedIn;
    final quantity = ref.watch(reserveViewModel(offer)).quantity;
    return SDealFooter(
      quantity: offer.maxReservable > 1
          ? SQuantityInput(
              value: quantity,
              max: offer.maxReservable,
              onChanged: ref.read(reserveViewModel(offer).notifier).setQuantity,
            )
          : null,
      action: SButton(
        label: quantity > 1 ? s.offerPageReserveCount(quantity) : s.reserveNow,
        expand: true,
        onPressed: signedIn
            ? () => reserve(context, ref, offer)
            : () => SignInPrompt.show(
                context,
                title: s.reserveSignInTitle,
                message: s.reserveSignInMessage,
              ),
      ),
    );
  }
}
