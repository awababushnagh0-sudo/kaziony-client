// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/pause_store_dto.dart';
import '../models/store_detail_dto.dart';
import '../models/store_pause_dto.dart';
import '../models/store_paused_dto.dart';
import '../models/store_stats_dto.dart';
import '../models/update_store_profile_dto.dart';

part 'partner_store_client.g.dart';

@RestApi()
abstract class PartnerStoreClient {
  factory PartnerStoreClient(Dio dio, {String? baseUrl}) = _PartnerStoreClient;

  /// My store with its staff
  @GET('/api/v1/partner/stores/{storeId}')
  Future<StoreDetailDto> getStore({
    @Path('storeId') required String storeId,
  });

  /// Edit pickup instructions, contact details and opening hours (owner).
  ///
  /// The name, kind, place, staff and opening another place are our team's: the app sends the owner to us (`GET /app-config` → `support`).
  @PATCH('/api/v1/partner/stores/{storeId}')
  Future<StoreDetailDto> updateProfile({
    @Path('storeId') required String storeId,
    @Body() required UpdateStoreProfileDto body,
  });

  /// Claims, redemptions and top offers
  @GET('/api/v1/partner/stores/{storeId}/stats')
  Future<StoreStatsDto> getStats({
    @Path('storeId') required String storeId,
  });

  /// Whether the store is offline, and what going offline touches
  @GET('/api/v1/partner/stores/{storeId}/pause')
  Future<StorePauseDto> getPause({
    @Path('storeId') required String storeId,
  });

  /// Go offline for a break or the rest of the day (owner or staff).
  ///
  /// Customers see the store closed and can't book; bookings already made stand. With `cancelBookings`, for a sudden closing, they are cancelled too and each customer is told, with no strike. Pausing again replaces the pause.
  @PUT('/api/v1/partner/stores/{storeId}/pause')
  Future<StorePausedDto> pause({
    @Path('storeId') required String storeId,
    @Body() required PauseStoreDto body,
  });

  /// Back online: customers can book again
  @DELETE('/api/v1/partner/stores/{storeId}/pause')
  Future<StorePauseDto> resume({
    @Path('storeId') required String storeId,
  });

  /// Upload the store logo or cover photo (owner)
  @MultiPart()
  @PUT('/api/v1/partner/stores/{storeId}/images/{kind}')
  Future<StoreDetailDto> setImage({
    @Path('kind') required String kind,
    @Path('storeId') required String storeId,
    @Part(name: 'image') required MultipartFile image,
  });
}
