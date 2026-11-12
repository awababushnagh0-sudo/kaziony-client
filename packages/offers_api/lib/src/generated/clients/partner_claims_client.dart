// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/claim_status.dart';
import '../models/partner_claim_dto.dart';
import '../models/partner_claim_list_dto.dart';
import '../models/redeem_claim_dto.dart';

part 'partner_claims_client.g.dart';

@RestApi()
abstract class PartnerClaimsClient {
  factory PartnerClaimsClient(Dio dio, {String? baseUrl}) = _PartnerClaimsClient;

  /// Claims for this store (default: reserved, soonest expiry first).
  ///
  /// [status] - Defaults to RESERVED: customers who are on their way.
  /// OUT_FOR_DELIVERY: deliveries to close, the oldest first.
  @GET('/api/v1/partner/stores/{storeId}/claims')
  Future<PartnerClaimListDto> list({
    @Path('storeId') required String storeId,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('status') ClaimStatus? status,
  });

  /// Look up a scanned code before redeeming it.
  ///
  /// `canRedeem` and `problem` say whether it can be redeemed.
  @GET('/api/v1/partner/stores/{storeId}/claims/code/{code}')
  Future<PartnerClaimDto> lookup({
    @Path('code') required String code,
    @Path('storeId') required String storeId,
  });

  /// Redeem a claim at the counter.
  ///
  /// Fails with 409 if it was already redeemed, expired or cancelled.
  @POST('/api/v1/partner/stores/{storeId}/claims/redeem')
  Future<PartnerClaimDto> redeem({
    @Path('storeId') required String storeId,
    @Body() required RedeemClaimDto body,
  });

  /// Send a booking with the store's driver.
  ///
  /// The customer called to have it brought: it becomes OUT_FOR_DELIVERY, with no time limit, until the store closes it (`delivered`, `not-delivered`, or redeeming its code at the door); one left open a day is taken as delivered. 409 "StoreDoesNotDeliver" when the store has delivery off, "AlreadyOutForDelivery", or as redeeming.
  @POST('/api/v1/partner/stores/{storeId}/claims/send-for-delivery')
  Future<PartnerClaimDto> sendForDelivery({
    @Path('storeId') required String storeId,
    @Body() required RedeemClaimDto body,
  });

  /// The driver handed it over.
  ///
  /// Counts as a pickup. 409 "NotOutForDelivery" unless it was sent.
  @POST('/api/v1/partner/stores/{storeId}/claims/{claimId}/delivered')
  Future<PartnerClaimDto> delivered({
    @Path('claimId') required String claimId,
    @Path('storeId') required String storeId,
  });

  /// The delivery didn't happen.
  ///
  /// The customer cancelled on the phone, or wasn't there: it is cancelled (NOT_DELIVERED) with no strike, the pieces go back on sale, and the customer is told. 409 "NotOutForDelivery" unless it was sent.
  @POST('/api/v1/partner/stores/{storeId}/claims/{claimId}/not-delivered')
  Future<PartnerClaimDto> notDelivered({
    @Path('claimId') required String claimId,
    @Path('storeId') required String storeId,
  });
}
