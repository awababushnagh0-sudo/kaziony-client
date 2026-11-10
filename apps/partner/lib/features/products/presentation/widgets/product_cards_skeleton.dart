import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import 'product_card.dart';

/// [lines] of the Products tab's grid while products load, two
/// [ProductCard]s' bones each.
class ProductCardsSkeleton extends StatelessWidget {
  const ProductCardsSkeleton({this.lines = 1, super.key});

  final int lines;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
    child: Column(
      spacing: Space.md,
      children: [
        for (var line = 0; line < lines; line++)
          const Row(
            spacing: Space.md,
            children: [
              Expanded(child: _CardBones()),
              Expanded(child: _CardBones()),
            ],
          ),
      ],
    ),
  );
}

class _CardBones extends StatelessWidget {
  const _CardBones();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SBone.wide(ratio: SImageRatio.card),
      Padding(
        padding: EdgeInsets.fromLTRB(Space.xs, Space.sm, Space.xs, Space.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.sm,
          children: [
            SBone.text(length: BoneLength.long),
            SBone.text(length: BoneLength.short),
          ],
        ),
      ),
    ],
  );
}
