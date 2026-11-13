import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart' as api;

import '../../bookings/data/booking_mapping.dart';
import '../domain/customer.dart';

class ApiCustomerRepository implements CustomerRepository {
  ApiCustomerRepository(this._api);

  final Api _api;
  late final _customers = _api.client(api.AdminCustomersClient.new);
  late final _users = _api.client(api.AdminUsersClient.new);

  @override
  Future<Result<CustomerPage>> list(CustomerQuery query) async {
    final result = await _api.guard(
      () => _customers.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        standing: switch (query.filter) {
          null => null,
          final standing => _standingFilter(standing),
        },
      ),
    );
    return result.map(
      (dto) => CustomerPage(
        total: dto.meta.total.toInt(),
        items: [for (final customer in dto.items) _toCustomer(customer)],
      ),
    );
  }

  @override
  Future<Result<CustomerDetails>> get(String id) async =>
      (await _api.guard(() => _customers.getCustomer(id: id))).map(_toDetails);

  @override
  Future<Result<CustomerBookingPage>> bookings(
    String id,
    CustomerBookingQuery query,
  ) async {
    final result = await _api.guard(
      () => _customers.bookings(
        id: id,
        page: query.page,
        pageSize: query.pageSize,
        status: switch (query.filter) {
          null => null,
          final status => claimStatusOf(status),
        },
      ),
    );
    return result.map(
      (dto) => CustomerBookingPage(
        total: dto.meta.total.toInt(),
        items: [for (final booking in dto.items) _toBooking(booking)],
      ),
    );
  }

  @override
  Future<Result<CustomerDetails>> endPause(String id) async =>
      (await _api.guard(() => _customers.endPause(id: id))).map(_toDetails);

  @override
  Future<Result<CustomerDetails>> takeBackStrike(
    String id,
    String strikeId,
  ) async => (await _api.guard(
    () => _customers.takeBackStrike(id: id, strikeId: strikeId),
  )).map(_toDetails);

  @override
  Future<Result<void>> setActive(String id, {required bool active}) async =>
      (await _api.guard(
        () => _users.setStatus(
          id: id,
          body: api.SetUserStatusDto(isActive: active),
        ),
      )).map((_) {});
}

api.CustomerStanding _standingFilter(CustomerStanding standing) =>
    switch (standing) {
      CustomerStanding.active => api.CustomerStanding.active,
      CustomerStanding.paused => api.CustomerStanding.paused,
      CustomerStanding.disabled => api.CustomerStanding.disabled,
      CustomerStanding.deleted => api.CustomerStanding.deleted,
    };

CustomerStanding _standing(api.CustomerStanding standing) => switch (standing) {
  api.CustomerStanding.paused => CustomerStanding.paused,
  api.CustomerStanding.disabled => CustomerStanding.disabled,
  api.CustomerStanding.deleted => CustomerStanding.deleted,
  // One this version doesn't know reads as booking as usual.
  api.CustomerStanding.active ||
  api.CustomerStanding.$unknown => CustomerStanding.active,
};

Customer _toCustomer(api.AdminCustomerDto dto) => Customer(
  id: dto.id,
  name: dto.name,
  email: dto.email,
  contactPhone: dto.contactPhone,
  standing: _standing(dto.standing),
  pausedUntil: dto.pausedUntil,
  strikes: dto.strikes.toInt(),
  missedPickups: dto.missedPickups.toInt(),
  bookings: dto.bookings.toInt(),
  pickedUp: dto.pickedUp.toInt(),
  lastBookedAt: dto.lastBookedAt,
  lastLoginAt: dto.lastLoginAt,
  createdAt: dto.createdAt,
);

CustomerDetails _toDetails(api.AdminCustomerDetailsDto dto) => CustomerDetails(
  // The page has the row's fields too.
  customer: Customer(
    id: dto.id,
    name: dto.name,
    email: dto.email,
    contactPhone: dto.contactPhone,
    standing: _standing(dto.standing),
    pausedUntil: dto.pausedUntil,
    strikes: dto.strikes.toInt(),
    missedPickups: dto.missedPickups.toInt(),
    bookings: dto.bookings.toInt(),
    pickedUp: dto.pickedUp.toInt(),
    lastBookedAt: dto.lastBookedAt,
    lastLoginAt: dto.lastLoginAt,
    createdAt: dto.createdAt,
  ),
  signsInWith: [
    for (final provider in dto.signsInWith)
      ?switch (provider) {
        api.AuthProvider.google => SignInMethod.google,
        api.AuthProvider.apple => SignInMethod.apple,
        api.AuthProvider.$unknown => null,
      },
  ],
  strikesBeforePause: dto.strikesBeforePause.toInt(),
  strikeHistory: [
    for (final strike in dto.strikeHistory)
      CustomerStrike(
        id: strike.id,
        createdAt: strike.createdAt,
        counts: strike.counts,
        booking: switch (strike.claim) {
          null => null,
          final claim => StrikeBooking(
            code: claim.code,
            offerTitle: claim.offerTitle,
            storeName: claim.storeName,
            storeArea: claim.storeArea,
          ),
        },
      ),
  ],
  bookingCounts: BookingCounts(
    waiting: dto.bookingCounts.reserved.toInt(),
    outForDelivery: dto.bookingCounts.outForDelivery.toInt(),
    pickedUp: dto.bookingCounts.redeemed.toInt(),
    missed: dto.bookingCounts.expired.toInt(),
    cancelled: dto.bookingCounts.cancelled.toInt(),
  ),
  lastPauseEndedAt: dto.lastPauseEndedAt,
  openReports: dto.openReports.toInt(),
  following: dto.following.toInt(),
  ratings: dto.ratings.toInt(),
  deletedAt: dto.deletedAt,
);

CustomerBooking _toBooking(api.AdminCustomerBookingDto dto) => CustomerBooking(
  id: dto.id,
  code: dto.code,
  status: bookingStatusOf(dto.status),
  quantity: dto.quantity.toInt(),
  totalPrice: dto.totalPrice,
  offerTitle: dto.offer.title,
  storeId: dto.store.id,
  storeName: dto.store.name,
  storeArea: dto.store.area,
  createdAt: dto.createdAt,
  expiresAt: dto.expiresAt,
  redeemedAt: dto.redeemedAt,
  cancelledAt: dto.cancelledAt,
  cancelReason: cancelReasonOf(dto.cancelReason),
  hasStrike: dto.hasStrike,
);
