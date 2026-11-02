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
    OfferSort.newest => sectionAllOffers,
  };

  String price(BuildContext context, String amount) => formatPrice(
    amount,
    languageCode: Localizations.localeOf(context).languageCode,
  );

  /// "2 left", only once a counted offer is almost gone: plenty left is
  /// nothing to act on, a few left is a reason to reserve now.
  String? stock(Offer offer) =>
      offer.almostGone ? piecesLeft(offer.remaining ?? 0) : null;

  /// When it ends, as short as it can be: "Ends in 45 min" in the last
  /// hour, "Until 9:00 PM" today, "Until Thursday" this coming week,
  /// "Until Nov 9" after.
  String ends(BuildContext context, Offer offer, DateTime now) {
    final language = Localizations.localeOf(context).languageCode;
    final left = offer.endsAt.difference(now);
    if (left.inMinutes < 60) {
      return endsInMinutes(left.inMinutes < 1 ? 1 : left.inMinutes);
    }
    if (isSameDay(offer.endsAt, now)) {
      return endsAtTime(formatTime(offer.endsAt, languageCode: language));
    }
    return endsOnDay(
      _daysApart(now, offer.endsAt) < _daysNamed
          ? formatWeekday(offer.endsAt, languageCode: language)
          : formatDayMonth(offer.endsAt, languageCode: language),
    );
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

/// A weekday names one day only within the week ahead; past it, the date.
const _daysNamed = 7;

/// Calendar days from [from] to [to], whatever their times of day.
int _daysApart(DateTime from, DateTime to) {
  DateTime day(DateTime date) {
    final local = date.toLocal();
    return DateTime.utc(local.year, local.month, local.day);
  }

  return day(to).difference(day(from)).inDays;
}
