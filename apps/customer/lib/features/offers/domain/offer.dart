import 'package:kernel/kernel.dart';

/// A kind of store (bakeries, sweets, cafés): what offers are filtered by.
class Category {
  const Category({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.iconUrl,
  });

  final String id;

  /// Stable across environments: picks the app's own picture for it.
  final String slug;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

/// What customers thought of a store after picking up there.
class StoreRating {
  const StoreRating({required this.average, required this.count});

  /// From 1 to 5, with one decimal.
  final double average;

  /// How many pickups were rated.
  final int count;
}

class OfferStore {
  const OfferStore({
    required this.id,
    required this.name,
    required this.category,
    this.logoUrl,
    this.rating,
  });

  final String id;
  final String name;
  final String? logoUrl;
  final Category category;

  /// Null before its first rating.
  final StoreRating? rating;
}

/// Where a store is: its one place, where its offers are picked up. A
/// brand with several places is several stores, told apart by [area].
class StoreLocation {
  const StoreLocation({
    required this.point,
    this.area,
    this.address,
    this.phone,
    this.hours = OpeningHours.none,
    this.distanceKm,
  });

  final GeoPoint point;

  /// The neighbourhood, shown with the store's name.
  final String? area;
  final String? address;
  final String? phone;
  final OpeningHours hours;

  /// From the place offers are shown around.
  final double? distanceKm;
}

/// A live offer as customers see it.
class Offer {
  const Offer({
    required this.id,
    required this.title,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercent,
    required this.limited,
    required this.claimWindowMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.store,
    required this.location,
    this.description,
    this.imageUrl,
    this.thumbUrl,
    this.remaining,
    this.total,
    this.maxPerUser,
  });

  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? thumbUrl;

  /// LD with 3 decimals ("4.500"): shown with `formatPrice`, never added up.
  final String originalPrice;
  final String offerPrice;
  final int discountPercent;

  /// Counted pieces, held for [claimWindowMinutes] once reserved (never
  /// past the offer's end); else a code good until the offer ends.
  final bool limited;
  final int? remaining;
  final int? total;

  /// The most one customer can take; null for no limit.
  final int? maxPerUser;
  final int claimWindowMinutes;

  /// When it can be picked up: from [startsAt] until [endsAt].
  final DateTime startsAt;
  final DateTime endsAt;
  final OfferStore store;

  /// Where to pick it up: the store's place.
  final StoreLocation location;

  /// The most that can be reserved at once: what's left, within the
  /// per-customer limit.
  int get maxReservable {
    final left = limited ? (remaining ?? 0) : null;
    return switch ((left, maxPerUser)) {
      (null, null) => _unlimitedMax,
      (final l?, null) => l,
      (null, final m?) => m,
      (final l?, final m?) => l < m ? l : m,
    };
  }

  /// No offer needs more at once; keeps the picker short.
  static const _unlimitedMax = 10;

  /// A few pieces left: worth saying in orange.
  bool get almostGone => limited && (remaining ?? 0) <= _almostGone;
  static const _almostGone = 3;
}

/// An offer's page: how to pick it up, and the customer's reservation if
/// any.
class OfferDetail {
  const OfferDetail({
    required this.offer,
    this.pickupInstructions,
    this.myBookingId,
  });

  final Offer offer;

  /// What the store asks of customers picking up, in its own words; null
  /// when it hasn't said.
  final String? pickupInstructions;

  /// The signed-in customer's active reservation for it.
  final String? myBookingId;
}

enum OfferSort { nearest, endingSoon, newest, biggestDiscount }

/// Which offers to list.
class OffersQuery {
  const OffersQuery({
    required this.around,
    this.sort = OfferSort.nearest,
    this.categoryId,
    this.search = '',
  });

  final GeoPoint around;
  final OfferSort sort;
  final String? categoryId;
  final String search;

  @override
  bool operator ==(Object other) =>
      other is OffersQuery &&
      other.around == around &&
      other.sort == sort &&
      other.categoryId == categoryId &&
      other.search == search;

  @override
  int get hashCode => Object.hash(around, sort, categoryId, search);
}

abstract interface class OffersRepository {
  Future<Result<PageResult<Offer>>> browse(
    OffersQuery query, {
    required int page,
    required int pageSize,
  });

  Future<Result<OfferDetail>> get(String offerId, {GeoPoint? around});

  /// Active ones, in the order the admins set.
  Future<Result<List<Category>>> categories();
}

final offersRepositoryProvider = Provider<OffersRepository>(
  (ref) => throw UnimplementedError('Overridden in dependencies.dart'),
);
