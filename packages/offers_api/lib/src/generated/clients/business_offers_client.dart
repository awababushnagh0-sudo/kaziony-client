// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/business_offer_dto.dart';
import '../models/business_offer_list_dto.dart';
import '../models/create_offer_dto.dart';
import '../models/offer_status.dart';
import '../models/update_offer_dto.dart';

part 'business_offers_client.g.dart';

@RestApi()
abstract class BusinessOffersClient {
  factory BusinessOffersClient(Dio dio, {String? baseUrl}) = _BusinessOffersClient;

  /// The store's offers with claim counts
  @GET('/api/v1/business/stores/{storeId}/offers')
  Future<BusinessOfferListDto> list({
    @Path('storeId') required String storeId,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('status') OfferStatus? status,
  });

  /// Post an offer from a product (owner).
  ///
  /// To repost an old offer, post again with the same productId: the photo and details are reused.
  @POST('/api/v1/business/stores/{storeId}/offers')
  Future<BusinessOfferDto> create({
    @Path('storeId') required String storeId,
    @Body() required CreateOfferDto body,
  });

  /// One offer with claim counts
  @GET('/api/v1/business/stores/{storeId}/offers/{offerId}')
  Future<BusinessOfferDto> getOffer({
    @Path('offerId') required String offerId,
    @Path('storeId') required String storeId,
  });

  /// Edit the title, description or end time (owner)
  @PATCH('/api/v1/business/stores/{storeId}/offers/{offerId}')
  Future<BusinessOfferDto> update({
    @Path('offerId') required String offerId,
    @Path('storeId') required String storeId,
    @Body() required UpdateOfferDto body,
  });

  /// Pause: hide from customers (owner).
  ///
  /// Existing reservations can still be redeemed.
  @POST('/api/v1/business/stores/{storeId}/offers/{offerId}/pause')
  Future<BusinessOfferDto> pause({
    @Path('offerId') required String offerId,
    @Path('storeId') required String storeId,
  });

  /// Resume a paused offer (owner)
  @POST('/api/v1/business/stores/{storeId}/offers/{offerId}/resume')
  Future<BusinessOfferDto> resume({
    @Path('offerId') required String offerId,
    @Path('storeId') required String storeId,
  });

  /// End an offer for good (owner).
  ///
  /// Existing reservations can still be redeemed.
  @POST('/api/v1/business/stores/{storeId}/offers/{offerId}/end')
  Future<BusinessOfferDto> end({
    @Path('offerId') required String offerId,
    @Path('storeId') required String storeId,
  });
}
