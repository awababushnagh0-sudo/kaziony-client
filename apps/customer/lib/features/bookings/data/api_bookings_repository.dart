import 'package:kernel/kernel.dart';
import 'package:offers_api/customer.dart' as api;
import 'package:offers_api/customer.dart' show ClaimsClient;

import '../../offers/data/api_offers_repository.dart';
import '../domain/booking.dart';

class ApiBookingsRepository implements BookingsRepository {
  ApiBookingsRepository(this._api);

  final Api _api;
  late final _claims = _api.client(ClaimsClient.new);

  @override
  Future<Result<Booking>> reserve(String offerId, {required int quantity}) =>
      _one(
        () => _claims.claim(
          offerId: offerId,
          body: api.CreateClaimDto(quantity: quantity),
        ),
      );

  @override
  Future<Result<PageResult<Booking>>> list({
    required int page,
    required int pageSize,
  }) async {
    final result = await _api.guard(
      () => _claims.list(page: page, pageSize: pageSize),
    );
    return result.map(
      (list) => PageResult(
        items: [for (final claim in list.items) _toBooking(claim)],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<Booking>> get(String bookingId) =>
      _one(() => _claims.getClaim(claimId: bookingId));

  @override
  Future<Result<Booking>> cancel(String bookingId) =>
      _one(() => _claims.cancel(claimId: bookingId));

  Future<Result<Booking>> _one(
    Future<api.CustomerClaimDto> Function() call,
  ) async => (await _api.guard(call)).map(_toBooking);

  static Booking _toBooking(api.CustomerClaimDto claim) => Booking(
    id: claim.id,
    code: claim.code,
    quantity: claim.quantity.toInt(),
    totalPrice: claim.totalPrice,
    status: switch (claim.status) {
      api.ClaimStatus.redeemed => BookingStatus.pickedUp,
      api.ClaimStatus.expired => BookingStatus.expired,
      api.ClaimStatus.cancelled => BookingStatus.cancelled,
      // A status added later reads as still waiting; the time still ends it.
      _ => BookingStatus.reserved,
    },
    expiresAt: claim.expiresAt.toLocal(),
    createdAt: claim.createdAt.toLocal(),
    pickedUpAt: claim.redeemedAt?.toLocal(),
    offerId: claim.offer.id,
    offerTitle: claim.offer.title,
    offerPrice: claim.offer.offerPrice,
    thumbUrl: claim.offer.thumbUrl,
    storeName: claim.store.name,
    storeLogoUrl: claim.store.logoUrl,
    branches: [for (final branch in claim.branches) toBranch(branch)],
    canCancel: claim.canCancel,
    limited: claim.offer.type == api.OfferType.limited,
  );
}
