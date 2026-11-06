import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/offer_texts.dart';
import '../l10n/generated/customer_localizations.dart';
import 'customer_illustrations.dart';

/// Where to pick up, with the way there in the phone's maps. One branch:
/// it, and a big "Get directions". Several: a box with a little map, how
/// many and which is closest, that opens to every one of them, closest
/// first, a directions button each.
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

    if (branches case [final only]) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SListTile(
            icon: SIcons.location,
            title: only.name,
            subtitle: where(only),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: SButton.secondary(
              label: s.storeGetDirections,
              icon: SIcons.navigate,
              expand: true,
              onPressed: () => directions(only),
            ),
          ),
        ],
      );
    }
    final closest = branches.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      child: SExpandable(
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
                trailing: SButton.text(
                  label: s.storeDirections,
                  onPressed: () => directions(branch),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
