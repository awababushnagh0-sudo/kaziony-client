import 'package:kernel/kernel.dart';
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

/// A hold time as people say it: "30 min", "1 hour", "2 hours".
String holdLabel(PartnerLocalizations s, int minutes) =>
    minutes % 60 == 0 ? s.holdHours(minutes ~/ 60) : s.holdValue(minutes);

/// Why posting or resuming an offer was refused, in the app's words.
String offerFailureMessage(BuildContext context, AppFailure failure) {
  final s = PartnerLocalizations.of(context);
  return switch (failure) {
    // Customers can't see the store yet: home says what's left.
    ForbiddenFailure(code: 'StoreDisabled') => s.storeNotLiveCantPost,
    _ => failureMessage(context, failure),
  };
}
