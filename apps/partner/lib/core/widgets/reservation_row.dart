import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/counter/domain/claim.dart';
import '../l10n/generated/partner_localizations.dart';
import '../routes/routes.dart';

/// A customer on their way: who, until when it's held, and how long that
/// leaves, in orange when it's due soon. What they took is on the page it
/// opens, the same as scanning their code.
class ReservationRow extends StatelessWidget {
  const ReservationRow(
    this.claim, {
    required this.now,
    this.showCode = false,
    super.key,
  });

  final Claim claim;
  final DateTime now;

  /// For a customer who gives their name instead of showing the code.
  final bool showCode;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SListTile(
      title: claim.customerName ?? s.someCustomer,
      subtitle: s.until(formatTime(claim.expiresAt, languageCode: language)),
      code: showCode ? ClaimCode.grouped(claim.code) : null,
      trailing: STag(
        timeLeftLabel(s, claim.expiresAt.difference(now)),
        hot: claim.isDueSoonAt(now),
      ),
      onTap: () => context.push(Routes.claim(claim.code, fromList: true)),
    );
  }
}

/// "12 min" under an hour, "2 h" above, never less than a minute.
String timeLeftLabel(PartnerLocalizations s, Duration left) {
  final minutes = (left.inSeconds / Duration.secondsPerMinute).ceil();
  if (minutes < Duration.minutesPerHour) {
    return s.minutesShort(minutes < 1 ? 1 : minutes);
  }
  return s.hoursShort(left.inHours);
}

/// The offer's name, with "×2" when more than one piece was taken.
String claimItemLabel(Claim claim) => claim.quantity > 1
    // "×2" reads left to right in Arabic too.
    ? '${claim.offer.title} \u2066×${claim.quantity}\u2069'
    : claim.offer.title;
