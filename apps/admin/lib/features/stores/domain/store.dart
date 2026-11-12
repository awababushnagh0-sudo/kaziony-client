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

/// What a store needs before customers see it. New stores start off, and
/// can be turned on once nothing is missing (the backend checks too).
enum GoLiveItem { logo, pickupInstructions, openingHours }

/// The backend's codes for a store's own refusals.
abstract final class StoreCodes {
  /// Turning on a store that lacks a [GoLiveItem], or emptying one of a
  /// live store.
  static const notReady = 'StoreNotReady';
}

/// A store's photos: the logo by its name, the cover across its page.
enum StoreImage { logo, cover }

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
    required this.phone,
    required this.missingToGoLive,
    this.address,
    this.openingHours = OpeningHours.none,
    this.pickupInstructions,
    this.ratingAverage,
    this.logoUrl,
    this.coverUrl,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
  });

  final String id;
  final String name;
  final Category category;

  /// Seen by customers.
  final bool isActive;

  /// What it still needs before it can be turned on, in order; empty when
  /// it's ready.
  final List<GoLiveItem> missingToGoLive;
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
  final String? coverUrl;

  /// How customers reach it about a pickup. Normalized (+2189XXXXXXXX).
  final String phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  String get label => '$name · $area';
}

/// What a store has under way, said before turning it off.
class StoreOngoing {
  const StoreOngoing({required this.liveOffers, required this.openBookings});

  /// On now or coming up: hidden while the store is off.
  final int liveOffers;

  /// Waiting to be picked up. They stay valid, and one missed while the
  /// store is off doesn't count against the customer.
  final int openBookings;
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
    required this.phone,
    this.pickupInstructions,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
    this.place,
  });

  final String name;
  final String categoryId;
  final String? pickupInstructions;

  /// Normalized (+2189XXXXXXXX).
  final String phone;
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
    required this.phone,
    required this.place,
    required this.ownerName,
    required this.ownerPhone,
  });

  final String name;
  final String categoryId;

  /// How customers reach it about a pickup. Normalized (+2189XXXXXXXX).
  final String phone;
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

  /// What turning the store off touches.
  Future<Result<StoreOngoing>> ongoing(String id);

  /// Puts [photo] in place of the store's logo or cover; [onProgress] gets
  /// the share sent, from 0 to 1.
  Future<Result<StoreDetails>> setImage(
    String id,
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  });

  /// Takes the logo or cover off. A live store keeps its logo: that fails
  /// with [StoreCodes.notReady].
  Future<Result<StoreDetails>> removeImage(String id, StoreImage image);

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
