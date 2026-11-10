// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_check_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemCheckDto _$SystemCheckDtoFromJson(Map<String, dynamic> json) =>
    SystemCheckDto(
      status: ServiceStatus.fromJson(json['status'] as String),
      latencyMs: json['latencyMs'] as num?,
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$SystemCheckDtoToJson(SystemCheckDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'latencyMs': ?instance.latencyMs,
      'detail': ?instance.detail,
    };
