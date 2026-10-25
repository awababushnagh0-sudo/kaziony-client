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
    required this.description,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
  });

  final String? description;
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
    required this.isActive,
    required this.branches,
    required this.members,
  });

  final String id;
  final String name;
  final StoreCategory category;
  final StoreProfile profile;

  /// Disabled stores can't post offers.
  final bool isActive;
  final List<Branch> branches;
  final List<StoreMember> members;
}

abstract interface class StoreRepository {
  Future<Result<Store>> getStore(String storeId);

  /// Owners only.
  Future<Result<Store>> updateProfile(String storeId, StoreProfile profile);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
