import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../../../../core/routes/routes.dart';
import '../../domain/offer.dart';
import '../offer_texts.dart';

/// How an offer's card looks: the same card in a home row and in a list,
/// so an offer is recognized wherever it shows; tiles where the customer
/// picked a list (`OffersLayoutSwitch`).
enum OfferCardShape {
  /// A raised card, its photo inside with what's left, the logo and the
  /// discount on it; under it the title, when to pick up, the rating and
  /// how far, and the prices. In a home row that scrolls sideways (an
  /// `SCarousel`), or a list's width.
  card,

  /// In a list shown as tiles: a small photo, the discount on its corner,
  /// beside the words; more offers to a screen.
  tile,
}

/// An offer in one of its [OfferCardShape]s; opens its page.
class OfferCard extends AppView {
  const OfferCard(
    this.offer, {
    this.shape = OfferCardShape.card,
    this.inStore = false,
    this.onOpen,
    super.key,
  });

  final Offer offer;
  final OfferCardShape shape;

  /// On the store's own page: its logo, name and rating are on the page
  /// already, so the card leaves them out.
  final bool inStore;

  /// Told when it's opened, before the offer's page shows.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    void open() {
      onOpen?.call();
      context.push(Routes.offer(offer.id));
    }

    return switch (shape) {
      OfferCardShape.card => SCard.raised(
        onTap: open,
        padded: false,
        child: _Boxed(offer: offer, now: now, inStore: inStore),
      ),
      OfferCardShape.tile => SCard.raised(
        onTap: open,
        padded: false,
        child: _Tile(offer: offer, now: now, inStore: inStore),
      ),
    };
  }
}

/// The photo inset at the top of a card, flat where the words meet it:
/// how many are left on a tag at its top, the store's logo and the
/// discount at its foot (no logo [inStore]). Under it the title across, then when to pick up
/// and the rating and how far, the prices beside those two.
class _Boxed extends StatelessWidget {
  const _Boxed({required this.offer, required this.now, required this.inStore});

  final Offer offer;
  final DateTime now;
  final bool inStore;

  @override
  Widget build(BuildContext context) {
    final left = offer.remaining ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xs, Space.xs, Space.xs, 0),
          child: Stack(
            children: [
              SImage.wide(offer.imageUrl, corners: SImageCorners.top),
              // On every counted offer: in a row, it's what makes one
              // worth opening before another.
              if (offer.limited && left > 0)
                PositionedDirectional(
                  top: Space.sm,
                  start: 0,
                  child: _LeftTag(offer: offer, left: left),
                ),
              // The logo stands for the store; its name is for screen
              // readers.
              if (!inStore)
                PositionedDirectional(
                  bottom: Space.sm,
                  start: Space.sm,
                  child: SLogo(
                    offer.store.logoUrl,
                    storeName: offer.store.name,
                  ),
                ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                child: _DiscountTag(offer, edge: BadgeEdge.end),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.xs,
            Space.md,
            Space.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SText(
                offer.title,
                variant: TextVariant.subtitle,
                weight: SFontWeight.bold,
                maxLines: 1,
              ),
              _Facts(offer: offer, now: now, inStore: inStore),
            ],
          ),
        ),
      ],
    );
  }
}

/// A square photo at the start, with the card's tags against its edge:
/// how many are left at its top, the discount at its foot. Beside it the
/// title, the store (not [inStore]), then when to pick up and the rating and how far, the
/// prices beside those two, as on the card.
class _Tile extends StatelessWidget {
  const _Tile({required this.offer, required this.now, required this.inStore});

  final Offer offer;
  final DateTime now;
  final bool inStore;

