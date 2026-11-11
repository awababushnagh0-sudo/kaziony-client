// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_member_dto.dart';
import '../models/add_member_response_dto.dart';
import '../models/add_store_location_dto.dart';
import '../models/create_store_dto.dart';
import '../models/create_store_response_dto.dart';
import '../models/store_detail_dto.dart';
import '../models/store_list_dto.dart';
import '../models/update_store_dto.dart';

part 'admin_stores_client.g.dart';

@RestApi()
abstract class AdminStoresClient {
  factory AdminStoresClient(Dio dio, {String? baseUrl}) = _AdminStoresClient;

  /// List and search stores.
  ///
  /// `search` finds a brand's places by name, or one by its area.
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

  /// Create a store at one place, with its owner account.
  ///
  /// Returns a temporary password for the owner, shown only once. If the phone already has a merchant account, it is linked instead. A brand's other places: `POST /admin/stores/{storeId}/locations`.
  @POST('/api/v1/admin/stores')
  Future<CreateStoreResponseDto> create({
    @Body() required CreateStoreDto body,
  });

  /// Store details with its staff
  @GET('/api/v1/admin/stores/{id}')
  Future<StoreDetailDto> getStore({
    @Path('id') required String id,
  });

  /// Edit, disable or enable a store.
  ///
  /// Send only the fields to change. An empty string clears an optional field (phone, email, links).
  @PATCH('/api/v1/admin/stores/{id}')
  Future<StoreDetailDto> update({
    @Path('id') required String id,
    @Body() required UpdateStoreDto body,
  });

  /// Delete a store that has no offers.
  ///
  /// Removes its products and team links; the merchant accounts stay. A store with offers keeps its customers' history and can only be disabled: 409 with error "StoreHasOffers".
  @DELETE('/api/v1/admin/stores/{id}')
  Future<void> remove({
    @Path('id') required String id,
  });

  /// Open another place of this store's brand.
  ///
  /// A store of its own at the place sent, with the same name, kind, photos, contact details and owners. Its staff, products and offers are its own.
  @POST('/api/v1/admin/stores/{storeId}/locations')
  Future<StoreDetailDto> addLocation({
    @Path('storeId') required String storeId,
    @Body() required AddStoreLocationDto body,
  });

  /// Upload or replace the store logo or cover photo
  @MultiPart()
  @PUT('/api/v1/admin/stores/{id}/images/{kind}')
  Future<StoreDetailDto> setImage({
    @Path('id') required String id,
    @Path('kind') required String kind,
    @Part(name: 'image') required MultipartFile image,
  });

  /// Remove the store logo or cover photo.
  ///
  /// A live store keeps its logo: customers see it (`StoreNotReady`). Another place of the brand using the same photo keeps it.
  @DELETE('/api/v1/admin/stores/{id}/images/{kind}')
  Future<StoreDetailDto> removeImage({
    @Path('id') required String id,
    @Path('kind') required String kind,
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
