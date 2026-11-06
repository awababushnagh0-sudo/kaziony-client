import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import 'store_tile.dart';

/// [StoreTile]s while they load, [count] of them down the page.
class StoreTilesSkeleton extends StatelessWidget {
  const StoreTilesSkeleton({this.count = 3, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [for (var i = 0; i < count; i++) const _Tile()],
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
        SBone.image(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xxs,
            children: [
              SBone.text(length: BoneLength.medium),
              SBone.text(variant: TextVariant.caption, length: BoneLength.long),
              SBone.badge(),
            ],
          ),
        ),
      ],
    ),
  );
}
