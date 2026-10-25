import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart' hide City;
import 'package:offers_api/partner.dart' as api show City;

import '../domain/store.dart';

class ApiStoreRepository implements StoreRepository {
  ApiStoreRepository(this._api);

  final Api _api;
  late final _stores = _api.client(PartnerStoreClient.new);

  @override
  Future<Result<Store>> getStore(String storeId) async {
    final result = await _api.guard(() => _stores.getStore(storeId: storeId));
    return result.map(_toStore);
  }

  @override
  Future<Result<Store>> updateProfile(
    String storeId,
    StoreProfile profile,
  ) async {
    final result = await _api.guard(
      () => _stores.updateProfile(
        storeId: storeId,
        // An empty value clears the field on the server.
        body: UpdateStoreProfileDto(
          description: profile.description ?? '',
          phone: profile.phone ?? '',
          email: profile.email ?? '',
          facebookUrl: profile.facebookUrl ?? '',
          instagramUrl: profile.instagramUrl ?? '',
        ),
      ),
    );
    return result.map(_toStore);
  }
}

Store _toStore(StoreDetailDto dto) => Store(
  id: dto.id,
  name: dto.name,
  category: StoreCategory(
    nameAr: dto.category.nameAr,
    nameEn: dto.category.nameEn,
  ),
  profile: StoreProfile(
    description: dto.description,
    phone: dto.phone,
    email: dto.email,
    facebookUrl: dto.facebookUrl,
    instagramUrl: dto.instagramUrl,
  ),
  isActive: dto.isActive,
  branches: [
    for (final branch in dto.branches)
      Branch(
        id: branch.id,
        name: branch.name,
        city: switch (branch.city) {
          api.City.tripoli => City.tripoli,
          api.City.$unknown => null,
        },
        area: branch.area,
        address: branch.address,
        phone: branch.phone,
        isActive: branch.isActive,
      ),
  ],
  members: [
    for (final member in dto.members)
      StoreMember(
        userId: member.userId,
        name: member.name,
        phone: member.phone,
        isOwner: member.role == StoreMemberRole.owner,
        branchId: member.branchId,
        isActive: member.isActive,
      ),
  ],
);
