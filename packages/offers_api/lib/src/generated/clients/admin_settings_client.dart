// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_settings_dto.dart';
import '../models/update_app_settings_dto.dart';

part 'admin_settings_client.g.dart';

@RestApi()
abstract class AdminSettingsClient {
  factory AdminSettingsClient(Dio dio, {String? baseUrl}) = _AdminSettingsClient;

  /// Platform settings (browse radius)
  @GET('/api/v1/admin/settings')
  Future<AppSettingsDto> getSettings();

  /// Change platform settings (admins only)
  @PATCH('/api/v1/admin/settings')
  Future<AppSettingsDto> updateSettings({
    @Body() required UpdateAppSettingsDto body,
  });
}
