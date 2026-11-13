import 'package:kernel/kernel.dart';

class StoreCategory {
  const StoreCategory({required this.nameAr, required this.nameEn});

  final String nameAr;
  final String nameEn;

  String name(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
}

class StoreMember {
  const StoreMember({
    required this.userId,
    required this.name,
    required this.phone,
    required this.isOwner,
    required this.isActive,
  });

  final String userId;
  final String? name;
  final String? phone;
  final bool isOwner;
  final bool isActive;
}

/// How customers get in touch, shown on the store's page. The owner edits
/// it; the name and category stay with our team.
class StoreProfile {
  const StoreProfile({
    required this.pickupInstructions,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.delivers,
    required this.deliveryPhone,
  });

  /// Shown on every offer's page: where to go in the shop, what to bring.
  final String? pickupInstructions;

  /// How customers reach the store about a pickup. Every store has one: it
  /// can change, not be cleared.
  final String phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Has its own drivers: customers with a booking can call to have it
  /// brought. Delivery and any fee are between them and the store.
  final bool delivers;

  /// The number customers call for that; null for [phone].
  final String? deliveryPhone;
}

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.area,
    required this.address,
    required this.location,
    required this.openingHours,
    required this.specialHours,
    required this.profile,
    required this.logoUrl,
    required this.coverUrl,
    required this.isActive,
    required this.wasLive,
    required this.missingToGoLive,
    required this.ratingAverage,
    required this.ratingCount,
    required this.members,
  });

  final String id;
  final String name;
  final StoreCategory category;

  /// Null for a city added after this version of the app.
  final City? city;

  /// The neighbourhood, shown with the name: a brand's places share it.
  final String? area;
  final String? address;

  /// Where it is on the map. Our team sets it, with the area and address.
  final GeoPoint location;

  /// The owner sets them.
  final OpeningHours openingHours;

  /// Dates that differ from [openingHours] (Ramadan, Eid), ones that
  /// haven't ended. The owner sets them too.
  final List<SpecialHours> specialHours;
  final StoreProfile profile;

  /// Round, by the store's name wherever customers see it.
  final String? logoUrl;

  /// Wide, across the top of the store's page.
  final String? coverUrl;

  /// Customers see it. New stores start off, and our team turns them on
  /// once they have what customers need. Stores that are off can't post
  /// offers.
  final bool isActive;

  /// Has been on for customers: one that's off now was turned off by our
  /// team, rather than waiting for its first day.
  final bool wasLive;

  /// What customers need that the store still lacks, in the order to add
  /// it; empty when it's ready. A live store can't lose them either.
  final List<GoLiveItem> missingToGoLive;

  /// Customers' stars after a pickup (1 to 5), one decimal. Null before the
  /// first rating.
  final double? ratingAverage;
  final int ratingCount;
  final List<StoreMember> members;

  /// Its name with its area: [storeLabel].
  String get label => storeLabel(name, area);
}

/// A store's name with its area, to tell a brand's places apart, each a
/// store of its own: "حلويات الساحل · حي الأندلس".
String storeLabel(String name, String? area) =>
    area == null || area.isEmpty ? name : '$name · $area';

/// The store's two pictures.
enum StoreImage { logo, cover }

/// Whether customers can book now: a store goes offline for a break, or
/// closes suddenly, and is back when the time is up (or sooner).
class StorePause {
  const StorePause({
    required this.pausedUntil,
    required this.nextOpening,
    required this.waitingBookings,
  });

  /// Offline until then; null when it takes bookings.
  final DateTime? pausedUntil;

  /// When the store's hours next open, after the stretch it's in: how long
  /// "until we open again" lasts. Null when they don't say.
  final DateTime? nextOpening;

  /// Bookings made and not picked up yet: they stand through a break, or
  /// are cancelled when the store closes suddenly.
  final int waitingBookings;

  /// Whether it's offline at [now].
  bool pausedAt(DateTime now) => pausedUntil?.isAfter(now) ?? false;
}

/// What a store needs before customers can see it. The owner adds each.
enum GoLiveItem { logo, pickupInstructions, openingHours }

/// What going offline did.
typedef StorePaused = ({StorePause pause, int cancelled});

abstract interface class StoreRepository {
  Future<Result<Store>> getStore(String storeId);

  /// Owners only.
  Future<Result<Store>> updateProfile(String storeId, StoreProfile profile);

  /// Owners only: the week's hours and the [special] dates, all of them.
  /// Leaves the profile as it is. Hours that close the store before
  /// bookings waiting are due fail with `HoursCancelBookings`, unless
  /// [cancelBookings] says to cancel them (their customers are told, and it
  /// doesn't count against them).
  Future<Result<Store>> setHours(
    String storeId,
    OpeningHours weekly,
    List<SpecialHours> special, {
    bool cancelBookings = false,
  });

  /// Owners and staff.
  Future<Result<StorePause>> getPause(String storeId);

  /// Owners and staff: stops new bookings for [duration], or until the
  /// hours open next when null. With [cancelBookings], for a sudden
  /// closing, the bookings waiting are cancelled too (their customers are
  /// told, and it doesn't count against them); [StorePaused.cancelled] says
  /// how many.
  Future<Result<StorePaused>> pause(
    String storeId, {
    Duration? duration,
    bool cancelBookings = false,
  });

  /// Owners and staff: customers can book again.
  Future<Result<StorePause>> resume(String storeId);

  /// Owners only. Replaces [image] with [photo].
  Future<Result<Store>> setImage(
    String storeId,
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  });
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
