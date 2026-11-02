import 'package:kernel/kernel.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/offer.dart';

/// How offers are put into words, the same on every page.
extension OfferTexts on CustomerLocalizations {
  /// A home row's name, and its "See all" page's.
  String section(OfferSort sort) => switch (sort) {
    OfferSort.endingSoon => sectionEndingSoon,
    OfferSort.nearest => sectionNearby,
    OfferSort.biggestDiscount => sectionBiggestDiscount,
    OfferSort.newest => sortNewest,
  };

  String price(BuildContext context, String amount) => formatPrice(
    amount,
    languageCode: Localizations.localeOf(context).languageCode,
  );

  /// "3 left", for counted offers.
  String? stock(Offer offer) =>
      offer.limited ? piecesLeft(offer.remaining ?? 0) : null;

  /// When it ends, as short as it can be: "Ends in 45 min" in the last
  /// hour, "Until 9:00 PM" today, "Until Thu" after.
  String ends(BuildContext context, Offer offer, DateTime now) {
    final language = Localizations.localeOf(context).languageCode;
    final left = offer.endsAt.difference(now);
    if (left.inMinutes < 60) {
      return endsInMinutes(left.inMinutes < 1 ? 1 : left.inMinutes);
    }
    return isSameDay(offer.endsAt, now)
        ? endsAtTime(formatTime(offer.endsAt, languageCode: language))
        : endsOnDay(formatShortDay(offer.endsAt, languageCode: language));
  }

  /// "Ends today at 9:00 PM", on the offer's page.
  String endsLong(BuildContext context, Offer offer, DateTime now) {
    final language = Localizations.localeOf(context).languageCode;
    return isSameDay(offer.endsAt, now)
        ? endsTodayAt(formatTime(offer.endsAt, languageCode: language))
        : endsOn(formatDateTime(offer.endsAt, languageCode: language));
  }

  /// "1.2 km".
  String distance(double km) => distanceKm(km.toStringAsFixed(1));

  /// The facts under an offer's title: when it ends, how far.
  List<String> details(BuildContext context, Offer offer, DateTime now) => [
    ends(context, offer, now),
    if (offer.nearestBranch.distanceKm case final km?) distance(km),
  ];
}
