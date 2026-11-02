// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_service_area_dto.dart';
import '../models/service_area_dto.dart';
import '../models/update_service_area_dto.dart';

part 'admin_service_areas_client.g.dart';

@RestApi()
abstract class AdminServiceAreasClient {
  factory AdminServiceAreasClient(Dio dio, {String? baseUrl}) = _AdminServiceAreasClient;

  /// Where Kaziony works
  @GET('/api/v1/admin/service-areas')
  Future<List<ServiceAreaDto>> listServiceAreas();

  /// Add a service area (admins only)
  @POST('/api/v1/admin/service-areas')
  Future<ServiceAreaDto> createServiceArea({
    @Body() required CreateServiceAreaDto body,
  });

  /// Change a service area (admins only)
  @PATCH('/api/v1/admin/service-areas/{id}')
  Future<ServiceAreaDto> updateServiceArea({
    @Path('id') required String id,
    @Body() required UpdateServiceAreaDto body,
  });

  /// Delete a service area (admins only)
  @DELETE('/api/v1/admin/service-areas/{id}')
  Future<void> deleteServiceArea({
    @Path('id') required String id,
  });
}
