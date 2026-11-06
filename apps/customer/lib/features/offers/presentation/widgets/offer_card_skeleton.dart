import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import 'offer_card.dart';

/// An [OfferCard] in [shape] while it loads: its photo and lines where the
/// words will be. Bones only: it shimmers under an `SSkeleton`, its own
/// unless it's in one already.
class OfferCardSkeleton extends StatelessWidget {
  const OfferCardSkeleton({this.shape = OfferCardShape.card, super.key});

  final OfferCardShape shape;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: switch (shape) {
      OfferCardShape.card => const _Boxed(),
      OfferCardShape.tile => const _Tile(),
    },
  );
}

/// Offers in a list, a screen's worth of them, cards or tiles.
class OfferListSkeleton extends StatelessWidget {
  const OfferListSkeleton({required this.tiles, super.key});

  final bool tiles;

  /// Enough to fill a tall phone; the rest is cut.
  static const _count = 6;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: tiles ? Space.sm : Space.lg,
        children: [
          for (var i = 0; i < _count; i++)
            OfferCardSkeleton(
              shape: tiles ? OfferCardShape.tile : OfferCardShape.card,
            ),
        ],
      ),
    ),
  );
}

class _Boxed extends StatelessWidget {
  const _Boxed();

  @override
  Widget build(BuildContext context) => const SCard.raised(
    padded: false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Space.xs, Space.xs, Space.xs, 0),
          child: SBone.wide(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(Space.md, Space.xs, Space.md, Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBone.text(
                variant: TextVariant.subtitle,
                length: BoneLength.long,
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
                        SBone.text(variant: TextVariant.caption),
                        SBone.text(
                          variant: TextVariant.caption,
                          length: BoneLength.medium,
                        ),
                      ],
                    ),
                  ),
                  // Where the prices go.
                  SBone.badge(),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile();

  @override
  Widget build(BuildContext context) => const SCard(
    child: Row(
      spacing: Space.md,
      children: [
        SBone.image(size: SImageSize.tile),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xxs,
            children: [
              SBone.text(length: BoneLength.long),
              SBone.text(
                variant: TextVariant.caption,
                length: BoneLength.medium,
              ),
              SBone.text(variant: TextVariant.caption),
              SBone.text(
                variant: TextVariant.subtitle,
                length: BoneLength.short,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
