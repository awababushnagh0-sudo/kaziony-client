// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_stats_dto.dart';

part 'admin_stats_client.g.dart';

@RestApi()
abstract class AdminStatsClient {
  factory AdminStatsClient(Dio dio, {String? baseUrl}) = _AdminStatsClient;

  /// Headline numbers for the dashboard
  @GET('/api/v1/admin/stats')
  Future<AdminStatsDto> getStats();
}
