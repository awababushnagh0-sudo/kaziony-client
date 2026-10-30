import 'package:kernel/kernel.dart';

/// The time now, moving on every minute: for the minutes left on screen.
final minuteClockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) => Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now()),
);
