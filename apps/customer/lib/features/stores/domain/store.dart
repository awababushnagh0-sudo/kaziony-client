import 'package:kernel/kernel.dart';

import '../../offers/domain/offer.dart';

/// A store in a list (near you, the customer's favorites): its logo,
/// name and area, and how far.
class StoreSummary {
  const StoreSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.liveOfferCount,
    this.logoUrl,
    this.coverUrl,
    this.area,
    this.distanceKm,
    this.rating,
  });

  final String id;
  final String name;
  final String? logoUrl;
  final String? coverUrl;
  final Category category;
  final int liveOfferCount;

  /// The neighbourhood: tells a brand's places apart.
  final String? area;

  /// Null for followed stores, listed wherever they are.
  final double? distanceKm;

  /// Null before its first rating.
  final StoreRating? rating;
}

/// A store's page.
class StoreDetail {
  const StoreDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.offers,
    this.logoUrl,
    this.coverUrl,
    this.phone,
    this.pickupInstructions,
    this.rating,
    this.isFollowing,
  });

  final String id;
  final String name;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final Category category;

  /// What the store asks of customers picking up; null when it hasn't
  /// said.
  final String? pickupInstructions;

  /// Null before its first rating.
  final StoreRating? rating;

  final StoreLocation location;

  /// Null for guests.
  final bool? isFollowing;

  /// Live now, ending soonest first.
  final List<Offer> offers;
}

/// Which stores to list around a place.
class StoresQuery {
  const StoresQuery({required this.around, this.categoryId, this.search = ''});

  final GeoPoint around;
  final String? categoryId;
  final String search;

  @override
  bool operator ==(Object other) =>
      other is StoresQuery &&
      other.around == around &&
      other.categoryId == categoryId &&
      other.search == search;

  @override
  int get hashCode => Object.hash(around, categoryId, search);
}

abstract interface class StoresRepository {
  /// Closest first, within the browse radius.
  Future<Result<PageResult<StoreSummary>>> nearby(
    StoresQuery query, {
    required int page,
    required int pageSize,
  });

  Future<Result<StoreDetail>> get(String storeId, {GeoPoint? around});

  /// The signed-in customer's, most recently followed first.
  Future<Result<List<StoreSummary>>> followed();

  Future<Result<void>> follow(String storeId);

  Future<Result<void>> unfollow(String storeId);
}

final storesRepositoryProvider = Provider<StoresRepository>(
  (ref) => throw UnimplementedError('Overridden in dependencies.dart'),
);
