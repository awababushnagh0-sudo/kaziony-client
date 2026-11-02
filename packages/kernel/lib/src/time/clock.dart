import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The time now, moving on every minute: for the minutes left on screen
/// ("Ends in 45 min"). Tests override it with a fixed time.
final minuteClockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) => Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now()),
);

/// The time now, moving on every second: for a countdown.
final secondClockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) => Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
);
