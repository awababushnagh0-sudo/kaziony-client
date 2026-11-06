import 'dart:convert';

import 'package:kernel/kernel.dart';
import 'package:offers_api/customer.dart' as api;
import 'package:offers_api/customer.dart' show StoresClient;

import '../../offers/data/api_offers_repository.dart';
import '../domain/store.dart';

class ApiStoresRepository implements StoresRepository {
  ApiStoresRepository(this._api);

  final Api _api;
  late final _stores = _api.client(StoresClient.new);

  @override
  Future<Result<PageResult<StoreSummary>>> nearby(
    StoresQuery query, {
    required int page,
    required int pageSize,
  }) async {
    final search = query.search.trim();
    final result = await _api.guard(
      () => _stores.nearby(
        lat: query.around.latitude,
        lng: query.around.longitude,
        page: page,
        pageSize: pageSize,
        categoryId: query.categoryId,
        search: search.isEmpty ? null : search,
      ),
    );
    return result.map(
      (list) => PageResult(
        items: [
          for (final store in list.items)
            StoreSummary(
              id: store.id,
              name: store.name,
              logoUrl: store.logoUrl,
              coverUrl: store.coverUrl,
              category: toCategory(store.category),
              liveOfferCount: store.liveOfferCount.toInt(),
              nearestBranch: toBranch(store.nearestBranch),
              rating: toRating(store.ratingAverage, store.ratingCount),
            ),
        ],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<StoreDetail>> get(String storeId, {GeoPoint? around}) async {
    final result = await _api.guard(
      () => _stores.getStore(
        storeId: storeId,
        lat: around?.latitude,
        lng: around?.longitude,
      ),
    );
    return result.map(
      (store) => StoreDetail(
        id: store.id,
        name: store.name,
        logoUrl: store.logoUrl,
        coverUrl: store.coverUrl,
        phone: store.phone,
        pickupInstructions: storeWords(store.pickupInstructions),
        rating: toRating(store.ratingAverage, store.ratingCount),
        category: toCategory(store.category),
        branches: [for (final branch in store.branches) toBranch(branch)],
        isFollowing: store.isFollowing,
        offers: [
          // Read through JSON, so they map the same way as browsing's
          // (toJson leaves nested objects as they are).
          for (final offer in store.offers)
            toOffer(
              api.PublicOfferDto.fromJson(
                jsonDecode(jsonEncode(offer)) as Map<String, Object?>,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<List<StoreSummary>>> followed() async {
    final result = await _api.guard(() => _stores.followed());
    return result.map(
      (list) => [
        for (final store in list)
          StoreSummary(
            id: store.id,
            name: store.name,
            logoUrl: store.logoUrl,
            category: toCategory(store.category),
            liveOfferCount: store.liveOfferCount.toInt(),
          ),
      ],
    );
  }

  @override
  Future<Result<void>> follow(String storeId) =>
      _api.guard(() => _stores.follow(storeId: storeId));

  @override
  Future<Result<void>> unfollow(String storeId) =>
      _api.guard(() => _stores.unfollow(storeId: storeId));
}
