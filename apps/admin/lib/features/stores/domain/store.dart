import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';

/// A row in the stores list.
class StoreSummary {
  const StoreSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.branchCount,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String name;
  final Category category;
  final int branchCount;
  final bool isActive;
  final DateTime createdAt;
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

/// A new store with its first branch and owner, as entered by an admin.
class NewStore {
  const NewStore({
    required this.name,
    required this.categoryId,
    required this.branch,
    required this.ownerName,
    required this.ownerPhone,
    this.phone,
    this.description,
  });

  final String name;
  final String categoryId;

  /// Normalized (+2189XXXXXXXX).
  final String? phone;
  final String? description;
  final NewBranch branch;
  final String ownerName;

  /// Normalized (+2189XXXXXXXX).
  final String ownerPhone;
}

class NewBranch {
  const NewBranch({
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.area,
    this.address,
  });

  final String name;
  final String city;
  final String? area;
  final String? address;
  final double latitude;
  final double longitude;
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
  Future<Result<List<Category>>> categories();
  Future<Result<CreatedStore>> create(NewStore store);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
