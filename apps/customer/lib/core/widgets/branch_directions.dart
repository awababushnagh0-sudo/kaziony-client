import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/offer_texts.dart';
import '../l10n/generated/customer_localizations.dart';
import 'customer_illustrations.dart';

/// Where to pick up, with the way there in the phone's maps, as one box
/// with a little map either way. One branch: the box is it, and tapping
/// it opens the directions. Several: the box says how many and which is
/// closest, and opens to every one of them, closest first, each a row that
/// opens its directions.
class BranchDirections extends AppView {
  /// [branches] closest first, at least one: the offer's branches (or the
  /// store's), all of them places to pick up.
  const BranchDirections({required this.branches, super.key});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    Future<void> directions(Branch branch) async {
      final opened = await ref
          .read(linkOpenerProvider)
          .open(directionsLink(branch.point));
      if (!opened && context.mounted) {
        SSnack.error(context, s.storeDirectionsFailed);
      }
    }

    String? where(Branch branch) {
      final parts = [
        ?(branch.address ?? branch.area),
        if (branch.distanceKm case final km?) s.distance(km),
      ];
      return parts.isEmpty ? null : parts.join(' · ');
    }

    // The way there, at the end of the box and of each row: the arrow,
    // without words, the same in both.
    const go = SIcon(SIcons.navigate, color: SColor.primary);
    final Widget box;
    if (branches case [final only]) {
      box = SBoxTile(
        illustration: CustomerIllustrations.map,
        title: only.name,
        subtitle: where(only),
        action: SIcons.navigate,
        actionLabel: s.storeGetDirections,
        onTap: () => directions(only),
      );
    } else {
      final closest = branches.first;
      box = SExpandable(
        illustration: CustomerIllustrations.map,
        title: s.branchCount(branches.length),
        tag: s.branchClosest,
        subtitle: [
          closest.name,
          if (closest.distanceKm case final km?) s.distance(km),
        ].join(' · '),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, branch) in branches.indexed) ...[
              if (i > 0) const SDivider(inset: true),
              // No pin each: in a list of branches it would say nothing.
              SListTile(
                title: branch.name,
                subtitle: where(branch),
                trailing: go,
                onTap: () => directions(branch),
              ),
            ],
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      child: box,
    );
  }
}
