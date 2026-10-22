// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigDto _$AppConfigDtoFromJson(Map<String, dynamic> json) => AppConfigDto(
  partner: AppVersionDto.fromJson(json['partner'] as Map<String, dynamic>),
  customer: AppVersionDto.fromJson(json['customer'] as Map<String, dynamic>),
  admin: AppVersionDto.fromJson(json['admin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppConfigDtoToJson(AppConfigDto instance) =>
    <String, dynamic>{
      'partner': instance.partner,
      'customer': instance.customer,
      'admin': instance.admin,
    };
