// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/followed_store_dto.dart';
import '../models/public_store_dto.dart';

part 'stores_client.g.dart';

@RestApi()
abstract class StoresClient {
  factory StoresClient(Dio dio, {String? baseUrl}) = _StoresClient;

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
