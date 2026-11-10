// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'job_run_status.dart';

part 'system_job_dto.g.dart';

@JsonSerializable()
class SystemJobDto {
  const SystemJobDto({
    required this.lastStatus,
    required this.lastResult,
    required this.name,
    required this.description,
    required this.schedule,
    required this.timeZone,
    required this.nextRunAt,
    required this.running,
    required this.runningOn,
    required this.lastStartedAt,
    required this.lastFinishedAt,
    required this.lastDurationMs,
    required this.lastError,
    required this.runCount,
    required this.failureCount,
    required this.backlog,
    required this.backlogLabel,
  });
  
  factory SystemJobDto.fromJson(Map<String, Object?> json) => _$SystemJobDtoFromJson(json);
  
  final JobRunStatus? lastStatus;

  /// What the last run did, e.g. { "expired": 3 }.
  final dynamic lastResult;
  final String name;
  final String description;

  /// Cron expression.
  final String? schedule;
  final String? timeZone;
  final DateTime? nextRunAt;
  final bool running;

  /// The instance running it.
  final String? runningOn;
  final DateTime? lastStartedAt;
  final DateTime? lastFinishedAt;
  final num? lastDurationMs;
  final String? lastError;
  final num runCount;
  final num failureCount;

  /// Work waiting for the next run (see backlogLabel); null if not counted.
  final num? backlog;

  /// What backlog counts.
  final String? backlogLabel;

  Map<String, Object?> toJson() => _$SystemJobDtoToJson(this);
}
