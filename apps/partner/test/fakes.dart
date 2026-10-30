import 'package:kernel/kernel.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';
import 'package:partner/features/counter/domain/claim.dart';
import 'package:partner/features/home/domain/store_stats.dart';
import 'package:partner/features/offers/domain/offer.dart';
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

StoreMembership store(String id, {bool isOwner = true, String? branchId}) =>
    StoreMembership(
      storeId: id,
      storeName: 'Store $id',
      storeLogoUrl: null,
      isOwner: isOwner,
      branchId: branchId,
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

Store storeDetails({StoreProfile? profile, List<Branch>? branches}) => Store(
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
  branches: branches ?? [branch('b1', 'Andalus')],
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

Branch branch(String id, String name) => Branch(
  id: id,
  name: name,
  city: City.tripoli,
  area: 'Hay Al Andalus',
  address: null,
  phone: null,
  isActive: true,
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

Offer offer(
  String id, {
  OfferStatus status = OfferStatus.active,
  OfferState state = OfferState.live,
  OfferType type = OfferType.limited,
  String productId = '1',
}) => Offer(
  id: id,
  productId: productId,
  title: 'Offer $id',
  description: null,
  thumbUrl: null,
  originalPrice: '8.000',
  offerPrice: '4.000',
  discountPercent: 50,
  type: type,
  status: status,
  state: state,
  totalQuantity: type == OfferType.limited ? 10 : null,
  remainingQuantity: type == OfferType.limited ? 3 : null,
  maxPerUser: 1,
  claimWindowMinutes: 60,
  startsAt: DateTime.utc(2026, 10, 25, 8),
  endsAt: DateTime.now().add(const Duration(hours: 5)),
  branchIds: const ['b1'],
  viewCount: 42,
  claims: const ClaimCounts(reserved: 2, redeemed: 5, expired: 1, cancelled: 0),
);

/// Serves [offers] filtered by status like the API, and records changes.
class FakeOfferRepository implements OfferRepository {
  FakeOfferRepository([List<Offer>? offers]) : offers = offers ?? [offer('o1')];

  final List<Offer> offers;
  final statuses = <OfferStatus?>[];
  final created = <NewOffer>[];
  final updated = <(String, OfferChanges)>[];
  final actions = <(String, String)>[];

  @override
  Future<Result<PageResult<Offer>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    OfferStatus? status,
  }) async {
    statuses.add(status);
    final matching = [
      for (final offer in offers)
        if (status == null || offer.status == status) offer,
    ];
    return Ok(PageResult(items: matching, total: matching.length));
  }

  @override
  Future<Result<Offer>> get(String storeId, String offerId) async =>
      Ok(offers.firstWhere((offer) => offer.id == offerId));

  @override
  Future<Result<Offer>> create(String storeId, NewOffer newOffer) async {
    created.add(newOffer);
    final posted = offer('posted', productId: newOffer.productId);
    offers.add(posted);
    return Ok(posted);
  }

  @override
  Future<Result<Offer>> update(
    String storeId,
    String offerId,
    OfferChanges changes,
  ) async {
    updated.add((offerId, changes));
    return get(storeId, offerId);
  }

  @override
  Future<Result<Offer>> pause(String storeId, String offerId) =>
      _set(offerId, 'pause', OfferStatus.paused, OfferState.paused);

  @override
  Future<Result<Offer>> resume(String storeId, String offerId) =>
      _set(offerId, 'resume', OfferStatus.active, OfferState.live);

  @override
  Future<Result<Offer>> end(String storeId, String offerId) =>
      _set(offerId, 'end', OfferStatus.ended, OfferState.ended);

  Future<Result<Offer>> _set(
    String offerId,
    String action,
    OfferStatus status,
    OfferState state,
  ) async {
    actions.add((offerId, action));
    final index = offers.indexWhere((offer) => offer.id == offerId);
    offers[index] = offer(offerId, status: status, state: state);
    return Ok(offers[index]);
  }
}

Claim claim(
  String code, {
  ClaimStatus status = ClaimStatus.reserved,
  bool canRedeem = true,
  DateTime? redeemedAt,
  String? customerName = 'Sara',
  int quantity = 1,
  String totalPrice = '4.500',
  Duration heldFor = const Duration(minutes: 40),
}) => Claim(
  id: 'c-$code',
  code: code,
  quantity: quantity,
  totalPrice: totalPrice,
  status: status,
  customerName: customerName,
  offer: const ClaimOffer(
    id: 'o1',
    title: 'Caramel cake',
    offerPrice: '4.500',
    originalPrice: '9.000',
    thumbUrl: null,
  ),
  expiresAt: DateTime.now().add(heldFor),
  redeemedAt: redeemedAt,
  redeemedBranchId: redeemedAt == null ? null : 'b1',
  canRedeem: canRedeem,
);

/// Looks codes up in [claims]; redeeming one marks it picked up, unless
/// [redeemFailure] says otherwise.
class FakeClaimRepository implements ClaimRepository {
  FakeClaimRepository([List<Claim>? claims])
    : claims = claims ?? [claim('ABCD2345')];

  final List<Claim> claims;
  final lookups = <String>[];
  final redeems = <(String, String?)>[];
  AppFailure? redeemFailure;

  @override
  Future<Result<PageResult<Claim>>> upcoming(
    String storeId, {
    required int page,
    required int pageSize,
  }) async {
    final waiting = [
      for (final claim in claims)
        if (claim.status == ClaimStatus.reserved) claim,
    ];
    return Ok(PageResult(items: waiting, total: waiting.length));
  }

  @override
  Future<Result<Claim>> lookup(String storeId, String code) async {
    lookups.add(code);
    final found = claims.where((claim) => claim.code == code).firstOrNull;
    return found == null ? const Err(NotFoundFailure()) : Ok(found);
  }

  @override
  Future<Result<Claim>> redeem(
    String storeId,
    String code, {
    String? branchId,
  }) async {
    redeems.add((code, branchId));
    if (redeemFailure case final failure?) return Err(failure);
    final index = claims.indexWhere((claim) => claim.code == code);
    claims[index] = claim(
      code,
      status: ClaimStatus.redeemed,
      canRedeem: false,
      redeemedAt: DateTime.now(),
    );
    return Ok(claims[index]);
  }
}

StoreStats stats({
  int onTheWay = 3,
  int redeemedToday = 9,
  int claimsToday = 14,
  int expiredToday = 2,
}) => StoreStats(
  liveOffers: 3,
  onTheWay: onTheWay,
  today: PeriodStats(
    claims: claimsToday,
    redeemed: redeemedToday,
    expired: expiredToday,
    redemptionRate: 0.8,
  ),
  last30Days: const PeriodStats(
    claims: 300,
    redeemed: 268,
    expired: 30,
    redemptionRate: 0.9,
  ),
);

class FakeStatsRepository implements StatsRepository {
  Result<StoreStats> result = Ok(stats());

  @override
  Future<Result<StoreStats>> get(String storeId) async => result;
}
