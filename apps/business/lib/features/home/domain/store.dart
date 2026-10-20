import 'package:kernel/kernel.dart';

class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.isActive,
  });

  final String id;
  final String name;
  final String city;
  final String? area;
  final bool isActive;
}

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.isActive,
    required this.branches,
  });

  final String id;
  final String name;
  final String? description;
  final String? logoUrl;

  /// Disabled stores can't post offers.
  final bool isActive;
  final List<Branch> branches;
}

abstract interface class StoreRepository {
  Future<Result<Store>> getStore(String storeId);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
