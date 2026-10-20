// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_offer_dto.dart';
import '../models/offer_list_dto.dart';
import '../models/offer_status.dart';

part 'admin_offers_client.g.dart';

@RestApi()
abstract class AdminOffersClient {
  factory AdminOffersClient(Dio dio, {String? baseUrl}) = _AdminOffersClient;

  /// List offers across all stores
  @GET('/api/v1/admin/offers')
  Future<OfferListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('status') OfferStatus? status,
    @Query('storeId') String? storeId,
  });

  /// Take an offer down.
  ///
  /// Hides it from customers and cancels active reservations.
  @POST('/api/v1/admin/offers/{id}/remove')
  Future<AdminOfferDto> remove({
    @Path('id') required String id,
  });
}