  @override
  Widget build(BuildContext context) {
    final left = offer.remaining ?? 0;
    return Padding(
      padding: const EdgeInsets.all(Space.sm),
      child: Row(
        spacing: Space.md,
        children: [
          Stack(
            children: [
              SImage(offer.thumbUrl ?? offer.imageUrl, size: SImageSize.tile),
              if (offer.limited && left > 0)
                PositionedDirectional(
                  top: Space.sm,
                  start: 0,
                  child: _LeftTag(offer: offer, left: left),
                ),
              PositionedDirectional(
                bottom: Space.sm,
                start: 0,
                child: _DiscountTag(offer, edge: BadgeEdge.start),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(offer.title),
                if (!inStore)
                  SText(
                    offer.store.name,
                    variant: TextVariant.caption,
                    color: SColor.textMuted,
                    maxLines: 1,
                  ),
                const Gap(Space.xxs),
                _Facts(offer: offer, now: now, inStore: inStore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// When to pick up, then the store's rating (not [inStore]) and how far,
/// with the prices beside those two lines.
class _Facts extends StatelessWidget {
  const _Facts({required this.offer, required this.now, required this.inStore});

  final Offer offer;
  final DateTime now;
  final bool inStore;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final rating = inStore ? null : offer.store.rating;
    final km = offer.nearestBranch.distanceKm;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: Space.md,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xxs,
            children: [
              _Fact(
                icon: SIcons.clock,
                text: s.cardPickup(context, offer, now),
              ),
              // Each only once known: a new store has no rating, and the
              // distance needs the customer's place.
              if (rating != null || km != null)
                Row(
                  spacing: Space.sm,
                  children: [
                    if (rating != null)
                      SRating(
                        average: rating.average,
                        label: s.rating(rating),
                        small: true,
                      ),
                    if (rating != null && km != null)
                      const SText(
                        '|',
                        variant: TextVariant.caption,
                        color: SColor.textSubtle,
                      ),
                    if (km != null)
                      Flexible(
                        child: SText(
                          s.distance(km),
                          variant: TextVariant.caption,
                          weight: SFontWeight.semibold,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        _Prices(offer),
      ],
    );
  }
}

/// "3 left" against a photo's edge: white, to read on any photo; orange
/// words once almost gone.
class _LeftTag extends StatelessWidget {
  const _LeftTag({required this.offer, required this.left});

  final Offer offer;
  final int left;

  @override
  Widget build(BuildContext context) => SBadge(
    CustomerLocalizations.of(context).piecesLeft(left),
    tone: offer.almostGone ? BadgeTone.onPhotoHot : BadgeTone.onPhoto,
    edge: BadgeEdge.start,
  );
}

/// The discount against a photo's [edge], in the brand's green.
class _DiscountTag extends StatelessWidget {
  const _DiscountTag(this.offer, {required this.edge});

  final Offer offer;
  final BadgeEdge edge;

  @override
  Widget build(BuildContext context) => SBadge(
    CustomerLocalizations.of(context).discountOff(offer.discountPercent),
    tone: BadgeTone.brand,
    edge: edge,
  );
}

/// One line: people see the photo and the start of the title, and open
/// the offer for the rest.
class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) =>
      SText(title, weight: SFontWeight.bold, maxLines: 1);
}

/// A short fact after its [icon]: when it ends, how far.
class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final SIcons icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    spacing: Space.xs,
    children: [
      SIcon(icon, size: SIconSize.xs, color: SColor.textSubtle),
      Flexible(
        child: SText(
          text,
          variant: TextVariant.caption,
          color: SColor.textMuted,
          maxLines: 1,
        ),
      ),
    ],
  );
}

/// The offer price under the regular one, crossed out.
class _Prices extends StatelessWidget {
  const _Prices(this.offer);

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _WasPrice(s.price(context, offer.originalPrice)),
        _Price(s.price(context, offer.offerPrice)),
      ],
    );
  }
}

class _Price extends StatelessWidget {
  const _Price(this.price);

  final String price;

  @override
  Widget build(BuildContext context) => SText(
    price,
    variant: TextVariant.subtitle,
    weight: SFontWeight.bold,
    color: SColor.primary,
  );
}

class _WasPrice extends StatelessWidget {
  const _WasPrice(this.price);

  final String price;

  @override
  Widget build(BuildContext context) => SText(
    price,
    variant: TextVariant.caption,
    color: SColor.textSubtle,
    struck: true,
  );
}
