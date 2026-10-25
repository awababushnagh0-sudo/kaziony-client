import 'package:kernel/kernel.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/products/domain/product.dart';
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

Product product(String id, {String price = '8.000', bool isArchived = false}) =>
    Product(
      id: id,
      title: 'Product $id',
      description: null,
      regularPrice: price,
      imageUrl: null,
      thumbUrl: null,
      isArchived: isArchived,
    );

/// Serves [products] a page at a time, filtered like the API.
class FakeProductRepository implements ProductRepository {
  FakeProductRepository([List<Product>? products])
    : products = products ?? [product('1'), product('2')];

  final List<Product> products;
  final listCalls = <({int page, String search, bool archived})>[];
  final created = <ProductDraft>[];
  final updated = <(String, ProductDraft)>[];
  final archived = <(String, bool)>[];

  /// The next list call fails with this, once.
  AppFailure? failNextList;

  @override
  Future<Result<PageResult<Product>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    String search = '',
    bool archived = false,
  }) async {
    listCalls.add((page: page, search: search, archived: archived));
    if (failNextList case final failure?) {
      failNextList = null;
      return Err(failure);
    }
    final matching = [
      for (final product in products)
        if (product.isArchived == archived && product.title.contains(search))
          product,
    ];
    return Ok(
      PageResult(
        items: matching.skip((page - 1) * pageSize).take(pageSize).toList(),
        total: matching.length,
      ),
    );
  }

  @override
  Future<Result<Product>> get(String storeId, String productId) async =>
      Ok(products.firstWhere((product) => product.id == productId));

  @override
  Future<Result<Product>> create(String storeId, ProductDraft draft) async {
    created.add(draft);
    final saved = product('created', price: draft.regularPrice);
    products.add(saved);
    return Ok(saved);
  }

  @override
  Future<Result<Product>> update(
    String storeId,
    String productId,
    ProductDraft draft,
  ) async {
    updated.add((productId, draft));
    return Ok(product(productId, price: draft.regularPrice));
  }

  @override
  Future<Result<Product>> setArchived(
    String storeId,
    String productId, {
    required bool archived,
  }) async {
    this.archived.add((productId, archived));
    return Ok(product(productId, isArchived: archived));
  }

  final photos = <(String, PreparedPhoto)>[];

  /// The next photo upload fails with this, once.
  AppFailure? failNextPhoto;

  @override
  Future<Result<Product>> setPhoto(
    String storeId,
    String productId,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) async {
    photos.add((productId, photo));
    onProgress(0.5);
    if (failNextPhoto case final failure?) {
      failNextPhoto = null;
      return Err(failure);
    }
    onProgress(1);
    return Ok(
      Product(
        id: productId,
        title: 'Product $productId',
        description: null,
        regularPrice: '8.000',
        imageUrl: 'http://test.invalid/$productId.jpg',
        thumbUrl: 'http://test.invalid/$productId-thumb.jpg',
        isArchived: false,
      ),
    );
  }
}
