// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_check_dto.dart';

part 'system_checks_dto.g.dart';

@JsonSerializable()
class SystemChecksDto {
  const SystemChecksDto({
    required this.database,
    required this.redis,
  });
  
  factory SystemChecksDto.fromJson(Map<String, Object?> json) => _$SystemChecksDtoFromJson(json);
  
  final SystemCheckDto database;

  /// Shared cache, rate limits and messages between instances.
  final SystemCheckDto redis;

  Map<String, Object?> toJson() => _$SystemChecksDtoToJson(this);
}
