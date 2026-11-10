// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_activity_dto.dart';
import 'system_connections_dto.dart';
import 'system_query_dto.dart';
import 'system_table_dto.dart';

part 'system_database_dto.g.dart';

@JsonSerializable()
class SystemDatabaseDto {
  const SystemDatabaseDto({
    required this.version,
    required this.sizeBytes,
    required this.connections,
    required this.cacheHitRatio,
    required this.statementsAvailable,
    required this.topQueries,
    required this.running,
    required this.tables,
  });
  
  factory SystemDatabaseDto.fromJson(Map<String, Object?> json) => _$SystemDatabaseDtoFromJson(json);
  
  final String version;
  final num sizeBytes;
  final SystemConnectionsDto connections;

  /// Reads served from memory, 0 to 1: below 0.99, Postgres needs more memory.
  final num? cacheHitRatio;

  /// Whether pg_stat_statements is on (the slowest queries need it).
  final bool statementsAvailable;

  /// Most total time first.
  final List<SystemQueryDto> topQueries;

  /// Queries running for over a second right now.
  final List<SystemActivityDto> running;

  /// Biggest first.
  final List<SystemTableDto> tables;

  Map<String, Object?> toJson() => _$SystemDatabaseDtoToJson(this);
}
