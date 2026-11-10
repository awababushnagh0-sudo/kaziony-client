// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_pool_dto.dart';

part 'system_instance_dto.g.dart';

@JsonSerializable()
class SystemInstanceDto {
  const SystemInstanceDto({
    required this.id,
    required this.hostname,
    required this.pid,
    required this.version,
    required this.nodeVersion,
    required this.startedAt,
    required this.reportedAt,
    required this.uptimeSeconds,
    required this.rssBytes,
    required this.heapUsedBytes,
    required this.cpuPercent,
    required this.eventLoopDelayMs,
    required this.pool,
    required this.requestsPerMinute,
    required this.current,
  });
  
  factory SystemInstanceDto.fromJson(Map<String, Object?> json) => _$SystemInstanceDtoFromJson(json);
  
  /// Host, process id and a random suffix.
  final String id;
  final String hostname;
  final num pid;

  /// APP_VERSION it runs (the release).
  final String version;
  final String nodeVersion;
  final DateTime startedAt;

  /// Its last report; instances report every 10 seconds.
  final DateTime reportedAt;
  final num uptimeSeconds;
  final num rssBytes;
  final num heapUsedBytes;

  /// Share of one CPU core, 0 to 100 (or more with worker threads).
  final num cpuPercent;

  /// How late timers ran (p99): high means the process is too busy.
  final num eventLoopDelayMs;
  final SystemPoolDto pool;

  /// Over the last 5 minutes.
  final num requestsPerMinute;

  /// The instance that answered this request.
  final bool current;

  Map<String, Object?> toJson() => _$SystemInstanceDtoToJson(this);
}
