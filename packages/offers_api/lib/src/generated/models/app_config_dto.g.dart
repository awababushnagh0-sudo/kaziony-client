// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigDto _$AppConfigDtoFromJson(Map<String, dynamic> json) => AppConfigDto(
  business: AppVersionDto.fromJson(json['business'] as Map<String, dynamic>),
  customer: AppVersionDto.fromJson(json['customer'] as Map<String, dynamic>),
  admin: AppVersionDto.fromJson(json['admin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppConfigDtoToJson(AppConfigDto instance) =>
    <String, dynamic>{
      'business': instance.business,
      'customer': instance.customer,
      'admin': instance.admin,
    };
