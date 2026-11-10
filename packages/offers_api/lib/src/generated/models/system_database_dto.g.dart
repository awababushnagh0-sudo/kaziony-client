// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_database_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemDatabaseDto _$SystemDatabaseDtoFromJson(Map<String, dynamic> json) =>
    SystemDatabaseDto(
      version: json['version'] as String,
      sizeBytes: json['sizeBytes'] as num,
      connections: SystemConnectionsDto.fromJson(
        json['connections'] as Map<String, dynamic>,
      ),
      cacheHitRatio: json['cacheHitRatio'] as num?,
      statementsAvailable: json['statementsAvailable'] as bool,
      topQueries: (json['topQueries'] as List<dynamic>)
          .map((e) => SystemQueryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      running: (json['running'] as List<dynamic>)
          .map((e) => SystemActivityDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tables: (json['tables'] as List<dynamic>)
          .map((e) => SystemTableDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemDatabaseDtoToJson(SystemDatabaseDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'sizeBytes': instance.sizeBytes,
      'connections': instance.connections,
      'cacheHitRatio': ?instance.cacheHitRatio,
      'statementsAvailable': instance.statementsAvailable,
      'topQueries': instance.topQueries,
      'running': instance.running,
      'tables': instance.tables,
    };
