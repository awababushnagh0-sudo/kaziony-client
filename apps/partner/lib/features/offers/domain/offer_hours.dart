import 'package:kernel/kernel.dart';

/// How a store's hours meet an offer running from now until it ends:
/// what its owner should know before posting it. Customers book counted
/// pieces and pick up only while the store is open.
sealed class OfferHours {
  const OfferHours();

  /// What [hours] make of an offer running from [now] until [endsAt]: null
  /// when the store is open the whole time, or its hours don't say.
  static OfferHours? of(
    StoreSchedule hours, {
    required DateTime now,
    required DateTime endsAt,
  }) {
    if (!endsAt.isAfter(now)) return null;
    final opens = hours.openAt(now) == false ? hours.opensAfter(now) : null;
    if (opens != null && !opens.isBefore(endsAt)) {
      return ClosedThroughOffer(opensAt: opens);
    }
    final closes = hours.openAt(endsAt) == false
        ? hours.lastClosing(now, endsAt)
        : null;
    if (opens == null && closes == null) return null;
    return OutsideHours(opensAt: opens, closesAt: closes);
  }
}

/// Closed from now until the offer ends, opening only at [opensAt]:
/// nobody could pick it up.
final class ClosedThroughOffer extends OfferHours {
  const ClosedThroughOffer({required this.opensAt});

  final DateTime opensAt;
}

/// Part of the offer's time the store is closed: now, until [opensAt];
/// and from [closesAt], before the offer ends. At least one is set.
final class OutsideHours extends OfferHours {
  const OutsideHours({this.opensAt, this.closesAt});

  final DateTime? opensAt;
  final DateTime? closesAt;
}
