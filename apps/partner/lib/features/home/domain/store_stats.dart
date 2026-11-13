import 'package:kernel/kernel.dart';

/// What happened in a stretch of time, each counted when it happened: a
/// pickup today of yesterday's reservation is today's.
class PeriodStats {
  const PeriodStats({
    required this.claims,
    required this.redeemed,
    required this.expired,
    required this.redemptionRate,
  });

  /// Reservations made.
  final int claims;

  /// Picked up at the counter (or delivered).
  final int redeemed;

  /// Not picked up in time.
  final int expired;

  /// Picked up out of those that ended, 0 to 1. Null before any ended.
  final double? redemptionRate;
}

/// A store's numbers: each of a brand's places has its own.
class StoreStats {
  const StoreStats({
    required this.liveOffers,
    required this.onTheWay,
    required this.outForDelivery,
    required this.today,
    required this.last30Days,
  });

  /// Offers customers can claim right now.
  final int liveOffers;

  /// Reservations not picked up yet and still held.
  final int onTheWay;

  /// Out with the store's drivers, for the store to close as delivered or
  /// not (a day on, they close as delivered).
  final int outForDelivery;

  /// Since midnight, Libya time.
  final PeriodStats today;
  final PeriodStats last30Days;
}

abstract interface class StatsRepository {
  Future<Result<StoreStats>> get(String storeId);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
