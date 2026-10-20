// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/offer_sort.dart';
import '../models/public_offer_detail_dto.dart';
import '../models/public_offer_list_dto.dart';

part 'offers_client.g.dart';

@RestApi()
abstract class OffersClient {
  factory OffersClient(Dio dio, {String? baseUrl}) = _OffersClient;

  /// Browse live offers.
  ///
  /// Send lat/lng to get distances, filter by radius and sort by nearest.
  ///
  /// [sort] - Default: nearest when lat/lng are sent, otherwise newest.
  ///
  /// [radiusKm] - Only offers within this distance (needs lat/lng). Default 25 km.
  ///
  /// [search] - Search offer titles and store names.
  @GET('/api/v1/offers')
  Future<PublicOfferListDto> browse({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('sort') OfferSort? sort,
    @Query('lat') num? lat,
    @Query('lng') num? lng,
    @Query('radiusKm') num? radiusKm,
    @Query('categoryId') String? categoryId,
    @Query('storeId') String? storeId,
    @Query('search') String? search,
  });

  /// Offer details with all its branches.
  ///
  /// Works without login. With a customer token, `myActiveClaimId` shows their reservation.
  @GET('/api/v1/offers/{offerId}')
  Future<PublicOfferDetailDto> getOffer({
    @Path('offerId') required String offerId,
    @Query('lat') num? lat,
    @Query('lng') num? lng,
  });
}
