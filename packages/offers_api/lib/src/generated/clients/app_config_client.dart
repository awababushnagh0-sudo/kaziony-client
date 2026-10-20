// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_config_dto.dart';

part 'app_config_client.g.dart';

@RestApi()
abstract class AppConfigClient {
  factory AppConfigClient(Dio dio, {String? baseUrl}) = _AppConfigClient;

  /// Settings the apps read on startup (minimum versions)
  @GET('/api/v1/app-config')
  Future<AppConfigDto> getAppConfig();
}
