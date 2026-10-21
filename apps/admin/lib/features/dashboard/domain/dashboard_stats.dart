import 'package:kernel/kernel.dart';

/// Totals shown on the dashboard home page.
class DashboardStats {
  const DashboardStats({
    required this.stores,
    required this.activeStores,
    required this.liveOffers,
    required this.totalOffers,
    required this.customers,
    required this.newCustomersLast7Days,
    required this.claimsLast7Days,
    required this.redemptionRate,
  });

  final int stores;
  final int activeStores;
  final int liveOffers;
  final int totalOffers;
  final int customers;
  final int newCustomersLast7Days;
  final int claimsLast7Days;

  /// Share of finished claims that were picked up, 0 to 1.
  /// Null before any claim has finished.
  final double? redemptionRate;
}

abstract interface class DashboardRepository {
  Future<Result<DashboardStats>> getStats();
}

/// Wired to the real implementation in `app/dependencies.dart`.
final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
