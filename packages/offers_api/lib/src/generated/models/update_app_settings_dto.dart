// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_app_settings_dto.g.dart';

@JsonSerializable()
class UpdateAppSettingsDto {
  const UpdateAppSettingsDto({
    this.browseRadiusKm,
  });
  
  factory UpdateAppSettingsDto.fromJson(Map<String, Object?> json) => _$UpdateAppSettingsDtoFromJson(json);
  
  final num? browseRadiusKm;

  Map<String, Object?> toJson() => _$UpdateAppSettingsDtoToJson(this);
}
