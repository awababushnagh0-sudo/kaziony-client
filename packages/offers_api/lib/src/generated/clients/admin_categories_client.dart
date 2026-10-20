// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/category_dto.dart';
import '../models/create_category_dto.dart';
import '../models/update_category_dto.dart';

part 'admin_categories_client.g.dart';

@RestApi()
abstract class AdminCategoriesClient {
  factory AdminCategoriesClient(Dio dio, {String? baseUrl}) = _AdminCategoriesClient;

  /// All categories, including hidden ones
  @GET('/api/v1/admin/categories')
  Future<List<CategoryDto>> list();

  /// Create a category
  @POST('/api/v1/admin/categories')
  Future<CategoryDto> create({
    @Body() required CreateCategoryDto body,
  });

  /// Edit or hide a category
  @PATCH('/api/v1/admin/categories/{id}')
  Future<CategoryDto> update({
    @Path('id') required String id,
    @Body() required UpdateCategoryDto body,
  });
}
