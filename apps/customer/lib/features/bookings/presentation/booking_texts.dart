import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/booking.dart';

/// A booking's state in words and color: waiting is orange, as anything
/// to act on.
(String, BadgeTone) bookingStatus(
  CustomerLocalizations s,
  Booking booking,
  DateTime now,
) => switch (booking.status) {
  _ when booking.isActiveAt(now) => (s.statusReserved, BadgeTone.accent),
  BookingStatus.pickedUp => (s.statusPickedUp, BadgeTone.success),
  BookingStatus.cancelled => (s.statusCancelled, BadgeTone.neutral),
  // Reserved but past its time reads as expired until the server says so.
  BookingStatus.reserved ||
  BookingStatus.expired => (s.statusExpired, BadgeTone.neutral),
};

/// Why a booking ended that the customer didn't cancel, and that it
/// doesn't count against them.
({String title, String message}) cancelledFor(
  CustomerLocalizations s,
  CancelReason reason,
) => switch (reason) {
  CancelReason.offerRemoved => (
    title: s.cancelledByUsTitle,
    message: s.cancelledOfferRemoved,
  ),
  CancelReason.storeOff => (
    title: s.cancelledByUsTitle,
    message: s.cancelledStoreOff,
  ),
  CancelReason.customer || CancelReason.other => (
    title: s.cancelledNotByYouTitle,
    message: s.cancelledNotByYou,
  ),
};

/// The day a past booking is filed under: "Today", "Yesterday", the day
/// with its weekday this year, or the date in another.
String bookingDay(
  CustomerLocalizations s,
  DateTime day,
  DateTime now, {
  required String languageCode,
}) {
  if (isSameDay(day, now)) return s.bookingsToday;
  if (isSameDay(day, now.subtract(const Duration(days: 1)))) {
    return s.bookingsYesterday;
  }
  return day.toLocal().year == now.toLocal().year
      ? formatDay(day, languageCode: languageCode)
      : formatDate(day, languageCode: languageCode);
}

/// The store with its area, which tells a brand's places apart: "Sweet
/// shop · Andalus".
String storeNamed(Booking booking) =>
    [booking.storeName, ?booking.location.area].join(' · ');

/// When a past booking happened: picked up, or else booked.
DateTime bookingTime(Booking booking) =>
    booking.pickedUpAt ?? booking.createdAt;

/// What to tell the customer of where they stand, calmly: booking paused
/// and until when, or the missed pickups that count, how many more pause
/// booking and when the oldest stops counting. Null when there's nothing
/// to say.
({String title, String? message})? standingWarning(
  CustomerLocalizations s,
  BookingStanding standing,
  DateTime now, {
  required String languageCode,
}) {
  if (standing.pausedAt(now)) {
    return (
      title: s.bookingPausedUntil(
        formatWhen(standing.pausedUntil!, languageCode: languageCode, now: now),
      ),
      message: s.bookingPausedMessage,
    );
  }
  if (standing.strikes < 1) return null;
  final left = standing.strikesLeft;
  final fades = standing.strikeFadesAt;
  final message = [
    if (left > 0) s.missedLeftBeforePause(left, standing.nextPauseDays),
    if (fades != null)
      s.missedFadesOn(
        standing.strikes,
        formatDayMonth(fades, languageCode: languageCode),
      ),
  ].join(' ');
  return (
    title: s.missedPickups(standing.strikes),
    message: message.isEmpty ? null : message,
  );
}

/// [standingWarning] on one line, for the account: "Booking paused until
/// 3:00 PM", "You missed a pickup · 2 more before a pause".
String? standingLine(
  CustomerLocalizations s,
  BookingStanding standing,
  DateTime now, {
  required String languageCode,
}) {
  if (standing.pausedAt(now)) {
    return s.bookingPausedUntil(
      formatWhen(standing.pausedUntil!, languageCode: languageCode, now: now),
    );
  }
  if (standing.strikes < 1) return null;
  return [
    s.missedPickups(standing.strikes),
    if (standing.strikesLeft > 0) s.missedLeftShort(standing.strikesLeft),
  ].join(' · ');
}

/// Why a reservation was refused, in the app's words; a pause with until
/// when, once [pausedUntil] is known (said from [now]).
String reserveFailureMessage(
  BuildContext context,
  AppFailure failure, {
  DateTime? pausedUntil,
  DateTime? now,
}) {
  final s = CustomerLocalizations.of(context);
  final language = Localizations.localeOf(context).languageCode;
  return switch (failure) {
    ConflictFailure(code: 'AlreadyReserved') => s.reserveAlreadyReserved,
    ConflictFailure(code: 'ClaimLimitReached') => s.reserveLimitReached,
    ConflictFailure(code: 'OverClaimLimit') => s.reserveOverLimit,
    ConflictFailure(code: 'TooManyReservations') => s.reserveTooMany,
    ConflictFailure(code: 'CancelledTooOften') => s.reserveCancelledTooOften,
    ConflictFailure(code: 'NotEnoughLeft') => s.reserveNotEnough,
    ConflictFailure(code: 'SoldOut') => s.soldOut,
    ConflictFailure(code: 'OfferNotStarted') => s.reserveNotStarted,
    ConflictFailure(code: 'OfferEnded') => s.reserveEnded,
    ForbiddenFailure(code: 'ClaimBanned') =>
      pausedUntil == null
          ? s.reservePaused
          : s.bookingPausedUntil(
              formatWhen(pausedUntil, languageCode: language, now: now),
            ),
    _ => failureMessage(context, failure),
  };
}

/// Why a rating was refused, in the app's words.
String ratingFailureMessage(BuildContext context, AppFailure failure) {
  final s = CustomerLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: 'NotPickedUp') => s.ratingNotPickedUp,
    ConflictFailure(code: 'AlreadyRated') => s.ratingAlreadyRated,
    _ => failureMessage(context, failure),
  };
}

/// "12:34" or "1:02:34": the time left to pick up.
String countdown(Duration left) {
  final clamped = left.isNegative ? Duration.zero : left;
  String two(int n) => n.toString().padLeft(2, '0');
  final minutes = two(clamped.inMinutes.remainder(60));
  final seconds = two(clamped.inSeconds.remainder(60));
  return clamped.inHours > 0
      ? '${clamped.inHours}:$minutes:$seconds'
      : '$minutes:$seconds';
}

/// Of [bookings], those still to pick up at [now], the soonest to run out
/// first.
List<Booking> toPickUpAt(List<Booking> bookings, DateTime now) => [
  for (final booking in bookings)
    if (booking.isActiveAt(now)) booking,
]..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
