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
}
