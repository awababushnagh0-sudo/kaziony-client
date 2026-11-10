// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_instance_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemInstanceDto _$SystemInstanceDtoFromJson(Map<String, dynamic> json) =>
    SystemInstanceDto(
      id: json['id'] as String,
      hostname: json['hostname'] as String,
      pid: json['pid'] as num,
      version: json['version'] as String,
      nodeVersion: json['nodeVersion'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      uptimeSeconds: json['uptimeSeconds'] as num,
      rssBytes: json['rssBytes'] as num,
      heapUsedBytes: json['heapUsedBytes'] as num,
      cpuPercent: json['cpuPercent'] as num,
      eventLoopDelayMs: json['eventLoopDelayMs'] as num,
      pool: SystemPoolDto.fromJson(json['pool'] as Map<String, dynamic>),
      requestsPerMinute: json['requestsPerMinute'] as num,
      current: json['current'] as bool,
    );

Map<String, dynamic> _$SystemInstanceDtoToJson(SystemInstanceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostname': instance.hostname,
      'pid': instance.pid,
      'version': instance.version,
      'nodeVersion': instance.nodeVersion,
      'startedAt': instance.startedAt.toIso8601String(),
      'reportedAt': instance.reportedAt.toIso8601String(),
      'uptimeSeconds': instance.uptimeSeconds,
      'rssBytes': instance.rssBytes,
      'heapUsedBytes': instance.heapUsedBytes,
      'cpuPercent': instance.cpuPercent,
      'eventLoopDelayMs': instance.eventLoopDelayMs,
      'pool': instance.pool,
      'requestsPerMinute': instance.requestsPerMinute,
      'current': instance.current,
    };
