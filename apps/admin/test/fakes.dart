import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:admin/features/dashboard/domain/dashboard_stats.dart';
import 'package:admin/features/stores/domain/location.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/users/domain/dashboard_user.dart';
import 'package:kernel/kernel.dart';

SessionUser user({
  String id = 'u1',
  AccountRole role = AccountRole.admin,
  bool mustChangePassword = false,
}) => SessionUser(
  id: id,
  role: role,
  name: 'Test Admin',
  phone: null,
  email: 'admin@offers.local',
  contactPhone: null,
  mustChangePassword: mustChangePassword,
  memberships: const [],
);

/// Signed in as [signedIn], without restoring a stored session.
class FakeSession extends SessionController {
  FakeSession(this.signedIn);

  final SessionUser signedIn;

  @override
  SessionState build() => SignedIn(signedIn);
}

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

DashboardUser sampleUser(
  int n, {
  DashboardRole role = DashboardRole.editor,
  bool active = true,
}) => DashboardUser(
  id: 'user-$n',
  name: 'User $n',
  email: 'user$n@offers.ly',
  role: role,
  isActive: active,
  createdAt: DateTime.utc(2026, 10, n, 12),
  lastLoginAt: n == 1 ? DateTime.utc(2026, 10, 20, 12) : null,
);

class FakeDashboardUserRepository implements DashboardUserRepository {
  List<DashboardUser> users = [
    sampleUser(1, role: DashboardRole.admin),
    sampleUser(2, active: false),
  ];
  final queries = <DashboardUserQuery>[];
  final created = <NewDashboardUser>[];
  Result<CreatedDashboardUser>? createResult;
  final opened = <String>[];
  final updates = <(String, EditedDashboardUser)>[];
  final activeChanges = <(String, bool)>[];
  final resets = <String>[];

  DashboardUser _find(String id) =>
      users.firstWhere((user) => user.id == id, orElse: () => sampleUser(9));

  @override
  Future<Result<DashboardUser>> get(String id) async {
    opened.add(id);
    return Ok(_find(id));
  }

  @override
  Future<Result<DashboardUser>> update(
    String id,
    EditedDashboardUser user,
  ) async {
    updates.add((id, user));
    final saved = _find(id);
    return Ok(
      DashboardUser(
        id: id,
        name: user.name,
        email: saved.email,
        role: user.role,
        isActive: saved.isActive,
        createdAt: saved.createdAt,
        lastLoginAt: saved.lastLoginAt,
      ),
    );
  }

  @override
  Future<Result<DashboardUser>> setActive(
    String id, {
    required bool active,
  }) async {
    activeChanges.add((id, active));
    final saved = _find(id);
    return Ok(
      DashboardUser(
        id: id,
        name: saved.name,
        email: saved.email,
        role: saved.role,
        isActive: active,
        createdAt: saved.createdAt,
        lastLoginAt: saved.lastLoginAt,
      ),
    );
  }

  @override
  Future<Result<String>> resetPassword(String id) async {
    resets.add(id);
    return const Ok('Tmp-5521-hw');
  }

  @override
  Future<Result<DashboardUserPage>> list(DashboardUserQuery query) async {
    queries.add(query);
    final matching = [
      for (final user in users)
        if (query.filter == null || user.role == query.filter) user,
    ];
    return Ok(DashboardUserPage(items: matching, total: matching.length));
  }

  @override
  Future<Result<CreatedDashboardUser>> create(NewDashboardUser user) async {
    created.add(user);
    return createResult ??
        Ok(
          CreatedDashboardUser(
            user: DashboardUser(
              id: 'new',
              name: user.name,
              email: user.email,
              role: user.role,
              isActive: true,
              createdAt: DateTime.utc(2026, 10, 22, 12),
            ),
            temporaryPassword: 'Tmp-7310-qz',
          ),
        );
  }
}

/// The app language, fixed to English so it matches the screens under test.
class EnglishLocale extends LocaleController {
  @override
  Locale build() => const Locale('en');
}
