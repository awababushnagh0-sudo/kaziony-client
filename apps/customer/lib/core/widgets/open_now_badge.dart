import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/presentation/offer_texts.dart';
import '../l10n/generated/customer_localizations.dart';

/// How a store is at [now], when it's worth a look: "Closes in 40 min" in
/// orange once it closes within the hour, "Closed now" in red while it's
/// closed. Null while it's open for a while yet, or on a day it didn't
/// say. [edge] sets it against a photo's edge, like a tag; [short] says
/// the minutes short, for a card.
SBadge? openNowBadge(
  BuildContext context,
  StoreSchedule hours,
  DateTime now, {
  BadgeEdge? edge,
  bool short = false,
}) {
  final s = CustomerLocalizations.of(context);
  switch (hours.openAt(now)) {
    case true:
      final left = hours.closesAfter(now)?.difference(now);
      if (left == null || left > _closingSoon) return null;
      final minutes = (left.inSeconds / Duration.secondsPerMinute).ceil();
      return SBadge(
        short
            ? s.storeClosesInShort(minutes)
            : s.storeClosesIn(s.holdTime(minutes)),
        tone: BadgeTone.warning,
        edge: edge,
      );
    case false:
      return SBadge(s.storeClosedNow, tone: BadgeTone.danger, edge: edge);
    case null:
      return null;
  }
}

/// As people look out for a store about to close.
const _closingSoon = Duration(hours: 1);
