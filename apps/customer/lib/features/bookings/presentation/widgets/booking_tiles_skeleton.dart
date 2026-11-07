import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// Booking tiles while they load, [count] of them down the page: the
/// bookings list and the ratings.
class BookingTilesSkeleton extends StatelessWidget {
  const BookingTilesSkeleton({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        for (var i = 0; i < count; i++)
          const SCard(
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
                      SBone.text(
                        variant: TextVariant.caption,
                        length: BoneLength.long,
                      ),
                    ],
                  ),
                ),
                SBone.badge(),
              ],
            ),
          ),
      ],
    ),
  );
}
