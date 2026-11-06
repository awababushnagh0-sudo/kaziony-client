import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import 'store_logo_row.dart';

/// A [StoreLogoRow] while it loads: its title and a row of round logos.
/// Bones only, for a page's skeleton.
class StoreLogoRowSkeleton extends StatelessWidget {
  const StoreLogoRowSkeleton({super.key});

  /// More than a phone shows across.
  static const _count = 6;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Space.sm,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: Space.lg),
        child: SBone.text(
          variant: TextVariant.subtitle,
          length: BoneLength.medium,
        ),
      ),
      SCarousel.small(
        children: [
          for (var i = 0; i < _count; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Space.xs),
              child: SBone.image(size: SImageSize.logoInRow),
            ),
        ],
      ),
    ],
  );
}
