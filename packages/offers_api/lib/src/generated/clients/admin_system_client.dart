// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/system_database_dto.dart';
import '../models/system_error_list_dto.dart';
import '../models/system_job_dto.dart';
import '../models/system_job_list_dto.dart';
import '../models/system_overview_dto.dart';
import '../models/system_traffic_dto.dart';

part 'admin_system_client.g.dart';

@RestApi()
abstract class AdminSystemClient {
  factory AdminSystemClient(Dio dio, {String? baseUrl}) = _AdminSystemClient;

  /// Health of the database and Redis, the running instances, and the last 5 minutes
  @GET('/api/v1/admin/system')
  Future<SystemOverviewDto> overview();

  /// Requests per minute and per route, with errors and latency.
  ///
  /// [minutes] - How far back, in minutes.
  @GET('/api/v1/admin/system/traffic')
  Future<SystemTrafficDto> traffic({
    @Query('minutes') required num minutes,
  });

  /// Server errors of the last 24 hours, grouped
  @GET('/api/v1/admin/system/errors')
  Future<SystemErrorListDto> errors();

  /// Scheduled jobs: schedule, last run, backlog
  @GET('/api/v1/admin/system/jobs')
  Future<SystemJobListDto> jobs();

  /// Runs a job now and returns how it went (409 JobRunning if it already is)
  @POST('/api/v1/admin/system/jobs/{name}/run')
  Future<SystemJobDto> runJob({
    @Path('name') required String name,
  });

  /// Database size, connections, tables and the slowest queries
  @GET('/api/v1/admin/system/database')
  Future<SystemDatabaseDto> databaseStats();
}
