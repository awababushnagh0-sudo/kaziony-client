// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/followed_store_dto.dart';
import '../models/public_store_dto.dart';
import '../models/public_store_list_dto.dart';

part 'stores_client.g.dart';

@RestApi()
abstract class StoresClient {
  factory StoresClient(Dio dio, {String? baseUrl}) = _StoresClient;

  /// Stores around a place, closest first.
  ///
  /// Within the browse radius (`GET /app-config` → `browse.radiusKm`), with or without live offers.
  ///
  /// [lat] - Where the customer is (or the place they set on the map), inside a.
  /// service area: 400 with error "OutsideServiceArea".
  ///
  /// [search] - Search store names.
  @GET('/api/v1/stores')
  Future<PublicStoreListDto> nearby({
    @Query('lat') required num lat,
    @Query('lng') required num lng,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('categoryId') String? categoryId,
    @Query('search') String? search,
  });

  /// Store page with branches and live offers.
  ///
  /// With a customer token, `isFollowing` is filled in.
  @GET('/api/v1/stores/{storeId}')
  Future<PublicStoreDto> getStore({
    @Path('storeId') required String storeId,
    @Query('lat') num? lat,
    @Query('lng') num? lng,
  });

  /// Follow a store to hear about its new offers
  @POST('/api/v1/stores/{storeId}/follow')
  Future<void> follow({
    @Path('storeId') required String storeId,
  });

  /// Unfollow a store
  @DELETE('/api/v1/stores/{storeId}/follow')
  Future<void> unfollow({
    @Path('storeId') required String storeId,
  });

  /// Stores I follow
  @GET('/api/v1/me/follows')
  Future<List<FollowedStoreDto>> followed();
}
