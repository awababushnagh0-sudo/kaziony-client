// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_app_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAppSettingsDto _$UpdateAppSettingsDtoFromJson(
  Map<String, dynamic> json,
) => UpdateAppSettingsDto(
  browseRadiusKm: json['browseRadiusKm'] as num?,
  holdMinutes: json['holdMinutes'] as num?,
);

Map<String, dynamic> _$UpdateAppSettingsDtoToJson(
  UpdateAppSettingsDto instance,
) => <String, dynamic>{
  'browseRadiusKm': ?instance.browseRadiusKm,
  'holdMinutes': ?instance.holdMinutes,
};
