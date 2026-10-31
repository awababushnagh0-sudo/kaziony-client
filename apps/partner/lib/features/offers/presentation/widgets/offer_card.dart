import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';
import 'offer_labels.dart';

/// The offer as a card in the Offers tab: its photo, title, prices and
/// state, until when it runs, how much is left and how it's selling.
class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, this.onTap, super.key});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final total = offer.totalQuantity;
    final claims = offer.claims;
    return SDealCard(
      title: offer.title,
      price: formatPrice(offer.offerPrice, languageCode: language),
      originalPrice: formatPrice(offer.originalPrice, languageCode: language),
      discountPercent: offer.discountPercent,
      imageUrl: offer.thumbUrl,
      status: offerStatus(s, offer.state),
      when: _when(s, language),
      stock: total == null
          ? null
          : DealStockSpec(
              label: s.piecesLeft(offer.remainingQuantity ?? 0, total),
              note: null,
              left: offerLeft(offer) ?? 0,
            ),
      figures: [
        Figure(
          value: '${offer.viewCount}',
          label: s.figureViews,
          icon: SIcons.show,
        ),
        Figure(
          value: '${claims.reserved + claims.redeemed}',
          label: s.figureReserved,
          icon: SIcons.users,
        ),
        Figure(
          value: '${claims.redeemed}',
          label: s.figurePickedUp,
          icon: SIcons.check,
        ),
      ],
      onTap: onTap,
    );
  }

  /// When it starts, until when it runs, or when it ended.
  String _when(PartnerLocalizations s, String language) {
    String at(DateTime time) => formatWhen(time, languageCode: language);
    return switch (offer.state) {
      OfferState.scheduled => s.startsAt(at(offer.startsAt)),
      OfferState.ended || OfferState.removed => s.endedAt(at(offer.endsAt)),
      _ => s.endsAt(at(offer.endsAt)),
    };
  }
}
