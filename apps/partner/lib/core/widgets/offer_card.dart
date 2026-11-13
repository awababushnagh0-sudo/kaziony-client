import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/widgets/offer_labels.dart';
import '../l10n/generated/partner_localizations.dart';
import 'offer_split_bar.dart';

/// The offer as a card, in the Offers tab and on home: which offer it is, its
/// price and time, the one number to watch at its end, and one bar of where
/// its pieces are now. The rest of the numbers are on its page.
class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, this.onTap, this.action, super.key});

  final Offer offer;
  final VoidCallback? onTap;

  /// A button at the card's foot (resuming a paused offer).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    // The lists around the cards group them by state already; a removed
    // offer is the one that looks like the ended ones beside it.
    final status = offer.state == OfferState.removed
        ? offerStatus(s, offer.state)
        : null;
    final figure = _figure(s);
    return SCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SImage(offer.thumbUrl),
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
              if (figure != null)
                SFigure(
                  figure.value,
                  label: figure.label,
                  hot: figure.hot,
                  quiet: figure.quiet,
                ),
            ],
          ),
          // Before it starts, the number at the end is all there is.
          if (offer.state != OfferState.scheduled)
            OfferSplitBar(offer, apart: figure?.count),
          ?action,
        ],
      ),
    );
  }

  /// The number to watch: the pieces left while it runs, all of them before
  /// it starts, and the pieces picked up when nothing limits it or it's
  /// over. None for an unlimited offer that hasn't started.
  _Figure? _figure(PartnerLocalizations s) {
    final total = offer.totalQuantity;
    final left = offer.remainingQuantity ?? 0;
    final over =
        offer.state == OfferState.ended || offer.state == OfferState.removed;
    if (offer.state == OfferState.scheduled) {
      return total == null ? null : _Figure('$total', label: s.figureReady);
    }
    if (total == null || over) {
      return _Figure(
        '${offer.claims.redeemed}',
        label: s.figurePickedUp,
        count: OfferCount.pickedUp,
        quiet: over,
      );
    }
    if (left == 0) {
      return _Figure(
        s.figureSoldOut,
        label: s.figureAllOf(total),
        count: OfferCount.left,
      );
    }
    return _Figure(
      '$left',
      label: s.figureLeftOf(total),
      count: OfferCount.left,
      hot: offer.state == OfferState.live && offer.isRunningOut,
      quiet: offer.state == OfferState.paused,
    );
  }

  /// When it starts, until when it runs, or when it ended: the time when
  /// that's today, otherwise the day, short enough to fit beside the price.
  String _when(PartnerLocalizations s, String language) {
    String at(DateTime time) => isSameDay(time, ServerClock.now())
        ? formatTime(time, languageCode: language)
        : formatDayMonth(time, languageCode: language);
    return switch (offer.state) {
      OfferState.scheduled => s.startsAt(at(offer.startsAt)),
      OfferState.ended || OfferState.removed => s.endedAt(at(offer.endsAt)),
      _ => s.until(at(offer.endsAt)),
    };
  }
}

/// The card's number, what it counts, and which of the bar's counts it is.
class _Figure {
  const _Figure(
    this.value, {
    required this.label,
    this.count,
    this.hot = false,
    this.quiet = false,
  });

  final String value;
  final String label;
  final OfferCount? count;
  final bool hot;
  final bool quiet;
}
