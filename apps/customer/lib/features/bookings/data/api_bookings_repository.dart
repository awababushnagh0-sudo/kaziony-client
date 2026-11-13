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
    bool rated = false,
  }) async {
    final result = await _api.guard(
      () => _claims.list(page: page, pageSize: pageSize, rated: rated),
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

  @override
  Future<Result<Booking>> rate(String bookingId, int stars) => _one(
    () => _claims.rate(
      claimId: bookingId,
      body: api.RateClaimDto(stars: stars),
    ),
  );

  @override
  Future<Result<Booking>> report(
    String bookingId,
    ReportReason reason, {
    String? note,
  }) => _one(
    () => _claims.report(
      claimId: bookingId,
      body: api.ReportClaimDto(
        reason: switch (reason) {
          ReportReason.storeClosed => api.ReportReason.storeClosed,
          ReportReason.notGiven => api.ReportReason.notGiven,
          ReportReason.priceDifferent => api.ReportReason.priceDifferent,
          ReportReason.quality => api.ReportReason.quality,
          ReportReason.other => api.ReportReason.other,
        },
        note: note,
      ),
    ),
  );

  @override
  Future<Result<BookingStanding>> standing() async {
    final result = await _api.guard(() => _claims.bookingStatus());
    return result.map(
      (status) => BookingStanding(
        strikes: status.strikes.toInt(),
        strikesBeforePause: status.strikesBeforePause.toInt(),
        strikeFadesAt: status.strikeFadesAt?.toLocal(),
        pausedUntil: status.pausedUntil?.toLocal(),
        nextPauseDays: status.nextPauseDays.toInt(),
        activeReservations: status.activeReservations.toInt(),
        maxActiveReservations: status.maxActiveReservations.toInt(),
      ),
    );
  }

  Future<Result<Booking>> _one(
    Future<api.CustomerClaimDto> Function() call,
  ) async => (await _api.guard(call)).map(_toBooking);

  static Booking _toBooking(api.CustomerClaimDto claim) => Booking(
    id: claim.id,
    code: claim.code,
    quantity: claim.quantity.toInt(),
    totalPrice: claim.totalPrice,
    status: switch (claim.status) {
      api.ClaimStatus.outForDelivery => BookingStatus.outForDelivery,
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
    location: toLocation(claim.location),
    canCancel: claim.canCancel,
    cancelEndsBooking: claim.cancelEndsBooking,
    limited: claim.offer.type == api.OfferType.limited,
    canRate: claim.canRate,
    myRating: claim.myRating?.toInt(),
    cancelReason: toCancelReason(claim.cancelReason),
    deliveryPhone: claim.store.deliveryPhone,
    sentForDeliveryAt: claim.sentForDeliveryAt?.toLocal(),
    report: switch (claim.report) {
      null => null,
      final report => BookingReport(
        resolved: report.status == api.ReportStatus.resolved,
        strikeRemoved: report.strikeRemoved,
        createdAt: report.createdAt.toLocal(),
      ),
    },
    canReport: claim.canReport,
  );
}

/// Null for a booking that isn't cancelled.
CancelReason? toCancelReason(api.CancelReason? reason) => switch (reason) {
  null => null,
  api.CancelReason.customer => CancelReason.customer,
  api.CancelReason.offerRemoved => CancelReason.offerRemoved,
  api.CancelReason.storeOff => CancelReason.storeOff,
  api.CancelReason.storeClosed => CancelReason.storeClosed,
  api.CancelReason.hoursChanged => CancelReason.hoursChanged,
  api.CancelReason.notDelivered => CancelReason.notDelivered,
  api.CancelReason.$unknown => CancelReason.other,
};
