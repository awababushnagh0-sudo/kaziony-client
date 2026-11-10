// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/booking_status_dto.dart';
import '../models/create_claim_dto.dart';
import '../models/customer_claim_dto.dart';
import '../models/customer_claim_list_dto.dart';
import '../models/rate_claim_dto.dart';

part 'claims_client.g.dart';

@RestApi()
abstract class ClaimsClient {
  factory ClaimsClient(Dio dio, {String? baseUrl}) = _ClaimsClient;

  /// Claim an offer.
  ///
  /// Takes `quantity` pieces (default 1) with one code, within the offer's `maxPerUser`. LIMITED offers hold them until `expiresAt` (our hold time, or the offer's end if sooner). A customer can hold 3 reservations at once (409 "TooManyReservations"), and after cancelling an offer 2 times can't book it again (409 "CancelledTooOften"). 3 missed pickups within 30 days pause booking for 3 days, 7 if paused lately (403 "ClaimBanned"). UNLIMITED offers just give a code valid until the offer ends.
  @POST('/api/v1/offers/{offerId}/claim')
  Future<CustomerClaimDto> claim({
    @Path('offerId') required String offerId,
    @Body() required CreateClaimDto body,
  });

  /// My claims (newest first, the active ones, or the rated ones).
  ///
  /// [active] - true: only reservations that can still be used.
  ///
  /// [rated] - true: only pickups I rated, the latest rating first: one per store, the.
  /// pickup my rating is from.
  @GET('/api/v1/me/claims')
  Future<CustomerClaimListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('active') bool? active,
    @Query('rated') bool? rated,
  });

  /// Where I stand: strikes, a pause, what I hold.
  ///
  /// For the app to warn after a missed pickup, before a pause, and say when one ends.
  @GET('/api/v1/me/booking-status')
  Future<BookingStatusDto> bookingStatus();

  /// One claim, with the code for the QR
  @GET('/api/v1/me/claims/{claimId}')
  Future<CustomerClaimDto> getClaim({
    @Path('claimId') required String claimId,
  });

  /// Cancel a reservation I can't pick up.
  ///
  /// Gives the pieces back. Cancelling in time is not a missed pickup, but cancelling the same offer 2 times closes it to me (`cancelEndsBooking` says so before).
  @POST('/api/v1/me/claims/{claimId}/cancel')
  Future<CustomerClaimDto> cancel({
    @Path('claimId') required String claimId,
  });

  /// Rate the store after picking up.
  ///
  /// One rating per store: rating after a later pickup replaces my stars for it. 409 with error "NotPickedUp" before it was picked up, "AlreadyRated" from this pickup again or an older one.
  @POST('/api/v1/me/claims/{claimId}/rating')
  Future<CustomerClaimDto> rate({
    @Path('claimId') required String claimId,
    @Body() required RateClaimDto body,
  });
}
