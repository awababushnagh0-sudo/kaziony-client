import 'package:kernel/kernel.dart';

class StoreCategory {
  const StoreCategory({required this.nameAr, required this.nameEn});

  final String nameAr;
  final String nameEn;

  String name(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
}

class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.address,
    required this.phone,
    required this.isActive,
  });

  final String id;
  final String name;

  /// Null for a city added after this version of the app.
  final City? city;
  final String? area;
  final String? address;
  final String? phone;
  final bool isActive;
}

class StoreMember {
  const StoreMember({
    required this.userId,
    required this.name,
    required this.phone,
    required this.isOwner,
    required this.branchId,
    required this.isActive,
  });

  final String userId;
  final String? name;
  final String? phone;
  final bool isOwner;

  /// Staff limited to one branch. Null means all branches.
  final String? branchId;
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
  });

  /// Shown on every offer's page: where to go in the shop, what to bring.
  final String? pickupInstructions;
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;
}

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.category,
    required this.profile,
    required this.logoUrl,
    required this.coverUrl,
    required this.isActive,
    required this.ratingAverage,
    required this.ratingCount,
    required this.branches,
    required this.members,
  });

  final String id;
  final String name;
  final StoreCategory category;
  final StoreProfile profile;

  /// Round, by the store's name wherever customers see it.
  final String? logoUrl;

  /// Wide, across the top of the store's page.
  final String? coverUrl;

  /// Disabled stores can't post offers.
  final bool isActive;

  /// Customers' stars after a pickup (1 to 5), one decimal. Null before the
  /// first rating.
  final double? ratingAverage;
  final int ratingCount;
  final List<Branch> branches;
  final List<StoreMember> members;
}

/// The store's two pictures.
enum StoreImage { logo, cover }

abstract interface class StoreRepository {
  Future<Result<Store>> getStore(String storeId);

  /// Owners only.
  Future<Result<Store>> updateProfile(String storeId, StoreProfile profile);

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
