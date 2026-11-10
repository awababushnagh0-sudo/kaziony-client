// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_api_v1_health_ready_response.dart';
import '../models/get_api_v1_health_response.dart';

part 'health_client.g.dart';

@RestApi()
abstract class HealthClient {
  factory HealthClient(Dio dio, {String? baseUrl}) = _HealthClient;

  /// Check that the API and database are healthy
  @GET('/api/v1/health')
  Future<GetApiV1HealthResponse> check();

  /// The process is running
  @GET('/api/v1/health/live')
  Future<void> live();

  /// This instance can serve requests
  @GET('/api/v1/health/ready')
  Future<GetApiV1HealthReadyResponse> ready();
}
