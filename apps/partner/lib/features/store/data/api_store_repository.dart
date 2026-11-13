import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart' hide City, GoLiveItem;
import 'package:offers_api/partner.dart' as api show City, GoLiveItem;

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
        // An empty value clears the field on the server; the phone can't
        // be cleared.
        body: UpdateStoreProfileDto(
          pickupInstructions: profile.pickupInstructions ?? '',
          phone: profile.phone,
          email: profile.email ?? '',
          facebookUrl: profile.facebookUrl ?? '',
          instagramUrl: profile.instagramUrl ?? '',
          delivers: profile.delivers,
          deliveryPhone: profile.deliveryPhone ?? '',
        ),
      ),
    );
    return result.map(_toStore);
  }

  @override
  Future<Result<Store>> setHours(
    String storeId,
    OpeningHours weekly,
    List<SpecialHours> special,
  ) async {
    final result = await _api.guard(
      () => _stores.updateProfile(
        storeId: storeId,
        // The fields left out stay as they are.
        body: UpdateStoreProfileDto(
          openingHours: weekly.toJson(),
          specialHours: [for (final range in special) range.toJson()],
        ),
      ),
    );
    return result.map(_toStore);
  }

  @override
  Future<Result<StorePause>> getPause(String storeId) async {
    final result = await _api.guard(() => _stores.getPause(storeId: storeId));
    return result.map(_toPause);
  }

  @override
  Future<Result<StorePaused>> pause(
    String storeId, {
    Duration? duration,
    bool cancelBookings = false,
  }) async {
    final result = await _api.guard(
      () => _stores.pause(
        storeId: storeId,
        body: PauseStoreDto(
          minutes: duration?.inMinutes,
          cancelBookings: cancelBookings,
        ),
      ),
    );
    return result.map(
      (dto) => (
        pause: StorePause(
          pausedUntil: dto.pausedUntil?.toLocal(),
          nextOpening: dto.nextOpening?.toLocal(),
          waitingBookings: dto.waitingBookings.toInt(),
        ),
        cancelled: dto.cancelled.toInt(),
      ),
    );
  }

  @override
  Future<Result<StorePause>> resume(String storeId) async {
    final result = await _api.guard(() => _stores.resume(storeId: storeId));
    return result.map(_toPause);
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
        image: photo.fullUpload(),
      ),
      onProgress: onProgress,
    );
    return result.map(_toStore);
  }
}

StorePause _toPause(StorePauseDto dto) => StorePause(
  pausedUntil: dto.pausedUntil?.toLocal(),
  nextOpening: dto.nextOpening?.toLocal(),
  waitingBookings: dto.waitingBookings.toInt(),
);

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
  specialHours: SpecialHours.listFromJson(dto.specialHours),
  profile: StoreProfile(
    pickupInstructions: dto.pickupInstructions,
    phone: dto.phone,
    email: dto.email,
    facebookUrl: dto.facebookUrl,
    instagramUrl: dto.instagramUrl,
    delivers: dto.delivers,
    deliveryPhone: dto.deliveryPhone,
  ),
  logoUrl: dto.logoUrl,
  coverUrl: dto.coverUrl,
  isActive: dto.isActive,
  wasLive: dto.wasLive,
  missingToGoLive: [
    for (final item in dto.missingToGoLive)
      ?switch (item) {
        api.GoLiveItem.logo => GoLiveItem.logo,
        api.GoLiveItem.pickupInstructions => GoLiveItem.pickupInstructions,
        api.GoLiveItem.openingHours => GoLiveItem.openingHours,
        // One added after this version of the app.
        api.GoLiveItem.$unknown => null,
      },
  ],
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
