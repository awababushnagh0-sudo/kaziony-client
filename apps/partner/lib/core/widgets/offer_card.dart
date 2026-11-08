import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/widgets/offer_labels.dart';
import '../l10n/generated/partner_localizations.dart';
import 'offer_split_bar.dart';

/// The offer as a card, in the Offers tab and on home: which offer it is, its
/// price and time, and one bar of where its pieces are now. The rest of the
/// numbers are on its page.
class OfferCard extends StatelessWidget {
  const OfferCard({
    required this.offer,
    this.onTap,
    this.showState = true,
    super.key,
  });

  final Offer offer;
  final VoidCallback? onTap;

  /// Off where every offer shown is in the same state.
  final bool showState;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final status = showState ? offerStatus(s, offer.state) : null;
    return SCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SImage(offer.thumbUrl, size: SImageSize.deal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (status != null)
                      SBadge.dot(status.label, tone: status.tone),
                    // One line each, so cards side by side stay level.
                    SText(
                      offer.title,
                      variant: TextVariant.subtitle,
                      weight: SFontWeight.bold,
                      maxLines: 1,
                    ),
                    SText.caption(
                      s.offerPriceAndWhen(
                        formatPrice(offer.offerPrice, languageCode: language),
                        _when(s, language),
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          OfferSplitBar(offer),
        ],
      ),
    );
  }

  /// When it starts, until when it runs, or when it ended: the time when
  /// that's today, otherwise the day, short enough to fit beside the price.
  String _when(PartnerLocalizations s, String language) {
    String at(DateTime time) => isSameDay(time, DateTime.now())
        ? formatTime(time, languageCode: language)
        : formatDayMonth(time, languageCode: language);
    return switch (offer.state) {
      OfferState.scheduled => s.startsAt(at(offer.startsAt)),
      OfferState.ended || OfferState.removed => s.endedAt(at(offer.endsAt)),
      _ => s.until(at(offer.endsAt)),
    };
  }
}
