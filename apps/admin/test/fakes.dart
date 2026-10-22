import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:admin/features/dashboard/domain/dashboard_stats.dart';
import 'package:admin/features/stores/domain/location.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:kernel/kernel.dart';

SessionUser user({
  AccountRole role = AccountRole.admin,
  bool mustChangePassword = false,
}) => SessionUser(
  id: 'u1',
  role: role,
  name: 'Test Admin',
  phone: null,
  email: 'admin@offers.local',
  contactPhone: null,
  mustChangePassword: mustChangePassword,
  memberships: const [],
);

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser> loginResult = Ok(user());
  final logins = <(String, String)>[];
  var logouts = 0;

  @override
  Future<Result<SessionUser>> login(String email, String password) async {
    logins.add((email, password));
    return loginResult;
  }

  @override
  Future<Result<SessionUser>> changePassword(
    String current,
    String next,
  ) async => Ok(user());

  @override
  Future<void> logout() async => logouts++;
}

const sampleStats = DashboardStats(
  stores: 12,
  activeStores: 10,
  liveOffers: 34,
  totalOffers: 120,
  customers: 560,
  newCustomersLast7Days: 45,
  claimsLast7Days: 78,
  redemptionRate: 0.8,
);

class FakeDashboardRepository implements DashboardRepository {
  Result<DashboardStats> result = const Ok(sampleStats);
  var calls = 0;

  @override
  Future<Result<DashboardStats>> getStats() async {
    calls++;
    return result;
  }
}

const sampleCategory = Category(
  id: 'cat-sweets',
  nameAr: 'حلويات',
  nameEn: 'Sweets',
);

StoreSummary sampleStore(int n, {bool active = true}) => StoreSummary(
  id: 'store-$n',
  name: 'Store $n',
  category: sampleCategory,
  branchCount: n,
  isActive: active,
  createdAt: DateTime.utc(2026, 10, n),
);

StoreDetails sampleDetails(String id, {bool active = true}) => StoreDetails(
  id: id,
  name: 'Sweet Coast',
  category: sampleCategory,
  isActive: active,
  createdAt: DateTime.utc(2026, 10, 15, 12),
  branchCount: 2,
  teamCount: 3,
  description: 'Fresh sweets every morning.',
  phone: '+218912345678',
  email: 'hello@sweetcoast.ly',
  instagramUrl: 'https://instagram.com/sweetcoast',
);

class FakeStoreRepository implements StoreRepository {
  List<StoreSummary> stores = [sampleStore(1), sampleStore(2, active: false)];
  final queries = <StoreQuery>[];
  final opened = <String>[];
  Result<StoreDetails>? detailsResult;
  final updates = <(String, EditedStore)>[];
  Result<StoreDetails>? updateResult;
  final activeChanges = <(String, bool)>[];
  final deleted = <String>[];
  Result<void> deleteResult = const Ok(null);
  final resolvedLinks = <String>[];
  Result<LatLng> locationResult = const Ok((
    latitude: 32.8872,
    longitude: 13.1913,
  ));
  final created = <NewStore>[];
  Result<CreatedStore>? createResult;

  @override
  Future<Result<StorePage>> list(StoreQuery query) async {
    queries.add(query);
    final matching = [
      for (final store in stores)
        if (store.name.toLowerCase().contains(query.search.toLowerCase()))
          store,
    ];
    return Ok(StorePage(items: matching, total: matching.length));
  }

  @override
  Future<Result<StoreDetails>> get(String id) async {
    opened.add(id);
    return detailsResult ?? Ok(sampleDetails(id));
  }

  @override
  Future<Result<StoreDetails>> update(String id, EditedStore store) async {
    updates.add((id, store));
    return updateResult ??
        Ok(
          StoreDetails(
            id: id,
            name: store.name,
            category: sampleCategory,
            isActive: true,
            createdAt: DateTime.utc(2026, 10, 15, 12),
            branchCount: 2,
            teamCount: 3,
            description: store.description,
            phone: store.phone,
            email: store.email,
            facebookUrl: store.facebookUrl,
            instagramUrl: store.instagramUrl,
          ),
        );
  }

  @override
  Future<Result<StoreDetails>> setActive(
    String id, {
    required bool active,
  }) async {
    activeChanges.add((id, active));
    return Ok(sampleDetails(id, active: active));
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return deleteResult;
  }

  @override
  Future<Result<LatLng>> resolveLocation(String link) async {
    resolvedLinks.add(link);
    return locationResult;
  }

  @override
  Future<Result<List<Category>>> categories() async =>
      const Ok([sampleCategory]);

  @override
  Future<Result<CreatedStore>> create(NewStore store) async {
    created.add(store);
    return createResult ??
        Ok(
          CreatedStore(
            storeId: 'new',
            storeName: store.name,
            ownerPhone: store.ownerPhone,
            temporaryPassword: 'Tmp-4821-xk',
          ),
        );
  }
}

/// The app language, fixed to English so it matches the screens under test.
class EnglishLocale extends LocaleController {
  @override
  Locale build() => const Locale('en');
}
