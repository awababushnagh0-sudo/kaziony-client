// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/category_dto.dart';

part 'categories_client.g.dart';

@RestApi()
abstract class CategoriesClient {
  factory CategoriesClient(Dio dio, {String? baseUrl}) = _CategoriesClient;

  /// Active categories, in display order
  @GET('/api/v1/categories')
  Future<List<CategoryDto>> list();
}
