import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart';

import '../domain/store_stats.dart';

class ApiStatsRepository implements StatsRepository {
  ApiStatsRepository(this._api);

  final Api _api;
  late final _stores = _api.client(PartnerStoreClient.new);

  @override
  Future<Result<StoreStats>> get(String storeId) async =>
      (await _api.guard(() => _stores.getStats(storeId: storeId))).map(
        (dto) => StoreStats(
          liveOffers: dto.liveOffers.toInt(),
          onTheWay: dto.activeReservations.toInt(),
          today: _toPeriod(dto.today),
          last30Days: _toPeriod(dto.last30Days),
        ),
      );
}

PeriodStats _toPeriod(PeriodStatsDto dto) => PeriodStats(
  claims: dto.claims.toInt(),
  redeemed: dto.redeemed.toInt(),
  expired: dto.expired.toInt(),
  redemptionRate: dto.redemptionRate?.toDouble(),
);
