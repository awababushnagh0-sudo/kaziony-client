import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/service_area.dart';

class ApiServiceAreaRepository implements ServiceAreaRepository {
  ApiServiceAreaRepository(this._api);

  final Api _api;
  late final _areas = _api.client(AdminServiceAreasClient.new);

  @override
  Future<Result<List<ServiceArea>>> list() async {
    final result = await _api.guard(_areas.listServiceAreas);
    return result.map((areas) => areas.map(_toArea).toList());
  }

  @override
  Future<Result<ServiceArea>> create(ServiceAreaDraft draft) async {
    final result = await _api.guard(
      () => _areas.createServiceArea(
        body: CreateServiceAreaDto(
          nameAr: draft.nameAr,
          nameEn: draft.nameEn,
          latitude: draft.latitude,
          longitude: draft.longitude,
          radiusKm: draft.radiusKm,
          isActive: draft.isActive,
        ),
      ),
    );
    return result.map(_toArea);
  }

  @override
  Future<Result<ServiceArea>> update(String id, ServiceAreaDraft draft) async {
    final result = await _api.guard(
      () => _areas.updateServiceArea(
        id: id,
        body: UpdateServiceAreaDto(
          nameAr: draft.nameAr,
          nameEn: draft.nameEn,
          latitude: draft.latitude,
          longitude: draft.longitude,
          radiusKm: draft.radiusKm,
          isActive: draft.isActive,
        ),
      ),
    );
    return result.map(_toArea);
  }

  @override
  Future<Result<void>> delete(String id) =>
      _api.guard(() => _areas.deleteServiceArea(id: id));
}

ServiceArea _toArea(ServiceAreaDto dto) => ServiceArea(
  id: dto.id,
  nameAr: dto.nameAr,
  nameEn: dto.nameEn,
  latitude: dto.latitude.toDouble(),
  longitude: dto.longitude.toDouble(),
  radiusKm: dto.radiusKm.toInt(),
  isActive: dto.isActive,
);
