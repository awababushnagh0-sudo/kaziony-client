// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_activity_dto.g.dart';

@JsonSerializable()
class SystemActivityDto {
  const SystemActivityDto({
    required this.pid,
    required this.state,
    required this.durationMs,
    required this.waitEvent,
    required this.query,
  });
  
  factory SystemActivityDto.fromJson(Map<String, Object?> json) => _$SystemActivityDtoFromJson(json);
  
  final num pid;
  final String state;
  final num durationMs;

  /// What it waits for, e.g. "Lock: transactionid".
  final String? waitEvent;
  final String query;

  Map<String, Object?> toJson() => _$SystemActivityDtoToJson(this);
}
