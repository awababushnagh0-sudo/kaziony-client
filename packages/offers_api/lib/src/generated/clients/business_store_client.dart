// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/branch_dto.dart';
import '../models/store_detail_dto.dart';
import '../models/store_stats_dto.dart';
import '../models/update_branch_dto.dart';
import '../models/update_store_profile_dto.dart';

part 'business_store_client.g.dart';

@RestApi()
abstract class BusinessStoreClient {
  factory BusinessStoreClient(Dio dio, {String? baseUrl}) = _BusinessStoreClient;

  /// My store with its branches and staff
  @GET('/api/v1/business/stores/{storeId}')
  Future<StoreDetailDto> getStore({
    @Path('storeId') required String storeId,
  });

  /// Edit description and contact details (owner)
  @PATCH('/api/v1/business/stores/{storeId}')
  Future<StoreDetailDto> updateProfile({
    @Path('storeId') required String storeId,
    @Body() required UpdateStoreProfileDto body,
  });

  /// Claims, redemptions and top offers
  @GET('/api/v1/business/stores/{storeId}/stats')
  Future<StoreStatsDto> getStats({
    @Path('storeId') required String storeId,
  });

  /// Upload the store logo or cover photo (owner)
  @MultiPart()
  @PUT('/api/v1/business/stores/{storeId}/images/{kind}')
  Future<StoreDetailDto> setImage({
    @Path('kind') required String kind,
    @Path('storeId') required String storeId,
    @Part(name: 'image') required File image,
  });

  /// Edit a branch, e.g. opening hours (owner)
  @PATCH('/api/v1/business/stores/{storeId}/branches/{branchId}')
  Future<BranchDto> updateBranch({
    @Path('branchId') required String branchId,
    @Path('storeId') required String storeId,
    @Body() required UpdateBranchDto body,
  });
}
