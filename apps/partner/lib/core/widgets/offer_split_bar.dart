import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../l10n/generated/partner_localizations.dart';

/// The counts of an [OfferSplitBar] a card can show bigger beside it.
enum OfferCount { pickedUp, left }

/// Where an offer's pieces are now, as one bar: picked up, on the way and
/// left. Before it starts, only what's ready. The same on its card and its
/// page, so the two always agree.
class OfferSplitBar extends StatelessWidget {
  const OfferSplitBar(this.offer, {this.apart, super.key});

  final Offer offer;

  /// The count shown bigger beside the bar, so its key leaves it out.
  final OfferCount? apart;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SSplitBar(
      parts: _parts(s),
      note: offer.totalQuantity == null ? s.noLimit : null,
      faded:
          offer.state == OfferState.ended || offer.state == OfferState.removed,
    );
  }

  List<SplitPart> _parts(PartnerLocalizations s) {
    final total = offer.totalQuantity;
    if (offer.state == OfferState.scheduled) {
      return [if (total != null) SplitPart(count: total, label: s.figureReady)];
    }
    return [
      SplitPart(
        count: offer.claims.redeemed,
        label: s.figurePickedUp,
        tone: SplitTone.done,
        keyed: apart != OfferCount.pickedUp,
      ),
      SplitPart(
        count: offer.claims.reserved,
        label: s.figureOnTheWay,
        tone: SplitTone.underway,
      ),
      if (total != null)
        SplitPart(
          count: offer.remainingQuantity ?? 0,
          label: s.figureLeft,
          tone: offer.state == OfferState.live && offer.isRunningOut
              ? SplitTone.hot
              : SplitTone.waiting,
          keyed: apart != OfferCount.left,
        ),
    ];
  }
}
