import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';
import 'location.dart';

/// A row in the stores list.
class StoreSummary {
  const StoreSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String name;
  final Category category;

  /// The neighbourhood: a brand's places share the name, so it tells them
  /// apart.
  final String area;
  final bool isActive;
  final DateTime createdAt;

  /// "حلويات الساحل · حي الأندلس", as the backend labels it in the log.
  String get label => '$name · $area';
}

/// Null (no filter) shows both.
enum StoreStatus { active, disabled }

typedef StoreQuery = ListQuery<StoreStatus>;
typedef StorePage = PageResult<StoreSummary>;

class Category {
  const Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  final String id;
  final String nameAr;
  final String nameEn;

  String name(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
}

/// One store, for its details page. A brand with several places is
/// several stores, each with its own place, offers and staff.
class StoreDetails {
  const StoreDetails({
    required this.id,
    required this.name,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.teamCount,
    required this.ratingCount,
    this.address,
    this.openingHours = OpeningHours.none,
    this.pickupInstructions,
    this.ratingAverage,
    this.logoUrl,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
  });

  final String id;
  final String name;
  final Category category;
  final bool isActive;
  final DateTime createdAt;

  /// Null for a city this version doesn't know yet.
  final City? city;

  /// The neighbourhood, shown with the name.
  final String area;
  final String? address;
  final double latitude;
  final double longitude;
  final OpeningHours openingHours;

  /// Owners and staff.
  final int teamCount;

  /// Shown to customers on every offer's page: where to go in the shop,
  /// what to bring.
  final String? pickupInstructions;

  /// Customers' stars after a pickup (1 to 5), one decimal. Null before the
  /// first rating.
  final double? ratingAverage;
  final int ratingCount;
  final String? logoUrl;

  /// Normalized (+2189XXXXXXXX).
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  String get label => '$name · $area';
}

/// Where a store is, as an admin sets it.
class StorePlace {
  const StorePlace({
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    this.address,
    this.openingHours = OpeningHours.none,
  });

  final City city;
  final String area;
  final String? address;
  final double latitude;
  final double longitude;
  final OpeningHours openingHours;
}

/// A store's own fields as an admin edited them. Empty optional fields
/// are null, and saving clears them.
class EditedStore {
  const EditedStore({
    required this.name,
    required this.categoryId,
    this.pickupInstructions,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
    this.place,
  });

  final String name;
  final String categoryId;
  final String? pickupInstructions;

  /// Normalized (+2189XXXXXXXX).
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Null keeps the place as it is: the owner sets the opening hours too,
  /// from the store app, and an edit of the name shouldn't undo theirs (or
  /// fill the activity log with a week of hours).
  final StorePlace? place;
}

/// A new store at its place, with its owner, as entered by an admin.
class NewStore {
  const NewStore({
    required this.name,
    required this.categoryId,
    required this.place,
    required this.ownerName,
    required this.ownerPhone,
    this.phone,
    this.email,
  });

  final String name;
  final String categoryId;

  /// Normalized (+2189XXXXXXXX).
  final String? phone;
  final String? email;
  final StorePlace place;
  final String ownerName;

  /// Normalized (+2189XXXXXXXX).
  final String ownerPhone;
}

/// Another place of a store's brand. The new store gets the brand's name,
/// category, photos, email and links, pickup instructions and owners.
class NewLocation {
  const NewLocation({required this.place, this.phone});

  final StorePlace place;

  /// Normalized (+2189XXXXXXXX). Null takes the brand's.
  final String? phone;
}

/// What to hand to the new store's owner.
class CreatedStore {
  const CreatedStore({
    required this.storeId,
    required this.storeName,
    required this.ownerPhone,
    required this.temporaryPassword,
  });

  final String storeId;
  final String storeName;
  final String ownerPhone;

  /// Shown once. Null when the phone already had a store account, which was
  /// linked as the owner instead.
  final String? temporaryPassword;
}

abstract interface class StoreRepository {
  Future<Result<StorePage>> list(StoreQuery query);
  Future<Result<StoreDetails>> get(String id);

  /// Fails like [create] when the place moves outside Libya.
  Future<Result<StoreDetails>> update(String id, EditedStore store);

  /// Disabled stores are hidden from customers and can't post offers.
  Future<Result<StoreDetails>> setActive(String id, {required bool active});

  /// Fails with a [ConflictFailure] when the store has offers: their claims
  /// are customers' history, so such a store can only be disabled.
  Future<Result<void>> delete(String id);
  Future<Result<List<Category>>> categories();

  /// Fails with a ValidationFailure whose code is
  /// [LocationCodes.outsideLibya] when the place is outside Libya.
  Future<Result<CreatedStore>> create(NewStore store);

  /// Opens [location] as another store of [storeId]'s brand, and returns
  /// the new store. Fails like [create] outside Libya.
  Future<Result<StoreDetails>> addLocation(
    String storeId,
    NewLocation location,
  );

  /// The point in a Google Maps link (short links included) or coordinates.
  /// Fails with a ValidationFailure whose code is one of [LocationCodes]
  /// when there's no usable point in it.
  Future<Result<LatLng>> resolveLocation(String link);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
