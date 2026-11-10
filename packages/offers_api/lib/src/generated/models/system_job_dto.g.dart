// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemJobDto _$SystemJobDtoFromJson(Map<String, dynamic> json) => SystemJobDto(
  lastStatus: json['lastStatus'] == null
      ? null
      : JobRunStatus.fromJson(json['lastStatus'] as String),
  lastResult: json['lastResult'],
  name: json['name'] as String,
  description: json['description'] as String,
  schedule: json['schedule'] as String?,
  timeZone: json['timeZone'] as String?,
  nextRunAt: json['nextRunAt'] == null
      ? null
      : DateTime.parse(json['nextRunAt'] as String),
  running: json['running'] as bool,
  runningOn: json['runningOn'] as String?,
  lastStartedAt: json['lastStartedAt'] == null
      ? null
      : DateTime.parse(json['lastStartedAt'] as String),
  lastFinishedAt: json['lastFinishedAt'] == null
      ? null
      : DateTime.parse(json['lastFinishedAt'] as String),
  lastDurationMs: json['lastDurationMs'] as num?,
  lastError: json['lastError'] as String?,
  runCount: json['runCount'] as num,
  failureCount: json['failureCount'] as num,
  backlog: json['backlog'] as num?,
  backlogLabel: json['backlogLabel'] as String?,
);

Map<String, dynamic> _$SystemJobDtoToJson(SystemJobDto instance) =>
    <String, dynamic>{
      'lastStatus': ?instance.lastStatus,
      'lastResult': ?instance.lastResult,
      'name': instance.name,
      'description': instance.description,
      'schedule': ?instance.schedule,
      'timeZone': ?instance.timeZone,
      'nextRunAt': ?instance.nextRunAt?.toIso8601String(),
      'running': instance.running,
      'runningOn': ?instance.runningOn,
      'lastStartedAt': ?instance.lastStartedAt?.toIso8601String(),
      'lastFinishedAt': ?instance.lastFinishedAt?.toIso8601String(),
      'lastDurationMs': ?instance.lastDurationMs,
      'lastError': ?instance.lastError,
      'runCount': instance.runCount,
      'failureCount': instance.failureCount,
      'backlog': ?instance.backlog,
      'backlogLabel': ?instance.backlogLabel,
    };
