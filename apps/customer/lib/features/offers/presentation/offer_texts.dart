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

  /// When it can be picked up, on the offer's page: "Pick up 4:00 PM –
  /// 9:00 PM" within one day, else "Pick up until 9:00 PM". The day is
  /// [pickupDay]'s.
  String pickupTime(BuildContext context, Offer offer) {
    final language = Localizations.localeOf(context).languageCode;
    final end = formatTime(offer.endsAt, languageCode: language);
    return isSameDay(offer.startsAt, offer.endsAt)
        ? offerInfoPickupBetween(
            formatTime(offer.startsAt, languageCode: language),
            end,
          )
        : offerInfoPickupUntil(end);
  }

  /// When to pick up, short, for a card whose clock icon says it's the
  /// pickup: "Today 4:00 PM – 9:00 PM", else "Thursday until 9:00 PM".
  String cardPickup(BuildContext context, Offer offer, DateTime now) {
    final language = Localizations.localeOf(context).languageCode;
    final day = pickupDay(context, offer, now);
    final end = formatTime(offer.endsAt, languageCode: language);
    return isSameDay(offer.startsAt, offer.endsAt)
        ? cardPickupBetween(
            day,
            formatTime(offer.startsAt, languageCode: language),
            end,
          )
        : cardPickupUntil(day, end);
  }

  /// The day [pickupTime] ends: "Today", "Tomorrow", "Thursday" this
  /// coming week, "Nov 9" after.
  String pickupDay(BuildContext context, Offer offer, DateTime now) {
    final language = Localizations.localeOf(context).languageCode;
    return switch (_daysApart(now, offer.endsAt)) {
      <= 0 => offerInfoToday,
      1 => offerInfoTomorrow,
      < _daysNamed => formatWeekday(offer.endsAt, languageCode: language),
      _ => formatDayMonth(offer.endsAt, languageCode: language),
    };
  }

  /// "Rated 4.5 out of 5 by 37 people", for screen readers.
  String rating(StoreRating rating) =>
      ratingLabel(rating.average.toStringAsFixed(1), rating.count);

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
