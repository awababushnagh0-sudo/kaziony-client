import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/dashboard_stats.dart';

class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository(this._api);

  final Api _api;
  late final _stats = _api.client(AdminStatsClient.new);

  @override
  Future<Result<DashboardStats>> getStats() async {
    final result = await _api.guard(_stats.getStats);
    return result.map(
      (dto) => DashboardStats(
        stores: dto.stores.total.toInt(),
        activeStores: dto.stores.active.toInt(),
        liveOffers: dto.offers.live.toInt(),
        totalOffers: dto.offers.total.toInt(),
        customers: dto.users.customers.toInt(),
        newCustomersLast7Days: dto.users.newCustomersLast7Days.toInt(),
        claimsLast7Days: dto.claims.last7Days.toInt(),
        redemptionRate: dto.claims.redemptionRate?.toDouble(),
      ),
    );
  }
}
