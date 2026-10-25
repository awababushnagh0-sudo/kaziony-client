import 'package:kernel/kernel.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/store/domain/store.dart';

SessionUser user({
  AccountRole role = AccountRole.merchant,
  bool mustChangePassword = false,
  List<StoreMembership> memberships = const [],
}) => SessionUser(
  id: 'u1',
  role: role,
  name: 'Test',
  phone: '+218910000001',
  email: null,
  contactPhone: null,
  mustChangePassword: mustChangePassword,
  memberships: memberships,
);

StoreMembership store(String id, {bool isOwner = true}) => StoreMembership(
  storeId: id,
  storeName: 'Store $id',
  storeLogoUrl: null,
  isOwner: isOwner,
  branchId: null,
);

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser> loginResult = Ok(user());
  final logins = <(String, String)>[];
  var logouts = 0;

  @override
  Future<Result<SessionUser>> login(String phone, String password) async {
    logins.add((phone, password));
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

Store storeDetails({StoreProfile? profile}) => Store(
  id: 'a',
  name: 'Store a',
  category: const StoreCategory(nameAr: 'حلويات', nameEn: 'Sweets'),
  profile:
      profile ??
      const StoreProfile(
        description: 'Fresh every morning',
        phone: '+218910000001',
        email: null,
        facebookUrl: null,
        instagramUrl: null,
      ),
  isActive: true,
  branches: const [
    Branch(
      id: 'b1',
      name: 'Andalus',
      city: City.tripoli,
      area: 'Hay Al Andalus',
      address: null,
      phone: null,
      isActive: true,
    ),
  ],
  members: const [
    StoreMember(
      userId: 'u1',
      name: 'Owner One',
      phone: '+218910000001',
      isOwner: true,
      branchId: null,
      isActive: true,
    ),
    StoreMember(
      userId: 'u2',
      name: 'Staff Two',
      phone: '+218920000002',
      isOwner: false,
      branchId: 'b1',
      isActive: true,
    ),
  ],
);

class FakeStoreRepository implements StoreRepository {
  Result<Store> getResult = Ok(storeDetails());
  final updates = <StoreProfile>[];

  @override
  Future<Result<Store>> getStore(String storeId) async => getResult;

  @override
  Future<Result<Store>> updateProfile(
    String storeId,
    StoreProfile profile,
  ) async {
    updates.add(profile);
    return Ok(storeDetails(profile: profile));
  }
}
