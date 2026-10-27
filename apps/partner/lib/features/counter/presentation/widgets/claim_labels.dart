import 'package:kernel/kernel.dart';

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
