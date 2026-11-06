import 'dart:async';

import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/stores/domain/store.dart';
import 'package:kernel/kernel.dart';

SessionUser customer({String? name = 'Ahmed', String? email = 'a@gmail.com'}) =>
    SessionUser(
      id: 'c1',
      role: AccountRole.customer,
      name: name,
      phone: null,
      email: email,
      contactPhone: null,
      mustChangePassword: false,
      memberships: const [],
    );

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser?> signInResult = Ok(customer());

  /// When set, sign-ins wait for it, to see the page while signing in.
  Completer<void>? hold;
  var signIns = 0;
  var signOuts = 0;

  @override
  Future<Result<SessionUser?>> signInWithGoogle() async {
    signIns++;
    await hold?.future;
    return signInResult;
  }

  @override
  Future<void> signOut() async => signOuts++;
}

/// A session that is already signed in as [user], without the backend.
class SignedInSession extends SessionController {
  SignedInSession(this.user);

  final SessionUser user;

  @override
  SessionState build() => SignedIn(user);
}

const tripoli = ServiceArea(
  nameAr: 'طرابلس',
  nameEn: 'Tripoli',
  center: GeoPoint(32.85, 13.18),
  radiusKm: 30,
);

/// Inside [tripoli], where [FakeLocationFinder] puts the phone too.
const souqAlJuma = GeoPoint(32.9, 13.22);

/// Outside [tripoli]: 45 km west.
const zawiya = GeoPoint(32.757, 12.727);

class FakeServiceAreaRepository implements ServiceAreaRepository {
  Result<List<ServiceArea>> result = const Ok([tripoli]);
  var loads = 0;

  @override
  Future<Result<List<ServiceArea>>> areas() async {
    loads++;
    return result;
  }
}

/// The time every page test runs at.
final now = DateTime(2026, 11, 2, 12);

const bakery = Category(
  id: 'cat1',
  slug: 'bakery',
  nameAr: 'مخابز',
  nameEn: 'Bakeries',
);

const branch = Branch(
  id: 'b1',
  name: 'Hay Al Andalus',
  point: souqAlJuma,
  area: 'Andalus',
  distanceKm: 1.2,
);

/// A counted offer with [remaining] of 10 left.
Offer offer({
  String id = 'o1',
  String title = 'Kunafa box',
  int? remaining = 3,
  int? maxPerUser = 2,
  bool limited = true,
  DateTime? startsAt,
  DateTime? endsAt,
  StoreRating? rating,
}) => Offer(
  id: id,
  title: title,
  originalPrice: '30.000',
  offerPrice: '15.000',
  discountPercent: 50,
  limited: limited,
  remaining: limited ? remaining : null,
  total: limited ? 10 : null,
  maxPerUser: maxPerUser,
  claimWindowMinutes: 60,
  startsAt: startsAt ?? now.subtract(const Duration(hours: 1)),
  endsAt: endsAt ?? now.add(const Duration(hours: 5)),
  store: OfferStore(
    id: 's1',
    name: 'Sweet shop',
    category: bakery,
    rating: rating,
  ),
  nearestBranch: branch,
  branchCount: 1,
);

Booking booking({
  String id = 'k1',
  BookingStatus status = BookingStatus.reserved,
  Duration left = const Duration(minutes: 42, seconds: 5),
  bool canCancel = true,
  bool limited = true,
  bool canRate = false,
  int? myRating,
}) => Booking(
  id: id,
  code: 'A2GUGPJ7',
  quantity: 2,
  totalPrice: '30.000',
  status: status,
  expiresAt: now.add(left),
  createdAt: now.subtract(const Duration(minutes: 18)),
  offerId: 'o1',
  offerTitle: 'Kunafa box',
  offerPrice: '15.000',
  storeName: 'Sweet shop',
  branches: const [branch],
  canCancel: canCancel,
  limited: limited,
  canRate: canRate,
  myRating: myRating,
);

class FakeOffersRepository implements OffersRepository {
  List<Offer> offers = [offer()];
  AppFailure? browseFailure;
  final queries = <OffersQuery>[];

  /// What [get] gives; built from [offers] when not set.
  Result<OfferDetail>? detail;
  List<Category> categoryList = const [bakery];

  @override
  Future<Result<PageResult<Offer>>> browse(
    OffersQuery query, {
    required int page,
    required int pageSize,
  }) async {
    queries.add(query);
    if (browseFailure case final failure?) return Err(failure);
    return Ok(PageResult(items: offers, total: offers.length));
  }

  @override
  Future<Result<OfferDetail>> get(String offerId, {GeoPoint? around}) async =>
      detail ??
      Ok(
        OfferDetail(
          offer: offers.firstWhere((o) => o.id == offerId),
          branches: const [branch],
        ),
      );

  @override
  Future<Result<List<Category>>> categories() async => Ok(categoryList);
}

class FakeBookingsRepository implements BookingsRepository {
  List<Booking> bookings = [booking()];
  Result<Booking>? reserveResult;
  Result<Booking>? cancelResult;
  Result<Booking>? rateResult;
  final reserved = <(String, int)>[];
  var cancels = 0;
  final rated = <(String, int)>[];

  @override
  Future<Result<Booking>> reserve(
    String offerId, {
    required int quantity,
  }) async {
    reserved.add((offerId, quantity));
    return reserveResult ?? Ok(booking());
  }

  @override
  Future<Result<PageResult<Booking>>> list({
    required int page,
    required int pageSize,
  }) async => Ok(PageResult(items: bookings, total: bookings.length));

  @override
  Future<Result<Booking>> get(String bookingId) async =>
      Ok(bookings.firstWhere((b) => b.id == bookingId));

  @override
  Future<Result<Booking>> cancel(String bookingId) async {
    cancels++;
    return cancelResult ??
        Ok(booking(id: bookingId, status: BookingStatus.cancelled));
  }

  @override
  Future<Result<Booking>> rate(String bookingId, int stars) async {
    rated.add((bookingId, stars));
    return rateResult ??
        Ok(
          booking(
            id: bookingId,
            status: BookingStatus.pickedUp,
            myRating: stars,
          ),
        );
  }
}

const storeSummary = StoreSummary(
  id: 's1',
  name: 'Sweet shop',
  category: bakery,
  liveOfferCount: 2,
  nearestBranch: branch,
);

class FakeStoresRepository implements StoresRepository {
  List<StoreSummary> stores = const [storeSummary];
  StoreRating? rating;
  String? pickupInstructions;
  List<StoreSummary> followedStores = const [];
  final follows = <String>[];
  final unfollows = <String>[];
  AppFailure? unfollowFailure;

  @override
  Future<Result<PageResult<StoreSummary>>> nearby(
    StoresQuery query, {
    required int page,
    required int pageSize,
  }) async => Ok(PageResult(items: stores, total: stores.length));

  @override
  Future<Result<StoreDetail>> get(String storeId, {GeoPoint? around}) async =>
      Ok(
        StoreDetail(
          id: storeId,
          name: 'Sweet shop',
          category: bakery,
          branches: const [branch],
          rating: rating,
          pickupInstructions: pickupInstructions,
          isFollowing: false,
          offers: [offer()],
        ),
      );

  @override
  Future<Result<List<StoreSummary>>> followed() async => Ok(followedStores);

  @override
  Future<Result<void>> follow(String storeId) async {
    follows.add(storeId);
    return const Ok(null);
  }

  @override
  Future<Result<void>> unfollow(String storeId) async {
    unfollows.add(storeId);
    if (unfollowFailure case final failure?) return Err(failure);
    return const Ok(null);
  }
}
