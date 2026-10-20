import 'package:kernel/kernel.dart';
import 'package:offers_api/business.dart';

import '../domain/store.dart';

class ApiStoreRepository implements StoreRepository {
  ApiStoreRepository(this._api);

  final Api _api;
  late final _stores = _api.client(BusinessStoreClient.new);

  @override
  Future<Result<Store>> getStore(String storeId) async {
    final result = await _api.guard(() => _stores.getStore(storeId: storeId));
    return result.map(_toStore);
  }
}

Store _toStore(StoreDetailDto dto) => Store(
  id: dto.id,
  name: dto.name,
  description: dto.description,
  logoUrl: dto.logoUrl,
  isActive: dto.isActive,
  branches: [
    for (final branch in dto.branches)
      Branch(
        id: branch.id,
        name: branch.name,
        city: branch.city,
        area: branch.area,
        isActive: branch.isActive,
      ),
  ],
);
