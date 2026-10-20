// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_product_dto.dart';
import '../models/product_dto.dart';
import '../models/product_list_dto.dart';
import '../models/update_product_dto.dart';

part 'business_products_client.g.dart';

@RestApi()
abstract class BusinessProductsClient {
  factory BusinessProductsClient(Dio dio, {String? baseUrl}) = _BusinessProductsClient;

  /// The store's saved products.
  ///
  /// [archived] - Show archived products instead of active ones.
  @GET('/api/v1/business/stores/{storeId}/products')
  Future<ProductListDto> list({
    @Path('storeId') required String storeId,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('search') String? search,
    @Query('archived') bool? archived,
  });

  /// Create a product.
  ///
  /// Then upload its photo with PUT /products/{productId}/image.
  @POST('/api/v1/business/stores/{storeId}/products')
  Future<ProductDto> create({
    @Path('storeId') required String storeId,
    @Body() required CreateProductDto body,
  });

  /// One product
  @GET('/api/v1/business/stores/{storeId}/products/{productId}')
  Future<ProductDto> getProduct({
    @Path('productId') required String productId,
    @Path('storeId') required String storeId,
  });

  /// Edit or archive a product
  @PATCH('/api/v1/business/stores/{storeId}/products/{productId}')
  Future<ProductDto> update({
    @Path('productId') required String productId,
    @Path('storeId') required String storeId,
    @Body() required UpdateProductDto body,
  });

  /// Upload the product photo and its thumbnail.
  ///
  /// [image] - About 1280px, compressed by the app.
  ///
  /// [thumb] - About 400px, used in lists.
  @MultiPart()
  @PUT('/api/v1/business/stores/{storeId}/products/{productId}/image')
  Future<ProductDto> setImage({
    @Path('productId') required String productId,
    @Path('storeId') required String storeId,
    @Part(name: 'image') required File image,
    @Part(name: 'thumb') required File thumb,
  });
}
