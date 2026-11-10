import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import 'offer_card.dart';

/// An [OfferCard] while it loads: its photo and lines where the words and
/// the bar will be. It shimmers under an `SSkeleton`, its own unless it's in
/// one already.
class OfferCardSkeleton extends StatelessWidget {
  const OfferCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const SSkeleton(
    child: SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SBone.image(size: SImageSize.thumb),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SBone.text(
                      variant: TextVariant.subtitle,
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
          SBone.text(variant: TextVariant.caption, length: BoneLength.full),
          SBone.text(variant: TextVariant.caption, length: BoneLength.full),
        ],
      ),
    ),
  );
}

/// The Offers tab's list while it loads, a screen's worth of cards.
class OfferListSkeleton extends StatelessWidget {
  const OfferListSkeleton({super.key});

  /// Enough to fill a tall phone; the rest is cut.
  static const _count = 6;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.sm,
        children: [for (var i = 0; i < _count; i++) const OfferCardSkeleton()],
      ),
    ),
  );
}
