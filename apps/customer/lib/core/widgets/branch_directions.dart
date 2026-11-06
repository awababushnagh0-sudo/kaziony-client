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
/// opens its directions. It fills the width it's given: pages pad it.
class BranchDirections extends AppView {
  /// [branches] closest first, at least one: the offer's branches (or the
  /// store's), all of them places to pick up.
  const BranchDirections({required this.branches, super.key});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (branches case [final only]) {
      return SBoxTile(
        illustration: CustomerIllustrations.map,
        title: only.name,
        subtitle: branchWhere(s, only),
        action: SIcons.navigate,
        actionLabel: s.storeGetDirections,
        onTap: () => openDirections(context, ref, only),
      );
    }
    final closest = branches.first;
    return SExpandable(
      illustration: CustomerIllustrations.map,
      title: s.branchCount(branches.length),
      tag: s.branchClosest,
      subtitle: [
        closest.name,
        if (closest.distanceKm case final km?) s.distance(km),
      ].join(' · '),
      child: BranchRows(branches: branches),
    );
  }
}

/// Every one of [branches], each a row that opens its directions.
class BranchRows extends AppView {
  const BranchRows({required this.branches, super.key});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, branch) in branches.indexed) ...[
          if (i > 0) const SDivider(inset: true),
          // No pin each: in a list of branches it would say nothing. The
          // way there is the arrow at the end, without words.
          SListTile(
            title: branch.name,
            subtitle: branchWhere(s, branch),
            trailing: const SIcon(SIcons.navigate, color: SColor.primary),
            onTap: () => openDirections(context, ref, branch),
          ),
        ],
      ],
    );
  }
}

/// Under a branch's name: its address (or area) and how far it is.
String? branchWhere(CustomerLocalizations s, Branch branch) {
  final parts = [
    ?(branch.address ?? branch.area),
    if (branch.distanceKm case final km?) s.distance(km),
  ];
  return parts.isEmpty ? null : parts.join(' · ');
}

/// Opens the way to [branch] in the phone's maps, or says it couldn't.
Future<void> openDirections(
  BuildContext context,
  WidgetRef ref,
  Branch branch,
) async {
  final s = CustomerLocalizations.of(context);
  final opened = await ref
      .read(linkOpenerProvider)
      .open(directionsLink(branch.point));
  if (!opened && context.mounted) {
    SSnack.error(context, s.storeDirectionsFailed);
  }
}
