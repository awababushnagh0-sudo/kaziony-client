import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_clock.dart';

/// The time now by the server's clock ([ServerClock]), moving on every
/// minute: for the minutes left on screen ("Ends in 45 min"). Tests
/// override it with a fixed time.
final minuteClockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) =>
      Stream.periodic(const Duration(minutes: 1), (_) => ServerClock.now()),
);

/// The time now by the server's clock, moving on every second: for a
/// countdown.
final secondClockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) =>
      Stream.periodic(const Duration(seconds: 1), (_) => ServerClock.now()),
);
