import 'dart:convert';

import 'package:kernel/kernel.dart';
import 'package:offers_api/customer.dart' as api;
import 'package:offers_api/customer.dart' show CategoriesClient, OffersClient;

import '../domain/offer.dart';

class ApiOffersRepository implements OffersRepository {
  ApiOffersRepository(this._api);

  final Api _api;
  late final _offers = _api.client(OffersClient.new);
  late final _categories = _api.client(CategoriesClient.new);

  @override
  Future<Result<PageResult<Offer>>> browse(
    OffersQuery query, {
    required int page,
    required int pageSize,
  }) async {
    final search = query.search.trim();
    final result = await _api.guard(
      () => _offers.browse(
        page: page,
        pageSize: pageSize,
        lat: query.around.latitude,
        lng: query.around.longitude,
        sort: switch (query.sort) {
          OfferSort.nearest => api.OfferSort.nearest,
          OfferSort.endingSoon => api.OfferSort.endingSoon,
          OfferSort.newest => api.OfferSort.newest,
          OfferSort.biggestDiscount => api.OfferSort.biggestDiscount,
        },
        categoryId: query.categoryId,
        search: search.isEmpty ? null : search,
      ),
    );
    return result.map(
      (list) => PageResult(
        items: [for (final offer in list.items) toOffer(offer)],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<OfferDetail>> get(String offerId, {GeoPoint? around}) async {
    final result = await _api.guard(
      () => _offers.getOffer(
        offerId: offerId,
        lat: around?.latitude,
        lng: around?.longitude,
      ),
    );
    return result.map(
      (offer) => OfferDetail(
        // The list's offer and more: read through JSON as one, so both map
        // the same way (toJson leaves nested objects as they are).
        offer: toOffer(
          api.PublicOfferDto.fromJson(
            jsonDecode(jsonEncode(offer)) as Map<String, Object?>,
          ),
        ),
        pickupInstructions: storeWords(offer.pickupInstructions),
        myBookingId: offer.myActiveClaimId,
      ),
    );
  }

  @override
  Future<Result<List<Category>>> categories() async {
    final result = await _api.guard(() => _categories.list());
    return result.map(
      (list) => [
        for (final category in list)
          if (category.isActive) toCategory(category),
      ],
    );
  }
}

/// Shared with stores, whose page lists their offers.
Offer toOffer(api.PublicOfferDto offer) => Offer(
  id: offer.id,
  title: offer.title,
  description: offer.description,
  imageUrl: offer.imageUrl,
  thumbUrl: offer.thumbUrl,
  originalPrice: offer.originalPrice,
  offerPrice: offer.offerPrice,
  discountPercent: offer.discountPercent.toInt(),
  limited: offer.type == api.OfferType.limited,
  remaining: offer.remainingQuantity?.toInt(),
  total: offer.totalQuantity?.toInt(),
  maxPerUser: offer.maxPerUser?.toInt(),
  claimWindowMinutes: offer.claimWindowMinutes.toInt(),
  lastBookingMinutes: offer.lastBookingMinutes.toInt(),
  lastPickupMinutes: offer.lastPickupMinutes.toInt(),
  startsAt: offer.startsAt.toLocal(),
  endsAt: offer.endsAt.toLocal(),
  store: OfferStore(
    id: offer.store.id,
    name: offer.store.name,
    logoUrl: offer.store.logoUrl,
    category: toCategory(offer.store.category),
    rating: toRating(offer.store.ratingAverage, offer.store.ratingCount),
  ),
  location: toLocation(offer.location),
);

/// Shared with stores. Null before the first rating.
StoreRating? toRating(num? average, num count) => average == null || count < 1
    ? null
    : StoreRating(average: average.toDouble(), count: count.toInt());

/// What a store wrote, or null when it's only blanks. Shared with stores.
String? storeWords(String? text) {
  final words = text?.trim();
  return words == null || words.isEmpty ? null : words;
}

Category toCategory(api.CategoryDto category) => Category(
  id: category.id,
  slug: category.slug,
  nameAr: category.nameAr,
  nameEn: category.nameEn,
  iconUrl: category.iconUrl,
);

/// Shared with stores and bookings, which say where to pick up too.
StoreLocation toLocation(api.PublicLocationDto location) => StoreLocation(
  point: GeoPoint(location.latitude.toDouble(), location.longitude.toDouble()),
  area: storeWords(location.area),
  address: storeWords(location.address),
  phone: storeWords(location.phone),
  hours: StoreSchedule.fromJson(
    openingHours: location.openingHours,
    specialHours: location.specialHours,
    pausedUntil: location.pausedUntil,
  ),
  distanceKm: location.distanceKm?.toDouble(),
);
