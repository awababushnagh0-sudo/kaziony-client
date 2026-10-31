import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';

/// What customers see of the offer right now, in words and a tone; null
/// for a state added after this version of the app.
DealStatus? offerStatus(
  PartnerLocalizations s,
  OfferState? state,
) => switch (state) {
  OfferState.live => DealStatus(label: s.offerLive, tone: BadgeTone.success),
  OfferState.scheduled => DealStatus(
    label: s.offerScheduled,
    tone: BadgeTone.neutral,
  ),
  OfferState.soldOut => DealStatus(
    label: s.offerSoldOut,
    tone: BadgeTone.warning,
  ),
  OfferState.paused => DealStatus(
    label: s.offerPaused,
    tone: BadgeTone.warning,
  ),
  OfferState.ended => DealStatus(label: s.offerEnded, tone: BadgeTone.neutral),
  OfferState.removed => DealStatus(
    label: s.offerRemoved,
    tone: BadgeTone.danger,
  ),
  null => null,
};

/// How long an offer runs: "2 days", "9 h 30 min", "45 min".
String offerLength(PartnerLocalizations s, Duration length) {
  if (length.inDays > 0) return s.daysCount(length.inDays);
  final minutes = length.inMinutes % Duration.minutesPerHour;
  if (length.inHours == 0) return s.minutesShort(minutes);
  return minutes == 0
      ? s.hoursShort(length.inHours)
      : s.hoursMinutesShort(length.inHours, minutes);
}

/// How much of a limited offer is left, 0 to 1; null for unlimited ones.
double? offerLeft(Offer offer) {
  final total = offer.totalQuantity;
  if (total == null || total == 0) return null;
  return (offer.remainingQuantity ?? 0) / total;
}
