// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'app_settings_dto.g.dart';

@JsonSerializable()
class AppSettingsDto {
  const AppSettingsDto({
    required this.browseRadiusKm,
  });
  
  factory AppSettingsDto.fromJson(Map<String, Object?> json) => _$AppSettingsDtoFromJson(json);
  
  /// Customers see offers from branches this close to them, in km.
  final num browseRadiusKm;

  Map<String, Object?> toJson() => _$AppSettingsDtoToJson(this);
}
