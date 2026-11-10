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

  /// When to pick up, short, beside a clock or a "Pick up" label: "Today
  /// 4:00 PM – 9:00 PM", else "Thursday until 9:00 PM".
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

  /// The day an offer's pickup ends: "Today", "Tomorrow", "Thursday" this
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

  /// How long a reservation is held, as people say it: "2 hours",
  /// "45 minutes", "1 hour and 30 minutes" (in Arabic "ساعتان",
  /// "45 دقيقة", "ساعة و30 دقيقة").
  String holdTime(int minutes) {
    final hours = minutes ~/ Duration.minutesPerHour;
    final rest = minutes % Duration.minutesPerHour;
    if (hours == 0) return holdMinutes(rest);
    if (rest == 0) return holdHours(hours);
    return holdHoursAndMinutes(holdHours(hours), holdMinutes(rest));
  }
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
