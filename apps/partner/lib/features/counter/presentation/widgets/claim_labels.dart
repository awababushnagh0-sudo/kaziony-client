import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/claim.dart';

/// Why [claim] can't be picked up, for the cashier; null when it can.
String? claimProblemMessage(BuildContext context, Claim claim) {
  final s = PartnerLocalizations.of(context);
  final redeemedAt = claim.redeemedAt;
  return switch (claim.problem) {
    null => null,
    ClaimProblem.alreadyRedeemed when redeemedAt != null => s.problemRedeemedAt(
      formatWhen(
        redeemedAt,
        languageCode: Localizations.localeOf(context).languageCode,
      ),
    ),
    ClaimProblem.alreadyRedeemed => s.problemRedeemed,
    ClaimProblem.cancelled => s.problemCancelled,
    ClaimProblem.expired => s.problemExpired,
    ClaimProblem.otherBranch => s.problemOtherBranch,
    ClaimProblem.other => s.problemOther,
  };
}

/// What the cashier should do about [claim]'s problem; null when there's
/// nothing to add.
String? claimProblemHint(BuildContext context, Claim claim) {
  final s = PartnerLocalizations.of(context);
  return switch (claim.problem) {
    null || ClaimProblem.other => null,
    ClaimProblem.alreadyRedeemed => s.problemRedeemedHint,
    ClaimProblem.cancelled => s.problemCancelledHint,
    ClaimProblem.expired => s.problemExpiredHint,
    ClaimProblem.otherBranch => s.problemOtherBranchHint,
  };
}

/// [status] as a badge; nothing for a status this version doesn't know.
class ClaimStatusBadge extends StatelessWidget {
  const ClaimStatusBadge(this.status, {super.key});

  final ClaimStatus? status;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return switch (status) {
      ClaimStatus.reserved => SBadge(s.claimReserved, tone: BadgeTone.success),
      ClaimStatus.redeemed => SBadge(s.claimRedeemed, tone: BadgeTone.success),
      ClaimStatus.expired => SBadge(s.claimExpired, tone: BadgeTone.warning),
      ClaimStatus.cancelled => SBadge(s.claimCancelled),
      null => const SizedBox.shrink(),
    };
  }
}
