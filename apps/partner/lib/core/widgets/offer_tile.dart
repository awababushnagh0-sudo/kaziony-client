import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../l10n/generated/partner_localizations.dart';

/// The offer as a row on home, to find the one to open: photo with the
/// discount, title, price, and how much of a limited offer is left. The
/// Offers tab shows more (`OfferCard`).
class OfferTile extends StatelessWidget {
  const OfferTile({required this.offer, this.onTap, super.key});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SDealTile(
      imageUrl: offer.thumbUrl,
      title: offer.title,
      price: formatPrice(offer.offerPrice, languageCode: language),
      discountPercent: offer.discountPercent,
      details: offerStockLabel(s, offer),
      hot: offer.state == OfferState.live && offer.isRunningOut,
      onTap: onTap,
    );
  }
}

/// "3 of 10 left"; null for unlimited offers.
String? offerStockLabel(PartnerLocalizations s, Offer offer) {
  final total = offer.totalQuantity;
  if (total == null) return null;
  return s.piecesLeft(offer.remainingQuantity ?? 0, total);
}
