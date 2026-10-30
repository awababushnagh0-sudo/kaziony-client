// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_claim_dto.dart';
import '../models/customer_claim_dto.dart';
import '../models/customer_claim_list_dto.dart';

part 'claims_client.g.dart';

@RestApi()
abstract class ClaimsClient {
  factory ClaimsClient(Dio dio, {String? baseUrl}) = _ClaimsClient;

  /// Claim an offer.
  ///
  /// Takes `quantity` pieces (default 1) with one code, within the offer's `maxPerUser`. LIMITED offers hold them until `expiresAt` (the claim window). A customer can hold 3 reservations at once; every 3rd missed pickup blocks claiming for 7 days. UNLIMITED offers just give a code valid until the offer ends.
  @POST('/api/v1/offers/{offerId}/claim')
  Future<CustomerClaimDto> claim({
    @Path('offerId') required String offerId,
    @Body() required CreateClaimDto body,
  });

  /// My claims (newest first, or active ones).
  ///
  /// [active] - true: only reservations that can still be used.
  @GET('/api/v1/me/claims')
  Future<CustomerClaimListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('active') bool? active,
  });

  /// One claim, with the code for the QR
  @GET('/api/v1/me/claims/{claimId}')
  Future<CustomerClaimDto> getClaim({
    @Path('claimId') required String claimId,
  });

  /// Cancel a reservation I can't pick up.
  ///
  /// Gives the pieces back. Cancelling in time is not a no-show.
  @POST('/api/v1/me/claims/{claimId}/cancel')
  Future<CustomerClaimDto> cancel({
    @Path('claimId') required String claimId,
  });
}
