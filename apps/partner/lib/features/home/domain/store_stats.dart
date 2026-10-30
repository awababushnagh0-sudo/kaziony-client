import 'package:kernel/kernel.dart';

/// Reservations made in a stretch of time, and how they ended.
class PeriodStats {
  const PeriodStats({
    required this.claims,
    required this.redeemed,
    required this.expired,
    required this.redemptionRate,
  });

  final int claims;

  /// Picked up at the counter.
  final int redeemed;

  /// Not picked up in time.
  final int expired;

  /// Picked up out of those that ended, 0 to 1. Null before any ended.
  final double? redemptionRate;
}

/// A store's numbers. Staff limited to a branch get their branch's.
class StoreStats {
  const StoreStats({
    required this.liveOffers,
    required this.onTheWay,
    required this.today,
    required this.last30Days,
  });

  /// Offers customers can claim right now.
  final int liveOffers;

  /// Reservations not picked up yet and still held.
  final int onTheWay;

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
