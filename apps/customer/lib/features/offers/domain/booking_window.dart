import 'package:kernel/kernel.dart';

/// What reserving a counted offer at a given time gets, by its store's
/// hours: worked out as the backend does, which has the last word.
sealed class BookingWindow {
  const BookingWindow();

  /// What reserving at [now] gets: held for [holdMinutes], unless the offer
  /// ends first ([endsAt]), or the store closes first and isn't open again
  /// by then (a break it's back from counts as open). Not while the store
  /// is closed, nor in its last [lastBookingMinutes]. Days the [hours]
  /// don't say limit nothing.
  factory BookingWindow.at(
    DateTime now, {
    required OpeningHours hours,
    required int holdMinutes,
    required DateTime endsAt,
    required int lastBookingMinutes,
  }) {
    if (hours.openAt(now) == false) {
      return BookingClosed(opensAt: hours.opensAfter(now));
    }
    final hold = now.add(Duration(minutes: holdMinutes));
    final (until, end) = hold.isAfter(endsAt)
        ? (endsAt, HeldEnd.offerEnds)
        : (hold, HeldEnd.holdTime);
    final closes = hours.openAt(until) == true
        ? null
        : hours.lastClosing(now, until);
    if (closes == null) return BookingHeld(until: until, end: end, now: now);
    if (closes.difference(now) < Duration(minutes: lastBookingMinutes)) {
      return BookingTooLate(closesAt: closes);
    }
    return BookingHeld(until: closes, end: HeldEnd.storeCloses, now: now);
  }
}

/// What ends a reservation's time.
enum HeldEnd {
  /// The whole hold time.
  holdTime,

  /// The offer ends before it.
  offerEnds,

  /// The store closes before it.
  storeCloses,
}

/// Reserved pieces are held until [until], for [minutes] from now.
final class BookingHeld extends BookingWindow {
  BookingHeld({required this.until, required this.end, required DateTime now})
    : minutes = (until.difference(now).inSeconds / Duration.secondsPerMinute)
          .round();

  final DateTime until;
  final HeldEnd end;
  final int minutes;

  /// Less than the whole hold time: worth saying before booking.
  bool get short => end != HeldEnd.holdTime;
}

/// The store is closed: it can be booked once it opens, at [opensAt] (null
/// when its hours don't say).
final class BookingClosed extends BookingWindow {
  const BookingClosed({required this.opensAt});

  final DateTime? opensAt;
}

/// The store closes at [closesAt], too soon to get there.
final class BookingTooLate extends BookingWindow {
  const BookingTooLate({required this.closesAt});

  final DateTime closesAt;
}
