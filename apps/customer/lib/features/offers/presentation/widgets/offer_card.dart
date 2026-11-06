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
    this.onOpen,
    super.key,
  });

  final Offer offer;
  final OfferCardShape shape;

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
        child: _Boxed(offer: offer, now: now),
      ),
      OfferCardShape.tile => SCard(
        onTap: open,
        child: _Tile(offer: offer, now: now),
      ),
    };
  }
}

/// The photo inset at the top of a card, flat where the words meet it:
/// how many are left on a tag at its top, the store's logo and the
/// discount at its foot. Under it the title across, then when to pick up
/// and the rating and how far, the prices beside those two.
class _Boxed extends StatelessWidget {
  const _Boxed({required this.offer, required this.now});

  final Offer offer;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final left = offer.remaining ?? 0;
    final rating = offer.store.rating;
    final km = offer.nearestBranch.distanceKm;
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
                  // White, to read on any photo; orange words once
                  // almost gone.
                  child: SBadge(
                    s.piecesLeft(left),
                    tone: offer.almostGone
                        ? BadgeTone.onPhotoHot
                        : BadgeTone.onPhoto,
                    edge: BadgeEdge.start,
                  ),
                ),
              // The logo stands for the store; its name is for screen
              // readers.
              PositionedDirectional(
                bottom: Space.sm,
                start: Space.sm,
                child: SLogo(offer.store.logoUrl, storeName: offer.store.name),
              ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                child: SBadge(
                  s.discountOff(offer.discountPercent),
                  tone: BadgeTone.brand,
                  edge: BadgeEdge.end,
                ),
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
              Row(
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
                        // Each only once known: a new store has no
                        // rating, and the distance needs the customer's
                        // place.
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A small photo at the start with the discount on its corner, the words
/// beside it, in an outlined box.
class _Tile extends StatelessWidget {
  const _Tile({required this.offer, required this.now});

  final Offer offer;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final stock = s.stock(offer);
    return Row(
      spacing: Space.md,
      children: [
        SDealPhoto(
          offer.thumbUrl ?? offer.imageUrl,
          size: SImageSize.tile,
          discount: s.discountOff(offer.discountPercent),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xxs,
            children: [
              Row(
                spacing: Space.sm,
                children: [
                  Expanded(child: _Title(offer.title)),
                  if (stock != null) SBadge(stock, tone: BadgeTone.warning),
                ],
              ),
              SText(
                offer.store.name,
                variant: TextVariant.caption,
                color: SColor.textMuted,
                maxLines: 1,
              ),
              _Fact(
                icon: SIcons.clock,
                text: s.details(context, offer, now).join(' · '),
              ),
              Row(
                spacing: Space.sm,
                children: [
                  _Price(s.price(context, offer.offerPrice)),
                  _WasPrice(s.price(context, offer.originalPrice)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
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
