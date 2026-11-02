import 'package:kernel/kernel.dart';
import 'package:offers_api/auth.dart';

import '../domain/browse_location.dart';

class ApiServiceAreaRepository implements ServiceAreaRepository {
  ApiServiceAreaRepository(this._api);

  final Api _api;
  late final _config = _api.client(AppConfigClient.new);

  @override
  Future<Result<List<ServiceArea>>> areas() async {
    final result = await _api.guard(() => _config.getAppConfig());
    return result.map(
      (config) => [
        for (final area in config.browse.areas)
          ServiceArea(
            nameAr: area.nameAr,
            nameEn: area.nameEn,
            center: GeoPoint(
              area.latitude.toDouble(),
              area.longitude.toDouble(),
            ),
            radiusKm: area.radiusKm,
          ),
      ],
    );
  }
}
