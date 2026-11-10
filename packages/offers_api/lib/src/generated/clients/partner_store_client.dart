// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/store_detail_dto.dart';
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

  /// Upload the store logo or cover photo (owner)
  @MultiPart()
  @PUT('/api/v1/partner/stores/{storeId}/images/{kind}')
  Future<StoreDetailDto> setImage({
    @Path('kind') required String kind,
    @Path('storeId') required String storeId,
    @Part(name: 'image') required File image,
  });
}
