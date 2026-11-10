// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_connections_dto.g.dart';

@JsonSerializable()
class SystemConnectionsDto {
  const SystemConnectionsDto({
    required this.total,
    required this.active,
    required this.idle,
    required this.idleInTransaction,
    required this.waitingOnLocks,
    required this.max,
  });
  
  factory SystemConnectionsDto.fromJson(Map<String, Object?> json) => _$SystemConnectionsDtoFromJson(json);
  
  /// Our database's connections, from every instance and tool.
  final num total;
  final num active;
  final num idle;

  /// Holding a transaction open while doing nothing: should stay near 0.
  final num idleInTransaction;

  /// Waiting for another query's lock.
  final num waitingOnLocks;

  /// What the server allows (max_connections).
  final num max;

  Map<String, Object?> toJson() => _$SystemConnectionsDtoToJson(this);
}
