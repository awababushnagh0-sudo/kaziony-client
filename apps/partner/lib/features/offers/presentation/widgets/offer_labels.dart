import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';

/// What customers see of the offer right now, as a colored badge.
class OfferStateBadge extends StatelessWidget {
  const OfferStateBadge({required this.state, super.key});

  final OfferState? state;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return switch (state) {
      OfferState.live => SBadge(s.offerLive, tone: BadgeTone.success),
      OfferState.scheduled => SBadge(s.offerScheduled),
      OfferState.soldOut => SBadge(s.offerSoldOut, tone: BadgeTone.warning),
      OfferState.paused => SBadge(s.offerPaused, tone: BadgeTone.warning),
      OfferState.ended => SBadge(s.offerEnded),
      OfferState.removed => SBadge(s.offerRemoved, tone: BadgeTone.danger),
      null => const SizedBox.shrink(),
    };
  }
}

/// "3 of 10 left · Until Tue, Oct 28 11:00 PM"
String offerSummary(BuildContext context, Offer offer) {
  final s = PartnerLocalizations.of(context);
  final total = offer.totalQuantity;
  final pieces = total == null
      ? s.noLimit
      : s.piecesLeft(offer.remainingQuantity ?? 0, total);
  final until = s.until(
    formatDateTime(
      offer.endsAt,
      languageCode: Localizations.localeOf(context).languageCode,
    ),
  );
  return '$pieces · $until';
}

/// The offer as a row: photo, prices, discount, summary and state.
class OfferTile extends StatelessWidget {
  const OfferTile({required this.offer, this.onTap, super.key});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return SDealTile(
      imageUrl: offer.thumbUrl,
      title: offer.title,
      price: formatPrice(offer.offerPrice, languageCode: language),
      originalPrice: formatPrice(offer.originalPrice, languageCode: language),
      discountPercent: offer.discountPercent,
      details: offerSummary(context, offer),
      trailing: OfferStateBadge(state: offer.state),
      onTap: onTap,
    );
  }
}
