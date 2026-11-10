// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_activity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemActivityDto _$SystemActivityDtoFromJson(Map<String, dynamic> json) =>
    SystemActivityDto(
      pid: json['pid'] as num,
      state: json['state'] as String,
      durationMs: json['durationMs'] as num,
      waitEvent: json['waitEvent'] as String?,
      query: json['query'] as String,
    );

Map<String, dynamic> _$SystemActivityDtoToJson(SystemActivityDto instance) =>
    <String, dynamic>{
      'pid': instance.pid,
      'state': instance.state,
      'durationMs': instance.durationMs,
      'waitEvent': ?instance.waitEvent,
      'query': instance.query,
    };
