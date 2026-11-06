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

/// One offer: its photo and prices, the store's rating and when to pick it
/// up, the store, how much is left, what it is, how picking up works and
/// where, and the way to reserve it, as many as allowed.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
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
              discountLabel: s.discountOff(detail.offer.discountPercent),
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

/// The page while the offer loads: its photo, title, rating and pickup
/// time, price, store and the first part about it.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) => const SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SBone.wide(),
        Gap(Space.sm),
        SBone.text(variant: TextVariant.display, length: BoneLength.long),
        SBone.text(length: BoneLength.medium),
        SBone.text(variant: TextVariant.title, length: BoneLength.short),
        Gap(Space.md),
        SBone.button(),
        Gap(Space.lg),
        SBone.text(variant: TextVariant.subtitle, length: BoneLength.medium),
        SBone.text(),
        SBone.text(length: BoneLength.long),
      ],
    ),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              SText.display(offer.title),
              const Gap(Space.xs),
              _Facts(offer: offer, now: now),
              const Gap(Space.sm),
              Wrap(
                spacing: Space.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SText(
                    s.price(context, offer.offerPrice),
                    variant: TextVariant.title,
                    weight: SFontWeight.bold,
                    color: SColor.primary,
                  ),
                  SText(
                    s.price(context, offer.originalPrice),
                    color: SColor.textSubtle,
                    struck: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: _StoreRow(store: offer.store),
        ),
        // When it ends is in the facts above.
        if (offer.limited && total != null && total > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: SDealStock(
              label: s.piecesOfTotal(offer.remaining ?? 0, total),
              left: (offer.remaining ?? 0) / total,
            ),
          ),
        if (description.isNotEmpty)
          PageSection(
            title: s.offerPageAbout,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: SText(description, color: SColor.textMuted),
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
        if (detail.branches.isNotEmpty)
          PageSection(
            title: detail.branches.length == 1 ? s.pickupOne : s.pickupAny,
            child: BranchDirections(branches: detail.branches),
          ),
        PageSection(
          title: s.pickupInstructionsTitle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            // Paying is in Good to know: the default only says what
            // happens at the counter.
            child: SText(
              detail.pickupInstructions ?? s.pickupInstructionsDefault,
              color: SColor.textMuted,
            ),
          ),
        ),
        const Gap(Space.xl),
      ],
    );
  }
}

/// The facts to know at a glance, a plain icon before each: the store's
/// rating once it has one, and when to pick up, with the day beside it.
class _Facts extends StatelessWidget {
  const _Facts({required this.offer, required this.now});

  final Offer offer;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.sm,
      children: [
        if (offer.store.rating case final rating?)
          SRating(
            average: rating.average,
            count: rating.count,
            label: s.rating(rating),
          ),
        Row(
          spacing: Space.sm,
          children: [
            const SIcon(
              SIcons.clock,
              size: SIconSize.sm,
              color: SColor.textMuted,
            ),
            Flexible(child: SText(s.pickupTime(context, offer))),
            SBadge(s.pickupDay(context, offer, now)),
          ],
        ),
      ],
    );
  }
}

/// The store, as a row that opens its page.
class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store});

  final OfferStore store;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return SCard(
      padded: false,
      child: SListTile(
        leading: SLogo(store.logoUrl, storeName: store.name),
        title: store.name,
        subtitle: store.category.name(language),
        onTap: () => context.push(Routes.store(store.id)),
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
