/// The time by the server's clock. Phones are often minutes off, or set
/// by hand, and bookings start and end by the server's time: what's shown
/// as "now" (counting down, open or closed) should agree with it.
abstract final class ServerClock {
  /// Gaps under this are the phone being right: the server's time comes in
  /// whole seconds, and a reply takes a moment.
  static const _close = Duration(seconds: 5);

  static Duration _ahead = Duration.zero;

  /// How far the server's clock is ahead of the phone's.
  static Duration get ahead => _ahead;

  /// The time now, by the server's clock.
  static DateTime now() => DateTime.now().add(_ahead);

  /// Takes the server's [time] from a reply to a request sent at [sentAt]
  /// and answered at [receivedAt], both by the phone's clock: the server
  /// read it halfway between.
  static void heard(
    DateTime time, {
    required DateTime sentAt,
    required DateTime receivedAt,
  }) {
    final halfway = sentAt.add(receivedAt.difference(sentAt) ~/ 2);
    final ahead = time.difference(halfway);
    _ahead = ahead.abs() < _close ? Duration.zero : ahead;
  }

  /// Back to the phone's clock, for tests.
  static void reset() => _ahead = Duration.zero;
}
