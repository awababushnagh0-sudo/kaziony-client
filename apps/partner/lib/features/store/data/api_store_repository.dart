import 'dart:io';

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
          pickupInstructions: profile.pickupInstructions ?? '',
          phone: profile.phone ?? '',
          email: profile.email ?? '',
          facebookUrl: profile.facebookUrl ?? '',
          instagramUrl: profile.instagramUrl ?? '',
        ),
      ),
    );
    return result.map(_toStore);
  }

  @override
  Future<Result<Store>> setOpeningHours(
    String storeId,
    OpeningHours hours,
  ) async {
    final result = await _api.guard(
      () => _stores.updateProfile(
        storeId: storeId,
        // The fields left out stay as they are.
        body: UpdateStoreProfileDto(openingHours: hours.toJson()),
      ),
    );
    return result.map(_toStore);
  }

  @override
  Future<Result<Store>> setImage(
    String storeId,
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) async {
    final result = await _api.upload(
      PartnerStoreClient.new,
      (stores) => stores.setImage(
        storeId: storeId,
        kind: switch (image) {
          StoreImage.logo => 'logo',
          StoreImage.cover => 'cover',
        },
        image: File(photo.fullPath),
      ),
      onProgress: onProgress,
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
  city: switch (dto.city) {
    api.City.tripoli => City.tripoli,
    api.City.$unknown => null,
  },
  area: dto.area,
  address: dto.address,
  location: GeoPoint(dto.latitude.toDouble(), dto.longitude.toDouble()),
  openingHours: OpeningHours.fromJson(dto.openingHours),
  profile: StoreProfile(
    pickupInstructions: dto.pickupInstructions,
    phone: dto.phone,
    email: dto.email,
    facebookUrl: dto.facebookUrl,
    instagramUrl: dto.instagramUrl,
  ),
  logoUrl: dto.logoUrl,
  coverUrl: dto.coverUrl,
  isActive: dto.isActive,
  ratingAverage: dto.ratingAverage?.toDouble(),
  ratingCount: dto.ratingCount.toInt(),
  members: [
    for (final member in dto.members)
      StoreMember(
        userId: member.userId,
        name: member.name,
        phone: member.phone,
        isOwner: member.role == StoreMemberRole.owner,
        isActive: member.isActive,
      ),
  ],
);
