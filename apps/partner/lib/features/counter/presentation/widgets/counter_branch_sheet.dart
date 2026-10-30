import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../counter_branch_view_model.dart';

/// Asks which branch this phone is at, and remembers it. Returns its id, or
/// null if the sheet was closed.
Future<String?> chooseCounterBranch(
  BuildContext context,
  WidgetRef ref,
  CounterBranches branches,
) async {
  final id = await SSheet.choose(
    context,
    title: PartnerLocalizations.of(context).chooseCounterBranch,
    selected: branches.branchId,
    options: [
      for (final branch in branches.choices)
        RadioOption(value: branch.id, label: branch.name),
    ],
  );
  if (id != null) {
    await ref.read(counterBranchChoiceProvider.notifier).choose(id);
  }
  return id;
}
