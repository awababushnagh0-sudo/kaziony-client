// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_member_dto.dart';
import '../models/add_member_response_dto.dart';
import '../models/branch_dto.dart';
import '../models/create_branch_dto.dart';
import '../models/create_store_dto.dart';
import '../models/create_store_response_dto.dart';
import '../models/store_detail_dto.dart';
import '../models/store_list_dto.dart';
import '../models/update_branch_dto.dart';
import '../models/update_store_dto.dart';

part 'admin_stores_client.g.dart';

@RestApi()
abstract class AdminStoresClient {
  factory AdminStoresClient(Dio dio, {String? baseUrl}) = _AdminStoresClient;

  /// List and search stores.
  ///
  /// [search] - Search by store name.
  @GET('/api/v1/admin/stores')
  Future<StoreListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('search') String? search,
    @Query('categoryId') String? categoryId,
    @Query('isActive') bool? isActive,
  });

  /// Create a store with its branches and owner account.
  ///
  /// Returns a temporary password for the owner, shown only once. If the phone already has a merchant account, it is linked instead.
  @POST('/api/v1/admin/stores')
  Future<CreateStoreResponseDto> create({
    @Body() required CreateStoreDto body,
  });

  /// Store details with branches and staff
  @GET('/api/v1/admin/stores/{id}')
  Future<StoreDetailDto> getStore({
    @Path('id') required String id,
  });

  /// Edit, disable or enable a store
  @PATCH('/api/v1/admin/stores/{id}')
  Future<StoreDetailDto> update({
    @Path('id') required String id,
    @Body() required UpdateStoreDto body,
  });

  /// Delete a store that has no offers.
  ///
  /// Removes its branches, products and team links; the merchant accounts stay. A store with offers keeps its customers' history and can only be disabled: 409 with error "StoreHasOffers".
  @DELETE('/api/v1/admin/stores/{id}')
  Future<void> remove({
    @Path('id') required String id,
  });

  /// Add a branch
  @POST('/api/v1/admin/stores/{id}/branches')
  Future<BranchDto> addBranch({
    @Path('id') required String id,
    @Body() required CreateBranchDto body,
  });

  /// Edit, disable or enable a branch
  @PATCH('/api/v1/admin/stores/{id}/branches/{branchId}')
  Future<BranchDto> updateBranch({
    @Path('id') required String id,
    @Path('branchId') required String branchId,
    @Body() required UpdateBranchDto body,
  });

  /// Add an owner or staff member.
  ///
  /// Creates a merchant account with a temporary password (shown once), or links an existing merchant with the same phone.
  @POST('/api/v1/admin/stores/{id}/members')
  Future<AddMemberResponseDto> addMember({
    @Path('id') required String id,
    @Body() required AddMemberDto body,
  });

  /// Remove someone from the store (keeps their account)
  @DELETE('/api/v1/admin/stores/{id}/members/{userId}')
  Future<void> removeMember({
    @Path('id') required String id,
    @Path('userId') required String userId,
  });
}
