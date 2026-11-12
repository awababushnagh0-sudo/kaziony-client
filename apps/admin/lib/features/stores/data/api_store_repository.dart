import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart' hide City, GoLiveItem;
import 'package:offers_api/admin.dart' as api show City, GoLiveItem;

import '../domain/location.dart';
import '../domain/store.dart';

class ApiStoreRepository implements StoreRepository {
  ApiStoreRepository(this._api);

  final Api _api;
  late final _stores = _api.client(AdminStoresClient.new);
  late final _categories = _api.client(AdminCategoriesClient.new);
  late final _locations = _api.client(AdminLocationsClient.new);

  @override
  Future<Result<StorePage>> list(StoreQuery query) async {
    final result = await _api.guard(
      () => _stores.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        isActive: switch (query.filter) {
          null => null,
          StoreStatus.active => true,
          StoreStatus.disabled => false,
        },
      ),
    );
    return result.map(
      (dto) => StorePage(
        total: dto.meta.total.toInt(),
        items: [for (final store in dto.items) storeSummaryFromDto(store)],
      ),
    );
  }

  @override
  Future<Result<StoreDetails>> get(String id) async {
    final result = await _api.guard(() => _stores.getStore(id: id));
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<StoreDetails>> update(String id, EditedStore store) async {
    final result = await _api.guard(
      () => _stores.update(id: id, body: updateStoreBody(store)),
    );
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<StoreDetails>> setActive(
    String id, {
    required bool active,
  }) async {
    final result = await _api.guard(
      () => _stores.update(
        id: id,
        body: UpdateStoreDto(isActive: active),
      ),
    );
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<StoreOngoing>> ongoing(String id) async {
    final result = await _api.guard(() => _stores.ongoing(id: id));
    return result.map(
      (dto) => StoreOngoing(
        liveOffers: dto.liveOffers.toInt(),
        openBookings: dto.openBookings.toInt(),
      ),
    );
  }

  @override
  Future<Result<int>> cancelBookings(String id) async =>
      (await _api.guard(() => _stores.cancelBookings(id: id)))
          .map((dto) => dto.cancelled.toInt());

  @override
  Future<Result<StoreDetails>> setImage(
    String id,
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) async {
    final result = await _api.upload(
      AdminStoresClient.new,
      (stores) => stores.setImage(
        id: id,
        kind: _imageKind(image),
        image: photo.fullUpload(),
      ),
      onProgress: onProgress,
    );
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<StoreDetails>> removeImage(String id, StoreImage image) async {
    final result = await _api.guard(
      () => _stores.removeImage(id: id, kind: _imageKind(image)),
    );
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<void>> delete(String id) =>
      _api.guard(() => _stores.remove(id: id));

  @override
  Future<Result<List<Category>>> categories() async {
    final result = await _api.guard(_categories.list);
    return result.map(
      (list) => [
        for (final category in list)
          if (category.isActive) _toCategory(category),
      ],
    );
  }

  @override
  Future<Result<CreatedStore>> create(NewStore store) async {
    final result = await _api.guard(
      () => _stores.create(body: createStoreBody(store)),
    );
    return result.map(
      (dto) => CreatedStore(
        storeId: dto.store.id,
        storeName: dto.store.name,
        ownerPhone: dto.owner.phone,
        temporaryPassword: dto.owner.temporaryPassword,
      ),
    );
  }

  @override
  Future<Result<StoreDetails>> addLocation(
    String storeId,
    NewLocation location,
  ) async {
    final result = await _api.guard(
      () => _stores.addLocation(
        storeId: storeId,
        body: addLocationBody(location),
      ),
    );
    return result.map(storeDetailsFromDto);
  }

  @override
  Future<Result<LatLng>> resolveLocation(String link) async {
    final result = await _api.guard(
      () => _locations.resolve(body: ResolveLocationDto(link: link)),
    );
    return result.map(
      (dto) => (
        latitude: dto.latitude.toDouble(),
        longitude: dto.longitude.toDouble(),
      ),
    );
  }
}

@visibleForTesting
StoreSummary storeSummaryFromDto(StoreListItemDto dto) => StoreSummary(
  id: dto.id,
  name: dto.name,
  category: _toCategory(dto.category),
  area: dto.area,
  isActive: dto.isActive,
  createdAt: dto.createdAt,
);

@visibleForTesting
StoreDetails storeDetailsFromDto(StoreDetailDto dto) => StoreDetails(
  id: dto.id,
  name: dto.name,
  category: _toCategory(dto.category),
  isActive: dto.isActive,
  createdAt: dto.createdAt,
  city: switch (dto.city) {
    api.City.tripoli => City.tripoli,
    api.City.$unknown => null,
  },
  area: dto.area,
  address: dto.address,
  latitude: dto.latitude.toDouble(),
  longitude: dto.longitude.toDouble(),
  openingHours: OpeningHours.fromJson(dto.openingHours),
  teamCount: dto.members.length,
  missingToGoLive: [
    for (final item in dto.missingToGoLive)
      ?switch (item) {
        api.GoLiveItem.logo => GoLiveItem.logo,
        api.GoLiveItem.pickupInstructions => GoLiveItem.pickupInstructions,
        api.GoLiveItem.openingHours => GoLiveItem.openingHours,
        api.GoLiveItem.$unknown => null,
      },
  ],
  ratingAverage: dto.ratingAverage?.toDouble(),
  ratingCount: dto.ratingCount.toInt(),
  pickupInstructions: dto.pickupInstructions,
  logoUrl: dto.logoUrl,
  coverUrl: dto.coverUrl,
  phone: dto.phone,
  email: dto.email,
  facebookUrl: dto.facebookUrl,
  instagramUrl: dto.instagramUrl,
);

@visibleForTesting
CreateStoreDto createStoreBody(NewStore store) {
  final place = store.place;
  return CreateStoreDto(
    name: store.name,
    categoryId: store.categoryId,
    phone: store.phone,
    city: _toApiCity(place.city),
    area: place.area,
    address: place.address,
    latitude: place.latitude,
    longitude: place.longitude,
    openingHours: _newOpeningHours(place.openingHours),
    owner: NewMerchantDto(name: store.ownerName, phone: store.ownerPhone),
  );
}

/// Every own field is sent, and the place when it's given; an empty
/// string clears an optional one.
@visibleForTesting
UpdateStoreDto updateStoreBody(EditedStore store) {
  final place = store.place;
  return UpdateStoreDto(
    name: store.name,
    categoryId: store.categoryId,
    pickupInstructions: store.pickupInstructions ?? '',
    phone: store.phone,
    email: store.email ?? '',
    facebookUrl: store.facebookUrl ?? '',
    instagramUrl: store.instagramUrl ?? '',
    city: place == null ? null : _toApiCity(place.city),
    area: place?.area,
    address: place == null ? null : place.address ?? '',
    latitude: place?.latitude,
    longitude: place?.longitude,
    openingHours: place?.openingHours.toJson(),
  );
}

@visibleForTesting
AddStoreLocationDto addLocationBody(NewLocation location) {
  final place = location.place;
  return AddStoreLocationDto(
    city: _toApiCity(place.city),
    area: place.area,
    address: place.address,
    latitude: place.latitude,
    longitude: place.longitude,
    openingHours: _newOpeningHours(place.openingHours),
    phone: location.phone,
  );
}

Category _toCategory(CategoryDto dto) =>
    Category(id: dto.id, nameAr: dto.nameAr, nameEn: dto.nameEn);

api.City _toApiCity(City city) => switch (city) {
  City.tripoli => api.City.tripoli,
};

/// A new place without hours sends none.
Map<String, Object?>? _newOpeningHours(OpeningHours hours) =>
    hours.isEmpty ? null : hours.toJson();

/// The backend's name for [image] in its photo routes.
String _imageKind(StoreImage image) => switch (image) {
  StoreImage.logo => 'logo',
  StoreImage.cover => 'cover',
};
