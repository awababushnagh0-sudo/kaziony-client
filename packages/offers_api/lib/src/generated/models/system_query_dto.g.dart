// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_query_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemQueryDto _$SystemQueryDtoFromJson(Map<String, dynamic> json) =>
    SystemQueryDto(
      query: json['query'] as String,
      calls: json['calls'] as num,
      totalMs: json['totalMs'] as num,
      meanMs: json['meanMs'] as num,
      rows: json['rows'] as num,
    );

Map<String, dynamic> _$SystemQueryDtoToJson(SystemQueryDto instance) =>
    <String, dynamic>{
      'query': instance.query,
      'calls': instance.calls,
      'totalMs': instance.totalMs,
      'meanMs': instance.meanMs,
      'rows': instance.rows,
    };
